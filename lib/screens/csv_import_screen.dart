import 'dart:io';
import 'package:flutter/material.dart';
import '../services/csv_service.dart';
import '../services/firebase_service.dart';
import '../widgets/custom_buttons.dart';

class CsvImportScreen extends StatefulWidget {
  const CsvImportScreen({super.key});

  @override
  State<CsvImportScreen> createState() => _CsvImportScreenState();
}

class _CsvImportScreenState extends State<CsvImportScreen> {
  File? _selectedFile;
  CsvImportResult? _parseResult;
  bool _isLoading = false;
  bool _isImporting = false;
  int _importProgress = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFE333),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFE333),
        elevation: 0,
        leading: IconButton(
          icon: Image.asset(
            'assets/images/back_icon.png',
            width: 24,
            height: 24,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Import CSV',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Instructions
            _buildInstructions(),
            const SizedBox(height: 24),

            // Sélection de fichier
            _buildFileSelection(),
            const SizedBox(height: 24),

            // Résultats du parsing
            if (_parseResult != null) ...[
              _buildParseResults(),
              const SizedBox(height: 24),
            ],

            // Actions
            _buildActions(),
          ],
        ),
      ),
    );
  }

  Widget _buildInstructions() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Format CSV attendu:',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '• Colonnes obligatoires: nom, piece\n'
            '• Colonnes optionnelles: meuble_zone, emplacement_precis, categorie_principale, sous_categorie, proprietaire, tags, description\n'
            '• Tags séparés par des virgules (max 4 + tag automatique "import-csv")\n'
            '• Tous les objets importés auront automatiquement le tag "import-csv"\n'
            '• Encodage UTF-8 recommandé',
            style: TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 12),
          SecondaryButton(
            text: 'Télécharger exemple CSV',
            onPressed: _downloadExample,
          ),
        ],
      ),
    );
  }

  Widget _buildFileSelection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Fichier sélectionné:',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          if (_selectedFile != null)
            Text(
              _selectedFile!.path.split('/').last,
              style: const TextStyle(fontSize: 14, color: Colors.green),
            )
          else
            const Text(
              'Aucun fichier sélectionné',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: SecondaryButton(
                  text: 'Choisir fichier CSV',
                  onPressed: _isLoading ? null : _selectFile,
                ),
              ),
              const SizedBox(width: 12),
              if (_selectedFile != null)
                Expanded(
                  child: PrimaryButton(
                    text: _isLoading ? 'Analyse...' : 'Analyser',
                    onPressed: _isLoading ? null : _parseFile,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildParseResults() {
    if (_parseResult == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Résultats de l\'analyse:',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),

          // Statistiques
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Valides',
                  _parseResult!.validCount.toString(),
                  Colors.green,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  'Erreurs',
                  _parseResult!.errorCount.toString(),
                  Colors.red,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  'Total',
                  _parseResult!.totalLines.toString(),
                  Colors.blue,
                ),
              ),
            ],
          ),

          // Liste des erreurs (si il y en a)
          if (_parseResult!.hasErrors) ...[
            const SizedBox(height: 16),
            const Text(
              'Erreurs détectées:',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 120,
              child: ListView.builder(
                itemCount: _parseResult!.errors.length,
                itemBuilder: (context, index) {
                  final error = _parseResult!.errors[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text(
                      'Ligne ${error.lineNumber}: ${error.error}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.red,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActions() {
    return Column(
      children: [
        if (_parseResult != null && _parseResult!.validCount > 0) ...[
          if (_isImporting) ...[
            LinearProgressIndicator(
              value: _parseResult!.validCount > 0
                  ? _importProgress / _parseResult!.validCount
                  : 0,
              backgroundColor: Colors.grey.shade300,
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
            ),
            const SizedBox(height: 8),
            Text(
              'Import en cours... $_importProgress/${_parseResult!.validCount}',
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
          ],
          PrimaryButton(
            text: _isImporting
                ? 'Import en cours...'
                : 'Importer ${_parseResult!.validCount} objets',
            onPressed: _isImporting ? null : _importItems,
          ),
        ],
      ],
    );
  }

  Future<void> _selectFile() async {
    try {
      final file = await CsvService.pickCsvFile();
      if (file != null) {
        setState(() {
          _selectedFile = file;
          _parseResult = null; // Reset previous results
        });
      }
    } catch (e) {
      _showError('Erreur lors de la sélection: $e');
    }
  }

  Future<void> _parseFile() async {
    if (_selectedFile == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final result = await CsvService.parseCsvFile(_selectedFile!);
      setState(() {
        _parseResult = result;
      });
    } catch (e) {
      _showError('Erreur lors de l\'analyse: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _importItems() async {
    if (_parseResult == null || _parseResult!.validItems.isEmpty) return;

    setState(() {
      _isImporting = true;
      _importProgress = 0;
    });

    try {
      final firebaseService = FirebaseService();
      final items = _parseResult!.validItems;

      // Import par batch de 10 pour éviter les timeouts
      const batchSize = 10;
      int imported = 0;

      for (int i = 0; i < items.length; i += batchSize) {
        final batch = items.skip(i).take(batchSize).toList();

        for (final item in batch) {
          await firebaseService.createItem(item);
          imported++;
          setState(() {
            _importProgress = imported;
          });
        }

        // Petite pause entre les batches
        await Future.delayed(const Duration(milliseconds: 100));
      }

      _showSuccess('$imported objets importés avec succès !');
      if (mounted) {
        Navigator.pop(
            context, true); // Retourner true pour indiquer un import réussi
      }
    } catch (e) {
      _showError('Erreur lors de l\'import: $e');
    } finally {
      setState(() {
        _isImporting = false;
      });
    }
  }

  void _downloadExample() {
    // Pour l'instant, on affiche juste le CSV d'exemple
    // Dans une vraie app, on pourrait utiliser un package comme path_provider
    // pour sauvegarder le fichier
    final example = CsvService.generateExampleCsv();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Exemple CSV'),
        content: SingleChildScrollView(
          child: Text(
            example,
            style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fermer'),
          ),
        ],
      ),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }
}
