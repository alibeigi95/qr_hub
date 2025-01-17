import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:qr_hub/qr_hub.dart';
import 'my_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(QrCodeScanHistoryAdapter());
  Hive.registerAdapter(QrCodeGenerateHistoryAdapter());
  runApp(const MyApp());
}

