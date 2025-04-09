import 'package:flutter/material.dart';
import '../models/tasting.dart';
import '../models/wine.dart';
import '../models/settings.dart';
import '../services/storage_provider.dart';
import '../widgets/tasting_form.dart';
import '../widgets/saved_tastings_list.dart';
import '../widgets/wines_list.dart';
import 'wine_deck_page.dart';
import 'settings_page.dart';

class TastingSummary extends StatefulWidget {
  final Tasting? initialTasting;

  const TastingSummary({super.key, this.initialTasting});

  @override
  State<TastingSummary> createState() => _TastingSummaryState();
}

class _TastingSummaryState extends State<TastingSummary> {
  bool _isEditing = false;
  bool _isWineParametersExpanded = false;
  List<Tasting> _savedTastings = [];
  Tasting? _selectedTasting;
  final _formKey = GlobalKey<FormState>();

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
    _checkSettings();
    _selectedTasting = widget.initialTasting;

    // Initialize controllers with values from initialTasting if available
    _nameController = TextEditingController(
      text: widget.initialTasting?.name ?? '',
    );
    _dateController = TextEditingController(
      text:
          widget.initialTasting?.date ??
          DateTime.now().toIso8601String().split('T')[0],
    );
    _detailsController = TextEditingController(
      text: widget.initialTasting?.details ?? '',
    );
    _flightController = TextEditingController(
      text: widget.initialTasting?.flight ?? '',
    );
    _numberOfWinesController = TextEditingController(
      text: widget.initialTasting?.numberOfWines?.toString() ?? '',
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

  Future<void> _checkSettings() async {
    final settings = await StorageProvider.instance.getSettings();
    if (settings.newSettings) {
      // Show welcome dialog after a short delay to ensure the widget is mounted
      Future.delayed(const Duration(milliseconds: 100), () {
        if (!mounted) return;
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            title: const Text('Welcome to Blind Taster'),
            content: const Text("Let's set your preferences for your tastings first."),
            actions: [
              TextButton(
                child: const Text('Get Started'),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SettingsPage(),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      });
    }
  }

  Future<void> _loadSavedTastings() async {
    final tastings = await StorageProvider.instance.getAllTastings();
    setState(() {
      _savedTastings = tastings;
    });
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

  Widget _buildTastingIcon() {
    return Container(
      width: 48,
      height: 20,
      child: Stack(
        clipBehavior: Clip.none,
        children: const [
          Positioned(left: 0, child: Icon(Icons.wine_bar, size: 16)),
          Positioned(left: 10, child: Icon(Icons.wine_bar, size: 16)),
          Positioned(left: 20, child: Icon(Icons.wine_bar, size: 16)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Blind Taster'),
        backgroundColor: Colors.purple.shade100,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const SettingsPage(),
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: FloatingActionButton.extended(
              key: const Key('goToWines'),
              onPressed: () async {
                print('[TastingSummary] Attempting form submission');
                if (_formKey.currentState!.validate()) {
                  print('[TastingSummary] Form validation passed');
                  try {
                    int numberOfWines =
                        int.tryParse(_numberOfWinesController.text) ?? 0;

                    // Create a list of numbered wines with default parameters
                    final wines = List<Wine>.generate(
                      numberOfWines,
                      (index) => Wine(
                        wineNumber: index + 1,
                        wineType:
                            _wineTypeController.text.isEmpty
                                ? null
                                : _wineTypeController.text,
                        grapes:
                            _grapesController.text.isEmpty
                                ? null
                                : _grapesController.text,
                        country:
                            _countryController.text.isEmpty
                                ? null
                                : _countryController.text,
                        region:
                            _regionController.text.isEmpty
                                ? null
                                : _regionController.text,
                        producer:
                            _producerController.text.isEmpty
                                ? null
                                : _producerController.text,
                        year:
                            _yearController.text.isEmpty
                                ? null
                                : _yearController.text,
                      ),
                    );

                    final tasting = Tasting(
                      name: _nameController.text,
                      id: _selectedTasting?.id ?? _savedTastings.length + 1,
                      date: _dateController.text,
                      details: _detailsController.text,
                      flight: _flightController.text,
                      numberOfWines: numberOfWines,
                      wineType:
                          _wineTypeController.text.isEmpty
                              ? null
                              : _wineTypeController.text,
                      grapes:
                          _grapesController.text.isEmpty
                              ? null
                              : _grapesController.text,
                      country:
                          _countryController.text.isEmpty
                              ? null
                              : _countryController.text,
                      region:
                          _regionController.text.isEmpty
                              ? null
                              : _regionController.text,
                      producer:
                          _producerController.text.isEmpty
                              ? null
                              : _producerController.text,
                      year:
                          _yearController.text.isEmpty
                              ? null
                              : _yearController.text,
                      wines:
                          _selectedTasting?.wines ??
                          wines, // Use existing wines or create new ones
                      isRevealed: _selectedTasting?.isRevealed ?? false,
                    );

                    // Ensure we have the correct number of wines
                    if (tasting.wines.length < numberOfWines) {
                      // Add more wines if needed
                      final additionalWines = List<Wine>.generate(
                        numberOfWines - tasting.wines.length,
                        (index) =>
                            Wine(wineNumber: tasting.wines.length + index + 1),
                      );
                      tasting.wines.addAll(additionalWines);
                    }

                    // Save the tasting
                    await StorageProvider.instance.saveTasting(tasting);

                    if (mounted) {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder:
                              (context) => WineDeckPage(
                                tasting: tasting,
                                currentCard: 0,
                              ),
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
              label: const Text('Tasting notes'),
              icon: const Icon(Icons.edit_note),
            ),
          ),
          if (_isEditing && _savedTastings.isNotEmpty) ...[
            FloatingActionButton.extended(
              heroTag: 'savedTastings',
              onPressed: () {
                setState(() {
                  _isEditing = false;
                });
              },
              label: const Text('Saved tastings'),
              icon: _buildTastingIcon(),
            ),
          ],
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
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
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Tasting Form Component
                    TastingForm(
                      formKey: _formKey,
                      nameController: _nameController,
                      dateController: _dateController,
                      detailsController: _detailsController,
                      flightController: _flightController,
                      numberOfWinesController: _numberOfWinesController,
                      wineTypeController: _wineTypeController,
                      grapesController: _grapesController,
                      countryController: _countryController,
                      regionController: _regionController,
                      producerController: _producerController,
                      yearController: _yearController,
                      onTap: () {
                        setState(() {
                          _isEditing = true;
                        });
                      },
                      isWineParametersExpanded: _isWineParametersExpanded,
                      onWineParametersExpanded: (expanded) {
                        setState(() {
                          _isWineParametersExpanded = expanded;
                        });
                      },
                      selectedTasting: _selectedTasting,
                    ),

                    const SizedBox(height: 24),

                    // Saved Tastings List Component (if not in editing mode)
                    if (!_isEditing && _savedTastings.isNotEmpty) ...[
                      SavedTastingsList(
                        savedTastings: _savedTastings,
                        selectedTasting: _selectedTasting,
                        onTastingSelected: (tasting) {
                          setState(() {
                            _nameController.text = tasting.name;
                            _dateController.text = tasting.date;
                            _detailsController.text = tasting.details;
                            _flightController.text = tasting.flight ?? '';
                            _numberOfWinesController.text =
                                tasting.numberOfWines?.toString() ?? '';
                            _wineTypeController.text = tasting.wineType ?? '';
                            _grapesController.text = tasting.grapes ?? '';
                            _countryController.text = tasting.country ?? '';
                            _regionController.text = tasting.region ?? '';
                            _producerController.text = tasting.producer ?? '';
                            _yearController.text = tasting.year ?? '';
                            _selectedTasting = tasting;
                          });
                        },
                        onNewTasting: _clearForm,
                        onEditingEnabled: () {
                          setState(() {
                            _isEditing = true;
                          });
                        },
                      ),
                    ],
                    const SizedBox(height: 24),
                    // Wines List Component (if a tasting is selected)
                    if (_selectedTasting != null &&
                        _selectedTasting!.wines.isNotEmpty) ...[
                      WinesList(
                        tasting: _selectedTasting!,
                        isEditing: _isEditing,
                      ),
                      const SizedBox(height: 24),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
