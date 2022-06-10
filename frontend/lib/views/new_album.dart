
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/models/album.dart';
import 'package:frontend/services/albums.dart';
import 'package:frontend/shared/error.dart';
import 'package:frontend/shared/globals.dart';
import 'package:frontend/states/library_collection.dart';

class NewAlbumView extends StatefulWidget {
  const NewAlbumView({Key? key}) : super(key: key);

  @override
  State<NewAlbumView> createState() => _NewAlbumViewState();
}

class _NewAlbumViewState extends State<NewAlbumView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  late final AlbumService albumService;
  bool _isProcessingForm = false;

  @override
  void initState() {
    super.initState();
    albumService = AlbumService.instance;
  }

  @override
  Widget build(BuildContext context) {
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
                  onPressed: _isProcessingForm ? null : () => _onSubmitForm(context),
                  child: _isProcessingForm 
                    ? Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text('Create'), 
                        SizedBox(width: kSpace),
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator()
                        )
                      ]) 
                    : const Text('Create'),
                ),
              ],
            ),
          ),
        ),
      )
    );
  }

  void _onSubmitForm(BuildContext context) async {
    setState(() {
      _isProcessingForm = true;
    });

    if (!_formKey.currentState!.validate()) return;

    try {
      AlbumData value = await albumService.createAlbum(name: _nameController.text);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Album "' + value.name + '" created')),
      );

      LibraryCollectionController.instance.reload();
      Navigator.pop(context);
    } on ApiError catch (error) {
      SnackBar snackBar = SnackBar(content: Text("${error.statusCode}: ${error.message}"));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } on Error catch (error) {
      print(error);
      SnackBar snackBar = const SnackBar(content: Text('Failed to create album'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } finally {
      setState(() {
        _isProcessingForm = false;
      });
    }
  }
}