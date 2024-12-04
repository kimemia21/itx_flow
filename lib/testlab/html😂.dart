import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;

class VSCodeProjectSaver {
  /// Save file with precise path handling for Windows
  Future<void> saveInProjectDirectory({
    required String url,
    required String relativePath,
    required String filename
  }) async {
    try {
      // Use the current script's directory to find project root
      String currentPath = Platform.script.toFilePath();
      
      // Construct the full path carefully
      // Normalize the path to handle different path separators
      String projectRoot = path.dirname(path.dirname(path.dirname(currentPath)));
      
      // For Windows, ensure correct path construction
      String fullTargetDirectory = path.join(
        projectRoot, 
        relativePath
      );
      
      // Create the full file path
      String fullFilePath = path.join(fullTargetDirectory, filename);
      
      // Ensure directory exists
      Directory(fullTargetDirectory).createSync(recursive: true);
      
      // Fetch HTML content
      final response = await http.get(Uri.parse(url));
      
      if (response.statusCode == 200) {
        final File file = File(fullFilePath);
        await file.writeAsString(response.body);
        
        print('HTML saved to: $fullFilePath');
      } else {
        throw Exception(
          'Failed to fetch HTML. Status code: ${response.statusCode}'
        );
      }
    } catch (e) {
      print('Detailed error saving file:');
      print('Error: $e');
      
      // Additional error details for FileSystemException
      if (e is FileSystemException) {
        print('File system error message: ${e.message}');
        print('Problematic path: ${e.path}');
      }
    }
  }

  /// Alternative method with more explicit path handling
  Future<void> saveWithFullPath({
    required String url,
    required String fullPath,
    required String filename
  }) async {
    try {
      // Construct full file path
      String fullFilePath = path.join(fullPath, filename);
      
      // Ensure directory exists
      Directory(fullPath).createSync(recursive: true);
      
      // Fetch HTML content
      final response = await http.get(Uri.parse(url));
      
      if (response.statusCode == 200) {
        final File file = File(fullFilePath);
        await file.writeAsString(response.body);
        
        print('HTML saved to: $fullFilePath');
      } else {
        throw Exception(
          'Failed to fetch HTML. Status code: ${response.statusCode}'
        );
      }
    } catch (e) {
      print('Error saving file: $e');
    }
  }
}

// Example usage
