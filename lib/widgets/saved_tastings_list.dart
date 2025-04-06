import 'package:flutter/material.dart';
import '../models/tasting.dart';
import '../services/storage_provider.dart';

class SavedTastingsList extends StatelessWidget {
  final List<Tasting> savedTastings;
  final Tasting? selectedTasting;
  final Function(Tasting) onTastingSelected;
  final Function() onNewTasting;
  final Function() onEditingEnabled;

  const SavedTastingsList({
    super.key,
    required this.savedTastings,
    required this.selectedTasting,
    required this.onTastingSelected,
    required this.onNewTasting,
    required this.onEditingEnabled,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Left side with title and icon
              Row(
                children: [
                  _buildTastingIcon(),
                  const SizedBox(width: 8),
                  const Text(
                    'Saved Tastings',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              
              // Right side with new tasting button
              if (selectedTasting != null)
                IconButton(
                  onPressed: () {
                    onNewTasting();
                    onEditingEnabled();
                  },
                  icon: Stack(
                    children: [
                      _buildTastingIcon(),
                      Positioned(
                        right: 4,
                        bottom: -2,
                        child: const Icon(Icons.add, size: 14),
                      ),
                    ],
                  ),
                  tooltip: 'New Tasting',
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
              key: const Key('savedTastingsList'),
              itemCount: savedTastings.length,
              itemBuilder: (context, index) {
                final tasting = savedTastings[index];
                return Card(
                  key: Key('tastingCard_${tasting.id}'),
                  margin: const EdgeInsets.symmetric(
                    vertical: 4,
                    horizontal: 8,
                  ),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(color: Colors.grey.shade200),
                  ),
                  child: ListTile(
                    key: Key('tastingListTile_${tasting.id}'),
                    title: Text(
                      '${tasting.name} ${tasting.flight?.padLeft(1, ' ') ?? ''}',
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    subtitle: Text(
                      '${tasting.date} (${tasting.wines.length}) ${tasting.producer?.padLeft(1, ' - ') ?? ''} ${tasting.country?.padLeft(1, ' - ') ?? ''} ${tasting.region?.padLeft(1, ' - ') ?? ''} ${tasting.year?.padLeft(1, ' - ') ?? ''} ${tasting.wineType?.padLeft(1, ' - ') ?? ''} ${tasting.grapes?.padLeft(1, ' - ') ?? ''}',
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () async {
                        final confirmed =
                            await showDialog<bool>(
                              context: context,
                              builder:
                                  (context) => AlertDialog(
                                    title: const Text('Delete Tasting'),
                                    content: Text(
                                      'Are you sure you want to delete "${tasting.name}"?',
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed:
                                            () => Navigator.of(
                                              context,
                                            ).pop(false),
                                        child: const Text('CANCEL'),
                                      ),
                                      TextButton(
                                        onPressed:
                                            () =>
                                                Navigator.of(context).pop(true),
                                        child: const Text('DELETE'),
                                      ),
                                    ],
                                  ),
                            ) ??
                            false;

                        if (confirmed) {
                          await StorageProvider.instance.deleteTasting(
                            tasting.id,
                          );
                          // We'll handle the state update in the parent widget
                        }
                      },
                    ),
                    onTap: () {
                      onTastingSelected(tasting);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTastingIcon() {
    return Container(
      width: 48,
      height: 20,  // Adding a height property is crucial for layout stability
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
}
