import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:frontend/views/new_picture.dart';

class TakePictureScreen extends StatefulWidget {
  const TakePictureScreen({
    Key? key,
    required this.camera,
  }) : super(key: key);

  final CameraDescription camera;

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  late CameraController _cameraController;
  late Future<void> _initializeControllerFuture;
  int _flashMode = 0;
  final List<IconData> _flashIcons = [
    Icons.flash_off,
    Icons.flash_auto,
    Icons.flash_on,
  ];

  @override
  void initState() {
    super.initState();
    _cameraController = CameraController(
      widget.camera,
      ResolutionPreset.medium,
    );

    _initializeControllerFuture = _cameraController.initialize();
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  void _takePicture() async {
    try {
      await _initializeControllerFuture;
      final image = await _cameraController.takePicture();

      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => DisplayPictureScreen(
            imagePath: image.path,
          ),
        ),
      );
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void _switchFlashState() {
    setState(() {
      _flashMode = (_flashMode + 1) %
          (FlashMode.values.length - 1); // Remove always on flash
      _cameraController.setFlashMode(FlashMode.values[_flashMode]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: FutureBuilder<void>(
          future: _initializeControllerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              _cameraController.setFlashMode(FlashMode.off);
              return Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.08,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.black,
                      ),
                      child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 16),
                              child: IconButton(
                                icon: const Icon(
                                  Icons.arrow_back_ios,
                                  color: Colors.white,
                                ),
                                onPressed: () => Navigator.pop(context),
                              ),
                            ),
                          ),
                          Center(
                            child: IconButton(
                              icon: Icon(
                                _flashIcons[_flashMode],
                                color: Colors.white,
                              ),
                              onPressed: _switchFlashState,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  CameraPreview(_cameraController),
                  Expanded(
                    child: Align(
                      child: ElevatedButton(
                        onPressed: _takePicture,
                        child: const Icon(Icons.camera_alt),
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}