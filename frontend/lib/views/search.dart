import 'dart:async';

import 'package:flutter/material.dart';
import 'package:frontend/components/picture_group_list.dart';
import 'package:frontend/components/searchbar/search_editing_controller.dart';
import 'package:frontend/components/searchbar/searchbar.dart';
import 'package:frontend/models/picture.dart';
import 'package:frontend/models/search_query.dart';
import 'package:frontend/services/pictures.dart';
import 'package:frontend/shared/error.dart';
import 'package:frontend/shared/globals.dart';

class SearchView extends StatefulWidget {
  const SearchView({Key? key}) : super(key: key);

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView>
    with AutomaticKeepAliveClientMixin {
  final StreamController<List<PictureData>?> _searchResultStreamController =
      StreamController<List<PictureData>?>();
  late final PictureService _pictureService;
  late SearchEditingController _searchEditingController;

  @override
  void initState() {
    super.initState();
    _pictureService = PictureService.instance;
    _searchEditingController = SearchEditingController();
  }

  Future<void> onSearchIsPerformed(
      SearchEditingController? controller, bool advancedSearch) async {
    if (controller == null) {
      return;
    }

    _searchResultStreamController.add(null);

    SearchQuery query = SearchQuery(
      tags: controller.tagsController.tags.toList(),
      name: controller.keywordController.text,
      begin: controller.fromDateController.date,
      end: controller.toDateController.date,
      useDateRange: controller.useDateRange.value,
    );

    List<PictureData>? response;
    try {
      response = await _pictureService.search(query);
    } catch (e) {
      if (e is ApiError) {
        print(e.code);
        print(e.message);
      }
      return;
    }
    _searchResultStreamController.add(response);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(kSpace),
          child: SearchBar(
            searchEditingController: _searchEditingController,
            onSearch: onSearchIsPerformed,
          ),
        ),
        Expanded(
            child: StreamBuilder<List<PictureData>?>(
          stream: _searchResultStreamController.stream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return PictureGroupList(
                data: snapshot.data!,
              );
            } else if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()));
            } else if (snapshot.connectionState == ConnectionState.active) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return const Center(child: Text("Waiting your search..."));
            }
          },
        ))
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
