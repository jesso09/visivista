import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:visivista/api/base_url.dart';
import 'package:visivista/model/global_item.dart';
import 'package:visivista/model/user.dart';

class Authentication {
  String baseUrl = GlobalApi.getBaseUrl();

  Future doLogin(String? email, String? password) async {
    Uri url = Uri.parse('${baseUrl}auth/login');

    final response = await http.post(url, body: {
      "email": email,
      "password": password,
      "device_token": GlobalItem.deviceToken,
    });

    if (response.statusCode == 200) {
      var loginData = json.decode(response.body);
      GlobalItem.userToken = loginData['data'];
      final mySharedPref = await SharedPreferences.getInstance();
      mySharedPref.setString('token', GlobalItem.userToken!);
      GlobalItem.isAlreadyLoggedIn = true;
      autoLogin();
      return true;
    } else {
      GlobalItem.message = 'Wrong Email/Password';

      return false;
    }
  }

  Future<User> getUserInfo(String? token) async {
    Uri url = Uri.parse('${baseUrl}user');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      var userData = json.decode(response.body);
      GlobalItem.userID = userData['id'];
      if (userData != null && userData is Map<String, dynamic>) {
        return User.fromJson(userData);
      } else {
        throw Exception('Invalid data format in response');
      }
    } else {
      throw Exception('Failed to load user info');
    }
  }

  Future registerUser(String? nama, String? email, String? password) async {
    Uri url = Uri.parse('${baseUrl}auth/register');

    final response = await http.post(url, body: {
      "nama": nama,
      "email": email,
      "password": password,
    });

    if (response.statusCode == 201) {
      return true;
    } else {
      var userLoggedIn = json.decode(response.body);

      if (userLoggedIn != null && userLoggedIn['message'] is List<dynamic>) {
        var messages = userLoggedIn['message'] as List<dynamic>;

        GlobalItem.message =
            messages.isNotEmpty ? messages.join('\n') : 'Tidak ada pesan';
      } else if (userLoggedIn != null && userLoggedIn['message'] is String) {
        GlobalItem.message = userLoggedIn['message'];
      } else {
        GlobalItem.message = 'Tidak ada pesan';
      }
      return false;
    }
  }

  Future<bool> autoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final myToken = prefs.getString('token');
    GlobalItem.userToken = myToken;
    GlobalItem.isAlreadyLoggedIn = true;

    // print("this token$myToken");
    // print("this Global Token${GlobalItem.userToken}");
    return true;
  }

  Future<bool> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    // await prefs.clear();
    GlobalItem.userToken = null;
    GlobalItem.isAlreadyLoggedIn = false;

    return true;
  }
}
