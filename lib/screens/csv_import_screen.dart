import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import '../services/csv_service.dart';
import '../services/firebase_service.dart';
import '../widgets/custom_buttons.dart';
import '../theme/unified_theme.dart';
import '../constants/app_constants.dart';

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
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UnifiedTheme.primaryYellow,
      resizeToAvoidBottomInset:
          true, // IMPORTANT: Redimensionne pour éviter le clavier
      body: Stack(
        children: [
          // Image de fond avec opacité
          const Positioned.fill(
            child: Opacity(
              opacity: 0.2,
              child: Image(
                image: AssetImage('assets/images/search_bg.png'),
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
                        color: UnifiedTheme.textBlack,
                        height: 1.1,
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Contenu scrollable
                  Expanded(
                    child: SingleChildScrollView(
                      controller: _scrollController,
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
        color: UnifiedTheme.primaryYellow,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: UnifiedTheme.textBlack, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'FORMAT CSV ATTENDU:',
            style: TextStyle(
              fontFamily: 'DelaGothicOne',
              fontSize: 20,
              color: UnifiedTheme.textBlack,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            '• Colonnes obligatoires: nom, piece, categorie_principale\n'
            '• Colonnes optionnelles: meuble_zone, emplacement_precis, sous_categorie, proprietaire, tags, description\n'
            '• Tags séparés par des virgules (max 4 + tag automatique "import-csv")\n'
            '• Tous les objets importés auront automatiquement le tag "import-csv"\n'
            '• Encodage UTF-8 recommandé',
            style: TextStyle(
              fontFamily: 'Chivo',
              fontSize: 16,
              color: UnifiedTheme.textBlack,
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
        color: UnifiedTheme.primaryYellow,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: UnifiedTheme.textBlack, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'FICHIER SÉLECTIONNÉ:',
            style: TextStyle(
              fontFamily: 'DelaGothicOne',
              fontSize: 20,
              color: UnifiedTheme.textBlack,
            ),
          ),
          const SizedBox(height: 16),
          if (_selectedFile != null)
            Text(
              _selectedFile!.path.split('/').last,
              style: const TextStyle(
                fontFamily: 'Chivo',
                fontSize: 16,
                color: UnifiedTheme.successGreen,
                fontWeight: FontWeight.w600,
              ),
            )
          else
            const Text(
              'Aucun fichier sélectionné',
              style: TextStyle(
                fontFamily: 'Chivo',
                fontSize: 16,
                color: UnifiedTheme.textBlack54,
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
                SizedBox(
                  height: 75,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _parseFile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isLoading
                          ? UnifiedTheme.textBlack.withOpacity(0.6)
                          : UnifiedTheme.textBlack,
                      foregroundColor: _isLoading
                          ? UnifiedTheme.primaryYellow.withOpacity(0.9)
                          : UnifiedTheme.primaryYellow,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(UnifiedTheme.borderRadius),
                      ),
                      elevation: 0,
                      textStyle: UnifiedTheme.buttonTextStyle,
                      minimumSize: const Size(double.infinity, 75),
                    ),
                    child: Text(
                      _isLoading ? 'ANALYSE...' : 'ANALYSER',
                      style: TextStyle(
                        fontFamily: 'DelaGothicOne',
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: _isLoading
                            ? UnifiedTheme.primaryYellow.withOpacity(0.9)
                            : UnifiedTheme.primaryYellow,
                      ),
                      textAlign: TextAlign.center,
                    ),
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
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: UnifiedTheme.primaryYellow,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: UnifiedTheme.textBlack, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'RÉSULTATS DE L\'ANALYSE:',
            style: TextStyle(
              fontFamily: 'DelaGothicOne',
              fontSize: 20,
              color: UnifiedTheme.textBlack,
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
                  UnifiedTheme.successGreen,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  'ERREURS',
                  _parseResult!.errorCount.toString(),
                  UnifiedTheme.errorRed,
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
                color: UnifiedTheme.errorRed,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              height: 120,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: UnifiedTheme.errorRed.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
                border:
                    Border.all(color: UnifiedTheme.errorRed.withOpacity(0.3)),
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
                        color: UnifiedTheme.errorRed,
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
                color: UnifiedTheme.primaryYellow,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: UnifiedTheme.textBlack, width: 1),
              ),
              child: Column(
                children: [
                  LinearProgressIndicator(
                    value: _parseResult!.validCount > 0
                        ? _importProgress / _parseResult!.validCount
                        : 0,
                    backgroundColor: UnifiedTheme.textBlack.withOpacity(0.2),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                        UnifiedTheme.successGreen),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'IMPORT EN COURS... $_importProgress/${_parseResult!.validCount}',
                    style: const TextStyle(
                      fontFamily: 'DelaGothicOne',
                      fontSize: 16,
                      color: UnifiedTheme.textBlack,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
          SizedBox(
            height: 75,
            child: ElevatedButton(
              onPressed: _isImporting ? null : _importItems,
              style: ElevatedButton.styleFrom(
                backgroundColor: _isImporting
                    ? UnifiedTheme.textBlack.withOpacity(0.6)
                    : UnifiedTheme.textBlack,
                foregroundColor: _isImporting
                    ? UnifiedTheme.primaryYellow.withOpacity(0.9)
                    : UnifiedTheme.primaryYellow,
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(UnifiedTheme.borderRadius),
                ),
                elevation: 0,
                textStyle: UnifiedTheme.buttonTextStyle,
                minimumSize: const Size(double.infinity, 75),
              ),
              child: Text(
                _isImporting
                    ? 'IMPORT EN COURS...'
                    : 'IMPORTER ${_parseResult!.validCount} ${AppConstants.pluralObjet(_parseResult!.validCount)}',
                style: TextStyle(
                  fontFamily: 'DelaGothicOne',
                  fontSize: 18, // Plus petit pour permettre 2 lignes lisibles
                  fontWeight: FontWeight.bold,
                  color: _isImporting
                      ? UnifiedTheme.primaryYellow.withOpacity(0.9)
                      : UnifiedTheme.primaryYellow,
                ),
                textAlign: TextAlign.center,
                maxLines: 2, // Permet 2 lignes comme souhaité
              ),
            ),
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

      // Scroll automatique vers les résultats après l'analyse (UX améliorée)
      Future.delayed(const Duration(milliseconds: 300), () {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        }
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

      if (Platform.isAndroid) {
        // Sur Android, demander les permissions et télécharger
        await _downloadOnAndroid(example);
      } else if (Platform.isIOS) {
        // Sur iOS, utiliser le répertoire documents (pas de permissions nécessaires)
        await _downloadOnIOS(example);
      } else {
        // Sur desktop, utiliser le répertoire documents
        await _downloadOnDesktop(example);
      }
    } catch (e) {
      _showError('ERREUR LORS DU TÉLÉCHARGEMENT: $e');
    }
  }

  Future<void> _downloadOnAndroid(String csvContent) async {
    try {
      // Approche moderne pour Android 11+ : créer dans le répertoire de l'app
      // puis proposer de partager le fichier (pas de permissions spéciales nécessaires)

      final directory = await getApplicationDocumentsDirectory();
      const fileName = 'exemple_scrountch.csv';
      final file = File('${directory.path}/$fileName');

      await file.writeAsString(csvContent, encoding: utf8);

      // Proposer de partager le fichier
      await _shareFile(file);
    } catch (e) {
      _showError('ERREUR ANDROID: $e');
    }
  }

  Future<void> _downloadOnIOS(String csvContent) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      const fileName = 'exemple_scrountch.csv';
      final file = File('${directory.path}/$fileName');

      await file.writeAsString(csvContent, encoding: utf8);
      _showSuccess('FICHIER CSV CRÉÉ: ${file.path}');
    } catch (e) {
      _showError('ERREUR IOS: $e');
    }
  }

  Future<void> _downloadOnDesktop(String csvContent) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      const fileName = 'exemple_scrountch.csv';
      final file = File('${directory.path}/$fileName');

      await file.writeAsString(csvContent, encoding: utf8);
      _showSuccess('FICHIER CSV CRÉÉ: ${file.path}');
    } catch (e) {
      _showError('ERREUR DESKTOP: $e');
    }
  }

  Future<void> _shareFile(File file) async {
    try {
      // Partager le fichier via le système de partage d'Android
      final result = await Share.shareXFiles(
        [XFile(file.path)],
        text: 'Exemple de fichier CSV pour Scrountch',
        subject: 'exemple_scrountch.csv',
      );

      if (result.status == ShareResultStatus.success) {
        _showSuccess(
            'FICHIER PARTAGÉ AVEC SUCCÈS!\nVous pouvez l\'enregistrer dans Téléchargements depuis l\'app de partage.');
      } else {
        _showSuccess(
            'FICHIER CRÉÉ: ${file.path}\nUtilisez un gestionnaire de fichiers pour y accéder.');
      }
    } catch (e) {
      // Fallback : afficher juste le chemin
      _showSuccess(
          'FICHIER CRÉÉ: ${file.path}\nUtilisez un gestionnaire de fichiers pour y accéder.');
    }
  }

  Future<bool> _showPermissionDialog() async {
    return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: UnifiedTheme.primaryYellow,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: const BorderSide(color: UnifiedTheme.textBlack, width: 1),
              ),
              title: const Text(
                'PERMISSION REQUISE',
                style: TextStyle(
                  fontFamily: 'DelaGothicOne',
                  fontSize: 20,
                  color: UnifiedTheme.textBlack,
                ),
              ),
              content: const Text(
                'Cette application a besoin d\'accéder au stockage pour télécharger le fichier CSV d\'exemple.\n\nVoulez-vous autoriser l\'accès ?',
                style: TextStyle(
                  fontFamily: 'Chivo',
                  fontSize: 16,
                  color: UnifiedTheme.textBlack,
                ),
              ),
              actions: [
                TertiaryButton(
                  text: 'REFUSER',
                  onPressed: () => Navigator.of(context).pop(false),
                  iconPath: 'assets/images/cross_icon.png',
                ),
                const SizedBox(height: 8),
                TertiaryButton(
                  text: 'AUTORISER',
                  onPressed: () => Navigator.of(context).pop(true),
                  iconPath: 'assets/images/check_icon.png',
                ),
              ],
            );
          },
        ) ??
        false;
  }

  void _showPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: UnifiedTheme.primaryYellow,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: const BorderSide(color: UnifiedTheme.textBlack, width: 1),
          ),
          title: const Text(
            'PERMISSION BLOQUÉE',
            style: TextStyle(
              fontFamily: 'DelaGothicOne',
              fontSize: 20,
              color: UnifiedTheme.textBlack,
            ),
          ),
          content: const Text(
            'L\'accès au stockage a été définitivement refusé. Pour télécharger le fichier CSV, veuillez aller dans les paramètres de l\'application et autoriser l\'accès au stockage.',
            style: TextStyle(
              fontFamily: 'Chivo',
              fontSize: 16,
              color: UnifiedTheme.textBlack,
            ),
          ),
          actions: [
            TertiaryButton(
              text: 'FERMER',
              onPressed: () => Navigator.of(context).pop(),
              iconPath: 'assets/images/cross_icon.png',
            ),
            const SizedBox(height: 8),
            TertiaryButton(
              text: 'OUVRIR PARAMÈTRES',
              onPressed: () {
                Navigator.of(context).pop();
                openAppSettings();
              },
              iconPath: 'assets/images/pen_icon.png',
            ),
          ],
        );
      },
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Center(
          child: Text(
            message.toUpperCase(),
            style: const TextStyle(
              fontFamily: 'DelaGothicOne',
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.normal,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        backgroundColor: UnifiedTheme.errorRed,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Center(
          child: Text(
            message.toUpperCase(),
            style: const TextStyle(
              fontFamily: 'DelaGothicOne',
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.normal,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        backgroundColor: UnifiedTheme.successGreen,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
