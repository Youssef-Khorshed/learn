#!/usr/bin/env dart
// clean_unused.dart
// Deletes unused files detected by detect_unused.dart.
// Supports deleting a specific file (--file) or all files from the report (--all).
// Use --dry-run to preview without deleting.

import 'dart:io';

// ─── Entry Point ────────────────────────────────────────────────────────────

void main(List<String> args) {
  if (args.isEmpty || args.contains('--help') || args.contains('-h')) {
    _printUsage();
    exit(args.isEmpty ? 1 : 0);
  }

  final hasAll = args.contains('--all');
  final hasFile = args.contains('--file');
  final isDryRun = args.contains('--dry-run');

  // Validate mutually exclusive flags
  if (hasAll && hasFile) {
    stderr.writeln(
      'Error: --all and --file are mutually exclusive. Use one at a time.',
    );
    _printUsage();
    exit(1);
  }

  if (!hasAll && !hasFile) {
    stderr.writeln('Error: You must provide either --all or --file <path>.');
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

  if (hasFile) {
    final fileIndex = args.indexOf('--file');
    if (fileIndex + 1 >= args.length) {
      stderr.writeln('Error: --file requires a file path argument.');
      _printUsage();
      exit(1);
    }
    final filePath = args[fileIndex + 1];
    _deleteSpecificFile(projectRoot, filePath, isDryRun);
  } else {
    _deleteAllFromReport(projectRoot, isDryRun);
  }
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

// ─── Delete Specific File ────────────────────────────────────────────────────

void _deleteSpecificFile(String projectRoot, String filePath, bool isDryRun) {
  // Resolve path relative to project root if not absolute
  final resolvedPath =
      filePath.startsWith('/') ? filePath : '$projectRoot/$filePath';

  final file = File(resolvedPath);

  if (!file.existsSync()) {
    stderr.writeln('Error: File not found: $filePath');
    exit(1);
  }

  final displayPath = filePath;

  if (isDryRun) {
    print('[DRY RUN] Would delete: $displayPath');
    print('\nDry run complete. 1 file would be deleted.');
    return;
  }

  print('The following file will be deleted:');
  print('  $displayPath');
  print('');

  if (!_confirm('Are you sure you want to delete this file? (yes/no): ')) {
    print('Cancelled. No files were deleted.');
    exit(0);
  }

  try {
    file.deleteSync();
    print('✅ Deleted: $displayPath');
  } catch (e) {
    stderr.writeln('Error deleting $displayPath: $e');
    exit(1);
  }
}

// ─── Delete All From Report ──────────────────────────────────────────────────

void _deleteAllFromReport(String projectRoot, bool isDryRun) {
  final reportFile = File('$projectRoot/unused_files_report.txt');

  if (!reportFile.existsSync()) {
    stderr.writeln(
      'Error: unused_files_report.txt not found.\n'
      'Please run the detector first:\n'
      '  dart scripts/detect_unused.dart',
    );
    exit(1);
  }

  // Read file list (skip comment lines starting with #)
  final lines =
      reportFile
          .readAsLinesSync()
          .map((l) => l.trim())
          .where((l) => l.isNotEmpty && !l.startsWith('#'))
          .toList();

  if (lines.isEmpty) {
    print('No files listed in unused_files_report.txt. Nothing to delete.');
    exit(0);
  }

  if (isDryRun) {
    print(
      '[DRY RUN] The following ${lines.length} file(s) would be deleted:\n',
    );
    for (final f in lines) {
      print('  [DRY RUN] $f');
    }
    print('\nDry run complete. ${lines.length} file(s) would be deleted.');
    return;
  }

  print('The following ${lines.length} file(s) will be deleted:\n');
  for (final f in lines) {
    print('  - $f');
  }
  print('');

  if (!_confirm(
    'Are you sure you want to delete all ${lines.length} file(s)? (yes/no): ',
  )) {
    print('Cancelled. No files were deleted.');
    exit(0);
  }

  print('');
  int deleted = 0;
  int skipped = 0;

  for (final relativePath in lines) {
    final file = File('$projectRoot/$relativePath');
    if (!file.existsSync()) {
      print('⚠️  Skipped (not found): $relativePath');
      skipped++;
      continue;
    }
    try {
      file.deleteSync();
      print('✅ Deleted: $relativePath');
      deleted++;
    } catch (e) {
      stderr.writeln('❌ Error deleting $relativePath: $e');
      skipped++;
    }
  }

  print('\n${'─' * 50}');
  print('Done. $deleted file(s) deleted, $skipped file(s) skipped.');
}

// ─── Confirmation Prompt ─────────────────────────────────────────────────────

bool _confirm(String prompt) {
  stdout.write(prompt);
  final input = stdin.readLineSync()?.trim().toLowerCase();
  return input == 'yes' || input == 'y';
}

// ─── Usage ───────────────────────────────────────────────────────────────────

void _printUsage() {
  print('''
Usage: dart scripts/clean_unused.dart <options>

Options:
  --all               Delete all files listed in unused_files_report.txt
  --file <path>       Delete a specific file by path
  --dry-run           Preview what would be deleted without actually deleting
  --help, -h          Show this help message

Examples:
  # Delete all unused files (after running detect_unused.dart)
  dart scripts/clean_unused.dart --all

  # Preview what would be deleted
  dart scripts/clean_unused.dart --all --dry-run

  # Delete a specific file
  dart scripts/clean_unused.dart --file lib/features/old_screen.dart

  # Preview deleting a specific file
  dart scripts/clean_unused.dart --file lib/features/old_screen.dart --dry-run

Workflow:
  1. dart scripts/detect_unused.dart        # detect & generate report
  2. dart scripts/clean_unused.dart --all   # delete all unused files
''');
}
