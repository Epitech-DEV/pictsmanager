
import 'package:flutter/material.dart';
import 'package:frontend/components/album.dart';
import 'package:frontend/models/album.dart';
import 'package:frontend/shared/globals.dart';

class AlbumList extends StatefulWidget {
  
  const AlbumList({
    required this.data,
    Key? key 
  }) : super(key: key);

  final List<AlbumData> data;

  @override
  State<AlbumList> createState() => _AlbumListState();
}

class _AlbumListState extends State<AlbumList> {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.all(kSpace * 2),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: kSpace * 2,
              crossAxisSpacing: kSpace * 2,
              childAspectRatio: 1,
            ),
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return Album(
                  data: widget.data[index],
                );
              },
              childCount: widget.data.length,
            ),
          ),
        ),
      ],
    );
  }
}