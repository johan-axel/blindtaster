import 'package:flutter/material.dart';
import '../models/tasting.dart';
import '../models/wine.dart';
import '../services/storage_service.dart';
import 'wine_deck_page.dart';

class TastingSummary extends StatefulWidget {
  final Tasting? initialTasting;

  const TastingSummary({super.key, this.initialTasting});

  @override
  State<TastingSummary> createState() => _TastingSummaryState();
}

class _TastingSummaryState extends State<TastingSummary> {
  List<Tasting> _savedTastings = [];
  Tasting? _selectedTasting;
  final _formKey = GlobalKey<FormState>();

  Future<void> _loadSavedTastings() async {
    final tastings = await StorageService.getAllTastings();
    setState(() {
      _savedTastings = tastings;
    });
  }
  late final TextEditingController _nameController;
  late final TextEditingController _dateController;
  late final TextEditingController _detailsController;
  late final TextEditingController _flightController;
  late final TextEditingController _numberOfWinesController;

  @override
  void initState() {
    super.initState();
    _loadSavedTastings();
    _selectedTasting = widget.initialTasting;
    // Initialize controllers with values from initialTasting if available
    _nameController = TextEditingController(
      text: widget.initialTasting?.name ?? '',
    );
    _dateController = TextEditingController(
      text: widget.initialTasting?.date ?? DateTime.now().toIso8601String().split('T')[0],
    );
    _detailsController = TextEditingController(
      text: widget.initialTasting?.details ?? '',
    );
    _flightController = TextEditingController(
      text: widget.initialTasting?.flight ?? '',
    );
    _numberOfWinesController = TextEditingController(
      text: widget.initialTasting?.numberOfWines.toString() ?? '0',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dateController.dispose();
    _detailsController.dispose();
    _flightController.dispose();
    _numberOfWinesController.dispose();
    super.dispose();
  }

  void _clearForm() {
    setState(() {
      _selectedTasting = null;
      _nameController.clear();
      _dateController.text = DateTime.now().toIso8601String().split('T')[0];
      _detailsController.clear();
      _flightController.clear();
      _numberOfWinesController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _clearForm,
        label: const Text('New Tasting'),
        icon: const Stack(
          children: [
            Icon(Icons.wine_bar),
            Positioned(
              right: -2,
              bottom: -2,
              child: Icon(Icons.add, size: 14),
            ),
          ],
        ),
        tooltip: 'Create New Tasting',
      ),
      appBar: AppBar(
        title: const Text('Tasting Summary'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Saved Tastings Section
            if (_savedTastings.isNotEmpty) ...[
              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 16),
              const Text(
                'Tasting data',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
            ],
            Expanded(
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Tasting Name',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a tasting name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _dateController,
                        decoration: const InputDecoration(
                          labelText: 'Date (YYYY-MM-DD)',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a date';
                          }
                          // Add date format validation if needed
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      TextFormField(
                        controller: _flightController,
                        decoration: const InputDecoration(
                          labelText: 'Flight',
                          border: OutlineInputBorder(),
                          hintText: 'Enter the flight name or number',
                        ),
                      ),
                      const SizedBox(height: 24),
                      TextFormField(
                        controller: _numberOfWinesController,
                        decoration: const InputDecoration(
                          labelText: 'Number of Wines',
                          border: OutlineInputBorder(),
                          hintText: 'Enter the number of wines in this tasting',
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return null;  // Optional field
                          }
                          final number = int.tryParse(value);

                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _detailsController,
                        decoration: const InputDecoration(
                          labelText: 'Details',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 3,
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              try {
                                int numberOfWines = int.tryParse(_numberOfWinesController.text) ?? 0;
                                
                                // Create a list of numbered wines
                                final wines = List<Wine>.generate(
                                  numberOfWines,
                                  (index) => Wine(wineNumber: index + 1),
                                );

                                final tasting = Tasting(
                                  name: _nameController.text,
                                  id: _selectedTasting?.id ?? _savedTastings.length + 1,
                                  date: _dateController.text,
                                  details: _detailsController.text,
                                  flight: _flightController.text,
                                  numberOfWines: numberOfWines,
                                  wines: _selectedTasting?.wines ?? wines, // Use existing wines or create new ones
                                );

                                // Ensure we have the correct number of wines
                                if (tasting.wines.length < numberOfWines) {
                                  // Add more wines if needed
                                  final additionalWines = List<Wine>.generate(
                                    numberOfWines - tasting.wines.length,
                                    (index) => Wine(wineNumber: tasting.wines.length + index + 1),
                                  );
                                  tasting.wines.addAll(additionalWines);
                                }

                                // Save the tasting
                                await StorageService.saveTasting(tasting);
                                print('Tasting saved: ${tasting.id} with ${tasting.wines.length} wines');

                                if (mounted) {
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: (context) => WineDeckPage(tasting: tasting, currentCard: 0),
                                    ),
                                  );
                                }
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Failed to save: $e')),
                                );
                              }
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              (_selectedTasting != null && _selectedTasting!.wines.isNotEmpty)
                                  ? 'Go to wine cards'
                                  : 'Create new tasting',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (_savedTastings.isNotEmpty) ...[
                const SizedBox(height: 16),
                const Text(
                  'Saved Tastings',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  height: 150,
                  child: ListView.builder(
                    itemCount: _savedTastings.length,
                    itemBuilder: (context, index) {
                      final tasting = _savedTastings[index];
                      return ListTile(
                        title: Text(tasting.name),
                        subtitle: Text('${tasting.flight}: ${tasting.date} - ${tasting.wines.length} wines'),
                        onTap: () {
                          setState(() {
                            _nameController.text = tasting.name;
                            _dateController.text = tasting.date;
                            _detailsController.text = tasting.details;
                            _selectedTasting = tasting;
                          });
                        },
                      );
                    },
                  ),
                ),
              ],
              if (_selectedTasting != null && _selectedTasting!.wines.isNotEmpty) ...[
                const SizedBox(height: 14),
                const Text(
                  'Wines',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 14),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  height: 150,
                  child: ListView.builder(
                    itemCount: _selectedTasting!.wines.length,
                    itemBuilder: (context, index) {
                      final wine = _selectedTasting!.wines[index];
                      return ListTile(
                        title: Text(wine.wineNumber.toString() + ' ' + wine.name),
                        subtitle: Text(wine.rating.toString()),
                        onTap: () {
                          //TODO navigate to wine card
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => WineDeckPage(
                                tasting: _selectedTasting!,
                                currentCard: wine.wineNumber-1,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ],
        ),
      ),
    );
  }
}
