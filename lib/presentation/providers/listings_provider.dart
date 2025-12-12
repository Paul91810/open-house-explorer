import 'package:flutter/foundation.dart';

import '../../data/listings_repository.dart';
import '../../domain/listing.dart';

enum ListingsStatus { initial, loading, loaded, error }

class ListingsProvider extends ChangeNotifier {
  final ListingsRepository repository;

  ListingsStatus _status = ListingsStatus.initial;
  String? _errorMessage;
  List<Listing> _allListings = [];
  List<Listing> _filteredListings = [];
  String _searchQuery = '';

  bool _isSearchMode = false;
  bool _initialAnimationPlayed = false;

  ListingsProvider({required this.repository});

  ListingsStatus get status => _status;
  String? get errorMessage => _errorMessage;
  List<Listing> get listings => List.unmodifiable(_filteredListings);
  String get searchQuery => _searchQuery;
  bool get isSearching => _searchQuery.isNotEmpty;
  bool get isEmpty =>
      _status == ListingsStatus.loaded && _filteredListings.isEmpty;

  bool get isSearchMode => _isSearchMode;
  bool get initialAnimationPlayed => _initialAnimationPlayed;

  Future<void> loadListings({bool forceRefresh = false}) async {
    if (_status == ListingsStatus.loading) return;

    _status = ListingsStatus.loading;
    notifyListeners();

    try {
      _allListings = await repository.getListings(forceRefresh: forceRefresh);
      _applyFilter();
      _status = ListingsStatus.loaded;
      _errorMessage = null;
    } catch (e, stack) {
      if (kDebugMode) {
        print('Error loading listings: $e');
        print(stack);
      }
      _status = ListingsStatus.error;
      _errorMessage = 'Failed to load listings';
    }

    notifyListeners();
  }

  void updateSearchQuery(String query) {
    if (query == _searchQuery) return;
    _searchQuery = query;
    _applyFilter();
    notifyListeners();
  }


  void startSearch() {
    if (_isSearchMode) return;
    _isSearchMode = true;
    notifyListeners();
  }

  void stopSearch() {
    if (!_isSearchMode) return;
    _isSearchMode = false;

    if (_searchQuery.isNotEmpty) {
      _searchQuery = '';
      _applyFilter();
    }
    notifyListeners();
  }

  void markInitialAnimationPlayed() {
    if (_initialAnimationPlayed) return;
    _initialAnimationPlayed = true;
    notifyListeners();
  }


  void _applyFilter() {
    if (_searchQuery.isEmpty) {
      _filteredListings = _allListings;
      return;
    }

    final q = _searchQuery.toLowerCase();
    _filteredListings = _allListings.where((listing) {
      final address = listing.fullAddress.toLowerCase();
      return address.contains(q);
    }).toList();
  }
}