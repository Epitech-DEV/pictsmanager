import 'package:flutter/material.dart';
import 'package:frontend/views/picture_add_to_album.dart';

class PictureAddTagsAndName extends StatefulWidget {
  const PictureAddTagsAndName({Key? key}) : super(key: key);

  @override
  State<PictureAddTagsAndName> createState() => _PictureAddTagsAndNameState();
}

class _PictureAddTagsAndNameState extends State<PictureAddTagsAndName> {
  final _nameController = TextEditingController();
  final _tagController = TextEditingController();
  List<Chip> tagList = [];
  String _tagValue = "";
  bool _validate = false;

  void _addTag(StateSetter setState) {
    if (_tagValue != "") {
      setState(() {
        _validate = false;
        tagList.add(
          Chip(
            label: Text(_tagValue),
            // deleteIcon: const Icon(Icons.delete),
            onDeleted: () {
              setState(() {
                tagList.removeAt(tagList.length - 1);
              });
            },
          ),
        );
        _tagController.clear();
        _tagValue = "";
      });
    } else {
      setState(() {
        _validate = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: SafeArea(
        child: Scaffold(
          body: Center(
            child: FractionallySizedBox(
              widthFactor: 0.8,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: "Name (defaults to current date)",
                      ),
                      onChanged: (value) => {setState(() {})},
                      controller: _nameController,
                      keyboardType: TextInputType.name,
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: "Tag",
                      errorText: _validate ? 'Tag Can\'t Be Empty' : null,
                    ),
                    onChanged: (value) => {
                      setState(() {
                        _tagValue = value;
                      }),
                    },
                    controller: _tagController,
                    keyboardType: TextInputType.name,
                  ),
                  ElevatedButton(
                    onPressed: () => _addTag(setState),
                    child: const Text("Add tag"),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Wrap(
                        direction: Axis.horizontal,
                        spacing: 10,
                        children: tagList,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: ElevatedButton(
                          child: const Text('Cancel'),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: ElevatedButton(
                          child: const Text('Continue'),
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const PictureAddToAlbum(),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}