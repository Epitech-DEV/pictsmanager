import 'package:flutter/material.dart';
import 'package:frontend/components/picture_group_list.dart';
import 'package:frontend/models/picture.dart';
import 'package:frontend/services/pictures.dart';
import 'package:frontend/shared/globals.dart';

class PhotosView extends StatefulWidget {
  const PhotosView({Key? key}) : super(key: key);

  @override
  State<PhotosView> createState() => _PhotosViewState();
}

class _PhotosViewState extends State<PhotosView> with AutomaticKeepAliveClientMixin {
  late PictureService _pictureService;
  late Future<List<PictureData>> _getUserPicturesFuture;

  @override
  void initState() {
    super.initState();
    _pictureService = PictureService.instance;
    _getUserPicturesFuture = _pictureService.getUserPictures();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return SafeArea(
      child: FutureBuilder<List<PictureData>>(
        future: _getUserPicturesFuture,
        builder: (BuildContext context, AsyncSnapshot<List<PictureData>> snapshot) {
          if (snapshot.hasData) {            
            return PictureGroupList(
              data: snapshot.data!
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Network Error: fail to fetch pictures'),
                  const SizedBox(height: kSpace),
                  ElevatedButton(
                    child: const Text('Retry'),
                    onPressed: () {
                      setState(() {
                        _getUserPicturesFuture = _pictureService.getUserPictures();
                      });
                    },
                  ),
                ],
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator()
            );
          }
        }, 
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
