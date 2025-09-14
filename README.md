# Scrountch - Family Home Inventory App

Une application Flutter simple pour gérer l'inventaire familial avec Firebase.

> ⚠️ **Configuration Required**: Ce repo nécessite une configuration Firebase. Voir [FIREBASE_SETUP.md](FIREBASE_SETUP.md) pour les instructions complètes.

## Aperçu

Scrountch aide les familles à suivre et localiser les objets de la maison dans différentes pièces et emplacements. Conçu avec une simplicité extrême, utilise Firebase pour le stockage de données et l'authentification anonyme.

## Fonctionnalités

- **Gestion des Objets**: Créer, modifier et rechercher des objets
- **Organisation par Pièces**: Hiérarchie complète Pièce → Location → Sous-location
- **Catégorisation**: Catégories principales et sous-catégories avec ajouts dynamiques
- **Recherche**: Recherche par nom avec résultats instantanés
- **Support Hors Ligne**: Fonctionne hors ligne avec cache Firebase
- **Synchronisation Multi-appareils**: Données synchronisées entre appareils familiaux
- **100% Gratuit**: Aucun coût, pas de photos pour éviter les frais Firebase

## Stack Technique

- **Framework**: Flutter (Dart)
- **Base de Données**: Firebase Firestore
- **Authentification**: Firebase Anonymous Authentication
- **Cible**: Android API niveau 21+

## Structure du Projet

```
lib/
├── main.dart                    # Point d'entrée de l'app
├── constants/
│   ├── app_constants.dart       # Données de référence et constantes
│   └── location_data.dart       # Hiérarchie complète des locations
├── models/
│   └── item.dart               # Modèle de données Item
├── services/
│   └── firebase_service.dart   # Opérations CRUD Firebase
├── screens/
│   ├── home_screen.dart        # Écran de navigation principal
│   ├── search_screen.dart      # Écran de saisie recherche
│   ├── results_screen.dart     # Affichage résultats recherche
│   ├── no_results_screen.dart  # Écran aucun résultat trouvé
│   ├── item_detail_screen.dart # Affichage détails objet
│   ├── manage_screen.dart      # Options de gestion
│   └── item_form_screen.dart   # Formulaire créer/modifier objet
└── widgets/
    └── item_card.dart          # Carte d'affichage objet réutilisable
```

## Instructions de Configuration

### 1. Configuration Firebase

1. Créer projet Firebase : `scrountch-family-inventory`
2. Activer l'authentification anonyme
3. Créer base de données Firestore avec règles de sécurité
4. Télécharger `google-services.json` dans `android/app/`

### 2. Prérequis pour le Build Android

#### Installation des outils requis

1. **Java 17** (recommandé pour la compatibilité) :

   ```bash
   brew install --cask temurin@17
   ```

2. **Android Command Line Tools** :

   ```bash
   brew install --cask android-commandlinetools
   ```

3. **Configuration des variables d'environnement** :

   ```bash
   export JAVA_HOME=/Library/Java/JavaVirtualMachines/temurin-17.jdk/Contents/Home
   export ANDROID_HOME=/opt/homebrew/share/android-commandlinetools
   export PATH="$PATH:$ANDROID_HOME/platform-tools"
   ```

4. **Installation des composants Android SDK** :
   ```bash
   sdkmanager --install "platform-tools" "platforms;android-33" "build-tools;33.0.0"
   ```

#### Configuration du projet

1. **Vérifier les versions dans `android/settings.gradle`** :

   ```gradle
   id "com.android.application" version "8.5.0" apply false
   id "org.jetbrains.kotlin.android" version "2.1.0" apply false
   ```

2. **Vérifier Gradle dans `android/gradle/wrapper/gradle-wrapper.properties`** :

   ```properties
   distributionUrl=https\://services.gradle.org/distributions/gradle-8.7-all.zip
   ```

3. **Vérifier le SDK minimum dans `android/app/build.gradle`** :
   ```gradle
   minSdkVersion 23  // Requis pour Firebase
   ```

### 3. Instructions de Build

#### Option A : Script automatisé (recommandé)

```bash
# Build release (production)
./build_apk_simple.sh release

# Build debug (tests)
./build_apk_simple.sh debug
```

#### Option B : Commandes manuelles

```bash
# Configuration des variables d'environnement
export JAVA_HOME=/Library/Java/JavaVirtualMachines/temurin-17.jdk/Contents/Home
export ANDROID_HOME=/opt/homebrew/share/android-commandlinetools
export PATH="/Users/[username]/code/flutter/bin:$PATH"

# Nettoyer et builder
flutter clean
flutter build apk --release
```

**L'APK sera généré dans** : `build/app/outputs/flutter-apk/app-release.apk`

### 4. Dépannage Build Android

#### Problèmes courants et solutions

1. **Erreur "Command not found: flutter"** :

   ```bash
   export PATH="/Users/[username]/code/flutter/bin:$PATH"
   ```

2. **Erreur de compatibilité Java/Gradle** :

   - Utiliser Java 17 (pas Java 21 ou 24)
   - Vérifier que Gradle 8.7+ est configuré
   - Nettoyer le cache : `rm -rf ~/.gradle/caches/`

3. **Erreur "minSdkVersion 21 cannot be smaller than version 23"** :

   - Mettre à jour `minSdkVersion 23` dans `android/app/build.gradle`

4. **Erreur de version Kotlin** :

   - Mettre à jour vers Kotlin 2.1.0 dans `android/settings.gradle`

5. **Ressources manquantes (ic_launcher, styles.xml)** :
   ```bash
   flutter create --platforms android . --project-name scrountch
   ```

#### Versions testées et compatibles

- **Java** : OpenJDK 17 (Temurin)
- **Gradle** : 8.7
- **Android Gradle Plugin** : 8.5.0
- **Kotlin** : 2.1.0
- **Android SDK** : API 23+ (Android 6.0+)

### 5. Installation APK

1. **Transférer l'APK** sur l'appareil Android (email, AirDrop, USB)
2. **Autoriser les sources inconnues** dans Paramètres > Sécurité
3. **Installer** en tapant sur le fichier APK
4. **Lancer** l'application "Scrountch"

## Spécifications Clés

- **Utilisateurs Maximum**: 3 utilisateurs sur 2 appareils Android
- **Pas de Photos**: Application 100% gratuite sans coûts de stockage
- **Offline First**: Fonctionne sans connexion internet
- **Zéro Maintenance**: Conçu pour la stabilité à long terme
- **Plan Firebase Spark**: Reste dans les limites du tier gratuit

## Utilisation

### Créer des Objets

1. Appuyer sur "RANGER" sur l'écran d'accueil
2. Appuyer sur "NOUVEL OBJET"
3. Remplir les champs obligatoires (Nom, Pièce)
4. Optionnellement ajouter location, catégorie, propriétaire, etc.
5. Appuyer sur "Enregistrer"

### Trouver des Objets

1. Appuyer sur "TROUVER" sur l'écran d'accueil
2. Saisir le nom de l'objet
3. Appuyer sur "RECHERCHER"
4. Voir les résultats ou détails de l'objet

### Gérer les Objets

- Modifier les objets en appuyant sur l'icône d'édition dans les détails
- Ajouter des sous-catégories personnalisées quand "Autre..." est sélectionné
- Navigation contextuelle selon le flux utilisateur

## Modèle de Données

Les objets contiennent :

- **Nom** (obligatoire)
- **Pièce** (obligatoire) - 13 pièces disponibles
- **Location** (optionnel) - Meuble/zone spécifique
- **Sous-location** (optionnel) - Emplacement précis
- **Propriétaire** (optionnel)
- **Catégorie Principale** (optionnel)
- **Sous-catégorie** (optionnel)
- **Tags** (optionnel) - Maximum 5 tags
- **Description** (optionnel)

## Hiérarchie de Localisation

- **13 Pièces** : Salon, Cuisine, Salle de bain, Bureau, Chambres, etc.
- **~92 Locations** : Meubles et zones spécifiques par pièce
- **~400 Sous-locations** : Emplacements précis (tiroirs, étagères, etc.)

## Quotas Firebase

Surveiller l'utilisation pour rester dans les limites du plan Spark :

- Firestore : 50K lectures, 20K écritures par jour
- Authentification : Utilisateurs anonymes illimités

## Informations de Build

- **Package** : com.famille.scrountch
- **Version** : 1.0.0+1
- **SDK Min** : Android API 21 (Android 5.0)
- **Cible** : Dernier SDK Android

## Licence

Application familiale privée - pas de distribution.
