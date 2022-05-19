
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/services/albums.dart';
import 'package:frontend/shared/globals.dart';

class NewAlbumView extends StatefulWidget {
  const NewAlbumView({Key? key}) : super(key: key);

  @override
  State<NewAlbumView> createState() => _NewAlbumViewState();
}

class _NewAlbumViewState extends State<NewAlbumView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    AlbumService albumService = AlbumService.getInstance();

    return Scaffold(
      appBar: AppBar(
        title: const Text('New Album'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(kSpace),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Album Name',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a name';
                        }
                        return null;
                      },
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9_\- ]')),
                        LengthLimitingTextInputFormatter(32),
                        FilteringTextInputFormatter.singleLineFormatter,
                      ],
                    ),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(40)
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Processing Data')),
                      );
                      await albumService.createAlbum(name: _nameController.text)
                        .then((value) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Album "' + value.name + '" created')),
                          );
                          Navigator.pop(context, value);
                        })
                        .catchError((error) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(error)),
                          );
                        });
                    }
                  },
                  child: const Text('Create'),
                ),
              ],
            ),
          ),
        ),
      )
    );
  }
}