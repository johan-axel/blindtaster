import 'package:flutter/material.dart';
import '../models/settings.dart';
import '../services/storage_provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late Settings settings;

  @override
  void initState() {
    super.initState();
    settings = StorageProvider.instance.getSettings();
  }

  Widget _buildToggleRow(String title, bool value, Function(bool) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 16)),
          Switch(
            value: value,
            onChanged: (newValue) {
              setState(() {
                onChanged(newValue);
                StorageProvider.instance.saveSettings(settings);
              });
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.purple.shade100,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Wine Card Parameters',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Tasting Notes',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      _buildToggleRow('Color', settings.showColor,
                          (value) => settings.showColor = value),
                      _buildToggleRow('Smell', settings.showSmell,
                          (value) => settings.showSmell = value),
                      _buildToggleRow('Smell Quality rating', settings.showSmellQuality,
                          (value) => settings.showSmellQuality = value),
                      _buildToggleRow('Taste', settings.showTaste,
                          (value) => settings.showTaste = value),
                      _buildToggleRow('Taste Quality rating', settings.showTasteQuality,
                          (value) => settings.showTasteQuality = value),
                      _buildToggleRow('Aftertaste', settings.showAftertaste,
                          (value) => settings.showAftertaste = value),
                      _buildToggleRow('Aftertaste Quality rating', settings.showAftertasteQuality,
                          (value) => settings.showAftertasteQuality = value),
                      _buildToggleRow('Comments', settings.showComments,
                          (value) => settings.showComments = value),
                      _buildToggleRow('Wine Rating', settings.showRating,
                          (value) => settings.showRating = value),
                      const Divider(),
                      const Text(
                        'Characteristics',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const Text(
                        '(Acidity, Sweetness, Body & Tannins sliders)',
                        style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      _buildToggleRow('Characteristics', settings.showCharacteristics,
                          (value) => settings.showCharacteristics = value),
                      const Divider(),
                      const Text(
                        'Wine Information',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      _buildToggleRow('Wine Type', settings.showWineType,
                          (value) => settings.showWineType = value),
                      _buildToggleRow('Grapes', settings.showGrapes,
                          (value) => settings.showGrapes = value),
                      _buildToggleRow('Country', settings.showCountry,
                          (value) => settings.showCountry = value),
                      _buildToggleRow('Region', settings.showRegion,
                          (value) => settings.showRegion = value),
                      _buildToggleRow('Producer', settings.showProducer,
                          (value) => settings.showProducer = value),
                      _buildToggleRow('Year', settings.showYear,
                          (value) => settings.showYear = value),
                      const Divider(),

                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
