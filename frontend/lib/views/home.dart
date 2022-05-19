import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:frontend/views/library.dart';
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
  late List<Widget> _views;
  late CameraDescription firstCamera;

  void _onPageSelected(int index) {
    setState(() {
      _selectedView = index;
      _viewController.jumpToPage(index);
    });
  }

  @override
  void initState() {
    _selectedView = 0;
    _viewController = PageController(initialPage: _selectedView);
    _views = const [
      PhotosView(),
      SearchView(),
      ShareView(),
      LibraryView(),
    ];
    super.initState();
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: ElevatedButton(
        onPressed: openCamera,
        child: const Icon(IconData(0xf60b, fontFamily: 'MaterialIcons')),
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40),
            ),
          ),
          padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
            const EdgeInsets.all(20),
          ),
        ),
      ),
      body: PageView(
        controller: _viewController,
        physics: const NeverScrollableScrollPhysics(),
        children: _views,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        unselectedItemColor: Colors.grey,
        selectedItemColor: Colors.lightBlue,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        unselectedFontSize: 14,
        selectedFontSize: 14,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(_selectedView == 0 ? Icons.photo : Icons.photo_outlined),
            label: 'Photos',
          ),
          BottomNavigationBarItem(
            icon:
                Icon(_selectedView == 1 ? Icons.search : Icons.search_outlined),
            label: 'Recherche',
          ),
          BottomNavigationBarItem(
            icon: Icon(_selectedView == 2
                ? Icons.people_alt
                : Icons.people_alt_outlined),
            label: 'Partage',
          ),
          BottomNavigationBarItem(
            icon: Icon(_selectedView == 3
                ? Icons.photo_library
                : Icons.photo_library_outlined),
            label: 'Bibliothèque',
          ),
        ],
        currentIndex: _selectedView,
        onTap: _onPageSelected,
      ),
    );
  }
}
