import 'package:flutter/material.dart';

import 'date_editing_controller.dart';

class DateField extends StatefulWidget {
  final DateEditingController? dateController;
  final String text;
  
  const DateField({
    Key? key, 
    this.dateController, 
    this.text = 'Date'
  }) : super(key: key);

  @override
  State<DateField> createState() => _DateFieldState();
}

class _DateFieldState extends State<DateField> {
  void _selectDate() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      currentDate: widget.dateController?.date ?? DateTime.now(),
    ).then((value) {
      if (value != null) {
        widget.dateController?.setDate(value);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.dateController?.controller,
      readOnly: true,
      keyboardType: TextInputType.datetime,
      decoration: InputDecoration(
          labelText: widget.text,
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(16),
            ),
          ),
          suffixIcon: IconButton(
            onPressed: _selectDate,
            icon: const Icon(Icons.calendar_month),
          )),
      onTap: _selectDate,
    );
  }
}
