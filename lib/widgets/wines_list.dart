import 'package:flutter/material.dart';
import '../models/tasting.dart';
import '../models/wine.dart';
import '../screens/wine_deck_page.dart';

class WinesList extends StatelessWidget {
  final Tasting tasting;
  final bool isEditing;

  const WinesList({super.key, required this.tasting, required this.isEditing});

  @override
  Widget build(BuildContext context) {
    if (tasting.wines.isEmpty) {
      return const Center(child: Text('No wines added yet'));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Wines',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ListView.builder(
          key: const Key('winesList'),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: tasting.wines.length,
          itemBuilder: (context, index) {
            final wine = tasting.wines[index];
            return Card(
              key: Key('wineCard_${wine.wineNumber}'),
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                key: Key('wineListTile_${wine.wineNumber}'),
                title: Text(
                  wine.name.isNotEmpty ? wine.name : 'Wine ${wine.wineNumber}',
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                subtitle: Text(
                  '${wine.color} | ${wine.smell} | ${wine.taste}',
                  style: TextStyle(color: Colors.grey.shade600),
                ),
                trailing:
                    isEditing
                        ? IconButton(
                          icon: const Icon(Icons.delete_outline),
                          onPressed: () {
                            // Delete functionality would be handled in parent
                          },
                        )
                        : const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  if (!isEditing) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder:
                            (context) => WineDeckPage(
                              tasting: tasting,
                              currentCard: index,
                            ),
                      ),
                    );
                  }
                },
              ),
            );
          },
        ),
      ],
    );
  }
}
