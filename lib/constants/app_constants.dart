class AppConstants {
  // App Information
  static const String appName = 'Scrountch';
  
  // Note: Version info is managed in pubspec.yaml
  // Use PackageInfo.fromPlatform() to get version at runtime if needed

  static const List<String> rooms = [
    'Salon',
    'Cuisine',
    'Salle de bain',
    'Bureau',
    'Chambre d\'Alice',
    'Chambre d\'Oscar',
    'Chambre des parents',
    'Toilettes',
    'Buanderie',
    'Garage',
    'Grenier',
    'Petit cabanon de jardin',
    'Extérieur'
  ];

  static const List<String> owners = ['Marie', 'Florian', 'Alice', 'Oscar'];

  static const List<String> mainCategories = [
    'Vêtements',
    'Cuisine',
    'Électronique',
    'Livres',
    'Jouets & Jeux',
    'Mobilier',
    'Outils & Bricolage',
    'Linge & Textiles',
    'Hygiène & Santé',
    'Papiers & Documents',
    'Produits ménagers',
    'Alimentation',
    'Bagages & Voyage',
    'Divers'
  ];

  // Subcategories maps
  static const Map<String, List<String>> subcategories = {
    'Vêtements': [
      'Hauts manches longues',
      'Hauts manches courtes',
      'Pulls',
      'Pantalons',
      'Jupes',
      'Robes',
      'Chaussures',
      'Lingerie',
      'Accessoires',
      'Manteaux',
      'Vestes',
      'Chaussettes',
      'Collants',
      'Sport'
    ],
    'Cuisine': [
      'Ustensiles',
      'Couteaux',
      'Verres',
      'Tasses',
      'Couverts',
      'Assiettes',
      'Bols',
      'Plats',
      'Électroménager',
      'Récipients',
      'Tupperware',
      'Rangement',
      'Accessoires',
      'Torchons'
    ],
    'Électronique': [
      'Ordinateurs',
      'Téléphones',
      'Tablettes',
      'Audio',
      'Télévision & Écrans',
      'Consoles de jeux',
      'Appareils photo',
      'Électroménager',
      'Câbles & Chargeurs',
      'Accessoires informatiques',
      'Stockage'
    ],
    'Livres': [
      'Romans',
      'BD',
      'Livres pour enfants',
      'Cuisine & Loisirs',
      'Scolaires & Éducatifs',
      'Guides & Pratiques',
      'Dictionnaires',
      'Magazines',
      'Albums photo'
    ],
    'Jouets & Jeux': [
      'Jeux de société',
      'Puzzles',
      'Jeux de construction',
      'Playmobil',
      'Poupées & Figurines',
      'Jeux électroniques',
      'Jouets d\'éveil',
      'Déguisements',
      'Jeux d\'extérieur',
      'Peluches',
      'Jeux éducatifs',
      'Cartes à jouer',
      'Jeux vidéo'
    ],
    'Mobilier': [
      'Chaises',
      'Tabourets',
      'Étagères & Bibliothèques',
      'Décoration murale',
      'Luminaires',
      'Tapis',
      'Rideaux',
      'Rangement & Boîtes'
    ],
    'Outils & Bricolage': [
      'Clés',
      'Tournevis',
      'Marteaux',
      'Scies',
      'Perceuses',
      'Pinces',
      'Visserie',
      'Fixations',
      'Peinture',
      'Jardinage',
      'Entretien & Nettoyage',
      'Mesure',
      'Sécurité & Protection',
      'Électricité',
      'Plomberie',
      'Colle & Adhésifs',
      'Échelles & Escabeaux',
      'Bâches'
    ],
    'Linge & Textiles': [
      'Draps',
      'Couvertures',
      'Oreillers & Coussins',
      'Serviettes',
      'Gants de toilette',
      'Torchons',
      'Nappes',
      'Rideaux',
      'Housses',
      'Couettes & Édredons',
      'Protections'
    ],
    'Hygiène & Santé': [
      'Médicaments',
      'Produits de soin',
      'Maquillage & Cosmétiques',
      'Hygiène dentaire',
      'Hygiène corporelle',
      'Hygiène intime',
      'Parfums',
      'Accessoires',
      'Matériel médical',
      'Compléments alimentaires',
      'Premiers secours'
    ],
    'Papiers & Documents': [
      'Factures',
      'Scolaire',
      'Manuels',
      'Photos',
      'Banques',
      'Assurances',
      'Travail',
      'Impôts',
      'Médical',
      'Voiture',
      'Papiers d\'identité / Passeport',
      'Courrier'
    ],
    'Produits ménagers': [
      'Nettoyage sols',
      'Nettoyage surfaces',
      'Lessive & Adoucissant',
      'Vaisselle',
      'Salle de bain & WC',
      'Vitres & Miroirs',
      'Désinfectants',
      'Détachants',
      'Éponges & Chiffons',
      'Produits spécialisés'
    ],
    'Alimentation': [
      'Conserves',
      'Épices & Condiments',
      'Produits secs',
      'Boissons',
      'Surgelés',
      'Snacks & Gâteaux',
      'Petit-déjeuner',
      'Huiles & Vinaigres',
      'Produits frais',
      'Compléments & Vitamines'
    ],
    'Bagages & Voyage': [
      'Valises',
      'Sacs de voyage',
      'Sacs à dos',
      'Trousses de toilette',
      'Accessoires voyage',
      'Matériel camping',
      'Équipement randonnée',
      'Pochettes & Organiseurs'
    ],
    'Divers': [
      'Objets saisonniers',
      'Souvenirs & Collections',
      'Artisanat & Créations',
      'Matériel événementiel',
      'Objets cassés/à réparer',
      'Décoration temporaire',
      'Articles de fête',
      'Objets non-classés',
      'Stockage temporaire',
      'Objets à donner/vendre'
    ]
  };

  // LIMITES DE VALIDATION
  static const int maxNameLength = 100;
  static const int maxDescriptionLength = 500;
  static const int maxTags = 5;
  static const int maxTagLength = 25;
  static const int maxSubcategoryLength = 50;

  // MESSAGES D'INTERFACE
  static const String errorNameRequired = "Le nom est obligatoire";
  static const String errorRoomRequired = "La pièce est obligatoire";
  static const String errorMaxTags = "Maximum 5 tags autorisés";
  static const String errorTagLength =
      "Chaque tag ne peut pas dépasser 25 caractères";
  static const String errorChooseRoomFirst = "Choisissez d'abord une pièce";
  static const String errorChooseLocationFirst = "Choisissez d'abord un meuble";
  static const String errorNoSublocation = "Aucun emplacement disponible";

  // CONFIRMATIONS
  static const String confirmUnsavedChanges =
      "Vous avez des modifications non sauvées. Quitter quand même ?";
  static const String confirmModify =
      "Êtes-vous sûr de vouloir modifier cet objet ?";

  // SUCCÈS/ERREUR
  static const String successSaved = "Objet enregistré avec succès";
  static const String successUpdated = "Objet modifié avec succès";
  static const String errorSaveFailed = "Erreur lors de la sauvegarde";
  static const String errorLoadFailed = "Erreur lors du chargement des données";
  static const String errorDeleteFailed = "Erreur lors de la suppression";
  static const String errorNoConnection =
      "Pas de connexion internet. Vérifiez votre réseau.";
}
