import 'package:flutter/material.dart';
import 'package:frontend/components/picture_list.dart';
import 'package:frontend/models/picture.dart';
import 'package:frontend/models/pictures_group.dart';
import 'package:frontend/repositories/picture.dart';
import 'package:frontend/services/pictures.dart';

class PhotosView extends StatefulWidget {
  const PhotosView({Key? key}) : super(key: key);

  @override
  State<PhotosView> createState() => _PhotosViewState();
}

class _PhotosViewState extends State<PhotosView> with AutomaticKeepAliveClientMixin {
  final PictureService _pictureService = PictureService(pictureRepository: PictureInMeromryRepository());
  PictureGroupType _currentGroupType = PictureGroupType.day;
  List<PicturesGroupData>? pictureGroups;
  late Future<List<PictureData>> _getUserPicturesFuture;

  @override
  void initState() {
    super.initState();
    _getUserPicturesFuture = _pictureService.getUserPictures();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return FutureBuilder<List<PictureData>>(
      future: _getUserPicturesFuture,
      builder: (BuildContext context, AsyncSnapshot<List<PictureData>> snapshot) {
        if (snapshot.hasData) {
          pictureGroups ??= _pictureService.generatePicturesGroups(PictureGroupType.day, snapshot.data!);
          
          return GestureDetector(
            onScaleStart: (ScaleStartDetails details) {
              // TODO : implement onScaleStart
            },
            child: PictureList(
              groupType: _currentGroupType, 
              data: pictureGroups ?? []
            ),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator()
          );
        }
      }, 
    );
  }

  @override
  bool get wantKeepAlive => true;
}
