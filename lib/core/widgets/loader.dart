import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class Loader extends StatelessWidget {
  const Loader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.3),
      child: Center(
        child: SizedBox(
          width: 10.w,
          height: 10.w,
          child: const CircularProgressIndicator(
            strokeWidth: 3,
            color: Colors.blueAccent,
          ),
        ),
      ),
    );
  }
}
