import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../models/settings.dart';
import '../services/storage_provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  Future<void> _exportTastingsToCSV() async {
    try {
      final csv = StorageProvider.instance.exportTastingsToCSV();
      final bytes = utf8.encode(csv);
      
      // Get temporary directory
      final tempDir = await getTemporaryDirectory();
      final fileName = 'wine_tastings_${DateTime.now().toIso8601String()}.csv';
      final file = File('${tempDir.path}/$fileName');
      
      // Write CSV to temporary file
      await file.writeAsBytes(bytes);
      
      // Share the file
      await Share.shareXFiles(
        [XFile(file.path)],
        subject: 'Wine Tastings Export',
      );
      
      // Clean up temporary file
      await file.delete();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error exporting tastings: $e')),
      );
    }
  }
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
                      ExpansionTile(
                        title: const Text(
                          'Tasting Notes',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        initiallyExpanded: false,
                        children: [
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
                        ],
                      ),
                      ExpansionTile(
                        title: const Text(
                          'Wine Information',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        initiallyExpanded: false,
                        children: [
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
                        ],
                      ),
                      const Divider(),
                      ExpansionTile(
                        title: const Text(
                          'Data Management',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        initiallyExpanded: false,
                        children: [
                          const SizedBox(height: 8),
                          ListTile(
                            title: const Text('Export Tastings'),
                            subtitle: const Text('Download all tastings as CSV file'),
                            trailing: ElevatedButton.icon(
                              onPressed: _exportTastingsToCSV,
                              icon: const Icon(Icons.download),
                              label: const Text('Export CSV'),
                            ),
                          ),
                        ],
                      ),
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
