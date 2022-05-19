import 'package:flutter/material.dart';
import 'package:frontend/components/album_list.dart';
import 'package:frontend/models/album.dart';
import 'package:frontend/services/albums.dart';
import 'package:frontend/shared/globals.dart';
import 'package:frontend/views/new_album.dart';

class LibraryView extends StatefulWidget {
  const LibraryView({Key? key}) : super(key: key);

  @override
  State<LibraryView> createState() => _LibraryViewState();
}

class _LibraryViewState extends State<LibraryView> with AutomaticKeepAliveClientMixin {
  final AlbumService _albumService = AlbumService.getInstance();
  late Future<List<AlbumData>> _getUserAlbumsFuture;

  @override
  void initState() {
    super.initState();
    _getUserAlbumsFuture = _albumService.getUserAlbums();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    
    return SafeArea(
      child: Stack(
        children: [
          FutureBuilder<List<AlbumData>>(
            future: _getUserAlbumsFuture,
            builder: (BuildContext context, AsyncSnapshot<List<AlbumData>> snapshot) {
              if (snapshot.hasData) {
                return AlbumList(data: snapshot.data!);
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
          Positioned(
            right: kSpace * 2,
            bottom: kSpace * 2,
            child: FloatingActionButton(
              onPressed: () async {
                final result = await Navigator.push(context, MaterialPageRoute(
                  builder: (context) => const NewAlbumView(),
                ));

                if (result != null) {
                  setState(() {
                    _getUserAlbumsFuture = _albumService.getUserAlbums();
                  });
                }
              },
              child: const Icon(Icons.create_new_folder_outlined),
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
