import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../widgets/compression_loading_overlay.dart';
import '../widgets/upload_modal.dart';
import '../widgets/hero_section.dart';
import '../widgets/web_navbar.dart';
import '../widgets/animated_background.dart';
import '../widgets/web_tutorial_overlay.dart';
import 'compression_result_screen.dart';

class WebHomeScreen extends StatefulWidget {
  const WebHomeScreen({super.key});

  @override
  State<WebHomeScreen> createState() => _WebHomeScreenState();
}

class _WebHomeScreenState extends State<WebHomeScreen> {
  File? _selectedImage;
  Uint8List? _imageBytes;
  bool _isProcessing = false;

  // Tutorial Keys
  final GlobalKey _logoKey = GlobalKey();
  final GlobalKey _themeKey = GlobalKey();
  final GlobalKey _uploadKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    // Show tutorial after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Small delay to ensure animations/layout are settled
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted && context.mounted) {
          _showTutorial();
        }
      });
    });
  }

  void _showTutorial() {
    WebTutorialOverlay.show(context, [
      TutorialStep(
        key: _logoKey,
        title: 'Welcome to DeepFract',
        description:
            'This is your home for Fractal image compression. Click here to return home anytime.',
        position: ContentPosition.bottomLeft,
      ),
      TutorialStep(
        key: _uploadKey,
        title: 'Upload Your Image',
        description:
            'Drag and drop your image here or click to browse. We support JPG, PNG, and WebP.',
        position: ContentPosition.left,
      ),
      TutorialStep(
        key: _themeKey,
        title: 'Customize Your View',
        description:
            'Toggle between Light and Dark mode to suit your preference.',
        position: ContentPosition.bottomRight,
      ),
    ]);
  }

  Future<void> _selectImage() async {
    await _showWebUploadModal();
  }

  Future<void> _showWebUploadModal() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return UploadModal(
          onImageSelected: (file, bytes) {
            setState(() {
              _selectedImage = file;
              _imageBytes = bytes;
            });
          },
        );
      },
    );
  }

  Future<void> _compressImage() async {
    if (_selectedImage == null) return;

    setState(() {
      _isProcessing = true;
    });

    final startTime = DateTime.now();

    await Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierDismissible: false,
        pageBuilder: (context, animation, secondaryAnimation) {
          return FadeTransition(
            opacity: animation,
            child: CompressionLoadingOverlay(
              imageFile: _selectedImage!,
              imageBytes: _imageBytes,
              onComplete: () {
                Navigator.of(context).pop();
              },
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );

    final endTime = DateTime.now();
    final compressionTime = endTime.difference(startTime);

    if (mounted) {
      setState(() {
        _isProcessing = false;
      });

      final shouldSelectNew = await Navigator.push<bool>(
        context,
        MaterialPageRoute(
          builder:
              (context) => CompressionResultScreen(
                originalImage: _selectedImage!,
                imageBytes: _imageBytes,
                originalSize: '10.0 MB',
                compressedSize: '1.0 MB',
                compressionTime: compressionTime,
              ),
        ),
      );

      if (shouldSelectNew == true && mounted) {
        _selectImage();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const AnimatedBackground(),
          Column(
            children: [
              WebNavbar(logoKey: _logoKey, themeToggleKey: _themeKey),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      HeroSection(
                        selectedImage: _selectedImage,
                        imageBytes: _imageBytes,
                        isProcessing: _isProcessing,
                        onSelectImage: _selectImage,
                        onCompressImage: _compressImage,
                        uploadKey: _uploadKey,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
