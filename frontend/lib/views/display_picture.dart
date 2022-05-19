import 'dart:io';
import 'package:flutter/material.dart';
import 'package:frontend/components/custom_elevated_button.dart';
import 'package:frontend/views/picture_add_tags_and_name.dart';
import 'package:intl/intl.dart';

class DisplayPictureScreen extends StatefulWidget {
  const DisplayPictureScreen({
    Key? key,
    required this.imagePath,
  }) : super(key: key);

  final String imagePath;
  @override
  State<DisplayPictureScreen> createState() => _DisplayPictureScreenState();
}

class _DisplayPictureScreenState extends State<DisplayPictureScreen> {
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
                  File(widget.imagePath),
                ),
                const SizedBox(height: 20),
                Align(
                  child: CustomElevatedButton(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PictureAddTagsAndName(),
                      ),
                    ),
                    icon: Icons.cloud_upload,
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
