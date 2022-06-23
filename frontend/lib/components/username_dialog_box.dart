import 'package:flutter/material.dart';
import 'package:frontend/shared/globals.dart';

class UsernameDialogBox extends StatefulWidget {
  const UsernameDialogBox({Key? key, required this.title, required this.content, required this.onComfirm}) : super(key: key);

  final String title;
  final String content;
  final Future<bool> Function(String username) onComfirm;

  @override
  State<UsernameDialogBox> createState() => _UsernameDialogBoxState();
}

class _UsernameDialogBoxState extends State<UsernameDialogBox> {
  late TextEditingController _usernameController;
  late bool _isProcessing;

  @override
  void initState() {
    _usernameController = TextEditingController();
    _isProcessing = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(widget.content),
          const SizedBox(height: kSpace * 2),
          TextField(
            controller: _usernameController,
            decoration: const InputDecoration(
              labelText: 'Username',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(16),
                ),
              ),
            ),
          )
        ]
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, 'Cancel'),
          child: const Text('Cancel', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        TextButton(
          onPressed: _isProcessing ? null : () async {
            await onConfirm();
          },
          child: _isProcessing ?
            Text(
              'Share', 
              style: TextStyle(
                color: Theme.of(context).disabledColor, 
                fontWeight: FontWeight.bold
              )
            ) : Text('Share', style: TextStyle(color: Theme.of(context).colorScheme.secondary, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  Future<void> onConfirm() async {
    setState(() {
      _isProcessing = true;
    });

    if (_usernameController.text.isNotEmpty) {
      bool isProcessed = await widget.onComfirm(_usernameController.text);

      if (isProcessed) {
        Navigator.pop(context, 'Confirm');
        return;
      }
    }

    setState(() {
      _isProcessing = false;
    });
  }
}