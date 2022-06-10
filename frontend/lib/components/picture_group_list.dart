
import 'package:flutter/material.dart';
import 'package:frontend/components/picture_list.dart';
import 'package:frontend/models/picture.dart';
import 'package:frontend/models/pictures_group.dart';
import 'package:frontend/services/pictures.dart';

class PictureGroupList extends StatefulWidget {
  const PictureGroupList({
    required this.data,
    Key? key
  }) : super(key: key);

  final List<PictureData> data;

  @override
  State<PictureGroupList> createState() => _PictureGroupListState();
}

class _PictureGroupListState extends State<PictureGroupList> {
  late PictureService _pictureService;
  List<PicturesGroupData>? pictureGroups;
  PictureGroupType _currentGroupType = PictureGroupType.day;
  bool _isGroupTypeAlreadyChanged = false;
  
  @override
  void initState() {
    _pictureService = PictureService.instance;
    pictureGroups = _pictureService.generatePicturesGroups(PictureGroupType.day, widget.data);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
          pictureGroups = _pictureService.generatePicturesGroups(newGroupType, widget.data);
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
  }
}