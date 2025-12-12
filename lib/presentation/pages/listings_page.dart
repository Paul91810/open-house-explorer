import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../domain/listing.dart';
import '../providers/listings_provider.dart';
import '../widgets/listing_card.dart';
import '../widgets/listings_shimmer.dart';
import '../widgets/staggered_list_item.dart';
import 'listing_detail_page.dart';

class ListingsPage extends StatefulWidget {
  const ListingsPage({super.key});

  @override
  State<ListingsPage> createState() => _ListingsPageState();
}

class _ListingsPageState extends State<ListingsPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _startSearch() {
    context.read<ListingsProvider>().startSearch();
  }

  void _stopSearch() {
    final provider = context.read<ListingsProvider>();
    provider.stopSearch();
    _searchController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ListingsProvider>();
    final size = MediaQuery.of(context).size;
    final isTablet = size.width >= 600;
    final horizontalBodyPadding = isTablet ? size.width * 0.12 : 8.0;
    final appBarHeight = isTablet ? 64.0 : 56.0;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(appBarHeight),
        child: provider.isSearchMode
            ? _buildSearchAppBar(appBarHeight)
            : _buildDefaultAppBar(appBarHeight),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: Align(
                  alignment: Alignment.topCenter,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: isTablet ? 600 : double.infinity,
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: horizontalBodyPadding,
                        vertical: 8,
                      ),
                      child: _buildBody(provider),
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (provider.isSearchMode &&
              provider.status == ListingsStatus.loaded &&
              provider.listings.isNotEmpty)
            Positioned(
              bottom: size.height * 0.04,
              left: 0,
              right: 0,
              child: Center(
                child: _ResultCountPill(count: provider.listings.length),
              ),
            ),
        ],
      ),
    );
  }

  AppBar _buildDefaultAppBar(double height) {
    return AppBar(
      toolbarHeight: height,
      backgroundColor: const Color(0xFF0B71C8),
     
      centerTitle: true,
      title: const Text(
        'Listings',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.search, color: Colors.white),
          onPressed: _startSearch,
        ),
      ],
    );
  }

  AppBar _buildSearchAppBar(double height) {
    final provider = context.watch<ListingsProvider>();

    return AppBar(
      automaticallyImplyLeading: false,
      toolbarHeight: height,
      backgroundColor: const Color(0xFF0B71C8),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: _stopSearch,
      ),
      titleSpacing: 0,
      title: TextField(
        controller: _searchController,
        autofocus: true,
        style: const TextStyle(color: Colors.white),
        decoration: const InputDecoration(
          hintText: 'Search by address',
          hintStyle: TextStyle(color: Colors.white70),
          border: InputBorder.none,
          isDense: true,
          contentPadding: EdgeInsets.symmetric(vertical: 8),
        ),
        cursorColor: Colors.white,
        onChanged: (value) =>
            context.read<ListingsProvider>().updateSearchQuery(value),
      ),
      actions: [
        if (provider.searchQuery.isNotEmpty)
          IconButton(
            icon: const Icon(Icons.clear, color: Colors.white),
            onPressed: () {
              _searchController.clear();
              context.read<ListingsProvider>().updateSearchQuery('');
            },
          ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildBody(ListingsProvider provider) {
    switch (provider.status) {
      case ListingsStatus.initial:
      case ListingsStatus.loading:
        return const ListingsShimmer();

      case ListingsStatus.error:
        return Center(child: Text(provider.errorMessage ?? 'Error'));

      case ListingsStatus.loaded:
        if (provider.listings.isEmpty) {
          return const Center(child: Text('No listings found.'));
        }

        final playEntryAnimation = !provider.initialAnimationPlayed;

        if (playEntryAnimation) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted) return;
            context.read<ListingsProvider>().markInitialAnimationPlayed();
          });
        }

        return ListView.separated(
          itemCount: provider.listings.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final listing = provider.listings[index];

            final card = ListingCard(
              listing: listing,
              onTap: () {
                Navigator.of(context).push(_buildDetailRoute(listing));
              },
            );

            if (!playEntryAnimation) {
              return card;
            }

            return StaggeredListItem(
              index: index,
              child: card,
            );
          },
        );
    }
  }

  Route _buildDetailRoute(Listing listing) {
    return PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, animation, secondaryAnimation) =>
          FadeTransition(
        opacity: animation,
        child: ListingDetailPage(listing: listing),
      ),
    );
  }
}

class _ResultCountPill extends StatelessWidget {
  final int count;

  const _ResultCountPill({required this.count});

  @override
  Widget build(BuildContext context) {
    final text = count.toString().padLeft(2, '0');
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        '$text listings found',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
        ),
      ),
    );
  }
}