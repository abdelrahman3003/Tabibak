import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tabibak/core/helper/shared_pref.dart';

final themeStateProvider = StateProvider<bool>(
    (ref) => SharedPrefsService.prefs.getBool(SharedPrefKeys.isDark) ?? false);
