import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
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
      print("FirebaseService: Initialized successfully");
    } catch (e) {
      print("FirebaseService: Initialization error - $e");
      throw Exception(AppConstants.ERROR_NO_CONNECTION);
    }
  }

  // Anonymous authentication (transparent to user)
  Future<void> _signInAnonymously() async {
    try {
      if (_auth.currentUser == null) {
        await _auth.signInAnonymously();
        print("FirebaseService: Anonymous authentication successful");
      }
    } catch (e) {
      print("FirebaseService: Authentication error - $e");
      throw Exception(AppConstants.ERROR_NO_CONNECTION);
    }
  }

  // Check if user is authenticated
  bool get isAuthenticated => _auth.currentUser != null;

  // CRUD Operations for Items

  // Create new item
  Future<Item> createItem(Item item) async {
    try {
      await _ensureAuthenticated();
      
      final docRef = await _firestore.collection('items').add(item.toFirestore());
      print("FirebaseService: Item created with ID - ${docRef.id}");
      
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
      print("FirebaseService: Create item error - $e");
      throw Exception(AppConstants.ERROR_SAVE_FAILED);
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
      print("FirebaseService: Get item error - $e");
      throw Exception(AppConstants.ERROR_LOAD_FAILED);
    }
  }

  // Update existing item
  Future<void> updateItem(Item item) async {
    try {
      await _ensureAuthenticated();
      
      await _firestore.collection('items').doc(item.id).update(item.toFirestore());
      print("FirebaseService: Item updated - ${item.id}");
    } catch (e) {
      print("FirebaseService: Update item error - $e");
      throw Exception(AppConstants.ERROR_SAVE_FAILED);
    }
  }

  // Delete item
  Future<void> deleteItem(String id) async {
    try {
      await _ensureAuthenticated();
      
      await _firestore.collection('items').doc(id).delete();
      print("FirebaseService: Item deleted - $id");
    } catch (e) {
      print("FirebaseService: Delete item error - $e");
      throw Exception(AppConstants.ERROR_DELETE_FAILED);
    }
  }

  // Search items by name
  Future<List<Item>> searchItems(String query) async {
    try {
      await _ensureAuthenticated();
      
      final querySnapshot = await _firestore
          .collection('items')
          .where('searchKeywords', arrayContains: query.toLowerCase())
          .get();

      final items = querySnapshot.docs.map((doc) => Item.fromFirestore(doc)).toList();
      print("FirebaseService: Search found ${items.length} items for query: $query");
      return items;
    } catch (e) {
      print("FirebaseService: Search error - $e");
      throw Exception(AppConstants.ERROR_LOAD_FAILED);
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
      final items = querySnapshot.docs.map((doc) => Item.fromFirestore(doc)).toList();
      print("FirebaseService: Filter query returned ${items.length} items");
      return items;
    } catch (e) {
      print("FirebaseService: Filter query error - $e");
      throw Exception(AppConstants.ERROR_LOAD_FAILED);
    }
  }

  // Get all items (paginated)
  Future<List<Item>> getAllItems({
    int limit = 20,
    String? startAfter,
  }) async {
    try {
      await _ensureAuthenticated();
      
      Query query = _firestore.collection('items').orderBy('updatedAt', descending: true);

      if (startAfter != null) {
        final lastDoc = await _firestore.collection('items').doc(startAfter).get();
        if (lastDoc.exists) {
          query = query.startAfterDocument(lastDoc);
        }
      }

      query = query.limit(limit);

      final querySnapshot = await query.get();
      final items = querySnapshot.docs.map((doc) => Item.fromFirestore(doc)).toList();
      print("FirebaseService: Loaded ${items.length} items");
      return items;
    } catch (e) {
      print("FirebaseService: Get all items error - $e");
      throw Exception(AppConstants.ERROR_LOAD_FAILED);
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
      final subcategories = AppConstants.SUBCATEGORIES[mainCategory] ?? [];
      
      // TODO: Could also fetch dynamic subcategories from Firestore
      // final querySnapshot = await _firestore
      //     .collection('subcategories')
      //     .doc(mainCategory)
      //     .get();
      
      return subcategories;
    } catch (e) {
      print("FirebaseService: Get subcategories error - $e");
      return AppConstants.SUBCATEGORIES[mainCategory] ?? [];
    }
  }

  Future<void> addCustomSubcategory(String mainCategory, String subcategory) async {
    try {
      await _ensureAuthenticated();
      
      // TODO: Save custom subcategory to Firestore
      // await _firestore
      //     .collection('subcategories')
      //     .doc(mainCategory)
      //     .update({
      //   'items': FieldValue.arrayUnion([subcategory])
      // });
      
      print("FirebaseService: Custom subcategory added - $mainCategory: $subcategory");
    } catch (e) {
      print("FirebaseService: Add subcategory error - $e");
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
      final items = querySnapshot.docs.map((doc) => Item.fromFirestore(doc)).toList();
      
      final stats = {
        'total': items.length,
        'rooms': items.map((item) => item.room).toSet().length,
        'categories': items.map((item) => item.mainCategory).where((cat) => cat != null).toSet().length,
      };
      
      print("FirebaseService: Stats - $stats");
      return stats;
    } catch (e) {
      print("FirebaseService: Get stats error - $e");
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