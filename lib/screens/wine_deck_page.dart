import 'package:flutter/material.dart';
import '../models/tasting.dart';
import '../models/wine.dart';
import '../widgets/wine_card.dart';
import '../screens/tasting_summary.dart';
import '../services/storage_service.dart';

class WineDeckPage extends StatefulWidget {
  final Tasting tasting;
  int currentCard;
  
  WineDeckPage({super.key, required this.tasting, this.currentCard = 0});

  @override
  State<WineDeckPage> createState() => _WineDeckPageState();
}

class _WineDeckPageState extends State<WineDeckPage> {
  Future<void> _saveTasting() async {
    try {
      await StorageService.saveTasting(widget.tasting);
    } catch (e) {
      // Show error message if save fails
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save: $e')),
        );
      }
    }
  }
  List<Wine> get _wines => widget.tasting.wines;
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    if (widget.currentCard > 0) {
      _pageController.jumpToPage(widget.currentCard);
    }
    _pageController.addListener(() {
      setState(() {
        widget.currentCard = _pageController.page?.round() ?? 0;
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _navigateToCard(int cardIndex) {
    if (cardIndex >= 0 && cardIndex < _wines.length) {
      _pageController.animateToPage(
        cardIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Widget _buildWineList() {
    return _wines.isEmpty
        ? const Center(child: Text('Add your first wine tasting note!'))
        : Column(
            children: [
              // Navigation buttons and page indicator
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                      if (widget.currentCard > 0) ...[
                        IconButton(
                        onPressed: () => _navigateToCard(widget.currentCard - 1),
                        icon: const Icon(Icons.arrow_back),
                        )
                      ] else ...[
                        IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => TastingSummary(
                                initialTasting: widget.tasting,
                              ),
                            ),
                          );
                        },
                        tooltip: 'Back to Tasting summary',
                      ),
                      ],
                      Text(
                        'Wine ${widget.currentCard + 1} of ${_wines.length}',
                        style: const TextStyle(fontSize: 16),
                      ),
                   if (widget.currentCard < _wines.length - 1) ...[
                      IconButton(
                        onPressed: () => _navigateToCard(widget.currentCard + 1),
                        icon: const Icon(Icons.arrow_forward),
                      )
                    ] else ...[ 
                      IconButton(
                        onPressed: () {
                          setState(() {
                            // Add new wine with next number in sequence
                            widget.tasting.wines.add(Wine(
                              wineNumber: _wines.length + 1,
                              wineType: widget.tasting.wineType,
                              grapes: widget.tasting.grapes,
                              country: widget.tasting.country,
                              region: widget.tasting.region,
                              producer: widget.tasting.producer,
                              year: widget.tasting.year,
                            ));
                            _saveTasting();

                            // Schedule the animation for the next frame
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              if (_wines.length > 1) {
                                _pageController.animateToPage(
                                  _wines.length - 1,
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              }
                            });
                          });
                        },
                        icon: const Icon(Icons.wine_bar),
                        tooltip: 'Add new wine to tasting',                        
                      )
                    ],
                  ],
                ),
              ),
              // Wine cards
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _wines.length,
                  itemBuilder: (context, index) {
                    return WineCard(
                      wine: _wines[index],
                      tasting: widget.tasting,
                      onChanged: _saveTasting,
                    );
                  },
                ),
              ),
            ],
          );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.tasting.name),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          Row(
            children: [
              const Text('Are the wines revealed?'),
              const SizedBox(width: 8),
              Switch(
                value: widget.tasting.isRevealed,
                onChanged: (value) async {
                  setState(() {
                    widget.tasting.isRevealed = value;
                  });
                  await StorageService.saveTasting(widget.tasting);
                },
              ),
              const SizedBox(width: 8),
              Text(widget.tasting.isRevealed ? 'Yes' : 'No'),
              const SizedBox(width: 16),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _buildWineList(),
          ),
          // Add some padding at the bottom
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
