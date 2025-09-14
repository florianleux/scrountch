# 🔥 Configuration Firebase

## Prérequis
1. Créer un projet Firebase sur [console.firebase.google.com](https://console.firebase.google.com)
2. Activer Firestore Database
3. Activer Authentication (Anonymous)

## Configuration Android

### 1. Télécharger google-services.json
1. Dans la console Firebase → Paramètres du projet
2. Onglet "Général" → Vos applications
3. Cliquer sur l'icône Android
4. Télécharger `google-services.json`
5. Placer dans `android/app/google-services.json`

### 2. Configurer firebase_options.dart
1. Copier `lib/firebase_options_template.dart` vers `lib/firebase_options.dart`
2. Remplacer les valeurs avec celles de votre projet Firebase :

```dart
// Exemple de configuration
static const FirebaseOptions android = FirebaseOptions(
  apiKey: 'AIzaSyA...', // Votre clé API Android
  appId: '1:123456789:android:abc123', // Votre App ID
  messagingSenderId: '123456789', // Votre Sender ID
  projectId: 'votre-projet-id', // Votre Project ID
  storageBucket: 'votre-projet-id.firebasestorage.app',
);
```

## Règles Firestore (Sécurité)

Configurer ces règles dans la console Firebase :

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Permettre lecture/écriture seulement aux utilisateurs authentifiés
    match /items/{document} {
      allow read, write: if request.auth != null;
    }
  }
}
```

## Vérification

Après configuration :
1. `flutter clean`
2. `flutter pub get`
3. `./build_apk_simple.sh`

L'app doit se connecter à votre Firebase sans erreur.
