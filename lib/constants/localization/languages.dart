import 'package:get/get.dart';
import 'package:google_map_practice_project/constants/localization/lan_files/bn_BD.dart';
import 'package:google_map_practice_project/constants/localization/lan_files/en_US.dart';

class Languages extends Translations {
  @override
  // TODO: implement keys
  Map<String, Map<String, String>> get keys => {
    "en_US": englishLanguage,
    'bn_BD': banglaLanguage,
  };
}
