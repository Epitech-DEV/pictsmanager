import 'dart:io';
import 'package:flutter/material.dart';
import 'package:frontend/views/new_picture_metadata.dart';


class DisplayPictureScreen extends StatelessWidget {
  const DisplayPictureScreen({
    Key? key,
    required this.imagePath,
  }) : super(key: key);

  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SingleChildScrollView(
          child: Expanded(
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.08,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.black,
                    ),
                    child: Align(
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
                  ),
                ),
                Image.file(
                  File(imagePath),
                ),
                const SizedBox(height: 20),
                Align(
                  child: ElevatedButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PictureAddTagsAndName(),
                      ),
                    ),
                    child: const Icon(Icons.cloud_upload),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}