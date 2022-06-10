import 'package:flutter/material.dart';
import 'package:frontend/models/album.dart';

class SelectableAlbumList extends StatefulWidget {
  const SelectableAlbumList({
    required this.data,
    Key? key,
    required this.selectedAlbums,
    required this.onCheck,
  }) : super(key: key);

  final List<AlbumData> data;
  final List<bool> selectedAlbums;
  final void Function(bool? value, int index) onCheck;

  @override
  State<SelectableAlbumList> createState() => _SelectableAlbumListState();
}

class _SelectableAlbumListState extends State<SelectableAlbumList> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => ListView(
        children: List.generate(
          widget.data.length,
          (index) => ListTile(
            title: Text(widget.data[index].name),
            trailing: Checkbox(
              value: widget.selectedAlbums[index],
              onChanged: (value) {
                widget.onCheck(value, index);
              },
            ),
          ),
        ),
      ),
    );
  }
}
