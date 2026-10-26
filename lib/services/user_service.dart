
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';

class UserService {
  static const String baseUrl = 'https://reqres.in/api/users';

  // Ganti dengan API key ReqRes milikmu jika diminta.
  static const String apiKey = 'free_user_3LETMvrLB2IDvpvGJyMANd08HJm';

  Map<String, String> get headers => {
        'Content-Type': 'application/json',
        'x-api-key': apiKey,
      };

  Future<List<UserModel>> getUsers() async {
    try {
      final response = await http
          .get(Uri.parse(baseUrl), headers: headers)
          .timeout(const Duration(seconds: 15));

      if (response.statusCode != 200) {
        throw Exception('Gagal mengambil data (${response.statusCode})');
      }

      final json = jsonDecode(response.body);
      final List data = json['data'];

      return data.map((e) => UserModel.fromJson(e)).toList();
    } on SocketException {
      throw Exception('Tidak ada koneksi internet.');
    } on http.ClientException {
      throw Exception('Tidak dapat terhubung ke server.');
    } on FormatException {
      throw Exception('Format data dari server tidak valid.');
    } catch (e) {
      throw Exception(e.toString().replaceFirst('Exception: ', ''));
    }
  }

  Future<Map<String, dynamic>> createUser({
    required String firstName,
    required String lastName,
    required String email,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse(baseUrl),
            headers: headers,
            body: jsonEncode({
              'first_name': firstName,
              'last_name': lastName,
              'email': email,
            }),
          )
          .timeout(const Duration(seconds: 15));

      if (response.statusCode != 201) {
        throw Exception('Gagal menambah user (${response.statusCode})');
      }

      return jsonDecode(response.body);
    } on SocketException {
      throw Exception('Tidak ada koneksi internet.');
    } on http.ClientException {
      throw Exception('Tidak dapat terhubung ke server.');
    } on FormatException {
      throw Exception('Format respons server tidak valid.');
    } catch (e) {
      throw Exception(e.toString().replaceFirst('Exception: ', ''));
    }
  }

  Future<Map<String, dynamic>> updateUser({
    required int id,
    required String firstName,
    required String lastName,
    required String email,
  }) async {
    try {
      final response = await http
          .put(
            Uri.parse('$baseUrl/$id'),
            headers: headers,
            body: jsonEncode({
              'first_name': firstName,
              'last_name': lastName,
              'email': email,
            }),
          )
          .timeout(const Duration(seconds: 15));

      if (response.statusCode != 200) {
        throw Exception('Gagal mengubah user (${response.statusCode})');
      }

      return jsonDecode(response.body);
    } on SocketException {
      throw Exception('Tidak ada koneksi internet.');
    } on http.ClientException {
      throw Exception('Tidak dapat terhubung ke server.');
    } on FormatException {
      throw Exception('Format respons server tidak valid.');
    } catch (e) {
      throw Exception(e.toString().replaceFirst('Exception: ', ''));
    }
  }

  Future<void> deleteUser(int id) async {
    try {
      final response = await http
          .delete(
            Uri.parse('$baseUrl/$id'),
            headers: headers,
          )
          .timeout(const Duration(seconds: 15));

      if (response.statusCode != 204 && response.statusCode != 200) {
        throw Exception('Gagal menghapus user (${response.statusCode})');
      }
    } on SocketException {
      throw Exception('Tidak ada koneksi internet.');
    } on http.ClientException {
      throw Exception('Tidak dapat terhubung ke server.');
    } catch (e) {
      throw Exception(e.toString().replaceFirst('Exception: ', ''));
    }
  }
}
