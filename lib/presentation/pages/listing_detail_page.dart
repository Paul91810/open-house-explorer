import 'package:flutter/material.dart';

import '../../domain/listing.dart';
import '../widgets/image_gallery.dart';

class ListingDetailPage extends StatelessWidget {
  final Listing listing;

  const ListingDetailPage({
    super.key,
    required this.listing,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width >= 600;
    final contentMaxWidth = isTablet ? 640.0 : double.infinity;
    final horizontalPadding = isTablet ? size.width * 0.08 : 16.0;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        top: false,
        child: DefaultTabController(
          length: 2,
          child: Column(
            children: [
              Hero(
                tag: 'listing-image-${listing.mlsNumber}',
                child: ImageGallery(
                  imageUrls: listing.pictures,
                  mlsNumber: listing.mlsNumber,
                ),
              ),

              Expanded(
                child: Align(
                  alignment: Alignment.topCenter,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: contentMaxWidth),
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                        horizontalPadding,
                        12,
                        horizontalPadding,
                        8 + MediaQuery.of(context).padding.bottom,
                      ),
                      child: TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0, end: 1),
                        duration: const Duration(seconds: 2),
                        curve: Curves.easeOut,
                        builder: (context, value, child) {
                          return Opacity(
                            opacity: value,
                            child: Transform.translate(
                              offset: Offset(0, 20 * (1 - value)),
                              child: child,
                            ),
                          );
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _HeaderRow(listing: listing),
                            const SizedBox(height: 6),
                            Text(
                              listing.displayAddress
                                  ? listing.fullAddress
                                  : 'Address undisclosed',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(color: Colors.grey[800]),
                            ),
                            const SizedBox(height: 12),
                            _IconsRow(listing: listing),
                            const SizedBox(height: 16),
                            const _ActionsRow(),
                            const SizedBox(height: 16),
                            const Divider(height: 1),
                            const SizedBox(height: 4),
                            const TabBar(
                              labelColor: Color(0xFF0B71C8),
                              unselectedLabelColor: Colors.black54,
                              indicatorColor: Color(0xFF0B71C8),
                              tabs: [
                                Tab(text: 'Details'),
                                Tab(text: 'Listing Agent'),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Expanded(
                              child: TabBarView(
                                children: [
                                  _DetailsTab(listing: listing),
                                  _AgentTab(listing: listing),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeaderRow extends StatelessWidget {
  final Listing listing;

  const _HeaderRow({required this.listing});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width >= 600;

    final priceStyle = Theme.of(context).textTheme.headlineSmall?.copyWith(
          fontSize: isTablet ? 24 : 20,
          fontWeight: FontWeight.w700,
        );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          listing.listPrice != null ? _formatPrice(listing.listPrice!) : '—',
          style: priceStyle,
        ),
        const SizedBox(width: 6),
        if (listing.propertyType != null)
          Text(
            listing.propertyType!,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[700],
                ),
          ),
        const Spacer(),
        _StatusChip(status: listing.status ?? ''),
      ],
    );
  }

  String _formatPrice(int price) {
    return '\$${price.toString().replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (m) => ',',
    )}';
  }
}

class _StatusChip extends StatelessWidget {
  final String status;

  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    if (status.isEmpty) return const SizedBox.shrink();

    Color bg = const Color(0xFF0B71C8);
    if (status.toLowerCase().contains('pending')) {
      bg = const Color(0xFFFFA000);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        status,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _IconsRow extends StatelessWidget {
  final Listing listing;

  const _IconsRow({required this.listing});

  @override
  Widget build(BuildContext context) {
    final infoStyle = Theme.of(context).textTheme.bodySmall;

    return Row(
      children: [
        _InfoIcon(
          icon: Icons.directions_car,
          label: '—',
          style: infoStyle,
        ),
        const SizedBox(width: 20),
        _InfoIcon(
          icon: Icons.bed,
          label: listing.beds?.toString() ?? '—',
          style: infoStyle,
        ),
        const SizedBox(width: 20),
        _InfoIcon(
          icon: Icons.bathtub,
          label: listing.bathsTotal?.toString() ?? '—',
          style: infoStyle,
        ),
        const SizedBox(width: 20),
        _InfoIcon(
          icon: Icons.description_outlined,
          label: listing.sqft != null ? '${listing.sqft} Sqft' : '—',
          style: infoStyle,
        ),
      ],
    );
  }
}

class _InfoIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  final TextStyle? style;

  const _InfoIcon({
    required this.icon,
    required this.label,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: const Color(0xFF0B71C8)),
        const SizedBox(width: 4),
        Text(label, style: style),
      ],
    );
  }
}

class _ActionsRow extends StatelessWidget {
  const _ActionsRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.language,
                size: 18, color: Color(0xFF0B71C8)),
            label: const Text(
              'View on website',
              style: TextStyle(color: Color(0xFF0B71C8), fontSize: 13),
            ),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Color(0xFF0B71C8)),
              padding: const EdgeInsets.symmetric(vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.location_on,
                size: 18, color: Color(0xFF0B71C8)),
            label: const Text(
              'View on map',
              style: TextStyle(color: Color(0xFF0B71C8), fontSize: 13),
            ),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Color(0xFF0B71C8)),
              padding: const EdgeInsets.symmetric(vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _DetailsTab extends StatelessWidget {
  final Listing listing;

  const _DetailsTab({required this.listing});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(top: 8, bottom: 24),
      children: [
        _DetailRow(label: 'MLS#', value: listing.mlsNumber),
        _DetailRow(label: 'Property type', value: listing.propertyType ?? '—'),
        _DetailRow(label: 'Status', value: listing.status ?? '—'),
      ],
    );
  }
}

class _AgentTab extends StatelessWidget {
  final Listing listing;

  const _AgentTab({required this.listing});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(top: 8, bottom: 24),
      children: [
        _DetailRow(
            label: 'Name', value: listing.listAgentName ?? 'Not available'),
        _DetailRow(
            label: 'Office', value: listing.listAgentOffice ?? 'Not available'),
      ],
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final labelStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: Colors.grey[600],
        );
    final valueStyle = Theme.of(context).textTheme.bodyMedium;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          SizedBox(
            width: 110,
            child: Text(label, style: labelStyle),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: valueStyle,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}