import 'package:flutter/material.dart';
import '../models/tasting_session.dart';
import '../services/storage_service.dart';
import 'wine_deck_page.dart';

class TastingSummary extends StatefulWidget {
  final TastingSession? initialTasting;

  const TastingSummary({super.key, this.initialTasting});

  @override
  State<TastingSummary> createState() => _TastingSummaryState();
}

class _TastingSummaryState extends State<TastingSummary> {
  List<TastingSession> _savedTastings = [];
  TastingSession? _selectedTasting;
  final _formKey = GlobalKey<FormState>();

  Future<void> _loadSavedTastings() async {
    final tastings = await StorageService.getAllTastingSessions();
    setState(() {
      _savedTastings = tastings;
    });
  }
  late final TextEditingController _nameController;
  late final TextEditingController _dateController;
  late final TextEditingController _detailsController;

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
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dateController.dispose();
    _detailsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasting Summary'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Saved Sessions Section
            if (_savedSessions.isNotEmpty) ...[              
              const Text(
                'Saved Tastings',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                height: 150,
                child: ListView.builder(
                  itemCount: _savedSessions.length,
                  itemBuilder: (context, index) {
                    final session = _savedSessions[index];
                    return ListTile(
                      title: Text(session.name),
                      subtitle: Text('${session.date} - ${session.wines.length} wines'),
                      onTap: () {
                        setState(() {
                          _nameController.text = session.name;
                          _dateController.text = session.date;
                          _detailsController.text = session.details;
                          _selectedTasting = session;
                        });
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 16),
              const Text(
                'Create New Tasting',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                              final session = TastingSession(
                                name: _nameController.text,
                                date: _dateController.text,
                                details: _detailsController.text,
                                wines: _selectedTasting?.wines ?? [], // Keep existing wines if available
                              );
                              // Save the session
                              await StorageService.saveTastingSession(session);
                              
                              if (mounted) {
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (context) => WineDeckPage(session: session),
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
                                ? 'Back to Wines'
                                : 'Create Tasting',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
