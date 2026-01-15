import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_map_practice_project/constants/app_text.dart';
import 'package:google_map_practice_project/constants/di.dart';
import 'package:google_map_practice_project/features/ruler/ruler_screen.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '../../../custom_widgets/custom_container.dart';
import '../../basic_google_map/presentation/basic_google_map_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.teal,

        centerTitle: true,
        title: Text("Google Map"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            CustomContainer(
              onTap: () {
                Get.to(() => BasicGoogleMapScreen());
              },
              title: 'basic_google_map'.tr,
            ),
            SizedBox(height: 10.h),

            Container(
              width: 1.sw,
              height: 100.h,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.teal,
                borderRadius: BorderRadius.circular(10.r),
              ),

              child: Text(
                'my_statement'.tr,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20.sp, color: Colors.black),
              ),
            ),
            SizedBox(height: 10.h),

            Container(
              width: 1.sw,
              height: 100.h,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.deepPurple,
                borderRadius: BorderRadius.circular(10.r),
              ),

              child: Text(
                'my_address'.tr,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20.sp, color: Colors.white),
              ),
            ),
            SizedBox(height: 10.h),

            ///-------->>> Making Ruler
            GestureDetector(
              onTap: () {
                Get.to(() => RulerScreen());
              },
              child: Container(
                width: 1.sw,
                height: 100.h,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(10.r),
                ),

                child: Text(
                  'make_ruler'.tr,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20.sp, color: Colors.white),
                ),
              ),
            ),
            SizedBox(height: 10.h),

            ToggleSwitch(
              minWidth: 90.0,
              initialLabelIndex: appData.read(kKeyEnglish)
                  ? 0
                  : 1, // Set initial index based on saved preference
              cornerRadius: 20.0,
              activeFgColor: Colors.white,
              inactiveBgColor: Colors.grey,
              inactiveFgColor: Colors.white,
              totalSwitches: 2,
              labels: ['English', 'Bangla'],
              icons: [Icons.language, Icons.language],
              activeBgColors: [
                [Colors.blue],
                [Colors.pink],
              ],
              onToggle: (index) {
                log('Switched To: $index');
                if (index == 0) {
                  log('😊😊----------Selected Language : English ------------');
                  appData.write(kKeyEnglish, true);
                  appData.write(kKeyBangla, false);
                  Get.updateLocale(Locale('en', 'US')); // Update the app locale
                } else if (index == 1) {
                  log('😏😏----------Selected Language : Bangla ------------');
                  appData.write(kKeyEnglish, false);
                  appData.write(kKeyBangla, true);
                  Get.updateLocale(Locale('bn', 'BD')); // Update the app locale
                } else {
                  return;
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
