import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
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
      body: Stack(
        children: [
          // Image de fond avec opacité
          Positioned.fill(
            child: Opacity(
              opacity: 0.2,
              child: Image.asset(
                'assets/images/search_bg.png',
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Contenu principal
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 24.0),
              child: Column(
                children: [
                  // Header standardisé
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Row(
                      children: [
                        // Bouton retour (50x50px)
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Image.asset(
                            'assets/images/back_icon.png',
                            width: 50,
                            height: 50,
                          ),
                        ),
                        const Spacer(),
                        // Bouton home (50x50px)
                        GestureDetector(
                          onTap: () => Navigator.pushNamedAndRemoveUntil(
                            context,
                            '/',
                            (route) => false,
                          ),
                          child: Image.asset(
                            'assets/images/home_icon.png',
                            width: 50,
                            height: 50,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Titre de la page
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.0),
                    child: Text(
                      'IMPORT CSV',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'DelaGothicOne',
                        fontSize: 38,
                        color: Colors.black,
                        height: 1.1,
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Contenu scrollable
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
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
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInstructions() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFFFE333),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.black, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'FORMAT CSV ATTENDU:',
            style: TextStyle(
              fontFamily: 'DelaGothicOne',
              fontSize: 20,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            '• Colonnes obligatoires: nom, piece\n'
            '• Colonnes optionnelles: meuble_zone, emplacement_precis, categorie_principale, sous_categorie, proprietaire, tags, description\n'
            '• Tags séparés par des virgules (max 4 + tag automatique "import-csv")\n'
            '• Tous les objets importés auront automatiquement le tag "import-csv"\n'
            '• Encodage UTF-8 recommandé',
            style: TextStyle(
              fontFamily: 'Chivo',
              fontSize: 16,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: TertiaryButton(
              text: 'TÉLÉCHARGER EXEMPLE CSV',
              onPressed: _downloadExample,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFileSelection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFFFE333),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.black, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'FICHIER SÉLECTIONNÉ:',
            style: TextStyle(
              fontFamily: 'DelaGothicOne',
              fontSize: 20,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),
          if (_selectedFile != null)
            Text(
              _selectedFile!.path.split('/').last,
              style: const TextStyle(
                fontFamily: 'Chivo',
                fontSize: 16,
                color: Colors.green,
                fontWeight: FontWeight.w600,
              ),
            )
          else
            const Text(
              'Aucun fichier sélectionné',
              style: TextStyle(
                fontFamily: 'Chivo',
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
          const SizedBox(height: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: TertiaryButton(
                  text: 'CHOISIR FICHIER CSV',
                  onPressed: _isLoading ? null : _selectFile,
                ),
              ),
              const SizedBox(height: 12),
              if (_selectedFile != null)
                PrimaryButton(
                  text: _isLoading ? 'ANALYSE...' : 'ANALYSER',
                  onPressed: _isLoading ? null : _parseFile,
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
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFFFE333),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.black, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'RÉSULTATS DE L\'ANALYSE:',
            style: TextStyle(
              fontFamily: 'DelaGothicOne',
              fontSize: 20,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 20),

          // Statistiques
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'VALIDES',
                  _parseResult!.validCount.toString(),
                  Colors.green,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  'ERREURS',
                  _parseResult!.errorCount.toString(),
                  Colors.red,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  'TOTAL',
                  _parseResult!.totalLines.toString(),
                  Colors.blue,
                ),
              ),
            ],
          ),

          // Liste des erreurs (si il y en a)
          if (_parseResult!.hasErrors) ...[
            const SizedBox(height: 20),
            const Text(
              'ERREURS DÉTECTÉES:',
              style: TextStyle(
                fontFamily: 'DelaGothicOne',
                fontSize: 16,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              height: 120,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: Colors.red.withOpacity(0.3)),
              ),
              child: ListView.builder(
                itemCount: _parseResult!.errors.length,
                itemBuilder: (context, index) {
                  final error = _parseResult!.errors[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text(
                      'Ligne ${error.lineNumber}: ${error.error}',
                      style: const TextStyle(
                        fontFamily: 'Chivo',
                        fontSize: 14,
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
              fontFamily: 'DelaGothicOne',
              fontSize: 24,
              color: color,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Chivo',
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (_parseResult != null && _parseResult!.validCount > 0) ...[
          if (_isImporting) ...[
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFFFE333),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.black, width: 1),
              ),
              child: Column(
                children: [
                  LinearProgressIndicator(
                    value: _parseResult!.validCount > 0
                        ? _importProgress / _parseResult!.validCount
                        : 0,
                    backgroundColor: Colors.black.withOpacity(0.2),
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(Colors.green),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'IMPORT EN COURS... $_importProgress/${_parseResult!.validCount}',
                    style: const TextStyle(
                      fontFamily: 'DelaGothicOne',
                      fontSize: 16,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
          PrimaryButton(
            text: _isImporting
                ? 'IMPORT EN COURS...'
                : 'IMPORTER ${_parseResult!.validCount} OBJETS',
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

  Future<void> _downloadExample() async {
    try {
      // Générer le contenu CSV d'exemple
      final example = CsvService.generateExampleCsv();
      
      // Obtenir le répertoire de téléchargement
      Directory? directory;
      if (Platform.isAndroid) {
        directory = await getExternalStorageDirectory();
      } else {
        directory = await getApplicationDocumentsDirectory();
      }
      
      if (directory != null) {
        // Créer le fichier CSV
        final fileName = 'exemple_scrountch.csv';
        final file = File('${directory.path}/$fileName');
        await file.writeAsString(example);
        
        // Afficher un message de succès
        _showSuccess('Fichier CSV téléchargé: ${file.path}');
      } else {
        _showError('Impossible d\'accéder au répertoire de téléchargement');
      }
    } catch (e) {
      _showError('Erreur lors du téléchargement: $e');
    }
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
