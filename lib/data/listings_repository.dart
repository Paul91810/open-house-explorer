import 'package:open_house_explorer/data/listings_remote_data_source.dart';

import '../domain/listing.dart';
import 'listings_local_data_source.dart';

class ListingsRepository {
  final ListingsLocalDataSource localDataSource;
  final ListingsRemoteDataSource? remoteDataSource;

  List<Listing>? _cache;

  ListingsRepository({
    required this.localDataSource,
    this.remoteDataSource,
  });

  
  Future<List<Listing>> getListings({
    bool forceRefresh = false,
    bool useRemote = false,
  }) async {
    if (!forceRefresh && _cache != null) {
      return _cache!;
    }

    if (useRemote && remoteDataSource != null) {
      final remoteListings =
          await remoteDataSource!.fetchListings('/listings'); 
      _cache = remoteListings;
      return _cache!;
    }

    final localListings = await localDataSource.loadListings();
    _cache = localListings;
    return _cache!;
  }
}