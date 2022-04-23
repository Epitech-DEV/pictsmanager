
import 'package:flutter/material.dart';
import 'package:frontend/models/pictures_group.dart';
import 'package:frontend/components/pictures_group.dart';

class PictureList extends StatefulWidget {
  
  const PictureList({
    required this.groupType,
    required this.data,
    Key? key 
  }) : super(key: key);

  final PictureGroupType groupType;
  final List<PicturesGroupData> data;

  @override
  State<PictureList> createState() => _PictureListState();
}

class _PictureListState extends State<PictureList> {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              final monthHasChanged = index != 0 ? widget.data[index - 1].date.month != widget.data[index].date.month : false;
              final yearHasChanged = index != 0 ? widget.data[index - 1].date.year != widget.data[index].date.year : false;
      
              return PicturesGroup(
                data: widget.data[index],
                monthHasChanged: monthHasChanged,
                yearHasChanged: yearHasChanged,
              );
            },
            childCount: widget.data.length,
          ),
        ),
      ],
    );
  }
}