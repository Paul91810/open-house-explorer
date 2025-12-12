import 'dart:convert';

import 'package:http/http.dart' as http;

import '../domain/listing.dart';

class ListingsRemoteDataSource {
  final http.Client client;
  final String baseUrl;

  ListingsRemoteDataSource({
    required this.client,
    required this.baseUrl,
  });

  Future<List<Listing>> fetchListings(String path) async {
    final uri = Uri.parse('$baseUrl$path');

    final response = await client.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch listings: ${response.statusCode}');
    }

    return Listing.listFromJsonString(utf8.decode(response.bodyBytes));
  }
}