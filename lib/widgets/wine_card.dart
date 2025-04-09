import 'package:flutter/material.dart';
import 'dart:async';
import '../models/wine.dart';
import '../models/tasting.dart';
import '../models/settings.dart';
import '../services/storage_provider.dart';

class WineCard extends StatefulWidget {
  final Wine wine;
  final Tasting tasting;
  final VoidCallback onChanged;

  const WineCard({
    super.key,
    required this.wine,
    required this.tasting,
    required this.onChanged,
  });

  @override
  State<WineCard> createState() => _WineCardState();
}

class _WineCardState extends State<WineCard> {
  late Settings _settings;
  StreamSubscription? _settingsSubscription;

  void _loadSettings() {
    _settings = StorageProvider.instance.getSettings();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _loadSettings();
    _settingsSubscription = StorageProvider.instance.settingsStream.listen((_) {
      _loadSettings();
    });
  }
  Timer? _debounceTimer;

  void _onFieldChanged() {
    // Cancel the previous timer if it exists
    _debounceTimer?.cancel();
    // Start a new timer
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      widget.onChanged();
    });
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _settingsSubscription?.cancel();
    super.dispose();
  }
  @override
  Widget _buildWineParameters() {
    if (!widget.tasting.isRevealed) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_settings.showWineType)
        const Divider(height: 32),
        const Text(
          'Wine Information',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        TextFormField(
          initialValue: widget.wine.name,
          decoration:  InputDecoration(
            labelText: 'Wine Name',
            border: OutlineInputBorder(),
          ),
          onChanged: (value) {
            widget.wine.name = value;
            _onFieldChanged();
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          initialValue: widget.wine.wineType,
          decoration: const InputDecoration(
            labelText: 'Type',
            border: OutlineInputBorder(),
            hintText: 'e.g., Red, White, Rosé',
          ),
          onChanged: (value) {
            widget.wine.wineType = value.isEmpty ? null : value;
            _onFieldChanged();
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          initialValue: widget.wine.grapes,
          decoration: const InputDecoration(
            labelText: 'Grape(s)',
            border: OutlineInputBorder(),
            hintText: 'e.g., Cabernet Sauvignon, Merlot',
          ),
          onChanged: (value) {
            widget.wine.grapes = value.isEmpty ? null : value;
            _onFieldChanged();
          },
        ),
        const SizedBox(height: 16),
        if (_settings.showCountry)
          Column(
            children: [
              TextFormField(
                initialValue: widget.wine.country,
                decoration: const InputDecoration(
                  labelText: 'Country',
                  border: OutlineInputBorder(),
                  hintText: 'e.g., France, Italy',
                ),
                onChanged: (value) {
                  widget.wine.country = value.isEmpty ? null : value;
                  _onFieldChanged();
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        TextFormField(
          initialValue: widget.wine.region,
          decoration: const InputDecoration(
            labelText: 'Region',
            border: OutlineInputBorder(),
            hintText: 'e.g., Bordeaux, Tuscany',
          ),
          onChanged: (value) {
            widget.wine.region = value.isEmpty ? null : value;
            _onFieldChanged();
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          initialValue: widget.wine.producer,
          decoration: const InputDecoration(
            labelText: 'Producer',
            border: OutlineInputBorder(),
            hintText: 'e.g., Château Margaux',
          ),
          onChanged: (value) {
            widget.wine.producer = value.isEmpty ? null : value;
            _onFieldChanged();
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          initialValue: widget.wine.year,
          decoration: const InputDecoration(
            labelText: 'Year',
            border: OutlineInputBorder(),
            hintText: 'e.g., 2018',
          ),
          keyboardType: TextInputType.number,
          onChanged: (value) {
            widget.wine.year = value.isEmpty ? null : value;
            _onFieldChanged();
          },
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 16),
            _buildWineParameters(),
            const SizedBox(height: 16),
            if (_settings.showColor) ...[  
              TextFormField(
                initialValue: widget.wine.color,
                decoration: const InputDecoration(
                  labelText: 'Color',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  widget.wine.color = value;
                  _onFieldChanged();
                },
              ),
              const SizedBox(height: 16),
            ],
            if (_settings.showSmell) ...[
              TextFormField(
                initialValue: widget.wine.smell,
                decoration: const InputDecoration(
                  labelText: 'Smell',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
                onChanged: (value) {
                  widget.wine.smell = value;
                  _onFieldChanged();
                },
              ),
            ],
            if (_settings.showSmellQuality) ...[
              _buildSlider('Smell Quality', widget.wine.smellQuality, (value) {
                setState(() => widget.wine.smellQuality = value);
                _onFieldChanged();
              }, true),
            ],
            if (_settings.showTaste) ...[  
              TextFormField(
                initialValue: widget.wine.taste,
                decoration: const InputDecoration(
                  labelText: 'Taste',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
                onChanged: (value) {
                  widget.wine.taste = value;
                  _onFieldChanged();
                },
              ),
            ],
            if (_settings.showTasteQuality) ...[  
              _buildSlider('Taste Quality', widget.wine.tasteQuality, (value) {
                setState(() => widget.wine.tasteQuality = value);
                _onFieldChanged();
              }, true),
            ],
            const SizedBox(height: 16),
            if (_settings.showAftertaste) ...[  
              TextFormField(
                initialValue: widget.wine.aftertaste,
                decoration: const InputDecoration(
                  labelText: 'Aftertaste',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
                onChanged: (value) {
                  widget.wine.aftertaste = value;
                  _onFieldChanged();
                },
              ),
            ],
            if (_settings.showAftertasteQuality) ...[  
              _buildSlider('Aftertaste Quality', widget.wine.aftertasteQuality, (value) {
                setState(() => widget.wine.aftertasteQuality = value);
                _onFieldChanged();
              }, true),
            ],
            const SizedBox(height: 16),
            if (_settings.showComments) ...[  
              TextFormField(
                initialValue: widget.wine.comments,
                decoration: const InputDecoration(
                  labelText: 'Comments',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                onChanged: (value) {
                  widget.wine.comments = value;
                  _onFieldChanged();
                },
              ),
            ],
            if (_settings.showCharacteristics) ...[  
              const SizedBox(height: 24),
              const Text('Characteristics', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
                _buildSlider('Acidity', widget.wine.acidity, (value) {
                  setState(() => widget.wine.acidity = value);
                  _onFieldChanged();
                }, false),
                _buildSlider('Body', widget.wine.body, (value) {
                  setState(() => widget.wine.body = value);
                  _onFieldChanged();
                }, false),
                _buildSlider('Fruit', widget.wine.fruit, (value) {
                  setState(() => widget.wine.fruit = value);
                  _onFieldChanged();
                }, false),
                _buildSlider('Sweetness', widget.wine.sweetness, (value) {
                  setState(() => widget.wine.sweetness = value);
                  _onFieldChanged();
                }, false),
                _buildSlider('Tannins', widget.wine.tannins, (value) {
                  setState(() => widget.wine.tannins = value);
                  _onFieldChanged();
                }, false),
            ],
            if (_settings.showRating) ...[  
              _buildSlider('Overall Rating', widget.wine.rating, (value) {
                setState(() => widget.wine.rating = value);
                _onFieldChanged();
              }, true),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSlider(String label, double? value, ValueChanged<double> onChanged, bool useSettings) {
    // If value is null or 0, use the minimum rating from settings
    final effectiveValue = (value ?? 0) <= 0 && useSettings ? _settings.minRating! : value!;
    
    return Row(
      children: [
        SizedBox(
          width: 100,
          child: Text(label, style: const TextStyle(fontSize: 16)),
        ),
        Expanded(
          child: Slider(
            value: effectiveValue,
            min: useSettings ? _settings.minRating! : 0,
            max: useSettings ? _settings.maxRating! : 5,
            divisions: useSettings ? _settings.ratingSteps! : 5,
            label: effectiveValue.toStringAsFixed(1),
            onChanged: (newValue) {
              // If the value was null or 0, update it immediately
              if ((value ?? 0) <= 0) {
                onChanged(effectiveValue);
              }
              onChanged(newValue);
            },
          ),
        ),
        SizedBox(
          width: 60,
          child: Text(
            effectiveValue.toStringAsFixed(1),
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }
}
