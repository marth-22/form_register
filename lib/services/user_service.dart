
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';

class UserService {
  static const String baseUrl = 'reqres.in/api/collections/contacts/records';

  // Masukkan API Key baru milikmu.
  // Jangan gunakan key yang sudah terlanjur dibagikan.
  static const String apiKey = 'pro_c0f8f7895c03a40758e84ef8a3be9530291d29b652062dad';

  Map<String, String> get headers => {
        'Content-Type': 'application/json',
        'x-api-key': apiKey,
        'X-Reqres-Env': 'prod',
      };

  // GET: Mengambil daftar pengguna
  Future<List<UserModel>> getUsers() async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl?page=1'), headers: headers)
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final List data = json['data'];

        return data
            .map((item) => UserModel.fromJson(item))
            .toList();
      } else {
        throw Exception(
          'Gagal mengambil data (${response.statusCode}): ${response.body}',
        );
      }
    } on SocketException {
      throw Exception('Tidak ada koneksi internet.');
    } on http.ClientException {
      throw Exception('Tidak dapat terhubung ke server.');
    } on FormatException {
      throw Exception('Format JSON tidak valid.');
    } catch (e) {
      throw Exception(e.toString().replaceFirst('Exception: ', ''));
    }
  }

  // POST: Menambahkan pengguna
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
              'name': '$firstName $lastName',
              'job': email,
            }),
          )
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        throw Exception(
          'Gagal menambah pengguna (${response.statusCode}): ${response.body}',
        );
      }
    } on SocketException {
      throw Exception('Tidak ada koneksi internet.');
    } on http.ClientException {
      throw Exception('Tidak dapat terhubung ke server.');
    } on FormatException {
      throw Exception('Format respons tidak valid.');
    } catch (e) {
      throw Exception(e.toString().replaceFirst('Exception: ', ''));
    }
  }

  // PUT: Memperbarui pengguna
  Future<Map<String, dynamic>> updateUser({
    required String id,
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
              'name': '$firstName $lastName',
              'job': email,
            }),
          )
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception(
          'Gagal mengubah pengguna (${response.statusCode}): ${response.body}',
        );
      }
    } on SocketException {
      throw Exception('Tidak ada koneksi internet.');
    } on http.ClientException {
      throw Exception('Tidak dapat terhubung ke server.');
    } on FormatException {
      throw Exception('Format respons tidak valid.');
    } catch (e) {
      throw Exception(e.toString().replaceFirst('Exception: ', ''));
    }
  }

  // DELETE: Menghapus pengguna
  Future<void> deleteUser(String id) async {
    try {
      final response = await http
          .delete(
            Uri.parse('$baseUrl/$id'),
            headers: headers,
          )
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 204 ||
          response.statusCode == 200) {
        return;
      } else {
        throw Exception(
          'Gagal menghapus pengguna (${response.statusCode}): ${response.body}',
        );
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
