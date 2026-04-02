import 'package:cached_network_image/cached_network_image.dart'
    show CachedNetworkImage;
import 'package:flutter/cupertino.dart' show CupertinoActivityIndicator;
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart' show SvgPicture;

class AppImage extends StatelessWidget {
  const AppImage({
    required this.imageUrl,
    super.key,
    this.height,
    this.width,
    this.fit = BoxFit.cover,
    this.color,
    this.fallbackUrl,
    this.placeholder,
  });

  final String imageUrl;
  final double? height;
  final double? width;
  final BoxFit fit;
  final Color? color;
  final String? fallbackUrl;
  final Widget? placeholder;

  bool get _isSvg => imageUrl.toLowerCase().endsWith('.svg');

  bool get _isNetworkUrl {
    return imageUrl.startsWith('http://') || imageUrl.startsWith('https://');
  }

  Widget _buildNetworkSvg() {
    try {
      return SvgPicture.network(
        imageUrl,
        height: height,
        width: width,
        fit: fit,
        colorFilter: color != null
            ? ColorFilter.mode(color!, BlendMode.srcIn)
            : null,
        placeholderBuilder: (_) => _buildPlaceholder(),
      );
    } on FormatException catch (e) {
      debugPrint('Asset SVG load failed: $e');
      return _buildFallbackImage();
    }
  }

  Widget _buildAssetSvg() {
    try {
      return SvgPicture.asset(
        imageUrl,
        height: height,
        width: width,
        fit: fit,
        colorFilter: color != null
            ? ColorFilter.mode(color!, BlendMode.srcIn)
            : null,
        placeholderBuilder: (_) => _buildPlaceholder(),
      );
    } on FormatException catch (e) {
      debugPrint('Asset SVG load failed: $e');
      return _buildFallbackImage();
    }
  }

  Widget _buildAssetImage() {
    return Image.asset(
      imageUrl,
      height: height,
      width: width,
      fit: fit,
      color: color,
      errorBuilder: (_, _, _) => _buildFallbackImage(),
    );
  }

  Widget _buildNetworkImage() {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      height: height,
      width: width,
      fit: fit,
      color: color,
      placeholder: (_, _) => _buildPlaceholder(),
      errorWidget: (_, _, _) => _buildFallbackImage(),
    );
  }

  Widget _buildPlaceholder() {
    return placeholder ??
        Container(
          height: height,
          width: width,
          color: Colors.grey[200],
          child: const Center(
            child: CupertinoActivityIndicator(),
          ),
        );
  }

  Widget _buildErrorWidget() {
    return Container(
      height: height,
      width: width,
      color: Colors.grey[200],
      child: const Icon(Icons.broken_image_outlined),
    );
  }

  Widget _buildFallbackImage() {
    if (fallbackUrl == null) return _buildErrorWidget();
    return AppImage(
      imageUrl: fallbackUrl!,
      height: height,
      width: width,
      fit: fit,
      color: color,
      placeholder: _buildPlaceholder(),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (imageUrl.isEmpty) return _buildErrorWidget();

    if (_isSvg) {
      return _isNetworkUrl ? _buildNetworkSvg() : _buildAssetSvg();
    }

    return _isNetworkUrl ? _buildNetworkImage() : _buildAssetImage();
  }
}
