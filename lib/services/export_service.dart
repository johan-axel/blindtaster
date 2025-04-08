import '../models/tasting.dart';
import 'storage_provider.dart';

class ExportService {
  static final ExportService instance = ExportService._internal();
  ExportService._internal();

  /// Export all tastings to CSV format
  String exportTastingsToCSV() {
    final StringBuffer csv = StringBuffer();
    
    // Header row
    csv.writeln('Tasting Name,Tasting Date,Flight,Wine Number,Wine Type,Grapes,Country,Region,Producer,Year,' +
                'Color,Smell,Smell Quality,Taste,Taste Quality,Aftertaste,Aftertaste Quality,' +
                'Acidity,Body,Fruit,Sweetness,Tannins,Overall Rating,Comments');

    // Get all tastings from storage
    final tastings = StorageProvider.instance.getAllTastings();
    
    // For each tasting, write all its wines
    for (final tasting in tastings) {
      for (final wine in tasting.wines) {
        csv.writeln(
          '${_escapeCSV(tasting.name)},' +
          '${_escapeCSV(tasting.date)},' +
          '${_escapeCSV(tasting.flight)},' +
          '${wine.wineNumber},' +
          '${_escapeCSV(wine.wineType)},' +
          '${_escapeCSV(wine.grapes)},' +
          '${_escapeCSV(wine.country)},' +
          '${_escapeCSV(wine.region)},' +
          '${_escapeCSV(wine.producer)},' +
          '${_escapeCSV(wine.year)},' +
          '${_escapeCSV(wine.color)},' +
          '${_escapeCSV(wine.smell)},' +
          '${wine.smellQuality ?? ''},' +
          '${_escapeCSV(wine.taste)},' +
          '${wine.tasteQuality ?? ''},' +
          '${_escapeCSV(wine.aftertaste)},' +
          '${wine.aftertasteQuality ?? ''},' +
          '${wine.acidity},' +
          '${wine.body},' +
          '${wine.fruit},' +
          '${wine.sweetness},' +
          '${wine.tannins},' +
          '${wine.rating},' +
          '${_escapeCSV(wine.comments)}'
        );
      }
    }
    
    return csv.toString();
  }

  /// Escape a string for CSV format
  String _escapeCSV(String? value) {
    if (value == null || value.isEmpty) return '';
    // If the value contains comma, quote, or newline, wrap in quotes and escape quotes
    if (value.contains(RegExp(r'[,"\n\r]'))) {
      return '"${value.replaceAll('"', '""')}"';
    }
    return value;
  }
}
