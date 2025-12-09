import 'dart:io';
import 'package:flutter/foundation.dart';
import '../utils/file_size_extension.dart';
import '../core/constants/app_durations.dart';
import '../core/errors/app_exceptions.dart' as errors;

/// Service for handling image compression through AI-powered backend.
///
/// Backend Compression Flow:
/// 1. User selects image from gallery/camera
/// 2. Image is uploaded to backend server
/// 3. Backend converts image to grayscale
/// 4. AI-powered fractal compression is applied
/// 5. Compressed image is returned to client
/// 6. User can download/share the compressed image
class CompressionService {
  /// Backend API base URL.
  /// TODO: Backend Integration - Replace with actual API endpoint
  static const String apiBaseUrl = 'YOUR_BACKEND_API_URL';

  /// Compression endpoint path.
  static const String compressEndpoint = '/api/compress';

  /// Compresses an image using AI-powered fractal compression
  ///
  /// Parameters:
  /// - imageFile: The image file to compress
  ///
  /// Returns:
  /// - CompressionResult containing compressed image, sizes, and metadata
  ///
  /// Throws:
  /// - CompressionException if compression fails
  Future<CompressionResult> compressImage(File imageFile) async {
    try {
      // TODO: Backend Integration - Implement actual API call
      // Example implementation:
      /*
      // 1. Calculate original file size
      final originalSize = await imageFile.length();
      
      // 2. Prepare multipart request
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('$_apiBaseUrl$_compressEndpoint'),
      );
      
      // 3. Add image file to request
      request.files.add(
        await http.MultipartFile.fromPath(
          'image',
          imageFile.path,
          contentType: MediaType('image', 'jpeg'), // or detect from file
        ),
      );
      
      // 4. Add any additional parameters
      request.fields['quality'] = 'high';
      request.fields['algorithm'] = 'fractal_ai';
      
      // 5. Send request to backend
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      
      // 6. Check response status
      if (response.statusCode == 200) {
        // 7. Parse response JSON
        final responseData = json.decode(response.body);
        
        // 8. Download compressed image
        final compressedImageBytes = base64.decode(responseData['compressed_image']);
        
        // 9. Save to temporary file
        final tempDir = await getTemporaryDirectory();
        final compressedFile = File('${tempDir.path}/compressed_${DateTime.now().millisecondsSinceEpoch}.jpg');
        await compressedFile.writeAsBytes(compressedImageBytes);
        
        // 10. Return result
        return CompressionResult(
          originalFile: imageFile,
          compressedFile: compressedFile,
          originalSize: originalSize,
          compressedSize: responseData['compressed_size'],
          compressionRatio: responseData['compression_ratio'],
          isGrayscale: responseData['is_grayscale'] ?? true,
        );
      } else {
        throw CompressionException('Server error: ${response.statusCode}');
      }
      */

      // Placeholder: Simulate API call with delay
      await Future.delayed(AppDurations.compressionSimulation);

      // For now, return a mock result
      final originalSize = await imageFile.length();
      final mockCompressedSize =
          (originalSize * 0.1).toInt(); // 90% compression

      return CompressionResult(
        originalFile: imageFile,
        compressedFile: imageFile, // TODO: Replace with actual compressed file
        originalSize: originalSize,
        compressedSize: mockCompressedSize,
        compressionRatio: 90.0,
        isGrayscale: true,
      );
    } catch (e) {
      debugPrint('Compression error: $e');
      throw CompressionException('Failed to compress image: ${e.toString()}');
    }
  }

  /// Calculates the compression ratio as a percentage.
  double calculateCompressionRatio(int originalSize, int compressedSize) {
    if (originalSize == 0) return 0.0;
    return ((originalSize - compressedSize) / originalSize) * 100;
  }

  // Note: formatFileSize has been removed. Use the extension method instead:
  // import '../utils/file_size_extension.dart';
  // Then use: bytes.toHumanReadableSize()
}

/// Result of image compression operation
class CompressionResult {
  final File originalFile;
  final File compressedFile;
  final int originalSize;
  final int compressedSize;
  final double compressionRatio;
  final bool isGrayscale;

  CompressionResult({
    required this.originalFile,
    required this.compressedFile,
    required this.originalSize,
    required this.compressedSize,
    required this.compressionRatio,
    required this.isGrayscale,
  });

  /// Returns original size in human-readable format
  String get formattedOriginalSize {
    return originalSize.toHumanReadableSize();
  }

  /// Returns compressed size in human-readable format
  String get formattedCompressedSize {
    return compressedSize.toHumanReadableSize();
  }

  /// Returns compression ratio as percentage string
  String get formattedCompressionRatio {
    return '${compressionRatio.toStringAsFixed(1)}%';
  }
}

/// Exception thrown when compression fails.
///
/// Note: Consider using [errors.CompressionException] from
/// `core/errors/app_exceptions.dart` for more structured error handling.
class CompressionException implements Exception {
  final String message;

  CompressionException(this.message);

  @override
  String toString() => 'CompressionException: $message';
}
