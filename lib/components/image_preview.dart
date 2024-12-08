import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ImagePreview extends StatelessWidget {
  final File? imageFile;
  final String? imageUrl;
  final double height;
  final double width;
  final BoxFit fit;

  const ImagePreview({
    super.key,
    this.imageFile,
    this.imageUrl,
    this.height = 200,
    this.width = double.infinity,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    if (imageFile != null) {
      if (kIsWeb) {
        // For web, convert the image file to memory image
        return Image.memory(
          imageFile!.readAsBytesSync(),
          height: height,
          width: width,
          fit: fit,
          errorBuilder: (context, error, stackTrace) {
            return _buildErrorPlaceholder();
          },
        );
      } else {
        // For mobile platforms
        return Image.file(
          imageFile!,
          height: height,
          width: width,
          fit: fit,
          errorBuilder: (context, error, stackTrace) {
            return _buildErrorPlaceholder();
          },
        );
      }
    } else if (imageUrl != null && imageUrl!.isNotEmpty) {
      // For network images
      return Image.network(
        imageUrl!,
        height: height,
        width: width,
        fit: fit,
        errorBuilder: (context, error, stackTrace) {
          return _buildErrorPlaceholder();
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                  loadingProgress.expectedTotalBytes!
                  : null,
            ),
          );
        },
      );
    }
    return _buildErrorPlaceholder();
  }

  Widget _buildErrorPlaceholder() {
    return Container(
      height: height,
      width: width,
      color: Colors.grey[200],
      child: const Icon(
        Icons.image_not_supported,
        color: Colors.grey,
        size: 50,
      ),
    );
  }
}