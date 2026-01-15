import 'package:google_map_practice_project/constants/app_text.dart';
import 'package:google_map_practice_project/constants/di.dart';

void setInitialLocalization() {
  appData.writeIfNull(kKeyEnglish, true);
  appData.writeIfNull(kKeyBangla, false);
}
