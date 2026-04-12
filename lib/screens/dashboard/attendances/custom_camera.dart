import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import '../../../utils/log_files.dart';

class CustomCamera extends StatefulWidget {
  @override
  _CustomCameraState createState() => _CustomCameraState();
}

class _CustomCameraState extends State<CustomCamera>
    with WidgetsBindingObserver {
  CameraController? _controller;
  late List<CameraDescription> _cameras;
  late int _selectedCameraIdx;
  bool _isCameraReady = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initCamera();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller!.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _initCamera();
    } else if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused) {
      _controller?.dispose();
    }
  }

  Future<void> _initCamera() async {
    _cameras = await availableCameras();
    _selectedCameraIdx = 0;

    _controller = CameraController(
      _cameras[_selectedCameraIdx],
      ResolutionPreset.medium,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    _controller!.addListener(() {
      if (mounted) setState(() {});
      if (_controller!.value.hasError) {
        print('Camera error ${_controller!.value.errorDescription}');
      }
      if (_controller!.value.isInitialized) {
        _isCameraReady = true;
      }
    });

    try {
      await _controller!.initialize();
    } on CameraException catch (error, stackTrace) {
      logError(error, stackTrace);
    }

    if (mounted) {
      setState(() {});
    }
  }

  Future<XFile?> takePicture() async {
    if (!_isCameraReady || !_controller!.value.isInitialized) {
      return null;
    }

    // Create a temporary directory for the picture
    final Directory tempDir = await getTemporaryDirectory();
    final String tempPath = tempDir.path;

    // Take the picture and save it to the temporary directory
    final XFile pictureFile = await _controller!.takePicture();

    // Retrieve the file from the temporary directory
    final File savedImage = File(pictureFile.path);
    final String fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
    final String filePath = '$tempPath/$fileName';
    await savedImage.copy(filePath);

    return XFile(filePath);
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null || !_controller!.value.isInitialized) {
      return Container();
    }
    return Scaffold(
      body: CameraPreview(_controller!),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.camera),
        onPressed: () async {
          final XFile? pictureFile = await takePicture();
          if (pictureFile != null) {
            Navigator.pop(context, pictureFile);
          }
        },
      ),
    );
  }
}
