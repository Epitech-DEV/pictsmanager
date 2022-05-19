import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class PictureAddToAlbum extends StatefulWidget {
  const PictureAddToAlbum({Key? key}) : super(key: key);

  @override
  State<PictureAddToAlbum> createState() => _PictureAddToAlbumState();
}

class _PictureAddToAlbumState extends State<PictureAddToAlbum> {
  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Scaffold(),
    );
  }
}
