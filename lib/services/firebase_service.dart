import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import '../models/item.dart';
import '../constants/app_constants.dart';

class FirebaseService {
  static final FirebaseService _instance = FirebaseService._internal();
  factory FirebaseService() => _instance;
  FirebaseService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Initialize Firebase service (Firebase app already initialized in main.dart)
  Future<void> initialize() async {
    try {
      await _signInAnonymously();
      debugPrint("FirebaseService: Initialized successfully");
    } catch (e) {
      debugPrint("FirebaseService: Initialization error - $e");
      throw Exception(AppConstants.errorNoConnection);
    }
  }

  // Anonymous authentication (transparent to user)
  Future<void> _signInAnonymously() async {
    try {
      if (_auth.currentUser == null) {
        await _auth.signInAnonymously();
        debugPrint("FirebaseService: Anonymous authentication successful");
      }
    } catch (e) {
      debugPrint("FirebaseService: Authentication error - $e");
      throw Exception(AppConstants.errorNoConnection);
    }
  }

  // Check if user is authenticated
  bool get isAuthenticated => _auth.currentUser != null;

  // CRUD Operations for Items

  // Create new item
  Future<Item> createItem(Item item) async {
    try {
      await _ensureAuthenticated();

      final docRef =
          await _firestore.collection('items').add(item.toFirestore());
      debugPrint("FirebaseService: Item created with ID - ${docRef.id}");

      // Return the item with the new ID
      return Item(
        id: docRef.id,
        name: item.name,
        room: item.room,
        location: item.location,
        subLocation: item.subLocation,
        mainCategory: item.mainCategory,
        subCategory: item.subCategory,
        owner: item.owner,
        tags: item.tags,
        description: item.description,
        createdAt: item.createdAt,
        updatedAt: item.updatedAt,
        searchKeywords: item.searchKeywords,
      );
    } catch (e) {
      debugPrint("FirebaseService: Create item error - $e");
      throw Exception(AppConstants.errorSaveFailed);
    }
  }

  // Read single item by ID
  Future<Item?> getItem(String id) async {
    try {
      await _ensureAuthenticated();

      final doc = await _firestore.collection('items').doc(id).get();
      if (doc.exists) {
        return Item.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      debugPrint("FirebaseService: Get item error - $e");
      throw Exception(AppConstants.errorLoadFailed);
    }
  }

  // Update existing item
  Future<void> updateItem(Item item) async {
    try {
      await _ensureAuthenticated();

      await _firestore
          .collection('items')
          .doc(item.id)
          .update(item.toFirestore());
      debugPrint("FirebaseService: Item updated - ${item.id}");
    } catch (e) {
      debugPrint("FirebaseService: Update item error - $e");
      throw Exception(AppConstants.errorSaveFailed);
    }
  }

  // Delete item
  Future<void> deleteItem(String id) async {
    try {
      await _ensureAuthenticated();

      await _firestore.collection('items').doc(id).delete();
      debugPrint("FirebaseService: Item deleted - $id");
    } catch (e) {
      debugPrint("FirebaseService: Delete item error - $e");
      throw Exception(AppConstants.errorDeleteFailed);
    }
  }

  // Search items by name
  Future<List<Item>> searchItems(String query) async {
    try {
      await _ensureAuthenticated();

      // Diviser la requête en mots individuels
      final searchWords = query
          .toLowerCase()
          .replaceAll(RegExp(r'[^\w\s]'), ' ')
          .split(' ')
          .where((word) => word.length > 1)
          .toList();

      if (searchWords.isEmpty) {
        return [];
      }

      // Firestore ne supporte qu'un seul arrayContains par requête
      // On cherche avec le premier mot et on filtre ensuite
      final querySnapshot = await _firestore
          .collection('items')
          .where('searchKeywords', arrayContains: searchWords.first)
          .get();

      final allItems =
          querySnapshot.docs.map((doc) => Item.fromFirestore(doc)).toList();

      // Filtrer localement pour que tous les mots soient présents
      final filteredItems = allItems.where((item) {
        return searchWords.every((word) =>
            item.searchKeywords.any((keyword) => keyword.contains(word)));
      }).toList();

      debugPrint(
          "FirebaseService: Search found ${filteredItems.length} items for query: $query (${searchWords.length} words)");
      return filteredItems;
    } catch (e) {
      debugPrint("FirebaseService: Search error - $e");
      throw Exception(AppConstants.errorLoadFailed);
    }
  }

  // Subcategory management
  Future<List<String>> getSubcategories(String mainCategory) async {
    try {
      // Return predefined subcategories from constants
      final subcategories = AppConstants.subcategories[mainCategory] ?? [];

      return subcategories;
    } catch (e) {
      debugPrint("FirebaseService: Get subcategories error - $e");
      return AppConstants.subcategories[mainCategory] ?? [];
    }
  }

  // Add subcategory (currently just logs - no actual storage)
  Future<void> addSubcategory(String mainCategory, String subcategory) async {
    debugPrint(
        "FirebaseService: Custom subcategory added - $mainCategory: $subcategory");
  }

  // Private helper methods
  Future<void> _ensureAuthenticated() async {
    if (!isAuthenticated) {
      await _signInAnonymously();
    }
  }
}
