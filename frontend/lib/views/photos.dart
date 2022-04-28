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
  final PictureService _pictureService = PictureService(pictureRepository: PictureInMemoryRepository());
  late Future<List<PictureData>> _getUserPicturesFuture;
  List<PicturesGroupData>? pictureGroups;

  PictureGroupType _currentGroupType = PictureGroupType.day;
  bool _isGroupTypeAlreadyChanged = false;

  @override
  void initState() {
    super.initState();
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
            pictureGroups ??= _pictureService.generatePicturesGroups(PictureGroupType.day, snapshot.data!);
            
            return GestureDetector(
              onScaleUpdate: (ScaleUpdateDetails details) {
                if (details.scale == 1.0 || _isGroupTypeAlreadyChanged) return;
                
                _isGroupTypeAlreadyChanged = true;
                
                PictureGroupType newGroupType = _currentGroupType;
    
                if (details.scale < 1.0) {
                  newGroupType = PictureGroupTypeUtils.next(_currentGroupType);
                }
                else {
                  newGroupType = PictureGroupTypeUtils.previous(_currentGroupType);
                }
                
                setState(() {
                  _currentGroupType = newGroupType;
                  pictureGroups = _pictureService.generatePicturesGroups(newGroupType, snapshot.data!);
                });
              },
              onScaleEnd: (_) {
                _isGroupTypeAlreadyChanged = false;
              },
              child: PictureList(
                groupType: _currentGroupType, 
                data: pictureGroups ?? []
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                children: [
                  const Text('Network Error: fail to fetch pictures'),
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
