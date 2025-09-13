# 📋 Règles de Build - Scrountch Family Inventory

## 🎯 Objectif
Ce document définit les règles et bonnes pratiques pour le build de l'application Scrountch Family Inventory.

## 🚀 Scripts de Build

### Scripts Disponibles
Le projet contient deux scripts de build optimisés :
- `build_apk_simple.sh` - **Script recommandé** pour les builds de routine
- `build_apk.sh` - Script avancé avec options supplémentaires

### ⚠️ RÈGLE IMPORTANTE : Utiliser TOUJOURS les scripts fournis

**❌ NE PAS utiliser directement :**
```bash
flutter build apk --release
```

**✅ UTILISER à la place :**
```bash
./build_apk_simple.sh
```

### Pourquoi utiliser les scripts ?
1. **Configuration Android automatique** - Gestion des SDK et NDK
2. **Nettoyage préalable** - `flutter clean` automatique
3. **Vérification des prérequis** - Validation de l'environnement
4. **Optimisations** - Tree-shaking et compression
5. **Reporting** - Informations détaillées sur le build
6. **Gestion des erreurs** - Messages d'erreur explicites

## 🔧 Prérequis Techniques

### Versions Android NDK
- **Version requise** : `26.1.10909125` (pour Firebase)
- **Configuration** : Automatiquement gérée par les scripts
- **Fichier** : `android/app/build.gradle`

### Dépendances Flutter
- **Flutter SDK** : Version stable recommandée
- **Dart SDK** : Inclus avec Flutter
- **Android SDK** : Géré via les scripts

## 📝 Processus de Build Standard

### 1. Préparation
```bash
# Vérifier l'état du repository
git status

# S'assurer que tous les changements sont commités
git add .
git commit -m "feat: description des changements"
```

### 2. Build
```bash
# Utiliser le script recommandé
./build_apk_simple.sh
```

### 3. Vérification
```bash
# Vérifier la génération de l'APK
ls -la build/app/outputs/flutter-apk/app-release.apk
```

## 🎨 Règles de Développement

### Avant chaque Build
1. **Tests locaux** - Vérifier que l'app fonctionne en debug
2. **Linting** - Corriger tous les warnings
3. **Commit propre** - Messages de commit descriptifs
4. **Documentation** - Mettre à jour si nécessaire

### Structure des Commits
```
type: description courte

- Détail 1
- Détail 2
- Détail 3
```

**Types recommandés :**
- `feat:` - Nouvelle fonctionnalité
- `fix:` - Correction de bug
- `style:` - Changements de style/UI
- `refactor:` - Refactoring de code
- `docs:` - Documentation

### Exemple de Commit
```bash
git commit -m "feat: amélioration majeure de l'interface utilisateur

- Agrandissement des icônes dans les dropdowns (24px → 32px)
- Conversion des champs location/sous-location en SearchableDropdown
- Ajout d'un système de tags visuels avec chips
- Amélioration de la validation des champs searchables"
```

## 🔍 Résolution de Problèmes

### Erreurs Communes

#### 1. "No Android SDK found"
**Solution :** Utiliser `./build_apk_simple.sh` qui configure automatiquement l'environnement

#### 2. "NDK version mismatch"
**Solution :** Les scripts gèrent automatiquement la version NDK correcte

#### 3. "Build failed"
**Diagnostic :**
```bash
# Nettoyer complètement
flutter clean
rm -rf build/
./build_apk_simple.sh
```

#### 4. "Dependencies issues"
**Solution :**
```bash
flutter pub get
flutter pub upgrade --major-versions
```

## 📊 Métriques de Build

### Taille APK Typique
- **Taille attendue** : ~50MB
- **Optimisations** : Tree-shaking activé
- **Compression** : Automatique

### Temps de Build
- **Build propre** : ~45-60 secondes
- **Build incrémental** : ~20-30 secondes

## 🚨 Règles de Sécurité

### Fichiers Sensibles
- **google-services.json** - Déjà dans le repository (OK pour ce projet familial)
- **Clés de signature** - Non présentes (debug uniquement)
- **Variables d'environnement** - Aucune requise actuellement

### Distribution
- **APK de debug** - Pour tests internes uniquement
- **Installation** - Autoriser "Sources inconnues" sur Android

## 📱 Installation sur Appareil

### Étapes
1. **Transférer l'APK** sur le téléphone Android
2. **Paramètres** → Sécurité → Autoriser "Sources inconnues"
3. **Ouvrir l'APK** avec le gestionnaire de fichiers
4. **Installer** en suivant les instructions

### Vérification
- L'app doit se lancer sans erreur
- Toutes les fonctionnalités doivent être opérationnelles
- Les données Firebase doivent se synchroniser

## 🔄 Maintenance

### Mise à jour des Dépendances
```bash
# Vérifier les mises à jour disponibles
flutter pub outdated

# Mettre à jour (avec prudence)
flutter pub upgrade --major-versions
```

### Nettoyage Périodique
```bash
# Nettoyer le cache Flutter
flutter clean

# Nettoyer le cache Gradle (si nécessaire)
cd android && ./gradlew clean && cd ..
```

## 📞 Support

### En cas de Problème
1. **Vérifier ce document** pour les solutions communes
2. **Consulter les logs** de build pour les erreurs spécifiques
3. **Tester avec un build propre** (`flutter clean` + script)
4. **Vérifier les versions** Flutter/Dart/Android SDK

### Logs Utiles
```bash
# Logs Flutter détaillés
flutter build apk --release --verbose

# Logs Gradle (Android)
cd android && ./gradlew assembleRelease --info
```

---

**📅 Dernière mise à jour :** Septembre 2025  
**👥 Équipe :** Scrountch Family Development  
**🔧 Version Flutter :** Stable Channel
