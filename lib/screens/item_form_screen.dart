import 'package:flutter/material.dart';
import '../models/item.dart';
import '../services/firebase_service.dart';
import '../services/navigation_service.dart';
import '../theme/unified_theme.dart';
import '../constants/app_constants.dart';
import '../constants/location_data.dart';
import 'item_detail_screen.dart';
import 'home_screen.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_buttons.dart';
import '../widgets/custom_dropdown.dart';
import '../widgets/confirmation_dialog.dart';
import '../widgets/tag_input_field.dart';

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
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _customSubcategoryController =
      TextEditingController();

  // Tags state
  List<String> _tags = [];

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
      _tags = List.from(item.tags ?? []);
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

  void _onTagsChanged(List<String> tags) {
    setState(() {
      _tags = tags;
      _hasUnsavedChanges = true;
    });
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
          AppConstants.maxSubcategoryLength) {
        _showSnackBar(
            "La sous-catégorie ne peut pas dépasser ${AppConstants.maxSubcategoryLength} caractères",
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
          tags: _tags.isEmpty ? null : _tags,
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
          tags: _tags.isEmpty ? null : _tags,
          description: _descriptionController.text.trim().isEmpty
              ? null
              : _descriptionController.text.trim(),
        );

        final createdItem = await _firebaseService.createItem(newItem);

        if (mounted) {
          _showSnackBar(AppConstants.SUCCESS_SAVED, isError: false);
          NavigationService.pushReplacement(
            context,
            ItemDetailScreen(
              item: createdItem,
              isFromCreation: true,
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
      return await ConfirmationDialog.show(
        context: context,
        title: 'Modifications non sauvées',
        content: AppConstants.CONFIRM_UNSAVED_CHANGES,
        confirmText: 'QUITTER',
        cancelText: 'RESTER',
        confirmIconPath: 'assets/images/cross_icon.png',
        cancelIconPath: 'assets/images/check_icon.png',
      );
    }
    return true;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _customSubcategoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, dynamic result) async {
        if (didPop) return;
        final shouldPop = await _onWillPop();
        if (shouldPop && mounted) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        backgroundColor: UnifiedTheme.primaryYellow,
        body: Stack(
          children: [
            // Image de fond par-dessus le fond jaune
            Positioned.fill(
              child: Opacity(
                opacity: 0.2,
                child: Image.asset(
                  'assets/images/search_bg.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Contenu principal
            SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(vertical: 24.0),
                child: Column(
                  children: [
                    // Header avec retour et logo
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Image.asset(
                              'assets/images/back_icon.png',
                              width: 50,
                              height: 50,
                            ),
                          ),
                          const Spacer(),
                          GestureDetector(
                            onTap: () {
                              NavigationService.pushAndRemoveUntil(
                                context,
                                const HomeScreen(),
                              );
                            },
                            child: Image.asset(
                              'assets/images/home_icon.png',
                              width: 50,
                              height: 50,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),

                    // Titre formaté comme les autres pages
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Text(
                        widget.isEditMode
                            ? 'MODIFIER OBJET'
                            : 'RANGER UN OBJET',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontFamily: 'DelaGothicOne',
                          fontSize: 38,
                          color: Colors.black,
                          height: 1.1,
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    // Contenu du formulaire
                    Form(
                      key: _formKey,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Nom (obligatoire)
                            CustomTextField(
                              controller: _nameController,
                              labelText: 'Nom de l\'objet *',
                              hintText: 'Ex: Bottes de ville',
                              maxLength: AppConstants.maxNameLength,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return AppConstants.ERROR_NAME_REQUIRED;
                                }
                                return null;
                              },
                            ),

                            const SizedBox(height: 10),

                            // Catégorie principale
                            CustomDropdown<String>(
                              value: _selectedMainCategory,
                              labelText: 'Catégorie',
                              isRequired: true,
                              items:
                                  AppConstants.MAIN_CATEGORIES.map((category) {
                                return DropdownMenuItem(
                                  value: category,
                                  child: Text(
                                    category,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedMainCategory = value;
                                  _hasUnsavedChanges = true;
                                });
                                _updateSubCategoriesForMainCategory(value);
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Veuillez sélectionner une catégorie';
                                }
                                return null;
                              },
                            ),

                            const SizedBox(height: 20),

                            // Sous-catégorie (conditionnelle)
                            if (_selectedMainCategory != null) ...[
                              CustomDropdown<String>(
                                value: _selectedSubCategory,
                                labelText: 'Sous-catégorie',
                                suffixIcon: _selectedSubCategory != null
                                    ? IconButton(
                                        icon: Image.asset(
                                          'assets/images/cross_icon.png',
                                          width: 20,
                                          height: 20,
                                          color: Colors.black,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _selectedSubCategory = null;
                                            _showCustomSubCategory = false;
                                            _hasUnsavedChanges = true;
                                          });
                                        },
                                      )
                                    : null,
                                items: [
                                  ..._availableSubCategories.map((subCategory) {
                                    return DropdownMenuItem(
                                      value: subCategory,
                                      child: Text(
                                        subCategory,
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
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
                                        fontWeight: FontWeight.w500,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                ],
                                onChanged: (value) {
                                  setState(() {
                                    _selectedSubCategory = value;
                                    _showCustomSubCategory =
                                        (value == 'Autre...');
                                    _hasUnsavedChanges = true;
                                  });
                                },
                              ),

                              const SizedBox(height: 20),

                              // Champ personnalisé si "Autre..."
                              if (_showCustomSubCategory) ...[
                                CustomTextField(
                                  controller: _customSubcategoryController,
                                  labelText: 'Sous-catégorie personnalisée',
                                  maxLength:
                                      AppConstants.maxSubcategoryLength,
                                ),
                                const SizedBox(height: 20),
                              ],
                            ],

                            const SizedBox(height: 20),

                            // Section Localisation en cascade
                            const Text(
                              'LOCALISATION *',
                              style: TextStyle(
                                fontSize: 18,
                                fontFamily: 'DelaGothicOne',
                                color: Colors.black,
                              ),
                            ),

                            const SizedBox(height: 16),

                            // Pièce (obligatoire)
                            CustomIconDropdown<String>(
                              value: _selectedRoom,
                              labelText: 'Pièce',
                              isRequired: true,
                              iconAsset: 'assets/images/room_icon.png',
                              items: LocationData.getRooms().map((room) {
                                return DropdownMenuItem(
                                  value: room,
                                  child: Text(
                                    room,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
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

                            // Location (conditionnelle)
                            if (_selectedRoom != null) ...[
                              const SizedBox(height: 16),

                              CustomIconDropdown<String>(
                                value: _selectedLocation,
                                labelText: 'Meuble/Zone',
                                iconAsset: 'assets/images/shelf_icon.png',
                                isExpanded:
                                    true, // Utilise toute la largeur disponible
                                fontSize:
                                    16, // Légèrement réduit pour éviter l'overflow
                                suffixIcon: _selectedLocation != null
                                    ? IconButton(
                                        icon: Image.asset(
                                          'assets/images/cross_icon.png',
                                          width: 20,
                                          height: 20,
                                          color: Colors.black,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _selectedLocation = null;
                                            _selectedSubLocation = null;
                                            _hasUnsavedChanges = true;
                                          });
                                        },
                                      )
                                    : null,
                                items: _availableLocations.map((location) {
                                  return DropdownMenuItem(
                                    value: location,
                                    child: Text(
                                      location,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _selectedLocation = value;
                                    _hasUnsavedChanges = true;
                                  });
                                  if (value != null && _selectedRoom != null) {
                                    _updateSubLocationsForLocation(
                                        _selectedRoom!, value);
                                  } else {
                                    // Réinitialiser les sous-locations si aucune location n'est sélectionnée
                                    setState(() {
                                      _selectedSubLocation = null;
                                      _availableSubLocations = [];
                                    });
                                  }
                                },
                              ),

                              // Sous-location (conditionnelle - seulement si des sous-locations existent)
                              if (_selectedLocation != null &&
                                  _selectedRoom != null &&
                                  LocationData.hasSubLocations(
                                      _selectedRoom!, _selectedLocation!)) ...[
                                const SizedBox(height: 16),
                                CustomIconDropdown<String>(
                                  value: _selectedSubLocation,
                                  labelText: 'Emplacement précis',
                                  iconAsset: 'assets/images/spot_icon.png',
                                  suffixIcon: _selectedSubLocation != null
                                      ? IconButton(
                                          icon: Image.asset(
                                            'assets/images/cross_icon.png',
                                            width: 20,
                                            height: 20,
                                            color: Colors.black,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              _selectedSubLocation = null;
                                              _hasUnsavedChanges = true;
                                            });
                                          },
                                        )
                                      : null,
                                  items:
                                      _availableSubLocations.map((subLocation) {
                                    return DropdownMenuItem(
                                      value: subLocation,
                                      child: Text(
                                        subLocation,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedSubLocation = value;
                                      _hasUnsavedChanges = true;
                                    });
                                  },
                                ),
                              ],
                            ],

                            const SizedBox(height: 40),
                            const Text(
                              'DÉTAILS',
                              style: TextStyle(
                                fontSize: 18,
                                fontFamily: 'DelaGothicOne',
                                color: Colors.black,
                              ),
                            ),

                            const SizedBox(height: 16),
                            // Propriétaire
                            CustomDropdown<String>(
                              value: _selectedOwner,
                              labelText: 'Propriétaire',
                              suffixIcon: _selectedOwner != null
                                  ? IconButton(
                                      icon: Image.asset(
                                        'assets/images/cross_icon.png',
                                        width: 20,
                                        height: 20,
                                        color: Colors.black,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _selectedOwner = null;
                                          _hasUnsavedChanges = true;
                                        });
                                      },
                                    )
                                  : null,
                              items: AppConstants.owners.map((owner) {
                                return DropdownMenuItem(
                                  value: owner,
                                  child: Text(
                                    owner,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedOwner = value;
                                  _hasUnsavedChanges = true;
                                });
                              },
                            ),
                            const SizedBox(height: 20),
                            // Tags
                            TagInputField(
                              initialTags: _tags,
                              labelText: 'Tags',
                              maxTags: AppConstants.maxTags,
                              maxTagLength: AppConstants.maxTagLength,
                              onTagsChanged: _onTagsChanged,
                            ),

                            const SizedBox(height: 20),

                            // Description
                            CustomTextField(
                              controller: _descriptionController,
                              labelText: 'Description',
                              maxLines: 4,
                              maxLength: AppConstants.maxDescriptionLength,
                            ),

                            const SizedBox(height: 30),

                            // Boutons
                            PrimaryButton(
                              onPressed: _isLoading ? null : _saveItem,
                              text: _isLoading
                                  ? 'ENREGISTREMENT...'
                                  : 'ENREGISTRER',
                              iconPath: _isLoading
                                  ? null
                                  : 'assets/images/check_icon.png',
                            ),

                            const SizedBox(height: 10),

                            SecondaryButton(
                              onPressed: _isLoading
                                  ? null
                                  : () async {
                                      final shouldPop = await _onWillPop();
                                      if (shouldPop && mounted) {
                                        Navigator.pop(context);
                                      }
                                    },
                              text: 'ANNULER',
                              iconPath: 'assets/images/cross_icon.png',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
