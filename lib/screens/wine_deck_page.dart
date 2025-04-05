import 'package:flutter/material.dart';
import '../models/tasting.dart';
import '../models/wine.dart';
import '../widgets/wine_card.dart';
import '../screens/tasting_summary.dart';
import '../services/storage_provider.dart';

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
      await StorageProvider.instance.saveTasting(widget.tasting);
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
  late final PageController _pageController;

  void _initPageController() {
    _pageController = PageController(initialPage: widget.currentCard);
    _pageController.addListener(() {
      if (_pageController.page != null && _pageController.page!.round() != widget.currentCard) {
        setState(() {
          widget.currentCard = _pageController.page!.round();
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _initPageController();
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
    return Column(
      children: [
        // Navigation buttons and page indicator
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Left side - Edit/Back button
if (widget.currentCard > 0)
                IconButton(
                  onPressed: () => _navigateToCard(widget.currentCard - 1),
                  icon: const Icon(Icons.arrow_back),
                )
              else
                IconButton(
                  icon: const Icon(Icons.summarize),
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
              // Center - Page indicator
              Text(
                _wines.isEmpty ? 'Add your first wine tasting note! ->' : 'Wine ${widget.currentCard + 1} of ${_wines.length}',
                style: const TextStyle(fontSize: 16),
              ),
              // Right side - Forward/Add button
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_wines.isNotEmpty && widget.currentCard < _wines.length - 1)
                    IconButton(
                      onPressed: () => _navigateToCard(widget.currentCard + 1),
                      icon: const Icon(Icons.arrow_forward),
                    ),
                  // Only show add wine button on the last wine or when there are no wines
                  if (_wines.isEmpty || widget.currentCard == _wines.length - 1)
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

                          // Update current card to the new wine
                          widget.currentCard = _wines.length - 1;
                          
                          // Schedule the animation for the next frame
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            _pageController.jumpToPage(widget.currentCard);
                            // Force a rebuild to update the page indicator
                            if (mounted) setState(() {});
                          });
                        });
                      },
                      icon: Stack(
                        alignment: Alignment.center,
                        children: const [
                          Icon(Icons.wine_bar),
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: Icon(Icons.add_circle, size: 14, color: Colors.green),
                          ),
                        ],
                      ),
                      tooltip: 'Add new wine to tasting',
                    ),
                ],
              ),
            ],
          ),
        ),
        // Wine cards or empty state
        Expanded(
          child: _wines.isEmpty
              ? const Center(child: Text('Add your first wine tasting note!'))
              : PageView.builder(
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
                  await StorageProvider.instance.saveTasting(widget.tasting);
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
