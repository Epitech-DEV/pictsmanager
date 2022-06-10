import 'package:flutter/material.dart';

import 'tags_editing_controller.dart';

class TagsField extends StatefulWidget {
  TagsEditingController? tagsController;
  TagsField({
    Key? key,
    this.tagsController,
  }) : super(key: key);

  @override
  State<TagsField> createState() => _TagsFieldState();
}

class _TagsFieldState extends State<TagsField> {
  late TextEditingController _controller;
  late FocusNode _focusNode;

  @override
  void initState() {
    _controller = TextEditingController();
    _focusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _addTag(String tag) {
    if (tag.isEmpty) {
      return;
    }
    widget.tagsController?.add(tag);
    _controller.clear();
    _focusNode.requestFocus();
  }

  Widget _buildChipsetList(BuildContext context) {
    if (widget.tagsController == null) {
      return Container();
    }
    return AnimatedBuilder(
      animation: widget.tagsController!,
      builder: (BuildContext context, Widget? child) {
        return Wrap(
          alignment: WrapAlignment.start,
          children: widget.tagsController!.tags.map((String tag) {
            return Chip(
              label: Text(tag),
              onDeleted: () {
                widget.tagsController!.remove(tag);
              },
            );
          }).toList(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildChipsetList(context),
        TextField(
          focusNode: _focusNode,
          controller: _controller,
          decoration: InputDecoration(
            border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(16))),
            label: const Text('Tags'),
            suffixIcon: IconButton(
              onPressed: () {
                _addTag(_controller.text);
              },
              icon: const Icon(Icons.add),
            ),
          ),
          onSubmitted: _addTag,
        ),
      ],
    );
  }
}
