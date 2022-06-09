import 'package:flutter/material.dart';
import 'package:frontend/components/album_list.dart';
import 'package:frontend/models/album.dart';
import 'package:frontend/services/albums.dart';
import 'package:frontend/shared/globals.dart';
import 'package:frontend/states/library_collection.dart';

class LibraryView extends StatefulWidget {
  const LibraryView({Key? key}) : super(key: key);

  @override
  State<LibraryView> createState() => _LibraryViewState();
}

class _LibraryViewState extends State<LibraryView> with AutomaticKeepAliveClientMixin {
  final AlbumService albumService = AlbumService.getInstance();
  late LibraryCollectionController _libraryCollectionController;

  @override
  void initState() {
    super.initState();
    _libraryCollectionController = LibraryCollectionController.instance;
    _libraryCollectionController.init(albumService, () => setState(() {}));
  }

  @override
  void dispose() {
    _libraryCollectionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    
    return SafeArea(
      child: FutureBuilder<List<AlbumData>>(
        future: _libraryCollectionController.loadFuture,
        builder: (BuildContext context, AsyncSnapshot<List<AlbumData>> snapshot) {
          if (snapshot.hasData) {
            return AlbumList(data: snapshot.data!);
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Network Error: fail to fetch albums'),
                  const SizedBox(height: kSpace),
                  ElevatedButton(
                    child: const Text('Retry'),
                    onPressed: () => _libraryCollectionController.reload(),
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
    );
  }

  @override
  bool get wantKeepAlive => true;
}
