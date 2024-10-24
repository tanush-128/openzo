import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:openzo_frontend/models/address.dart';

import '../constants/constants.dart';

class AddressRepository {
  static String endpoint = '${GlobalConsts.backend_url}/users';
  // static String endpoint = 'https://fxscpgdl-8081.inc1.devtunnels.ms';

  static Future<List<Address>> getAddressesByUserId(String userId) async {
    final response = await http.get(
      Uri.parse('$endpoint/address/user/$userId'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      return (jsonDecode(response.body) as List)
          .map((e) => Address.fromJson(e))
          .toList();
    } else {
      throw Exception('Failed to load user');
    }
  }

  static Future<Address> createAddress(Address address) async {
    final response = await http.post(
      Uri.parse('$endpoint/address'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(address.toJson()),
    );

    if (response.statusCode == 201) {
      return Address.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(jsonDecode(response.body)['error']);
    }
  }

  static Future<Address> updateAddress(Address address) async {
    final response = await http.put(
      Uri.parse('$endpoint/address'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(address.toJson()),
    );

    if (response.statusCode == 200) {
      return Address.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(jsonDecode(response.body)['error']);
    }
  }
}
