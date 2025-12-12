import 'package:flutter/services.dart' show rootBundle;

import '../domain/listing.dart';

class ListingsLocalDataSource {
  final String assetPath;

  ListingsLocalDataSource({this.assetPath = 'assets/listings.json'});

  Future<List<Listing>> loadListings() async {
    final jsonString = await rootBundle.loadString(assetPath);
    return Listing.listFromJsonString(jsonString);
  }
}