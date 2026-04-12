import '../constants/api_constants.dart';
import 'package:http/http.dart' as http;

class UploadData {
  Future<bool> postdata(String jsonData, String pathName) async {
    String baseUrl = ApiConstants.basePath + pathName;

    var response = await http.post(Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'}, body: jsonData);

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
