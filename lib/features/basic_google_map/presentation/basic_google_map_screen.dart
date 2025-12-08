import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BasicGoogleMapScreen extends StatelessWidget {
  const BasicGoogleMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(8.sp),
          child: Column(
            children: [
              Text(
                "Basic Google Map",
                style: TextStyle(color: Colors.black, fontSize: 20.sp),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
