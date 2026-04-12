import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;

import '../constants/api_constants.dart';

class IndirectDataUploadImageAPI {
  Future<bool> postImagesToserver(
      {List<File>? imageFiles, String? indirectDataGuid}) async {
    // Create a multipart request for uploading the images
    final request = http.MultipartRequest(
        'POST',
        Uri.parse(
            '${ApiConstants.basePath}UploadImage?IndirectDataGuid=$indirectDataGuid'));
    for (var imageFile in imageFiles!) {
      final fileName = path.basename(imageFile.path);
      final fileStream = http.ByteStream(imageFile.openRead());
      final fileLength = await imageFile.length();
      final multipartFile = http.MultipartFile(
          'content', fileStream, fileLength,
          filename: fileName);
      request.files.add(multipartFile);
    }

    // Send the request and wait for the response
    final response = await request.send();
    if (response.statusCode >= 200 && response.statusCode < 400) {
      // The images were uploaded successfully
      return true;
    } else {
      // There was an error uploading the images
      return false;
    }
  }
}
