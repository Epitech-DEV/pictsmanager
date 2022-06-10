import 'package:flutter/material.dart';
import 'package:frontend/models/album.dart';
import 'package:frontend/shared/globals.dart';
import 'package:frontend/views/album_pictures.dart';

typedef AlbumOnTap = void Function(AlbumData albumData);

class Album extends StatelessWidget {
  const Album({
    required this.data,
    Key? key,
    this.onTap,
    this.isSelected = false,
    this.index,
  }) : super(key: key);

  final AlbumData data;
  final AlbumOnTap? onTap;
  final bool isSelected;
  final int? index;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (onTap != null) {
          onTap!(data);
          return;
        }
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AlbumPicturesView(
                album: data,
              ),
            ));
      },
      child: Stack(
        children: [
          Container(
              decoration: BoxDecoration(
            color: isSelected ? Colors.blue : Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(3.0),
          )),
          const Center(
            child: Icon(Icons.folder, size: 42),
          ),
          Positioned(
            bottom: kSpace,
            left: kSpace,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(data.name, style: Theme.of(context).textTheme.titleLarge),
                Text(data.pictures.length.toString() + ' Photo(s)',
                    style: Theme.of(context).textTheme.titleSmall),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
