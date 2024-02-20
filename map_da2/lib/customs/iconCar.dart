import 'package:flutter/material.dart';
class CarCrashIcon extends StatelessWidget {
  final VoidCallback? onPressed;

  const CarCrashIcon({Key? key, this.onPressed}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.car_crash_outlined,
        color: Colors.black,
        size: 45.0,
      ),
      onPressed: onPressed,
    );
  }
}