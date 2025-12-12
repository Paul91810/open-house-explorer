import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ListingsShimmer extends StatelessWidget {
  final int itemCount;

  const ListingsShimmer({super.key, this.itemCount = 6});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width >= 600;
    final cardHeight = isTablet ? 130.0 : 110.0;
    final imageWidth = isTablet ? size.width * 0.22 : size.width * 0.28;

    return ListView.separated(
      itemCount: itemCount,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            height: cardHeight,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: const Color(0xFFE0E0E0)),
            ),
            child: Row(
              children: [
                // Image skeleton
                Container(
                  width: imageWidth,
                  height: cardHeight,
                  decoration: const BoxDecoration(
                    borderRadius:
                        BorderRadius.horizontal(left: Radius.circular(6)),
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 100,
                          height: 16,
                          color: Colors.white,
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: double.infinity,
                          height: 14,
                          color: Colors.white,
                        ),
                        const SizedBox(height: 4),
                        Container(
                          width: size.width * 0.3,
                          height: 14,
                          color: Colors.white,
                        ),
                        const Spacer(),
                        Row(
                          children: [
                            Container(
                              width: 40,
                              height: 14,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 8),
                            Container(
                              width: 40,
                              height: 14,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Container(
                                height: 14,
                                color: Colors.white,
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
      },
    );
  }
}