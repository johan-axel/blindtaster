import 'package:flutter/material.dart';
import 'dart:async';
import '../models/wine.dart';
import '../models/tasting.dart';

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
    super.dispose();
  }
  @override
  Widget _buildWineParameters() {
    if (!widget.tasting.isRevealed) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(height: 32),
        const Text(
          'Wine Information',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.purple,
                    border: Border.all(color: Colors.purple.shade300, width: 2),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 3,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '#${widget.wine.wineNumber}',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
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
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildWineParameters(),
            const SizedBox(height: 16),
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
            const SizedBox(height: 16),
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
            const SizedBox(height: 16),
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
            const SizedBox(height: 16),
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
            const SizedBox(height: 24),
            const Text('Characteristics', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _buildSlider('Acidity', widget.wine.acidity, (value) {
              setState(() => widget.wine.acidity = value);
              _onFieldChanged();
            }),
            _buildSlider('Body', widget.wine.body, (value) {
              setState(() => widget.wine.body = value);
              _onFieldChanged();
            }),
            _buildSlider('Fruit', widget.wine.fruit, (value) {
              setState(() => widget.wine.fruit = value);
              _onFieldChanged();
            }),
            _buildSlider('Sweetness', widget.wine.sweetness, (value) {
              setState(() => widget.wine.sweetness = value);
              _onFieldChanged();
            }),
            _buildSlider('Tannins', widget.wine.tannins, (value) {
              setState(() => widget.wine.tannins = value);
              _onFieldChanged();
            }),
            const SizedBox(height: 24),
            const Text('Overall Rating', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Row(
              children: [
                Expanded(
                  child: Slider(
                    value: widget.wine.rating,
                    min: 1.0,
                    max: 5.0,
                    divisions: 80,
                    label: widget.wine.rating.toStringAsFixed(1),
                    onChanged: (value) {
                      setState(() => widget.wine.rating = value);
                      _onFieldChanged();
                    },
                  ),
                ),
                SizedBox(
                  width: 60,
                  child: Text(
                    widget.wine.rating.toStringAsFixed(1),
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSlider(String label, double value, ValueChanged<double> onChanged) {
    return Row(
      children: [
        SizedBox(
          width: 100,
          child: Text(label, style: const TextStyle(fontSize: 16)),
        ),
        Expanded(
          child: Slider(
            value: value,
            min: 0.0,
            max: 5.0,
            divisions: 10,
            label: value.toStringAsFixed(1),
            onChanged: onChanged,
          ),
        ),
        SizedBox(
          width: 60,
          child: Text(
            value.toStringAsFixed(1),
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }
}
