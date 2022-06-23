
import 'package:flutter/material.dart';

class DeleteDialogBox extends StatefulWidget {
  const DeleteDialogBox({
    required this.title,
    required this.content,
    required this.onDelete,
    Key? key
  }) : super(key: key);

  final String title;
  final String content;
  final Future<bool> Function() onDelete;

  @override
  State<DeleteDialogBox> createState() => _DeleteDialogBoxState();
}

class _DeleteDialogBoxState extends State<DeleteDialogBox> {
  late bool _isProcessingDeletion;

  @override
  void initState() {
    super.initState();
    _isProcessingDeletion = false;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: Text(widget.content),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, 'Cancel'),
          child: const Text('Cancel', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        TextButton(
          onPressed: _isProcessingDeletion ? null : () async {
            await onDelete();
          },
          child: _isProcessingDeletion ?
            Text(
              'Delete', 
              style: TextStyle(
                color: Theme.of(context).disabledColor, 
                fontWeight: FontWeight.bold
              )
            ) : const Text('Delete', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  Future<void> onDelete() async {
    setState(() {
      _isProcessingDeletion = true;
    });

    bool isDeleted = await widget.onDelete();

    if (isDeleted) {
      Navigator.pop(context, 'Delete');
      return;
    }

    setState(() {
      _isProcessingDeletion = false;
    });
  }
}