import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomContainer extends StatelessWidget {
  final String title;
  final void Function()? onTap;
  const CustomContainer({super.key, required this.title, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 1.sw,
        height: 120.h,
        decoration: BoxDecoration(
          color: Colors.amber,
          border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(10.r),
        ),
        padding: EdgeInsets.all(10.sp),
        alignment: Alignment.center,
        child: Text(
          title,
          style: TextStyle(color: Colors.black, fontSize: 20.sp),
        ),
      ),
    );
  }
}
