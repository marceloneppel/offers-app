import 'package:offers/src/app/const.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<String> getCity() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString(citySharedPreferenceId) ?? "";
}

Future<void> setCity(String city) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString(citySharedPreferenceId, city);
}
