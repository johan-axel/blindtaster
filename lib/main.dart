import 'package:flutter/material.dart';
import 'screens/tasting_summary.dart';
import 'services/storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StorageService.init();
  runApp(const WineTasterApp());
}

class WineTasterApp extends StatelessWidget {
  const WineTasterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wine Taster',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.purple),
        useMaterial3: true,
      ),
      home: const TastingSummary(),
    );
  }
}
