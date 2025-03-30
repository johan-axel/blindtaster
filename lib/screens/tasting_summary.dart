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
  bool _isWineParametersExpanded = false;
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
  late final TextEditingController _wineTypeController;
  late final TextEditingController _grapesController;
  late final TextEditingController _countryController;
  late final TextEditingController _regionController;
  late final TextEditingController _producerController;
  late final TextEditingController _yearController;

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
      text: widget.initialTasting?.numberOfWines.toString() ?? '',
    );
    _wineTypeController = TextEditingController(
      text: widget.initialTasting?.wineType ?? '',
    );
    _grapesController = TextEditingController(
      text: widget.initialTasting?.grapes ?? '',
    );
    _countryController = TextEditingController(
      text: widget.initialTasting?.country ?? '',
    );
    _regionController = TextEditingController(
      text: widget.initialTasting?.region ?? '',
    );
    _producerController = TextEditingController(
      text: widget.initialTasting?.producer ?? '',
    );
    _yearController = TextEditingController(
      text: widget.initialTasting?.year ?? '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dateController.dispose();
    _detailsController.dispose();
    _flightController.dispose();
    _numberOfWinesController.dispose();
    _wineTypeController.dispose();
    _grapesController.dispose();
    _countryController.dispose();
    _regionController.dispose();
    _producerController.dispose();
    _yearController.dispose();
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
      _wineTypeController.clear();
      _grapesController.clear();
      _countryController.clear();
      _regionController.clear();
      _producerController.clear();
      _yearController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [         
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: FloatingActionButton.extended(
              heroTag: 'goToWines',
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  try {
                    int numberOfWines = int.tryParse(_numberOfWinesController.text) ?? 0;
                    
                    // Create a list of numbered wines with default parameters
                    final wines = List<Wine>.generate(
                      numberOfWines,
                      (index) => Wine(
                        wineNumber: index + 1,
                        wineType: _wineTypeController.text.isEmpty ? null : _wineTypeController.text,
                        grapes: _grapesController.text.isEmpty ? null : _grapesController.text,
                        country: _countryController.text.isEmpty ? null : _countryController.text,
                        region: _regionController.text.isEmpty ? null : _regionController.text,
                        producer: _producerController.text.isEmpty ? null : _producerController.text,
                        year: _yearController.text.isEmpty ? null : _yearController.text,
                      ),
                    );

                    final tasting = Tasting(
                      name: _nameController.text,
                      id: _selectedTasting?.id ?? _savedTastings.length + 1,
                      date: _dateController.text,
                      details: _detailsController.text,
                      flight: _flightController.text,
                      numberOfWines: numberOfWines,
                      wineType: _wineTypeController.text.isEmpty ? null : _wineTypeController.text,
                      grapes: _grapesController.text.isEmpty ? null : _grapesController.text,
                      country: _countryController.text.isEmpty ? null : _countryController.text,
                      region: _regionController.text.isEmpty ? null : _regionController.text,
                      producer: _producerController.text.isEmpty ? null : _producerController.text,
                      year: _yearController.text.isEmpty ? null : _yearController.text,
                      wines: _selectedTasting?.wines ?? wines, // Use existing wines or create new ones
                      isRevealed: _selectedTasting?.isRevealed ?? false,
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
                    print('Tasting saved: ${tasting.id} with ${tasting.wines.length} wines and is Revealed: ${tasting.isRevealed}');

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
              label: const Text('Go to Wine notes'),
              icon: const Icon(Icons.wine_bar),
            ),
          ),
          if (_selectedTasting != null) ...[   
            FloatingActionButton.extended(
              heroTag: 'newTasting',
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
              tooltip: 'New Tasting',
            ),
          ]
        ],
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
                      ExpansionTile(
                        title: const Text('Set wine parameters'),
                        initiallyExpanded: _isWineParametersExpanded,
                        onExpansionChanged: (expanded) {
                          setState(() {
                            _isWineParametersExpanded = expanded;
                          });
                        },
                        children: [
                          TextFormField(
                            controller: _wineTypeController,
                            decoration: const InputDecoration(
                              labelText: 'Type',
                              border: OutlineInputBorder(),
                              hintText: 'e.g., Red, White, Rosé',
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _grapesController,
                            decoration: const InputDecoration(
                              labelText: 'Grape(s)',
                              border: OutlineInputBorder(),
                              hintText: 'e.g., Cabernet Sauvignon, Merlot',
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _countryController,
                            decoration: const InputDecoration(
                              labelText: 'Country',
                              border: OutlineInputBorder(),
                              hintText: 'e.g., France, Italy',
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _regionController,
                            decoration: const InputDecoration(
                              labelText: 'Region',
                              border: OutlineInputBorder(),
                              hintText: 'e.g., Bordeaux, Tuscany',
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _producerController,
                            decoration: const InputDecoration(
                              labelText: 'Producer',
                              border: OutlineInputBorder(),
                              hintText: 'e.g., Château Margaux',
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _yearController,
                            decoration: const InputDecoration(
                              labelText: 'Year',
                              border: OutlineInputBorder(),
                              hintText: 'e.g., 2018',
                            ),
                            keyboardType: TextInputType.number,
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                      ],
                    ),
                  ),
                ),
              ),
              if (_savedTastings.isNotEmpty) ...[
                const Divider(),
                const SizedBox(height: 24),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.wine_bar, size: 20),
                          const SizedBox(width: 8),
                          const Text(
                            'Saved Tastings',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Container(
                        height: 150,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ListView.builder(
                          itemCount: _savedTastings.length,
                          itemBuilder: (context, index) {
                            final tasting = _savedTastings[index];
                            return Card(
                              margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                                side: BorderSide(color: Colors.grey.shade200),
                              ),
                              child: ListTile(
                                title: Text(
                                  '${tasting.name} ${tasting.flight?.padLeft(1, ' ') ?? ''}',
                                  style: const TextStyle(fontWeight: FontWeight.w500),
                                ),
                                subtitle: Text(
                                  '${tasting.date} (${tasting.wines.length}) ${tasting.producer?.padLeft(1, ' - ') ?? ''} ${tasting.country?.padLeft(1, ' - ') ?? ''} ${tasting.region?.padLeft(1, ' - ') ?? ''} ${tasting.year?.padLeft(1, ' - ') ?? ''} ${tasting.wineType?.padLeft(1, ' - ') ?? ''} ${tasting.grapes?.padLeft(1, ' - ') ?? ''}',
                                  style: TextStyle(color: Colors.grey.shade600),
                                ),
                                onTap: () {
                          setState(() {
                            _nameController.text = tasting.name;
                            _dateController.text = tasting.date;
                            _detailsController.text = tasting.details;
                            _selectedTasting = tasting;
                                  });
                                },
                              ),
                            );
                          },
                        ),
                      ),
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
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          height: 150,
                          child: ListView.builder(
                            itemCount: _selectedTasting!.wines.length,
                            itemBuilder: (context, index) {
                              final wine = _selectedTasting!.wines[index];
                              return ListTile(
                                title: Text('${wine.wineNumber} [${wine.rating}] ${wine.name} ${wine.producer?.padLeft(1, ' - ') ?? ''} ${wine.country?.padLeft(1, ' - ') ?? ''} ${wine.region?.padLeft(1, ' - ') ?? ''} ${wine.year?.padLeft(1, ' - ') ?? ''} ${wine.wineType?.padLeft(1, ' - ') ?? ''} ${wine.grapes?.padLeft(1, ' - ') ?? ''}'),
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
                      ]
                    ],
                  ),
                ),
              ],
            ],
        ),
      ),
    );
  }
}
