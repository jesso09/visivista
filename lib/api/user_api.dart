import 'dart:convert';
import 'package:visivista/model/global_item.dart';
import 'package:http/http.dart' as http;
import 'package:visivista/model/user.dart';
import 'package:visivista/api/base_url.dart';

class UserApi {
  String baseUrl = GlobalApi.getBaseUrl();

  Future<User> getDataUser() async {
    Uri url = Uri.parse('${baseUrl}user/getUser');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer ${GlobalItem.userToken}',
      },
    );
    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);
      var dataUser = responseData['data'];
      if (dataUser != null && dataUser is Map<String, dynamic>) {
        return User.fromJson(dataUser);
      } else {
        throw Exception('Invalid data format in response');
      }
    } else {
      throw Exception('Failed to connect to $baseUrl');
    }
  }

  Future<bool> edit({
    required int idUser,
    String? photo,
    String? nama,
    String? email,
    bool closePressed = false,
  }) async {
    try {
      Uri url = Uri.parse('${baseUrl}user/editUser');

      // Membuat request dengan tipe Multipart
      var request = http.MultipartRequest('POST', url)
        ..headers['Authorization'] = 'Bearer ${GlobalItem.userToken}'
        ..fields.addAll({
          "nama": nama ?? "",
          "email": email ?? "",
        });

      // Menambahkan file gambar ke request
      if (photo != null && photo.isNotEmpty && !closePressed) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'profile_pict',
            photo,
          ),
        );
      }

      // Mengirim request dan mendapatkan response
      final response = await request.send();

      // String responseBody = await response.stream.bytesToString();
      // print("IdUser $idUser");
      // print(responseBody);
      // print(request);
      // print(response.statusCode);
      // Menanggapi response
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (error) {
      return false;
    }
  }

  Future<List<User>> searchUser(String nama) async {
    Uri url = Uri.parse('${baseUrl}user/searchUser');

    final response = await http.post(
      url,
      body: {
        "nama": nama,
      },
      headers: {
        'Authorization': 'Bearer ${GlobalItem.userToken}',
      },
    );
    if (response.statusCode == 200) {
      var responseData = json.decode(response.body) as Map<String, dynamic>;
      var dataFromResponse = responseData['data'] as List<dynamic>;

      List<User> listData = dataFromResponse
          .map<User>((tempData) => User.fromJson(tempData))
          .toList();
      return listData;
    } else if (response.statusCode == 0) {
      throw Exception('Failed to connect to $baseUrl');
    } else {
      throw Exception('Failed get data member');
    }
  }

  Future updateDeviceToken(int idUser, String deviceToken) async {
    Uri url = Uri.parse('${baseUrl}user/devto');

    final response = await http.post(
      url,
      body: {
        "id": idUser.toString(),
        "device_token": deviceToken,
      },
      headers: {
        'Authorization': 'Bearer ${GlobalItem.userToken}',
      },
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future deleteProfilePict(bool closePressed) async {
    Uri url = Uri.parse('${baseUrl}user/deleteProfilePict');

    final response = await http.post(
      url,
      body: {
        "closePressed": closePressed.toString(),
      },
      headers: {
        'Authorization': 'Bearer ${GlobalItem.userToken}',
      },
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
