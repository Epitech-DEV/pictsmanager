import 'package:flutter/material.dart';

class FriendTextFields extends StatefulWidget {
  const FriendTextFields({
    Key? key,
    required this.index,
    required this.changeTag,
    required this.getTag,
  });

  final int index;
  final String Function(int index) getTag;
  final void Function(int index, String value) changeTag;
  @override
  _FriendTextFieldsState createState() => _FriendTextFieldsState();
}

class _FriendTextFieldsState extends State<FriendTextFields> {
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      _nameController.text = widget.getTag(widget.index);
    });

    return TextFormField(
      controller: _nameController,
      onChanged: (value) => widget.changeTag(widget.index, value),
      decoration: const InputDecoration(hintText: 'Enter a tag'),
      validator: (value) {
        if (value != null && value.trim().isEmpty) {
          return 'Please enter something';
        }
        return null;
      },
    );
  }
}
