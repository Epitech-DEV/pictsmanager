
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:frontend/models/picture.dart';
import 'package:frontend/services/pictures.dart';

class PictureView extends StatefulWidget {
  const PictureView({ 
    required this.data,
    Key? key 
  }) : super(key: key);

  final PictureData data;

  @override
  State<PictureView> createState() => _PictureViewState();
}

class _PictureViewState extends State<PictureView> {
  late final PictureService _pictureService;

  @override
  void initState() {
    super.initState();
    _pictureService = PictureService.instance;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.data.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              // Todo : share image
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => showDialog<String>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: const Text('Delete Album'),
                content: const Text('Are you sure you want to delete this album?'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'Cancel'),
                    child: const Text('Cancel', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  TextButton(
                    onPressed: () async {
                      await _pictureService.deletePicture(widget.data.id!);
                      Navigator.pop(context, 'Delete');
                    },
                    child: const Text('Delete', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ).then((value) {
              if (value == 'Delete') {
                Navigator.pop(context);
              }
            }),
          ),
        ],
      ),
      body: Container(
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
        ),
        child: InteractiveViewer(
          child: Center(
            child: CachedNetworkImage(
              imageUrl: widget.data.path,
              fit: BoxFit.cover,
              placeholder: (context, url) => Center(
                child: Container(
                  color: Theme.of(context).primaryColor,
                ),
              ),
              errorWidget: (context, url, error) => Center(
                child: Container(
                  color: Theme.of(context).errorColor,
                ),
              ),
            ),
          ),
        ),
      )
    );
  }
}