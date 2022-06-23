import 'dart:io';

import 'package:flutter/material.dart';
import 'package:frontend/components/selectable_album_list.dart';
import 'package:frontend/models/album.dart';
import 'package:frontend/models/metadata.dart';
import 'package:frontend/repositories/picture.dart';
import 'package:frontend/services/albums.dart';
import 'package:frontend/shared/globals.dart';
import 'package:frontend/views/home.dart';

class PictureAddToAlbum extends StatefulWidget {
  const PictureAddToAlbum({
    Key? key,
    required this.imagePath,
    required this.name,
    required this.tagList,
  }) : super(key: key);

  final String imagePath;
  final List<String> tagList;
  final String name;

  @override
  State<PictureAddToAlbum> createState() => _PictureAddToAlbumState();
}

class _PictureAddToAlbumState extends State<PictureAddToAlbum> {
  final AlbumService _albumService = AlbumService.instance;
  late Future<List<AlbumData>> _getUserAlbumsFuture;
  PictureApiRepository pictureApiRepository = PictureApiRepository();
  List<bool> checkboxSelectedAlbums = [];

  @override
  void initState() {
    super.initState();
    _getUserAlbumsFuture = _albumService.getUserAlbums();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: FutureBuilder(
          future: _getUserAlbumsFuture,
          builder:
              (BuildContext context, AsyncSnapshot<List<AlbumData>> snapshot) {
            if (snapshot.hasData) {
              if (checkboxSelectedAlbums.isEmpty) {
                for (AlbumData album in snapshot.data!) {
                  album = album;
                  checkboxSelectedAlbums.add(false);
                }
              }
              return Column(children: [
                Expanded(
                  child: SelectableAlbumList(
                    data: snapshot.data!,
                    selectedAlbums: checkboxSelectedAlbums,
                    onCheck: (value, index) {
                      setState(() {
                        checkboxSelectedAlbums[index] = value!;
                      });
                    },
                  ),
                ),
                SizedBox(
                  height: 120,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(kSpace * 2),
                        child: ElevatedButton(
                          child: const Text('Cancel'),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(kSpace * 2),
                        child: ElevatedButton(
                          child: const Text('Upload'),
                          onPressed: () async {
                            List<AlbumData> selectedAlbums = snapshot.data!;
                            List<AlbumData> albums = [];
                            checkboxSelectedAlbums
                                .asMap()
                                .forEach((index, element) {
                              if (element) {
                                albums.add(selectedAlbums[index]);
                              }
                            });
                            await pictureApiRepository.uploadPicture(
                              File(widget.imagePath),
                              PictureMetadata(
                                filename: widget.name,
                                tags: widget.tagList,
                                albums: albums,
                              ),
                            );
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (context) => const HomeView(),
                              ),
                              (Route<dynamic> route) => false,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                )
              ]);
            } else if (snapshot.hasError) {
              return Center(
                child: Column(
                  children: [
                    const Text('Network Error: fail to fetch albums'),
                    const SizedBox(height: kSpace),
                    ElevatedButton(
                      child: const Text('Retry'),
                      onPressed: () {
                        setState(() {
                          _getUserAlbumsFuture = _albumService.getUserAlbums();
                        });
                      },
                    ),
                  ],
                ),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}
