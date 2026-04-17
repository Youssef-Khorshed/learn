#!/usr/bin/env dart
// detect_unused.dart
// Scans the Flutter project for unused Dart source files and unused asset files.
// Outputs a report to stdout and writes unused_files_report.txt to the project root.

import 'dart:io';

// ─── Entry Point ────────────────────────────────────────────────────────────

void main(List<String> args) {
  if (args.contains('--help') || args.contains('-h')) {
    _printUsage();
    exit(0);
  }

  final unrecognized = args.where((a) => a != '--help' && a != '-h').toList();
  if (unrecognized.isNotEmpty) {
    stderr.writeln('Unknown flag(s): ${unrecognized.join(', ')}');
    _printUsage();
    exit(1);
  }

  final projectRoot = _findProjectRoot();
  if (projectRoot == null) {
    stderr.writeln(
      'Error: Could not find project root (no pubspec.yaml found).',
    );
    exit(1);
  }

  print('Project root: $projectRoot\n');

  // ── Load optional exclusion config ──────────────────────────────────────
  final exclusions = _loadExclusions(projectRoot);
  if (exclusions.isNotEmpty) {
    print('Exclusion patterns loaded: ${exclusions.length}');
  }

  // ── Load font files declared in pubspec.yaml ─────────────────────────────
  final declaredFonts = _loadDeclaredFonts(projectRoot);

  // ── Detect unused Dart files ─────────────────────────────────────────────
  print('Scanning Dart files...');
  final unusedDart = _detectUnusedDartFiles(projectRoot, exclusions);

  // ── Detect unused asset files ────────────────────────────────────────────
  print('Scanning asset files...');
  final unusedAssets = _detectUnusedAssets(
    projectRoot,
    exclusions,
    declaredFonts,
  );

  // ── Print report ─────────────────────────────────────────────────────────
  _printReport(unusedDart, unusedAssets);

  // ── Write report file ────────────────────────────────────────────────────
  _writeReportFile(projectRoot, unusedDart, unusedAssets);
}

// ─── Project Root Detection ──────────────────────────────────────────────────

String? _findProjectRoot() {
  var dir = Directory.current;
  while (true) {
    if (File('${dir.path}/pubspec.yaml').existsSync()) {
      return dir.path;
    }
    final parent = dir.parent;
    if (parent.path == dir.path) return null;
    dir = parent;
  }
}

// ─── Exclusion Config ────────────────────────────────────────────────────────

List<String> _loadExclusions(String projectRoot) {
  final configFile = File('$projectRoot/unused_cleaner_config.yaml');
  if (!configFile.existsSync()) return [];

  final lines = configFile.readAsLinesSync();
  final patterns = <String>[];
  bool inExclude = false;

  for (final line in lines) {
    final trimmed = line.trim();
    if (trimmed == 'exclude:') {
      inExclude = true;
      continue;
    }
    if (inExclude) {
      if (trimmed.startsWith('-')) {
        patterns.add(
          trimmed.substring(1).trim().replaceAll("'", '').replaceAll('"', ''),
        );
      } else if (trimmed.isNotEmpty && !trimmed.startsWith('#')) {
        inExclude = false;
      }
    }
  }
  return patterns;
}

bool _isExcluded(String relativePath, List<String> exclusions) {
  for (final pattern in exclusions) {
    if (_globMatch(pattern, relativePath)) return true;
  }
  return false;
}

bool _globMatch(String pattern, String path) {
  // Convert glob to regex
  final regexStr = pattern
      .replaceAll('.', r'\.')
      .replaceAll('**', '__DOUBLE_STAR__')
      .replaceAll('*', '[^/]*')
      .replaceAll('__DOUBLE_STAR__', '.*');
  return RegExp('^$regexStr\$').hasMatch(path);
}

// ─── Font Detection ──────────────────────────────────────────────────────────

Set<String> _loadDeclaredFonts(String projectRoot) {
  final pubspec = File('$projectRoot/pubspec.yaml');
  final fonts = <String>{};
  if (!pubspec.existsSync()) return fonts;

  final lines = pubspec.readAsLinesSync();
  bool inFonts = false;

  for (final line in lines) {
    final trimmed = line.trim();
    if (trimmed == 'fonts:') {
      inFonts = true;
      continue;
    }
    if (inFonts) {
      if (trimmed.startsWith('asset:')) {
        final asset = trimmed.substring('asset:'.length).trim();
        fonts.add(asset);
      } else if (trimmed.isNotEmpty &&
          !trimmed.startsWith('-') &&
          !trimmed.startsWith('family:') &&
          !trimmed.startsWith('fonts:') &&
          !trimmed.startsWith('#') &&
          !line.startsWith(' ') &&
          !line.startsWith('\t')) {
        inFonts = false;
      }
    }
  }
  return fonts;
}

// ─── Dart File Detection ─────────────────────────────────────────────────────

// Generated file suffixes to skip
const _generatedSuffixes = [
  '.g.dart',
  '.freezed.dart',
  '.gr.dart',
  '.config.dart',
];

List<String> _detectUnusedDartFiles(
  String projectRoot,
  List<String> exclusions,
) {
  final libDir = Directory('$projectRoot/lib');
  if (!libDir.existsSync()) return [];

  // Collect all dart files
  final allFiles =
      libDir
          .listSync(recursive: true)
          .whereType<File>()
          .where((f) => f.path.endsWith('.dart'))
          .toList();

  // Build relative paths map: relativePath -> absolutePath
  final relativeToAbsolute = <String, String>{};
  for (final f in allFiles) {
    final rel = f.path.substring(projectRoot.length + 1).replaceAll('\\', '/');
    relativeToAbsolute[rel] = f.path;
  }

  // Read package name from pubspec
  final packageName = _readPackageName(projectRoot);

  // Build import graph: for each file, what files does it import?
  // We track which files are "imported by someone"
  final importedFiles = <String>{};

  for (final f in allFiles) {
    final rel = f.path.substring(projectRoot.length + 1).replaceAll('\\', '/');
    final content = f.readAsStringSync();
    final imports = _extractImports(content);

    for (final imp in imports) {
      String? resolved;

      if (imp.startsWith('package:$packageName/')) {
        // package import → lib/...
        final libRelative =
            'lib/' + imp.substring('package:$packageName/'.length);
        resolved = libRelative;
      } else if (!imp.startsWith('package:') && !imp.startsWith('dart:')) {
        // relative import
        resolved = _resolveRelativeImport(rel, imp);
      }

      if (resolved != null) {
        importedFiles.add(resolved);
      }
    }
  }

  // Entry points: main.dart is always reachable
  final entryPoints = <String>{'lib/main.dart'};

  // Unused = not imported by anyone, not an entry point, not generated
  final unused = <String>[];
  for (final rel in relativeToAbsolute.keys) {
    if (entryPoints.contains(rel)) continue;
    if (_generatedSuffixes.any((s) => rel.endsWith(s))) continue;
    if (_isExcluded(rel, exclusions)) continue;
    if (!importedFiles.contains(rel)) {
      unused.add(rel);
    }
  }

  unused.sort();
  return unused;
}

List<String> _extractImports(String content) {
  final results = <String>[];
  // Match import/export 'uri'; or import/export "uri";
  final regex = RegExp(r'''(?:import|export)\s+['"]([^'"]+)['"]''');
  for (final match in regex.allMatches(content)) {
    results.add(match.group(1)!);
  }
  return results;
}

String _resolveRelativeImport(String fromFile, String importPath) {
  // fromFile: lib/features/foo/bar.dart
  // importPath: ../widgets/baz.dart
  final parts = fromFile.split('/');
  parts.removeLast(); // remove filename, keep directory parts

  final importParts = importPath.split('/');
  for (final part in importParts) {
    if (part == '..') {
      if (parts.isNotEmpty) parts.removeLast();
    } else if (part != '.') {
      parts.add(part);
    }
  }
  return parts.join('/');
}

String _readPackageName(String projectRoot) {
  final pubspec = File('$projectRoot/pubspec.yaml');
  if (!pubspec.existsSync()) return '';
  for (final line in pubspec.readAsLinesSync()) {
    if (line.startsWith('name:')) {
      return line.substring('name:'.length).trim();
    }
  }
  return '';
}

// ─── Asset File Detection ────────────────────────────────────────────────────

List<String> _detectUnusedAssets(
  String projectRoot,
  List<String> exclusions,
  Set<String> declaredFonts,
) {
  final assetsDir = Directory('$projectRoot/assets');
  if (!assetsDir.existsSync()) return [];

  // Collect all asset files
  final assetFiles =
      assetsDir.listSync(recursive: true).whereType<File>().toList();

  // Read all dart source content once
  final libDir = Directory('$projectRoot/lib');
  final allDartContent = StringBuffer();
  if (libDir.existsSync()) {
    for (final f in libDir.listSync(recursive: true).whereType<File>()) {
      if (f.path.endsWith('.dart')) {
        allDartContent.write(f.readAsStringSync());
        allDartContent.write('\n');
      }
    }
  }
  final dartContent = allDartContent.toString();

  final unused = <String>[];

  for (final f in assetFiles) {
    final rel = f.path.substring(projectRoot.length + 1).replaceAll('\\', '/');

    // Skip declared fonts
    if (declaredFonts.contains(rel)) continue;

    // Skip exclusions
    if (_isExcluded(rel, exclusions)) continue;

    // Check if referenced in any dart file
    final filename = rel.split('/').last;
    final referenced =
        dartContent.contains(rel) ||
        dartContent.contains(filename) ||
        dartContent.contains("'$rel'") ||
        dartContent.contains('"$rel"');

    if (!referenced) {
      unused.add(rel);
    }
  }

  unused.sort();
  return unused;
}

// ─── Report Output ───────────────────────────────────────────────────────────

void _printReport(List<String> unusedDart, List<String> unusedAssets) {
  print('\n${'=' * 60}');
  print('  UNUSED FILES REPORT');
  print('=' * 60);

  print('\n📄 Unused Dart Files (${unusedDart.length}):');
  if (unusedDart.isEmpty) {
    print('  ✅ No unused Dart files found.');
  } else {
    for (final f in unusedDart) {
      print('  - $f');
    }
  }

  print('\n🖼  Unused Asset Files (${unusedAssets.length}):');
  if (unusedAssets.isEmpty) {
    print('  ✅ No unused asset files found.');
  } else {
    for (final f in unusedAssets) {
      print('  - $f');
    }
  }

  print('\n${'─' * 60}');
  print(
    'Summary: ${unusedDart.length} unused Dart file(s), ${unusedAssets.length} unused asset file(s).',
  );
  print('${'=' * 60}\n');
}

void _writeReportFile(
  String projectRoot,
  List<String> unusedDart,
  List<String> unusedAssets,
) {
  final reportFile = File('$projectRoot/unused_files_report.txt');
  final buffer = StringBuffer();

  buffer.writeln('# Unused Files Report');
  buffer.writeln('# Generated by detect_unused.dart');
  buffer.writeln('#');
  buffer.writeln('# Run: dart scripts/clean_unused.dart --all   to delete all');
  buffer.writeln(
    '# Run: dart scripts/clean_unused.dart --file <path>   to delete one',
  );
  buffer.writeln();

  for (final f in unusedDart) {
    buffer.writeln(f);
  }
  for (final f in unusedAssets) {
    buffer.writeln(f);
  }

  reportFile.writeAsStringSync(buffer.toString());
  print('Report saved to: unused_files_report.txt');
  print('Total files listed: ${unusedDart.length + unusedAssets.length}');
}

void _printUsage() {
  print('''
Usage: dart scripts/detect_unused.dart [options]

Options:
  --help, -h    Show this help message

Description:
  Scans the Flutter project for unused Dart source files and unused asset files.
  Outputs a report to stdout and writes unused_files_report.txt to the project root.

Optional config file (unused_cleaner_config.yaml) in project root:
  exclude:
    - 'lib/generated/**'
    - 'assets/icons/**'
''');
}
