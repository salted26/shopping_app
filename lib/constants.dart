import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

final NumberFormat numberFormat = NumberFormat("###,###,###,###");

late SharedPreferences sharedPreferences;
void initializeSharedPreferences() async {
  sharedPreferences = await SharedPreferences.getInstance();
}