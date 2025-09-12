import 'package:flutter/material.dart';
import '../models/item.dart';
import '../services/firebase_service.dart';
import '../constants/app_constants.dart';
import '../theme/app_theme.dart';
import '../constants/location_data.dart';
import 'item_detail_screen.dart';

class ItemFormScreen extends StatefulWidget {
  final bool isEditMode;
  final Item? existingItem;
  final String? initialName;

  const ItemFormScreen({
    super.key,
    required this.isEditMode,
    this.existingItem,
    this.initialName,
  });

  @override
  State<ItemFormScreen> createState() => _ItemFormScreenState();
}

class _ItemFormScreenState extends State<ItemFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseService _firebaseService = FirebaseService();

  // Form controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _tagsController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _customSubcategoryController =
      TextEditingController();

  // Form state - Localisation en cascade
  String? _selectedRoom;
  String? _selectedLocation;
  String? _selectedSubLocation;
  List<String> _availableLocations = [];
  List<String> _availableSubLocations = [];

  // Form state - Autres champs
  String? _selectedOwner;
  String? _selectedMainCategory;
  String? _selectedSubCategory;
  List<String> _availableSubCategories = [];
  bool _showCustomSubCategory = false;

  // Loading state
  bool _isLoading = false;
  bool _hasUnsavedChanges = false;

  @override
  void initState() {
    super.initState();
    _initializeForm();
  }

  void _initializeForm() {
    if (widget.isEditMode && widget.existingItem != null) {
      final item = widget.existingItem!;
      _nameController.text = item.name;
      _selectedRoom = item.room;
      _selectedLocation = item.location;
      _selectedSubLocation = item.subLocation;
      _selectedOwner = item.owner;
      _selectedMainCategory = item.mainCategory;
      _selectedSubCategory = item.subCategory;
      _tagsController.text = _tagsToString(item.tags);
      _descriptionController.text = item.description ?? '';

      // Charger les locations pour la pièce sélectionnée
      if (_selectedRoom != null) {
        _updateLocationsForRoom(_selectedRoom!);
        if (_selectedLocation != null) {
          _updateSubLocationsForLocation(_selectedRoom!, _selectedLocation!);
        }
      }

      // Charger les sous-catégories si catégorie principale sélectionnée
      if (_selectedMainCategory != null) {
        _updateSubCategoriesForMainCategory(_selectedMainCategory);
      }
    } else if (widget.initialName != null) {
      _nameController.text = widget.initialName!;
    }

    // Écouter les changements pour détecter les modifications non sauvées
    _nameController.addListener(_onFormChanged);
    _tagsController.addListener(_onFormChanged);
    _descriptionController.addListener(_onFormChanged);
    _customSubcategoryController.addListener(_onFormChanged);
  }

  void _onFormChanged() {
    if (!_hasUnsavedChanges) {
      setState(() {
        _hasUnsavedChanges = true;
      });
    }
  }

  // Méthodes cascade obligatoires selon les spécifications
  void _updateLocationsForRoom(String room) {
    setState(() {
      _availableLocations = LocationData.getLocationsForRoom(room);
      _selectedLocation = null;
      _selectedSubLocation = null;
      _availableSubLocations = [];
    });
  }

  void _updateSubLocationsForLocation(String room, String location) {
    setState(() {
      _availableSubLocations =
          LocationData.getSubLocationsForLocation(room, location);
      _selectedSubLocation = null;
    });
  }

  void _updateSubCategoriesForMainCategory(String? mainCategory) {
    if (mainCategory == null) {
      setState(() {
        _availableSubCategories = [];
        _selectedSubCategory = null;
        _showCustomSubCategory = false;
      });
      return;
    }

    setState(() {
      _availableSubCategories = AppConstants.SUBCATEGORIES[mainCategory] ?? [];
      _selectedSubCategory = null;
      _showCustomSubCategory = false;
    });
  }

  String _tagsToString(List<String>? tags) {
    return tags?.join(', ') ?? '';
  }

  List<String>? _parseTags(String tagsText) {
    if (tagsText.trim().isEmpty) return null;
    return tagsText
        .split(',')
        .map((tag) => tag.trim())
        .where((tag) => tag.isNotEmpty)
        .toList();
  }

  String? _validateTags(String? value) {
    if (value == null || value.trim().isEmpty) return null;

    final tags = _parseTags(value);
    if (tags == null) return null;

    if (tags.length > AppConstants.MAX_TAGS) {
      return AppConstants.ERROR_MAX_TAGS;
    }

    for (final tag in tags) {
      if (tag.length > AppConstants.MAX_TAG_LENGTH) {
        return AppConstants.ERROR_TAG_LENGTH;
      }
    }

    return null;
  }

  Future<void> _saveItem() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Validation sous-catégorie personnalisée
    if (_showCustomSubCategory) {
      if (_customSubcategoryController.text.trim().isEmpty) {
        _showSnackBar("La sous-catégorie personnalisée est obligatoire",
            isError: true);
        return;
      }
      if (_customSubcategoryController.text.length >
          AppConstants.MAX_SUBCATEGORY_LENGTH) {
        _showSnackBar(
            "La sous-catégorie ne peut pas dépasser ${AppConstants.MAX_SUBCATEGORY_LENGTH} caractères",
            isError: true);
        return;
      }
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Gérer sous-catégorie personnalisée
      String? finalSubCategory = _selectedSubCategory;
      if (_showCustomSubCategory && _selectedMainCategory != null) {
        final customSubCategory = _customSubcategoryController.text.trim();
        await _firebaseService.addSubcategory(
            _selectedMainCategory!, customSubCategory);
        finalSubCategory = customSubCategory;
      }

      if (widget.isEditMode && widget.existingItem != null) {
        // Modification
        final updatedItem = widget.existingItem!.copyWith(
          name: _nameController.text.trim(),
          room: _selectedRoom!,
          location: _selectedLocation,
          subLocation: _selectedSubLocation,
          owner: _selectedOwner,
          mainCategory: _selectedMainCategory,
          subCategory: finalSubCategory,
          tags: _parseTags(_tagsController.text),
          description: _descriptionController.text.trim().isEmpty
              ? null
              : _descriptionController.text.trim(),
        );

        await _firebaseService.updateItem(updatedItem);

        if (mounted) {
          _showSnackBar(AppConstants.SUCCESS_UPDATED, isError: false);
          Navigator.pop(context, updatedItem);
        }
      } else {
        // Création
        final newItem = Item.create(
          name: _nameController.text.trim(),
          room: _selectedRoom!,
          location: _selectedLocation,
          subLocation: _selectedSubLocation,
          owner: _selectedOwner,
          mainCategory: _selectedMainCategory,
          subCategory: finalSubCategory,
          tags: _parseTags(_tagsController.text),
          description: _descriptionController.text.trim().isEmpty
              ? null
              : _descriptionController.text.trim(),
        );

        final createdItem = await _firebaseService.createItem(newItem);

        if (mounted) {
          _showSnackBar(AppConstants.SUCCESS_SAVED, isError: false);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ItemDetailScreen(
                item: createdItem,
                isFromCreation: true,
              ),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        _showSnackBar(AppConstants.ERROR_SAVE_FAILED, isError: true);
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showSnackBar(String message, {required bool isError}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Future<bool> _onWillPop() async {
    if (_hasUnsavedChanges) {
      return await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Modifications non sauvées'),
              content: const Text(AppConstants.CONFIRM_UNSAVED_CHANGES),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Rester', style: TextStyle(fontFamily: 'DelaGothicOne', color: Colors.black, fontSize: 16)),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text('Quitter', style: TextStyle(fontFamily: 'DelaGothicOne', color: Colors.black, fontSize: 16)),
                ),
              ],
            ),
          ) ??
          false;
    }
    return true;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _tagsController.dispose();
    _descriptionController.dispose();
    _customSubcategoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: const Color(0xFFFFEF99), // Fond jaune très clair
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            widget.isEditMode ? 'MODIFIER OBJET' : 'NOUVEL OBJET',
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w900,
            ),
          ),
          iconTheme: const IconThemeData(
            color: Colors.black,
          ),
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Nom (obligatoire)
                TextFormField(
                  controller: _nameController,
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Nom de l\'objet *',
                    hintText: 'Ex: Télévision Samsung',
                  ),
                  maxLength: AppConstants.MAX_NAME_LENGTH,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return AppConstants.ERROR_NAME_REQUIRED;
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                // Section Localisation en cascade
                const Text(
                  'LOCALISATION *',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: Colors.black,
                  ),
                ),

                const SizedBox(height: 16),

                // Pièce (obligatoire)
                DropdownButtonFormField<String>(
                  value: _selectedRoom,
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                  ),
                  iconEnabledColor: Colors.black,
                  decoration: const InputDecoration(
                    labelText: 'Pièce *',
                    labelStyle: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                    ),
                    prefixIcon: Icon(Icons.room, color: Colors.black),
                  ),
                  dropdownColor: const Color(0xFFFFEF99),
                  items: LocationData.getRooms().map((room) {
                    return DropdownMenuItem(
                      value: room,
                      child: Text(
                        room,
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedRoom = value;
                      _hasUnsavedChanges = true;
                    });
                    if (value != null) {
                      _updateLocationsForRoom(value);
                    }
                  },
                  validator: (value) {
                    if (value == null) {
                      return AppConstants.ERROR_ROOM_REQUIRED;
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // Location (optionnel)
                DropdownButtonFormField<String>(
                  value: _selectedLocation,
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                  ),
                  iconEnabledColor: Colors.black,
                  decoration: const InputDecoration(
                    labelText: 'Meuble/Zone',
                    labelStyle: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                    ),
                    prefixIcon: Icon(Icons.chair, color: Colors.black),
                  ),
                  dropdownColor: const Color(0xFFFFEF99),
                  items: _availableLocations.map((location) {
                    return DropdownMenuItem(
                      value: location,
                      child: Text(
                        location,
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: _selectedRoom == null
                      ? null
                      : (value) {
                          setState(() {
                            _selectedLocation = value;
                            _hasUnsavedChanges = true;
                          });
                          if (value != null && _selectedRoom != null) {
                            _updateSubLocationsForLocation(
                                _selectedRoom!, value);
                          }
                        },
                ),

                const SizedBox(height: 16),

                // Sous-location (optionnel)
                DropdownButtonFormField<String>(
                  value: _selectedSubLocation,
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                  ),
                  iconEnabledColor: Colors.black,
                  decoration: const InputDecoration(
                    labelText: 'Emplacement précis',
                    labelStyle: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                    ),
                    prefixIcon: Icon(Icons.place, color: Colors.black),
                  ),
                  dropdownColor: const Color(0xFFFFEF99),
                  items: _availableSubLocations.map((subLocation) {
                    return DropdownMenuItem(
                      value: subLocation,
                      child: Text(
                        subLocation,
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: _selectedLocation == null
                      ? null
                      : (value) {
                          setState(() {
                            _selectedSubLocation = value;
                            _hasUnsavedChanges = true;
                          });
                        },
                ),

                const SizedBox(height: 20),

                // Propriétaire
                DropdownButtonFormField<String>(
                  value: _selectedOwner,
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                  ),
                  iconEnabledColor: Colors.black,
                  decoration: const InputDecoration(
                    labelText: 'Propriétaire',
                    labelStyle: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  dropdownColor: const Color(0xFFFFEF99),
                  items: [
                    const DropdownMenuItem<String>(
                      value: null,
                      child: Text(
                        'Aucun',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    ...AppConstants.OWNERS.map((owner) {
                      return DropdownMenuItem(
                        value: owner,
                        child: Text(
                          owner,
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      );
                    }),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedOwner = value;
                      _hasUnsavedChanges = true;
                    });
                  },
                ),

                const SizedBox(height: 20),

                // Catégorie principale
                DropdownButtonFormField<String>(
                  value: _selectedMainCategory,
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                  ),
                  iconEnabledColor: Colors.black,
                  decoration: const InputDecoration(
                    labelText: 'Catégorie',
                    labelStyle: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  dropdownColor: const Color(0xFFFFEF99),
                  items: [
                    const DropdownMenuItem<String>(
                      value: null,
                      child: Text(
                        'Aucune',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    ...AppConstants.MAIN_CATEGORIES.map((category) {
                      return DropdownMenuItem(
                        value: category,
                        child: Text(
                          category,
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      );
                    }),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedMainCategory = value;
                      _hasUnsavedChanges = true;
                    });
                    _updateSubCategoriesForMainCategory(value);
                  },
                ),

                const SizedBox(height: 20),

                // Sous-catégorie (conditionnelle)
                if (_selectedMainCategory != null) ...[
                  DropdownButtonFormField<String>(
                    value: _selectedSubCategory,
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                    ),
                    iconEnabledColor: Colors.black,
                    decoration: const InputDecoration(
                      labelText: 'Sous-catégorie',
                      labelStyle: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    dropdownColor: const Color(0xFFFFEF99),
                    items: [
                      const DropdownMenuItem<String>(
                        value: null,
                        child: Text(
                          'Aucune',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      ..._availableSubCategories.map((subCategory) {
                        return DropdownMenuItem(
                          value: subCategory,
                          child: Text(
                            subCategory,
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        );
                      }),
                      const DropdownMenuItem<String>(
                        value: 'Autre...',
                        child: Text(
                          'Autre...',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedSubCategory = value;
                        _showCustomSubCategory = (value == 'Autre...');
                        _hasUnsavedChanges = true;
                      });
                    },
                  ),

                  const SizedBox(height: 20),

                  // Champ personnalisé si "Autre..."
                  if (_showCustomSubCategory) ...[
                    TextFormField(
                      controller: _customSubcategoryController,
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                      ),
                      decoration: const InputDecoration(
                        labelText: 'Sous-catégorie personnalisée',
                      ),
                      maxLength: AppConstants.MAX_SUBCATEGORY_LENGTH,
                    ),
                    const SizedBox(height: 20),
                  ],
                ],

                // Tags
                TextFormField(
                  controller: _tagsController,
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Tags',
                    hintText: 'Séparés par des virgules (max 5)',
                  ),
                  maxLength: 150,
                  validator: _validateTags,
                ),

                const SizedBox(height: 20),

                // Description
                TextFormField(
                  controller: _descriptionController,
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Description',
                  ),
                  maxLines: 4,
                  maxLength: AppConstants.MAX_DESCRIPTION_LENGTH,
                ),

                const SizedBox(height: 30),

                // Boutons
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 56,
                        child: OutlinedButton(
                          onPressed: _isLoading
                              ? null
                              : () async {
                                  if (await _onWillPop()) {
                                    if (mounted) Navigator.pop(context);
                                  }
                                },
                          style: OutlinedButton.styleFrom(
                            side:
                                const BorderSide(color: Colors.black, width: 2),
                            backgroundColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'ANNULER',
                            style: TextStyle(fontFamily: 'DelaGothicOne', color: Colors.black, fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: SizedBox(
                        height: 56,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _saveItem,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: _isLoading
                              ? const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Color(0xFFFFEF99)),
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    const Text(
                                      'CHARGEMENT...',
                                      style: TextStyle(
                                        fontFamily: 'DelaGothicOne',
                                        color: Color(0xFFFFEF99),
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                )
                              : const Text(
                                  'ENREGISTRER',
                                  style: TextStyle(
                                    fontFamily: 'DelaGothicOne',
                                    color: Color(0xFFFFEF99),
                                    fontSize: 16,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
