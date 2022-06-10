import 'package:flutter/material.dart';

import 'date_field.dart';
import 'search_editing_controller.dart';
import 'tags_field.dart';

class AdvancedSearchDialog extends StatelessWidget {
  final SearchEditingController searchEditingController;

  const AdvancedSearchDialog({
    Key? key,
    required this.searchEditingController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      thickness: 6,
      radius: const Radius.circular(5),
      thumbVisibility: true,
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(right: 16),
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          child: Column(
            children: [
              TextField(
                controller: searchEditingController.keywordController,
                decoration: const InputDecoration(
                  labelText: 'Image name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(16),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              TagsField(
                tagsController: searchEditingController.tagsController,
              ),
              const SizedBox(height: 8),
              AnimatedBuilder(
                animation: searchEditingController.useDateRange,
                builder: (context, child) {
                  return Column(
                    children: [
                      Row(children: [
                        Checkbox(
                            value: searchEditingController.useDateRange.value,
                            onChanged: (state) {
                              searchEditingController.useDateRange.value =
                                  !searchEditingController.useDateRange.value;
                            }),
                        GestureDetector(
                          child: const Text('Date range'),
                          onTap: () {
                            searchEditingController.useDateRange.value =
                                !searchEditingController.useDateRange.value;
                          },
                        )
                      ]),
                      const SizedBox(height: 8),
                      DateField(
                          dateController:
                              searchEditingController.fromDateController,
                          text: searchEditingController.useDateRange.value
                              ? 'From'
                              : 'Date'),
                      if (searchEditingController.useDateRange.value)
                        const SizedBox(height: 8),
                      if (searchEditingController.useDateRange.value)
                        DateField(
                          dateController:
                              searchEditingController.toDateController,
                          text: 'To',
                        ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
