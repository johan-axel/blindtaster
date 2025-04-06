import 'package:flutter/material.dart';
import '../models/tasting.dart';

class TastingForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController dateController;
  final TextEditingController detailsController;
  final TextEditingController flightController;
  final TextEditingController numberOfWinesController;
  final TextEditingController wineTypeController;
  final TextEditingController grapesController;
  final TextEditingController countryController;
  final TextEditingController regionController;
  final TextEditingController producerController;
  final TextEditingController yearController;
  final Function() onTap;
  final bool isWineParametersExpanded;
  final Function(bool) onWineParametersExpanded;
  final Tasting? selectedTasting;

  const TastingForm({
    super.key,
    required this.formKey,
    required this.nameController,
    required this.dateController,
    required this.detailsController,
    required this.flightController,
    required this.numberOfWinesController,
    required this.wineTypeController,
    required this.grapesController,
    required this.countryController,
    required this.regionController,
    required this.producerController,
    required this.yearController,
    required this.onTap,
    required this.isWineParametersExpanded,
    required this.onWineParametersExpanded,
    this.selectedTasting,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Tasting Name',
                border: OutlineInputBorder(),
              ),
              onTap: onTap,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a tasting name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: dateController,
              decoration: const InputDecoration(
                labelText: 'Date (YYYY-MM-DD)',
                border: OutlineInputBorder(),
              ),
              onTap: onTap,
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
              controller: flightController,
              decoration: const InputDecoration(
                labelText: 'Flight',
                border: OutlineInputBorder(),
                hintText: 'Enter the flight name or number',
              ),
              onTap: onTap,
            ),
            const SizedBox(height: 24),
            TextFormField(
              controller: numberOfWinesController,
              decoration: const InputDecoration(
                labelText: 'Number of Wines',
                border: OutlineInputBorder(),
                hintText: 'Enter the number of wines in this tasting',
              ),
              onTap: onTap,
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return null; // Optional field
                }
                final number = int.tryParse(value);
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: detailsController,
              decoration: const InputDecoration(
                labelText: 'Details',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
              onTap: onTap,
            ),
            const SizedBox(height: 24),
            ExpansionTile(
              title: const Text('Wine Parameters'),
              initiallyExpanded: isWineParametersExpanded,
              onExpansionChanged: onWineParametersExpanded,
              children: [
                const SizedBox(height: 16),
                TextFormField(
                  controller: wineTypeController,
                  decoration: const InputDecoration(
                    labelText: 'Wine Type',
                    border: OutlineInputBorder(),
                    hintText: 'e.g., Red, White, Rosé',
                  ),
                  onTap: onTap,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: grapesController,
                  decoration: const InputDecoration(
                    labelText: 'Grapes',
                    border: OutlineInputBorder(),
                    hintText: 'e.g., Cabernet Sauvignon, Chardonnay',
                  ),
                  onTap: onTap,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: countryController,
                  decoration: const InputDecoration(
                    labelText: 'Country',
                    border: OutlineInputBorder(),
                    hintText: 'e.g., France, Italy',
                  ),
                  onTap: onTap,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: regionController,
                  decoration: const InputDecoration(
                    labelText: 'Region',
                    border: OutlineInputBorder(),
                    hintText: 'e.g., Bordeaux, Tuscany',
                  ),
                  onTap: onTap,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: producerController,
                  decoration: const InputDecoration(
                    labelText: 'Producer',
                    border: OutlineInputBorder(),
                    hintText: 'e.g., Château Margaux',
                  ),
                  onTap: onTap,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: yearController,
                  decoration: const InputDecoration(
                    labelText: 'Year',
                    border: OutlineInputBorder(),
                    hintText: 'e.g., 2018',
                  ),
                  onTap: onTap,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
