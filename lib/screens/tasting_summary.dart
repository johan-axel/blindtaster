import 'package:flutter/material.dart';
import '../models/tasting_session.dart';
import 'wine_list_page.dart';

class TastingSummary extends StatefulWidget {
  final TastingSession? initialSession;

  const TastingSummary({super.key, this.initialSession});

  @override
  State<TastingSummary> createState() => _TastingSummaryState();
}

class _TastingSummaryState extends State<TastingSummary> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _dateController;
  late final TextEditingController _detailsController;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with values from initialSession if available
    _nameController = TextEditingController(
      text: widget.initialSession?.name ?? '',
    );
    _dateController = TextEditingController(
      text: widget.initialSession?.date ?? DateTime.now().toIso8601String().split('T')[0],
    );
    _detailsController = TextEditingController(
      text: widget.initialSession?.details ?? '',
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
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
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
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final session = TastingSession(
                      name: _nameController.text,
                      date: _dateController.text,
                      details: _detailsController.text,
                      wines: widget.initialSession?.wines ?? [], // Keep existing wines if available
                    );
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => WineListPage(session: session),
                      ),
                    );
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    (widget.initialSession != null && widget.initialSession!.wines.isNotEmpty)
                        ? 'Back to Wines'
                        : 'Create Tasting',
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
