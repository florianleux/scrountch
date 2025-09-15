import 'dart:convert';
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import '../models/item.dart';
import '../constants/app_constants.dart';
import '../constants/location_data.dart';

/// Résultat du parsing d'une ligne CSV
class CsvParseResult {
  final Item? item;
  final String? error;
  final int lineNumber;

  CsvParseResult({this.item, this.error, required this.lineNumber});

  bool get isValid => item != null && error == null;
}

/// Résultat complet de l'import CSV
class CsvImportResult {
  final List<Item> validItems;
  final List<CsvParseResult> errors;
  final int totalLines;

  CsvImportResult({
    required this.validItems,
    required this.errors,
    required this.totalLines,
  });

  int get validCount => validItems.length;
  int get errorCount => errors.length;
  bool get hasErrors => errors.isNotEmpty;
  double get successRate => totalLines > 0 ? validCount / totalLines : 0.0;
}

/// Service simple pour l'import CSV
class CsvService {
  static const List<String> expectedHeaders = [
    'nom',
    'piece',
    'meuble_zone',
    'emplacement_precis',
    'categorie_principale',
    'sous_categorie',
    'proprietaire',
    'tags',
    'description'
  ];

  /// Sélectionner un fichier CSV
  static Future<File?> pickCsvFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv'],
        allowMultiple: false,
      );

      if (result != null && result.files.single.path != null) {
        return File(result.files.single.path!);
      }
      return null;
    } catch (e) {
      throw Exception('Erreur lors de la sélection du fichier: $e');
    }
  }

  /// Parser un fichier CSV et retourner les résultats
  static Future<CsvImportResult> parseCsvFile(File file) async {
    try {
      final content = await file.readAsString(encoding: utf8);
      return _parseCsvContent(content);
    } catch (e) {
      throw Exception('Erreur lors de la lecture du fichier: $e');
    }
  }

  /// Parser le contenu CSV
  static CsvImportResult _parseCsvContent(String content) {
    final List<Item> validItems = [];
    final List<CsvParseResult> errors = [];

    try {
      final List<List<dynamic>> rows =
          const CsvToListConverter().convert(content);

      if (rows.isEmpty) {
        throw Exception('Le fichier CSV est vide');
      }

      // Vérifier les en-têtes
      final headers =
          rows.first.map((h) => h.toString().toLowerCase().trim()).toList();
      final headerValidation = _validateHeaders(headers);
      if (headerValidation != null) {
        errors.add(CsvParseResult(
          error: headerValidation,
          lineNumber: 1,
        ));
        return CsvImportResult(
          validItems: validItems,
          errors: errors,
          totalLines: rows.length - 1,
        );
      }

      // Parser chaque ligne de données
      for (int i = 1; i < rows.length; i++) {
        final result = _parseRow(rows[i], headers, i + 1);
        if (result.isValid) {
          validItems.add(result.item!);
        } else {
          errors.add(result);
        }
      }

      return CsvImportResult(
        validItems: validItems,
        errors: errors,
        totalLines: rows.length - 1,
      );
    } catch (e) {
      errors.add(CsvParseResult(
        error: 'Erreur de format CSV: $e',
        lineNumber: 0,
      ));
      return CsvImportResult(
        validItems: validItems,
        errors: errors,
        totalLines: 0,
      );
    }
  }

  /// Valider les en-têtes CSV
  static String? _validateHeaders(List<String> headers) {
    final requiredHeaders = ['nom', 'piece', 'categorie_principale'];

    for (final required in requiredHeaders) {
      if (!headers.contains(required)) {
        return 'Colonne obligatoire manquante: "$required"';
      }
    }

    return null;
  }

  /// Parser une ligne de données
  static CsvParseResult _parseRow(
      List<dynamic> row, List<String> headers, int lineNumber) {
    try {
      // Créer un map des données
      final Map<String, String> data = {};
      for (int i = 0; i < headers.length && i < row.length; i++) {
        data[headers[i]] = row[i]?.toString().trim() ?? '';
      }

      // Extraire et valider les champs
      final String nom = data['nom'] ?? '';
      final String piece = data['piece'] ?? '';
      final String? meubleZone =
          data['meuble_zone']?.isEmpty == true ? null : data['meuble_zone'];
      final String? emplacementPrecis =
          data['emplacement_precis']?.isEmpty == true
              ? null
              : data['emplacement_precis'];
      final String? categoriePrincipale =
          data['categorie_principale']?.isEmpty == true
              ? null
              : data['categorie_principale'];
      final String? sousCategorie = data['sous_categorie']?.isEmpty == true
          ? null
          : data['sous_categorie'];
      final String? proprietaire =
          data['proprietaire']?.isEmpty == true ? null : data['proprietaire'];
      final String? description =
          data['description']?.isEmpty == true ? null : data['description'];

      // Parser les tags et ajouter automatiquement "import-csv"
      // Tous les objets importés via CSV auront le tag "import-csv" pour faciliter leur identification
      List<String> tags = [
        'import-csv'
      ]; // Tag automatique pour tous les imports CSV
      final tagsString = data['tags'];
      if (tagsString != null && tagsString.isNotEmpty) {
        final userTags = tagsString
            .split(',')
            .map((t) => t.trim())
            .where((t) => t.isNotEmpty)
            .toList();
        tags.addAll(userTags);
      }

      // Validation des champs obligatoires
      if (nom.isEmpty) {
        return CsvParseResult(
            error: 'Le nom est obligatoire', lineNumber: lineNumber);
      }
      if (piece.isEmpty) {
        return CsvParseResult(
            error: 'La pièce est obligatoire', lineNumber: lineNumber);
      }
      if (categoriePrincipale == null || categoriePrincipale.isEmpty) {
        return CsvParseResult(
            error: 'La catégorie principale est obligatoire', lineNumber: lineNumber);
      }

      // Validation des valeurs
      final validationError = _validateFieldValues(
        nom: nom,
        piece: piece,
        meubleZone: meubleZone,
        emplacementPrecis: emplacementPrecis,
        categoriePrincipale: categoriePrincipale,
        sousCategorie: sousCategorie,
        proprietaire: proprietaire,
        tags: tags,
        description: description,
      );

      if (validationError != null) {
        return CsvParseResult(error: validationError, lineNumber: lineNumber);
      }

      // Créer l'item
      final item = Item.create(
        name: nom,
        room: piece,
        location: meubleZone,
        subLocation: emplacementPrecis,
        mainCategory: categoriePrincipale,
        subCategory: sousCategorie,
        owner: proprietaire,
        tags: tags,
        description: description,
      );

      return CsvParseResult(item: item, lineNumber: lineNumber);
    } catch (e) {
      return CsvParseResult(
          error: 'Erreur de parsing: $e', lineNumber: lineNumber);
    }
  }

  /// Valider les valeurs des champs
  static String? _validateFieldValues({
    required String nom,
    required String piece,
    String? meubleZone,
    String? emplacementPrecis,
    String? categoriePrincipale,
    String? sousCategorie,
    String? proprietaire,
    List<String>? tags,
    String? description,
  }) {
    // Validation du nom
    if (nom.length > AppConstants.maxNameLength) {
      return 'Le nom ne peut pas dépasser ${AppConstants.maxNameLength} caractères';
    }

    // Validation de la pièce
    if (!AppConstants.rooms.contains(piece)) {
      return 'Pièce invalide: "$piece". Valeurs autorisées: ${AppConstants.rooms.join(", ")}';
    }

    // Validation du meuble/zone
    if (meubleZone != null) {
      final availableLocations = LocationData.getLocationsForRoom(piece);
      if (!availableLocations.contains(meubleZone)) {
        return 'Meuble/Zone invalide pour "$piece": "$meubleZone"';
      }
    }

    // Validation de l'emplacement précis
    if (emplacementPrecis != null && meubleZone != null) {
      if (!LocationData.hasSubLocations(piece, meubleZone)) {
        return 'Aucun emplacement précis disponible pour "$piece" → "$meubleZone"';
      }
      final availableSubLocations =
          LocationData.getSubLocationsForLocation(piece, meubleZone);
      if (!availableSubLocations.contains(emplacementPrecis)) {
        return 'Emplacement précis invalide: "$emplacementPrecis"';
      }
    }

    // Validation de la catégorie principale (maintenant obligatoire)
    if (categoriePrincipale == null || categoriePrincipale.isEmpty) {
      return 'La catégorie principale est obligatoire';
    }
    if (!AppConstants.mainCategories.contains(categoriePrincipale)) {
      return 'Catégorie principale invalide: "$categoriePrincipale". Valeurs autorisées: ${AppConstants.mainCategories.join(", ")}';
    }

    // Validation de la sous-catégorie
    if (sousCategorie != null) {
      final availableSubCategories =
          AppConstants.subcategories[categoriePrincipale] ?? [];
      if (!availableSubCategories.contains(sousCategorie)) {
        return 'Sous-catégorie invalide pour "$categoriePrincipale": "$sousCategorie"';
      }
    }

    // Validation du propriétaire
    if (proprietaire != null && !AppConstants.owners.contains(proprietaire)) {
      return 'Propriétaire invalide: "$proprietaire". Valeurs autorisées: ${AppConstants.owners.join(", ")}';
    }

    // Validation des tags (en tenant compte du tag automatique "import-csv")
    if (tags != null) {
      if (tags.length > AppConstants.maxTags) {
        return 'Maximum ${AppConstants.maxTags} tags autorisés (y compris le tag automatique "import-csv")';
      }
      for (final tag in tags) {
        if (tag.length > AppConstants.maxTagLength) {
          return 'Tag trop long: "$tag" (max ${AppConstants.maxTagLength} caractères)';
        }
      }
    }

    // Validation de la description
    if (description != null &&
        description.length > AppConstants.maxDescriptionLength) {
      return 'Description trop longue (max ${AppConstants.maxDescriptionLength} caractères)';
    }

    return null;
  }

  /// Générer un fichier CSV d'exemple
  static String generateExampleCsv() {
    final List<List<String>> rows = [
      expectedHeaders,
      [
        'Fer à repasser',
        'Buanderie',
        'Étagère métallique',
        'Étagère 2',
        'Électronique',
        'Électroménager',
        'Marie',
        'repassage,linge',
        'Fer vapeur Calor (le tag "import-csv" sera ajouté automatiquement)'
      ],
      [
        'Aspirateur',
        'Salon',
        'Placard du couloir',
        'Emplacement aspirateur',
        'Électronique',
        'Électroménager',
        'Florian',
        'nettoyage,sol',
        'Dyson V8'
      ],
      [
        'Livre Harry Potter',
        'Chambre d\'Alice',
        '',
        '',
        'Livres',
        'Romans',
        'Alice',
        'fantasy,enfant',
        'Tome 1'
      ]
    ];

    return const ListToCsvConverter().convert(rows);
  }
}
