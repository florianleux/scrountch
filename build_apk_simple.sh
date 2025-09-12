#!/bin/bash

# Script de build APK pour Scrountch
# Usage: ./build_apk_simple.sh [debug|release]

set -e

echo "🏠 Building Scrountch Family Inventory App..."
echo "================================================"

# Configuration des variables d'environnement
export JAVA_HOME=/Library/Java/JavaVirtualMachines/temurin-17.jdk/Contents/Home
export ANDROID_HOME=/opt/homebrew/share/android-commandlinetools
export PATH="/Users/florian.leux/code/flutter/bin:$PATH:$ANDROID_HOME/platform-tools"

# Vérification des prérequis
echo "🔍 Vérification des prérequis..."

if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter non trouvé. Vérifiez l'installation."
    exit 1
fi

if ! command -v java &> /dev/null; then
    echo "❌ Java non trouvé. Installez Java 17 avec: brew install --cask temurin@17"
    exit 1
fi

if [ ! -d "$ANDROID_HOME" ]; then
    echo "❌ Android SDK non trouvé. Installez avec: brew install --cask android-commandlinetools"
    exit 1
fi

echo "✅ Prérequis vérifiés"

# Déterminer le type de build
BUILD_TYPE=${1:-release}
if [[ "$BUILD_TYPE" != "debug" && "$BUILD_TYPE" != "release" ]]; then
    echo "❌ Type de build invalide. Utilisez 'debug' ou 'release'"
    exit 1
fi

echo "🧹 Nettoyage du projet..."
flutter clean

echo "📦 Récupération des dépendances..."
flutter pub get

echo "🔨 Build APK ($BUILD_TYPE)..."
if [ "$BUILD_TYPE" = "debug" ]; then
    flutter build apk --debug
else
    flutter build apk --release
fi

# Vérification du succès
APK_PATH="build/app/outputs/flutter-apk/app-$BUILD_TYPE.apk"
if [ -f "$APK_PATH" ]; then
    APK_SIZE=$(du -h "$APK_PATH" | cut -f1)
    echo "✅ Build réussi!"
    echo "📱 APK généré: $APK_PATH"
    echo "📏 Taille: $APK_SIZE"
    echo ""
    echo "🚀 Pour installer sur Android:"
    echo "   1. Transférer l'APK sur votre téléphone"
    echo "   2. Autoriser 'Sources inconnues' dans les paramètres"
    echo "   3. Installer en tapant sur le fichier APK"
else
    echo "❌ Build échoué! L'APK n'a pas été généré."
    exit 1
fi
