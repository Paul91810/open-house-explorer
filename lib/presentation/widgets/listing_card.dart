import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../domain/listing.dart';

class ListingCard extends StatelessWidget {
  final Listing listing;
  final VoidCallback? onTap;

  const ListingCard({
    super.key,
    required this.listing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final isTablet = size.width >= 600;

    final cardHeight = isTablet ? 130.0 : 110.0;
    final imageWidth = isTablet ? size.width * 0.22 : size.width * 0.28;
    final contentPadding = size.width * 0.02;

    final priceStyle = theme.textTheme.titleMedium?.copyWith(
      fontSize: isTablet ? 18 : 16,
      fontWeight: FontWeight.w600,
    );

    final addressStyle = theme.textTheme.bodyMedium?.copyWith(
      fontSize: isTablet ? 14 : 13,
      color: Colors.grey[800],
    );

    return InkWell(
      onTap: onTap,
      child: Container(
        height: cardHeight,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: const Color(0xFFE0E0E0)),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius:
                  const BorderRadius.horizontal(left: Radius.circular(6)),
              child: SizedBox(
                width: imageWidth,
                height: cardHeight,
                child: listing.pictures.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: listing.pictures.first,
                        fit: BoxFit.cover,
                        placeholder: (_, __) =>
                            Container(color: Colors.grey[200]),
                        errorWidget: (_, __, ___) => Container(
                          color: Colors.grey[300],
                          alignment: Alignment.center,
                          child: const Icon(Icons.broken_image),
                        ),
                      )
                    : Container(
                        color: Colors.grey[200],
                        alignment: Alignment.center,
                        child: const Icon(Icons.image_not_supported),
                      ),
              ),
            ),

            Expanded(
              child: Padding(
                padding: EdgeInsets.all(contentPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            listing.listPrice != null
                                ? _formatPrice(listing.listPrice!)
                                : '—',
                            style: priceStyle,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 4),
                        _buildStatusChip(listing.status),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      listing.displayAddress
                          ? listing.fullAddress
                          : 'Address undisclosed',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: addressStyle,
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        _iconWithText(
                          icon: Icons.directions_car,
                          text: '—',
                        ),
                        const SizedBox(width: 12),
                        _iconWithText(
                          icon: Icons.bed,
                          text: listing.beds?.toString() ?? '—',
                        ),
                        const SizedBox(width: 12),
                        _iconWithText(
                          icon: Icons.bathtub,
                          text: listing.bathsTotal?.toString() ?? '—',
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _iconWithText(
                            icon: Icons.description_outlined,
                            text: listing.sqft != null
                                ? '${listing.sqft} Sqft'
                                : '—',
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(String? status) {
    if (status == null || status.isEmpty) {
      return const SizedBox.shrink();
    }

    final normalized = status.toLowerCase();
    Color bg = const Color(0xFF0B71C8);
    if (normalized.contains('pending')) {
      bg = const Color(0xFFFFA000);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        status,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _iconWithText({
    required IconData icon,
    required String text,
    TextOverflow? overflow,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: const Color(0xFF0B71C8)),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            text,
            overflow: overflow,
            style: const TextStyle(fontSize: 12),
          ),
        ),
      ],
    );
  }

  String _formatPrice(int price) {
    return '\$${price.toString().replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'),
        (m) => ',')}';
  }
}