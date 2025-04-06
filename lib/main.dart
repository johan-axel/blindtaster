import 'package:flutter/material.dart';
import 'screens/tasting_summary.dart';
import 'services/storage_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StorageProvider.instance.init();
  runApp(const WineTasterApp());
}

class WineTasterApp extends StatefulWidget {
  const WineTasterApp({super.key});

  @override
  State<WineTasterApp> createState() => _WineTasterAppState();
}

class _WineTasterAppState extends State<WineTasterApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.detached) {
      StorageProvider.instance.dispose();
    }
  }

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
