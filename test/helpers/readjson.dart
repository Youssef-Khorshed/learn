import 'dart:io';

String readjson({required String name}) {
  var dir = Directory.current.path;
  if (dir.endsWith('/test')) {
    dir = dir.replaceAll('/test', '');
  }
  return File('$dir/test/$name.json').readAsStringSync();
}
