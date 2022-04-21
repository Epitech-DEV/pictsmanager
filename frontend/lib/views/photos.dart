import 'package:flutter/material.dart';

class PhotosView extends StatefulWidget {
  const PhotosView({Key? key}) : super(key: key);

  @override
  State<PhotosView> createState() => _PhotosViewState();
}

class _PhotosViewState extends State<PhotosView> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return const Center(
      child: Text("Photos"),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
