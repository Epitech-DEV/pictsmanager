import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:frontend/views/library.dart';
import 'package:frontend/views/new_album.dart';
import 'package:frontend/views/photos.dart';
import 'package:frontend/views/search.dart';
import 'package:frontend/views/share.dart';
import 'package:frontend/views/take_picture.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late PageController _viewController;
  late int _selectedView;
  late CameraDescription firstCamera;
  late Map<String, Widget> _views;
  late AppBar _appBar;

  void openCamera() async {
    WidgetsFlutterBinding.ensureInitialized();
    final cameras = await availableCameras();
    firstCamera = cameras.first;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TakePictureScreen(
          camera: firstCamera,
        ),
      ),
    );
  }

  void _onPageSelected(int index) {
    setState(() {
      _selectedView = index;
      _viewController.jumpToPage(index);
    });

    _appBar = _generateAppBarContent(index);
  }

  AppBar _generateAppBarContent(int index) {
    switch (index) {
      case 1:
        return _buildAppBar('Search');
      case 2:
        return _buildAppBar('Share');
      case 3:
        return _buildAppBar(
          'Library',
          actions: [
            IconButton(
              icon: const Icon(Icons.create_new_folder_outlined),
              onPressed: () => navigateToAlbumCreationScreen(context),
            ),
          ],
        );
      default:
        return _buildAppBar('Photos');
    }
  }

  AppBar _buildAppBar(String title, {List<Widget>? actions}) {
    return AppBar(
      title: Text(title),
      actions: actions,
    );
  }

  @override
  void initState() {
    _selectedView = 0;
    _viewController = PageController(initialPage: _selectedView);
    _appBar = _generateAppBarContent(_selectedView);
    _views = const {
      'Photos': PhotosView(),
      'Search': SearchView(),
      'Share': ShareView(),
      'Library': LibraryView(),
    };
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar,
      body: PageView(
        controller: _viewController,
        physics: const NeverScrollableScrollPhysics(),
        children: _views.values.toList(),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'take-photo',
        onPressed: openCamera,
        tooltip: 'Open Camera',
        child: const Icon(Icons.camera),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        unselectedItemColor: Theme.of(context).unselectedWidgetColor,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        unselectedFontSize: 14,
        selectedFontSize: 14,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(_selectedView == 0 ? Icons.photo : Icons.photo_outlined),
            label: _views.keys.elementAt(0),
          ),
          BottomNavigationBarItem(
            icon:
                Icon(_selectedView == 1 ? Icons.search : Icons.search_outlined),
            label: _views.keys.elementAt(1),
          ),
          BottomNavigationBarItem(
            icon: Icon(_selectedView == 2
                ? Icons.people_alt
                : Icons.people_alt_outlined),
            label: _views.keys.elementAt(2),
          ),
          BottomNavigationBarItem(
            icon: Icon(_selectedView == 3
                ? Icons.photo_library
                : Icons.photo_library_outlined),
            label: _views.keys.elementAt(3),
          ),
        ],
        currentIndex: _selectedView,
        onTap: _onPageSelected,
      ),
    );
  }

  void navigateToAlbumCreationScreen(BuildContext context) async{
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const NewAlbumView(),
      ),
    );
  }
}
