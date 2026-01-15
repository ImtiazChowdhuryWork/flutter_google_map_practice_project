import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_map_practice_project/constants/app_text.dart';
import 'package:google_map_practice_project/constants/di.dart';
import 'package:google_map_practice_project/constants/initial_localization_setting.dart';
import 'package:google_map_practice_project/constants/localization/languages.dart';
import 'package:google_map_practice_project/features/home/presentation/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await diSetup();
  setInitialLocalization();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          translations: Languages(),
          locale: appData.read(kKeyEnglish)
              ? Locale('en', 'US')
              : appData.read(kKeyBangla)
              ? Locale('bn', 'BD')
              : Locale('en', 'US'),
          fallbackLocale: Locale('en', 'US'),

          home: HomeScreen(),
        );
      },
    );
  }
}
