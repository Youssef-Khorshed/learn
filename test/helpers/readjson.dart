import 'dart:io';

Future<String> readJson({required String name}) async {
  try {
    // Get the current directory (make sure it's the correct one for your environment)
    var dir = Directory.current.path;

    // If running in a test environment, adjust path accordingly
    if (dir.endsWith('test')) {
      dir = dir.substring(0, dir.length - 'test'.length);
    }

    // Construct the full path to the JSON file
    var filePath = '$dir/test/$name.json';

    // Check if the file exists before reading it
    var file = File(filePath);
    if (!await file.exists()) {
      throw Exception('File not found: $filePath');
    }

    // Read the file asynchronously and return the contents as a String
    return await file.readAsString();
  } catch (e) {
    // Handle errors (e.g., file not found, invalid JSON)
    print('Error reading JSON: $e');
    rethrow;
  }
}
