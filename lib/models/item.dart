import 'package:cloud_firestore/cloud_firestore.dart';

class Item {
  String id; // Document ID Firestore
  String name; // OBLIGATOIRE 1-100 chars
  String room; // OBLIGATOIRE - pièce
  String? location; // OPTIONNEL - meuble/zone
  String? subLocation; // OPTIONNEL - emplacement précis
  String? mainCategory; // OPTIONNEL - catégorie principale
  String? subCategory; // OPTIONNEL - sous-catégorie
  String? owner; // OPTIONNEL - propriétaire
  List<String>? tags; // OPTIONNEL - max 5 tags
  String? description; // OPTIONNEL - max 500 chars
  DateTime createdAt; // Auto-généré
  DateTime updatedAt; // Auto-généré
  List<String> searchKeywords; // Auto-généré pour recherche

  Item({
    required this.id,
    required this.name,
    required this.room,
    this.location,
    this.subLocation,
    this.mainCategory,
    this.subCategory,
    this.owner,
    this.tags,
    this.description,
    required this.createdAt,
    required this.updatedAt,
    required this.searchKeywords,
  });

  // Factory constructor for creating Item from Firestore document
  factory Item.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return Item(
      id: doc.id,
      name: data['name'] ?? '',
      room: data['room'] ?? '',
      location: data['location'],
      subLocation: data['subLocation'],
      mainCategory: data['mainCategory'],
      subCategory: data['subCategory'],
      owner: data['owner'],
      tags: data['tags'] != null ? List<String>.from(data['tags']) : null,
      description: data['description'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
      searchKeywords: data['searchKeywords'] != null
          ? List<String>.from(data['searchKeywords'])
          : [],
    );
  }

  // Factory constructor for creating new Item
  factory Item.create({
    required String name,
    required String room,
    String? location,
    String? subLocation,
    String? mainCategory,
    String? subCategory,
    String? owner,
    List<String>? tags,
    String? description,
  }) {
    final now = DateTime.now();
    final searchKeywords = _generateSearchKeywords(
      name: name,
      room: room,
      location: location,
      subLocation: subLocation,
      tags: tags,
      owner: owner,
      mainCategory: mainCategory,
      subCategory: subCategory,
    );

    return Item(
      id: '', // Will be set by Firestore
      name: name,
      room: room,
      location: location,
      subLocation: subLocation,
      mainCategory: mainCategory,
      subCategory: subCategory,
      owner: owner,
      tags: tags,
      description: description,
      createdAt: now,
      updatedAt: now,
      searchKeywords: searchKeywords,
    );
  }

  // Convert Item to Map for Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'room': room,
      'location': location,
      'subLocation': subLocation,
      'mainCategory': mainCategory,
      'subCategory': subCategory,
      'owner': owner,
      'tags': tags,
      'description': description,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'searchKeywords': searchKeywords,
    };
  }

  // Update existing item
  Item copyWith({
    String? name,
    String? room,
    String? location,
    String? subLocation,
    String? mainCategory,
    String? subCategory,
    String? owner,
    List<String>? tags,
    String? description,
  }) {
    final updatedName = name ?? this.name;
    final updatedRoom = room ?? this.room;
    final updatedLocation = location ?? this.location;
    final updatedSubLocation = subLocation ?? this.subLocation;
    final updatedTags = tags ?? this.tags;
    final updatedOwner = owner ?? this.owner;
    final updatedMainCategory = mainCategory ?? this.mainCategory;
    final updatedSubCategory = subCategory ?? this.subCategory;

    final updatedSearchKeywords = _generateSearchKeywords(
      name: updatedName,
      room: updatedRoom,
      location: updatedLocation,
      subLocation: updatedSubLocation,
      tags: updatedTags,
      owner: updatedOwner,
      mainCategory: updatedMainCategory,
      subCategory: updatedSubCategory,
    );

    return Item(
      id: id,
      name: updatedName,
      room: updatedRoom,
      location: updatedLocation,
      subLocation: updatedSubLocation,
      mainCategory: updatedMainCategory,
      subCategory: updatedSubCategory,
      owner: updatedOwner,
      tags: updatedTags,
      description: description ?? this.description,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
      searchKeywords: updatedSearchKeywords,
    );
  }

  // Generate search keywords from name only
  static List<String> _generateSearchKeywords({
    required String name,
    required String room,
    String? location,
    String? subLocation,
    List<String>? tags,
    String? owner,
    String? mainCategory,
    String? subCategory,
  }) {
    final keywords = <String>{};

    // Diviser seulement le nom en mots
    keywords.addAll(_splitToKeywords(name));

    return keywords.toList();
  }

  static List<String> _splitToKeywords(String text) {
    return text
        .toLowerCase()
        .replaceAll(RegExp(r'[^\w\s]'), ' ')
        .split(' ')
        .where((word) => word.length > 1)
        .toList();
  }

  // Validation method
  String? validate() {
    if (name.trim().isEmpty) {
      return "Le nom est obligatoire";
    }
    if (name.length > 100) {
      return "Le nom ne peut pas dépasser 100 caractères";
    }
    if (room.trim().isEmpty) {
      return "La pièce est obligatoire";
    }
    if (tags != null && tags!.length > 5) {
      return "Maximum 5 tags autorisés";
    }
    if (tags != null) {
      for (final tag in tags!) {
        if (tag.length > 25) {
          return "Chaque tag ne peut pas dépasser 25 caractères";
        }
      }
    }
    if (description != null && description!.length > 500) {
      return "La description ne peut pas dépasser 500 caractères";
    }
    return null;
  }

  // Get full location string "Pièce → Location → Sous-location"
  String get fullLocation {
    final parts = <String>[room];
    if (location != null && location!.isNotEmpty) {
      parts.add(location!);
    }
    if (subLocation != null && subLocation!.isNotEmpty) {
      parts.add(subLocation!);
    }
    return parts.join('\n↓\n');
  }

  // Get full category string "Catégorie → Sous-catégorie"
  String get fullCategory {
    final parts = <String>[];
    if (mainCategory != null && mainCategory!.isNotEmpty) {
      parts.add(mainCategory!);
      if (subCategory != null && subCategory!.isNotEmpty) {
        parts.add(subCategory!);
      }
    }
    return parts.join(' → ');
  }
}
