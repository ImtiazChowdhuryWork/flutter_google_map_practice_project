import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
              title: "Basic Google Map",
            ),
          ],
        ),
      ),
    );
  }
}
