import 'package:flutter/material.dart';

import 'advanced_search_dialog.dart';
import 'search_editing_controller.dart';

class SearchBar extends StatefulWidget {
  final SearchEditingController? searchEditingController;
  final Function(SearchEditingController? controller)? onSearch;

  const SearchBar({
    Key? key,
    this.searchEditingController,
    this.onSearch,
  }) : super(key: key);

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  Future<void> _showAdvancedSearchDialog(BuildContext context) async {
    SearchEditingController controller = SearchEditingController();

    controller.copyFrom(widget.searchEditingController);

    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Advanced Search'),
            content: AdvancedSearchDialog(searchEditingController: controller),
            actions: <Widget>[
              OutlinedButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              ElevatedButton(
                child: const Text('Search'),
                onPressed: () {
                  if (widget.searchEditingController != null) {
                    widget.searchEditingController!.copyFrom(controller);
                  }
                  widget.onSearch?.call(widget.searchEditingController);
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(16))),
        label: const Text('Image name'),
        suffixIcon: IconButton(
          tooltip: 'Advanced Search',
          onPressed: () {
            _showAdvancedSearchDialog(context);
          },
          icon: const Icon(Icons.menu),
        ),
      ),
      onSubmitted: (String submitted) {
        widget.onSearch?.call(widget.searchEditingController);
      },
    );
  }
}
