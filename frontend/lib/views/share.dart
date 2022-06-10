import 'package:flutter/material.dart';
import 'package:frontend/components/album.dart';
import 'package:frontend/models/album.dart';
import 'package:frontend/models/picture.dart';
import 'package:frontend/models/pictures_group.dart';
import 'package:frontend/models/shared.dart';
import 'package:frontend/services/albums.dart';
import 'package:frontend/services/pictures.dart';
import 'package:frontend/shared/globals.dart';

import '../components/pictures_group.dart';

class ShareView extends StatefulWidget {
  const ShareView({Key? key}) : super(key: key);

  @override
  State<ShareView> createState() => _ShareViewState();
}

class _ShareViewState extends State<ShareView> with AutomaticKeepAliveClientMixin {
  late final AlbumService _albumService;
  late final PictureService _pictureService;

  late Future<SharedData> _getSharedDataFuture;

  @override
  void initState() {
    super.initState();
    _albumService = AlbumService.instance;
    _pictureService = PictureService.instance;
    _getSharedDataFuture = _getSharedData();
  }

  Future<SharedData> _getSharedData() async {
    final List<AlbumData> albums = await _albumService.getSharedAlbums();
    final List<PictureData> pictures = await _pictureService.getSharedPictures();
    
    return SharedData(
      albums: albums, 
      pictures: pictures
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder<SharedData>(
      future: _getSharedDataFuture,
      builder: (BuildContext context, AsyncSnapshot<SharedData> snapshot) {
        if (snapshot.hasData) {
          final List<AlbumData> albums = snapshot.data!.albums;
          final List<PictureData> pictures = snapshot.data!.pictures;
          final pictureGroups = _pictureService.generatePicturesGroups(PictureGroupType.day, pictures);

          return CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.all(kSpace * 2),
                sliver: SliverToBoxAdapter(
                  child: Text(
                    'Albums',
                    style: Theme.of(context).textTheme.headline4,
                  ),
                ),
              ),
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
                        data: albums[index],
                      );
                    },
                    childCount: albums.length,
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.all(kSpace * 2),
                sliver: SliverToBoxAdapter(
                  child: Text(
                    'Pictures',
                    style: Theme.of(context).textTheme.headline4,
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    final monthHasChanged = index != 0 ? pictureGroups[index - 1].month != pictureGroups[index].month : false;
                    final yearHasChanged = index != 0 ? pictureGroups[index - 1].year != pictureGroups[index].year : false;
            
                    return PicturesGroup(
                      data: pictureGroups[index],
                      monthHasChanged: monthHasChanged,
                      yearHasChanged: yearHasChanged,
                    );
                  },
                  childCount: pictureGroups.length,
                ),
              ),
            ],
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Network Error: fail to fetch albums'),
                const SizedBox(height: kSpace),
                ElevatedButton(
                  child: const Text('Retry'),
                  onPressed: () {
                    setState(() {
                      _getSharedDataFuture = _getSharedData();
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
    );
  }

  @override
  bool get wantKeepAlive => true;
}
