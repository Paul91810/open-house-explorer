import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ImageGallery extends StatefulWidget {
  final List<String> imageUrls;
  final String? mlsNumber;
  final VoidCallback? onShare;

  const ImageGallery({
    super.key,
    required this.imageUrls,
    this.mlsNumber,
    this.onShare,
  });

  @override
  State<ImageGallery> createState() => _ImageGalleryState();
}

class _GalleryState extends ChangeNotifier {
  int _currentPage = 0;
  int get currentPage => _currentPage;

  void setPage(int index) {
    if (index == _currentPage) return;
    _currentPage = index;
    notifyListeners();
  }
}

class _ImageGalleryState extends State<ImageGallery> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.imageUrls.isEmpty) {
      final size = MediaQuery.of(context).size;
      final height = size.height * 0.3;

      return Container(
        color: Colors.grey[200],
        height: height,
        alignment: Alignment.center,
        child: const Icon(
          Icons.image_not_supported,
          size: 48,
          color: Colors.grey,
        ),
      );
    }

    final size = MediaQuery.of(context).size;
    final isTablet = size.width >= 600;
    final height = isTablet ? size.height * 0.45 : size.height * 0.35;
    final safeTop = MediaQuery.of(context).padding.top;

    return ChangeNotifierProvider(
      create: (_) => _GalleryState(),
      child: Builder(
        builder: (galleryContext) {
          return SizedBox(
            height: height,
            width: double.infinity,
            child: Stack(
              fit: StackFit.expand,
              children: [
                PageView.builder(
                  controller: _pageController,
                  itemCount: widget.imageUrls.length,
                  onPageChanged: (index) {
                    galleryContext.read<_GalleryState>().setPage(index);
                  },
                  itemBuilder: (context, index) {
                    final url = widget.imageUrls[index];
                    return CachedNetworkImage(
                      imageUrl: url,
                      fit: BoxFit.cover,
                      placeholder: (context, _) =>
                          Container(color: Colors.grey[200]),
                      errorWidget: (context, _, __) => Container(
                        color: Colors.grey[300],
                        alignment: Alignment.center,
                        child: const Icon(Icons.broken_image),
                      ),
                    );
                  },
                ),

                Positioned(
                  top: safeTop + 8,
                  left: 8,
                  child: _CircleIconButton(
                    icon: Icons.arrow_back,
                    onPressed: () => Navigator.of(context).maybePop(),
                  ),
                ),

                Positioned(
                  top: safeTop + 8,
                  right: 8,
                  child: _CircleIconButton(
                    icon: Icons.share,
                    onPressed:widget.onShare, 
                  ),
                ),

                Positioned(
                  top: safeTop + 8,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.12),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Text(
                        'MLS# ${widget.mlsNumber ?? ''}',
                        style: const TextStyle(
                          color: Color(0xFF0B71C8),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),

                Positioned(
                  bottom: 12,
                  right: 12,
                  child: Consumer<_GalleryState>(
                    builder: (_, state, __) {
                      final current = state.currentPage + 1;
                      final total = widget.imageUrls.length;
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha:  0.65),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '$current/$total',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;

  const _CircleIconButton({
    required this.icon,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withValues(alpha:  0.9),
      shape: const CircleBorder(),
      elevation: 2,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Icon(
            icon,
            size: 20,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }
}