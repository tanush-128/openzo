// repositories/sale_repository.dart
import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:openzo_frontend/models/sale.dart';
import 'package:openzo_frontend/constants/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SaleRepository {
  static String endpoint = '${GlobalConsts.backend_url}/sales';

  static Future<Sale> createSale(Sale sale) async {
    final response = await http.post(
      Uri.parse('$endpoint/'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(sale.toJson()),
    );

    if (response.statusCode == 201) {
      return Sale.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create sale');
    }
  }

  static Future<Sale> getSaleByID(String id) async {
    final response = await http.get(
      Uri.parse('$endpoint/$id'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      return Sale.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to get sale');
    }
  }

  static Future<List<Sale>> getSalesByStoreID(String storeID) async {
    final response = await http.get(
      Uri.parse('$endpoint/store/$storeID'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      return body.map((dynamic item) => Sale.fromJson(item)).toList();
    } else {
      throw Exception('Failed to get sales');
    }
  }

  static Future<List<Sale>> getSalesByUserID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) {
      return [];
    }

    final response = await http.get(
      Uri.parse('$endpoint/user'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': token,
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      return body.map((dynamic item) => Sale.fromJson(item)).toList();
    } else {
      throw Exception('Failed to get sales');
    }
  }

  static Future<Sale> changeSaleStatus(String id, String status) async {
    final response = await http.put(
      Uri.parse('$endpoint/$id/status/$status'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      return Sale.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to change sale status');
    }
  }

  static Future<Sale> updateSale(Sale sale) async {
    // sale.orderTime = DateTime.now();
    // sale.bookingTime ??= DateTime.now();
    final response = await http.put(
      Uri.parse('$endpoint/'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(sale.toJson()),
    );

    if (response.statusCode == 200) {
      log("Updated sale: ${response.body}");
      return Sale.fromJson(jsonDecode(response.body));
    } else {
      log("Failed to update sale: ${response.body}");
      throw Exception('Failed to update sale');
    }
  }

  static Future<void> deleteSale(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    final response = await http.delete(
      Uri.parse('$endpoint/$id'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': token!,
      },
    );

    if (response.statusCode == 200) {
      log("Deleted sale: ${response.body}");
    } else {
      throw Exception('Failed to delete sale');
    }
  }
}
