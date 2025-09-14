class LocationData {
  static const Map<String, Map<String, List<String>>> locationsHierarchy = {
    'Salon': {
      'Grand buffet': [
        'Tiroir droit',
        'Tiroir milieu',
        'Tiroir gauche',
        'Placard milieu',
        'Placard droit',
        'Placard gauche',
        'Dessus'
      ],
      'Vaisselier blanc': [
        'Étagère 1 (haut)',
        'Étagère 2',
        'Étagère 3',
        'Étagère 4',
        'Étagère 5',
        'Étagère 6 (bas)'
      ],
      'Meuble télé': [
        'Tiroir droit',
        'Tiroir gauche',
        'Placard droit',
        'Placard gauche',
        'Dessus'
      ],
      'Caisse à roulettes': [''],
      'Meuble à carrés blanc': [
        'Carré haut droit',
        'Carré haut gauche',
        'Carré bas droit',
        'Carré bas gauche',
        'Dessus'
      ],
      'Coffre du canapé': [''],
      'Placard du couloir': [
        'Étagère 1 (haut)',
        'Étagère 2',
        'Étagère 3',
        'Étagère 4',
        'Étagère 5',
        'Étagère 6 (bas)',
        'Sol',
        'Emplacement aspirateur'
      ],
    },
    'Cuisine': {
      'Frigo': [
        'Porte',
        'Étage 1 (haut)',
        'Étage 2',
        'Étage 3',
        'Étage 4',
        'Étage 5 (bas)',
        'Tiroir à légumes'
      ],
      'Freezer': ['Étage 1 (haut)', 'Étage 2 (bas)'],
      'Placard au-dessus du frigo': [''],
      'Placard à rails': [
        'Étagère 1 (haut)',
        'Étagère 2',
        'Étagère 3',
        'Étagère 4 (bas)'
      ],
      'Placard en haut à côté du frigo': [
        'Étagère 1 (haut)',
        'Étagère 2',
        'Étagère 3 (bas)'
      ],
      'Tiroir à couverts sous machine à café': [''],
      'Placard à plateaux': ['Plateau 1', 'Plateau 2'],
      'Placard à goûters': ['Étagère 1 (haut)', 'Étagère 2 (bas)'],
      'Tiroir sous plan de travail': [''],
      'Placard sous l\'évier': [''],
      'Placard au-dessus de l\'évier': [
        'Droite étagère 1 (haut)',
        'Droite étagère 2',
        'Droite étagère 3 (bas)',
        'Gauche étagère 1 (haut)',
        'Gauche étagère 2',
        'Gauche étagère 3 (bas)'
      ],
      'Tiroir sous la plaque': [''],
      'Placard sous la plaque': ['Étagère 1 (haut)', 'Étagère 2 (bas)'],
      'Tiroir sous le four': [''],
      'Placard sous le four': ['Étagère 1 (haut)', 'Étagère 2 (bas)'],
      'Placard au-dessus du four': [''],
      'Placard gauche au-dessus de la machine à café': [
        'Étagère 1 (haut)',
        'Étagère 2',
        'Étagère 3 (bas)'
      ],
      'Placard droit au-dessus de la machine à café': [
        'Étagère 1 (haut)',
        'Étagère 2',
        'Étagère 3 (bas)'
      ],
      'Placard gauche au-dessus du plan de travail': [
        'Étagère 1 (haut)',
        'Étagère 2',
        'Étagère 3 (bas)'
      ],
      'Placard droit au-dessus du plan de travail': [
        'Étagère 1 (haut)',
        'Étagère 2',
        'Étagère 3 (bas)'
      ],
    },
    'Salle de bain': {
      'Meuble à roulettes': [''],
      'Meuble miroir': ['Gauche', 'Milieu gauche', 'Milieu droit', 'Droite'],
      'Sous le lavabo': [
        'Carré haut gauche',
        'Carré bas gauche',
        'Placard gauche',
        'Placard droite',
        'Carré haut droite',
        'Carré bas droite'
      ],
      'Porte-manteaux': [''],
    },
    'Bureau': {
      'Meuble à roulettes blanc en plastique': [''],
      'Meuble à roulettes blanc en métal': [''],
      'Étagère murale': [''],
      'Meuble blanc à tiroirs haut': ['Tiroir gauche', 'Tiroir droit'],
      'Meuble blanc à tiroirs bas': ['Tiroir gauche', 'Tiroir droit'],
    },
    'Chambre d\'Alice': {
      'Tiroir du bureau sur le bureau': [''],
      'Colonne blanche': [
        'Carrée du haut',
        'Carrée du milieu',
        'Carrée du bas',
        'Tiroir haut',
        'Tiroir bas'
      ],
      'Table de chevet': ['Tiroir haut', 'Tiroir bas'],
      'Sous le lit': ['Tiroir droite', 'Tiroir gauche'],
      'Maison de poupée': [''],
      'Caisse en plastique à couvercle vert': [''],
      'Penderie gauche': [
        'Étagère 1 (haut)',
        'Étagère 2',
        'Étagère 3',
        'Étagère 4',
        'Étagère 5',
        'Étagère 6 (bas)',
        'Sol'
      ],
      'Penderie droite': [
        'Étagère 1 (haut)',
        'Étagère 2',
        'Étagère 3 (bas)',
        'Penderie',
        'Sol'
      ],
    },
    'Chambre d\'Oscar': {
      'Bibliothèque': ['Étagère 1', 'Étagère 2', 'Tiroir'],
      'Coffre à jouets sous le bureau': [''],
      'Étagère du coin': [''],
      'Table de chevet': ['Tiroir haut', 'Tiroir bas'],
      'Penderie de gauche': [
        'Étagère 1 (haut)',
        'Étagère 2',
        'Étagère 3',
        'Étagère 4',
        'Étagère 5',
        'Étagère 6 (bas)',
        'Sol'
      ],
      'Penderie de droite': [
        'Étagère 1 (haut)',
        'Étagère 2',
        'Étagère 3 (bas)',
        'Penderie',
        'Sol'
      ],
      'Caisse à roulettes en bois': [''],
    },
    'Chambre des parents': {
      'Sous le lit': [
        'Tiroir Florian droit',
        'Tiroir Florian gauche',
        'Tiroir Marie droit',
        'Tiroir Marie gauche'
      ],
      'Penderie droite': [
        'Étagère du haut',
        'Caisse Florian droite',
        'Caisse Florian gauche',
        'Penderie',
        'Sol'
      ],
      'Penderie gauche': [
        'Étagère du haut',
        'Caisse Florian droite',
        'Caisse Florian gauche',
        'Étagère vêtement Florian',
        'Étagère Marie 1 (haut)',
        'Étagère Marie 2',
        'Tiroir Florian',
        'Étagère Marie 3',
        'Étagère Marie 4 (bas)'
      ],
    },
    'Toilettes': {
      'Carré en osier': [''],
      'Étagère de coin': ['Droite', 'Gauche'],
    },
    'Buanderie': {
      'Congélateur': [
        'Tiroir 1 (haut)',
        'Tiroir 2',
        'Tiroir 3',
        'Tiroir 4',
        'Tiroir 5',
        'Tiroir 6 (bas)'
      ],
      'Meuble à roulettes blanc': ['Étage haut', 'Étage milieu', 'Étage bas'],
      'Plan de travail': [''],
      'Étagère au-dessus du porte-manteau': [''],
      'Porte-manteaux': [''],
      'Étagère de coin': ['Étagère haut', 'Étagère milieu', 'Étagère bas'],
      'Au-dessus de la porte': ['Étagère haut', 'Étagère bas'],
      'Meuble à chaussures noir': [
        'Compartiment du haut',
        'Compartiment du bas'
      ],
      'Armoire métallique de gauche': [
        'Étagère 1 (haut)',
        'Étagère 2',
        'Étagère 3',
        'Étagère 4',
        'Étagère 5',
        'Étagère 6 (bas)',
        'Sol'
      ],
      'Fond à droite': [
        'Étagère 1',
        'Étagère 2',
        'Étagère 3',
        'Étagère 4',
        'Étagère 5',
        'Étagère 6',
        'Sol'
      ],
      'Penderie droite': [
        'Étagère 1',
        'Étagère 2',
        'Étagère 3',
        'Penderie',
        'Rack à chaussures'
      ],
      'Penderie gauche': [
        'Étagère 1',
        'Étagère 2',
        'Étagère 3',
        'Penderie',
        'Rack à chaussures',
        'Meuble à bouteilles'
      ],
    },
    'Garage': {
      'Panneau mural droite': [
        'Étagère 1 (haut)',
        'Étagère 2',
        'Étagère 3',
        'Étagère 4 (bas)'
      ],
      'Panneau mural gauche': [
        'Étagère 1 (haut)',
        'Étagère 2',
        'Étagère 3',
        'Étagère 4 (bas)'
      ],
      'Mur du fond': [''],
      'Mur de droite': [''],
      'Mur de gauche': [''],
      'Étagère basse métallique 1': ['Étage haut', 'Étage bas'],
      'Étagère basse métallique 2': ['Étage haut', 'Étage bas'],
      'Plan de travail': [
        'Mug Hulk',
        'Mug Surfer d\'argent',
        'Petit meuble à quatre tiroirs noirs',
        'Petit meuble à deux tiroirs noirs',
        'Petit meuble à tiroir gris',
        'Meuble à tiroir métallique'
      ],
      'Étagère en bois': [
        'Étagère 1 (haut)',
        'Étagère 2',
        'Étagère 3',
        'Étagère 4',
        'Étagère 5 (bas)'
      ],
      'Étagère en bois blanche': [
        'Étagère 1 (haut)',
        'Étagère 2',
        'Étagère 3',
        'Étagère 4',
        'Étagère 5 (bas)'
      ],
      'Établi': ['Étagère 1', 'Étagère 2', 'Tiroir dessus de l\'établi'],
      'Étagère métallique': [
        'Étagère 1 (haut)',
        'Étagère 2',
        'Étagère 3',
        'Étagère 4',
        'Étagère 5 (bas)'
      ],
      'Rack à vélos': [''],
      'Étagère au-dessus de la porte': [''],
      'Meuble à semis': [''],
      'Plafond': [
        'Rack gauche',
        'Rack milieu gauche',
        'Rack milieu droit',
        'Rack droit',
        'Rack au-dessus de la porte'
      ],
      'Meuble métallique noir à roulettes': [''],
    },
    'Grenier': {
      'Grenier': [''],
    },
    'Petit cabanon de jardin': {
      'Étagère métallique gauche': ['Étage 1', 'Étage 2', 'Sol'],
      'Étagère métallique basse milieu': ['Étage 1', 'Étage 2', 'Étage 3'],
      'Étagère murale': ['Étagère haut', 'Étagère bas'],
      'Étagère basse en bois': ['Étage 1', 'Étage 2', 'Étage 3'],
    },
    'Extérieur': {
      'Étagère métal à côté du cabanon': [''],
      'Banc coffre noir côté piscine': [''],
      'Pompe à piscine': [''],
      'Coffre carré 1 côté terrasse': [''],
      'Coffre carré 2 côté terrasse': [''],
      'Cabane pour enfants': [''],
    },
  };

  // Retourne la liste des 13 pièces
  static List<String> getRooms() {
    return locationsHierarchy.keys.toList();
  }

  // Retourne les locations pour une pièce donnée
  static List<String> getLocationsForRoom(String room) {
    return locationsHierarchy[room]?.keys.toList() ?? [];
  }

  // Retourne les sous-locations pour une pièce + location donnée
  static List<String> getSubLocationsForLocation(String room, String location) {
    final subLocations = locationsHierarchy[room]?[location] ?? [];
    // Filtrer les chaînes vides (locations sans sous-location)
    return subLocations.where((sub) => sub.isNotEmpty).toList();
  }

  // Teste si une location a des sous-locations
  static bool hasSubLocations(String room, String location) {
    final subLocations = getSubLocationsForLocation(room, location);
    return subLocations.isNotEmpty;
  }
}
