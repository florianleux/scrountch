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

  // Initialize Firebase and anonymous authentication
  Future<void> initialize() async {
    try {
      await Firebase.initializeApp();
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

  // Migration function to update searchKeywords for existing items
  Future<void> migrateSearchKeywords() async {
    try {
      await _ensureAuthenticated();

      final querySnapshot = await _firestore.collection('items').get();

      for (final doc in querySnapshot.docs) {
        final item = Item.fromFirestore(doc);

        // Régénérer les searchKeywords avec seulement le nom
        final newKeywords = Item.generateSearchKeywordsFromName(item.name);

        // Mettre à jour seulement si les keywords ont changé
        if (!_listsEqual(item.searchKeywords, newKeywords)) {
          await doc.reference.update({
            'searchKeywords': newKeywords,
          });
          debugPrint('Updated searchKeywords for item: ${item.name}');
        }
      }

      debugPrint('Migration completed successfully');
    } catch (e) {
      debugPrint('Migration error: $e');
      throw Exception('Migration failed');
    }
  }

  bool _listsEqual(List<String> list1, List<String> list2) {
    if (list1.length != list2.length) return false;
    for (int i = 0; i < list1.length; i++) {
      if (list1[i] != list2[i]) return false;
    }
    return true;
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

  // Get items by filters
  Future<List<Item>> getItemsByFilters({
    String? room,
    String? mainCategory,
    String? subCategory,
    String? owner,
    int? limit,
  }) async {
    try {
      await _ensureAuthenticated();

      Query query = _firestore.collection('items');

      if (room != null) {
        query = query.where('room', isEqualTo: room);
      }
      if (mainCategory != null) {
        query = query.where('mainCategory', isEqualTo: mainCategory);
      }
      if (subCategory != null) {
        query = query.where('subCategory', isEqualTo: subCategory);
      }
      if (owner != null) {
        query = query.where('owner', isEqualTo: owner);
      }
      if (limit != null) {
        query = query.limit(limit);
      }

      final querySnapshot = await query.get();
      final items =
          querySnapshot.docs.map((doc) => Item.fromFirestore(doc)).toList();
      debugPrint(
          "FirebaseService: Filter query returned ${items.length} items");
      return items;
    } catch (e) {
      debugPrint("FirebaseService: Filter query error - $e");
      throw Exception(AppConstants.errorLoadFailed);
    }
  }

  // Get all items (paginated)
  Future<List<Item>> getAllItems({
    int limit = 20,
    String? startAfter,
  }) async {
    try {
      await _ensureAuthenticated();

      Query query =
          _firestore.collection('items').orderBy('updatedAt', descending: true);

      if (startAfter != null) {
        final lastDoc =
            await _firestore.collection('items').doc(startAfter).get();
        if (lastDoc.exists) {
          query = query.startAfterDocument(lastDoc);
        }
      }

      query = query.limit(limit);

      final querySnapshot = await query.get();
      final items =
          querySnapshot.docs.map((doc) => Item.fromFirestore(doc)).toList();
      debugPrint("FirebaseService: Loaded ${items.length} items");
      return items;
    } catch (e) {
      debugPrint("FirebaseService: Get all items error - $e");
      throw Exception(AppConstants.errorLoadFailed);
    }
  }

  // Get items by room
  Future<List<Item>> getItemsByRoom(String room) async {
    return getItemsByFilters(room: room);
  }

  // Get items by category
  Future<List<Item>> getItemsByCategory(String category) async {
    return getItemsByFilters(mainCategory: category);
  }

  // Get items by owner
  Future<List<Item>> getItemsByOwner(String owner) async {
    return getItemsByFilters(owner: owner);
  }

  // Subcategory management
  Future<List<String>> getSubcategories(String mainCategory) async {
    try {
      // Return predefined subcategories from constants
      final subcategories = AppConstants.subcategories[mainCategory] ?? [];

      // TODO: Could also fetch dynamic subcategories from Firestore
      // final querySnapshot = await _firestore
      //     .collection('subcategories')
      //     .doc(mainCategory)
      //     .get();

      return subcategories;
    } catch (e) {
      debugPrint("FirebaseService: Get subcategories error - $e");
      return AppConstants.subcategories[mainCategory] ?? [];
    }
  }

  Future<void> addCustomSubcategory(
      String mainCategory, String subcategory) async {
    try {
      await _ensureAuthenticated();

      // TODO: Save custom subcategory to Firestore
      // await _firestore
      //     .collection('subcategories')
      //     .doc(mainCategory)
      //     .update({
      //   'items': FieldValue.arrayUnion([subcategory])
      // });

      debugPrint(
          "FirebaseService: Custom subcategory added - $mainCategory: $subcategory");
    } catch (e) {
      debugPrint("FirebaseService: Add subcategory error - $e");
    }
  }

  // Alias pour addCustomSubcategory (utilisé dans item_form_screen.dart)
  Future<void> addSubcategory(String mainCategory, String subcategory) async {
    await addCustomSubcategory(mainCategory, subcategory);
  }

  // Get item statistics
  Future<Map<String, int>> getItemStats() async {
    try {
      await _ensureAuthenticated();

      final querySnapshot = await _firestore.collection('items').get();
      final items =
          querySnapshot.docs.map((doc) => Item.fromFirestore(doc)).toList();

      final stats = {
        'total': items.length,
        'rooms': items.map((item) => item.room).toSet().length,
        'categories': items
            .map((item) => item.mainCategory)
            .where((cat) => cat != null)
            .toSet()
            .length,
      };

      debugPrint("FirebaseService: Stats - $stats");
      return stats;
    } catch (e) {
      debugPrint("FirebaseService: Get stats error - $e");
      return {'total': 0, 'rooms': 0, 'categories': 0};
    }
  }

  // Private helper methods
  Future<void> _ensureAuthenticated() async {
    if (!isAuthenticated) {
      await _signInAnonymously();
    }
  }
}
