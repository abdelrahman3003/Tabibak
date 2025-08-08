import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tabibak/my_app.dart';

import 'core/services/app_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppService.init();
  runApp(ProviderScope(child: DevicePreview(builder: (context) {
    return const MyApp();
  })));
}
