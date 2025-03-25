import 'package:flutter/material.dart';
import '../models/tasting_session.dart';
import '../models/wine.dart';
import '../widgets/wine_card.dart';
import '../screens/tasting_summary.dart';
import '../services/storage_service.dart';

class WineDeckPage extends StatefulWidget {
  final TastingSession session;
  
  const WineDeckPage({super.key, required this.session});

  @override
  State<WineDeckPage> createState() => _WineDeckPageState();
}

class _WineDeckPageState extends State<WineDeckPage> {
  Future<void> _saveTastingSession() async {
    try {
      await StorageService.saveTastingSession(widget.session);
    } catch (e) {
      // Show error message if save fails
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save: $e')),
        );
      }
    }
  }
  List<Wine> get _wines => widget.session.wines;
  final PageController _pageController = PageController();

  int _currentCard = 0;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() {
        _currentCard = _pageController.page?.round() ?? 0;
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
                    IconButton(
                      onPressed: _currentCard > 0
                          ? () => _navigateToCard(_currentCard - 1)
                          : null,
                      icon: const Icon(Icons.arrow_back),
                    ),
                    Text(
                      'Wine ${_currentCard + 1} of ${_wines.length}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    IconButton(
                      onPressed: _currentCard < _wines.length - 1
                          ? () => _navigateToCard(_currentCard + 1)
                          : null,
                      icon: const Icon(Icons.arrow_forward),
                    ),
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
                      onChanged: _saveTastingSession,
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
        title: Text(widget.session.name),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => TastingSummary(
                    initialTasting: widget.session,
                  ),
                ),
              );
            },
            tooltip: 'Back to Tasting summary',
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            // Add new wine with next number in sequence
            widget.session.wines.add(Wine(wineNumber: _wines.length + 1));
            _saveTastingSession();
          });
          // Wait for the next frame when the PageView is built
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (_wines.length > 1) {
              _pageController.animateToPage(
                _wines.length - 1,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            }
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
