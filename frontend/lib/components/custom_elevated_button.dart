import 'package:flutter/material.dart';

class CustomElevatedButton extends StatefulWidget {
  const CustomElevatedButton({
    Key? key,
    required this.onTap,
    required this.icon,
  }) : super(key: key);

  final void Function() onTap;
  final IconData icon;

  @override
  State<CustomElevatedButton> createState() => _CustomElevatedButtonState();
}

class _CustomElevatedButtonState extends State<CustomElevatedButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: Icon(widget.icon),
      onPressed: widget.onTap,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.pressed)) {
              return Theme.of(context).colorScheme.primary.withOpacity(0.5);
            }
            return null;
          },
        ),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40),
          ),
        ),
        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
          const EdgeInsets.all(20),
        ),
      ),
    );
  }
}
