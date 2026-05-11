import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:restaurant_flutter_app/common/widgets/snack_bar_widget.dart';
import 'package:restaurant_flutter_app/models/tax_model.dart';
import 'package:restaurant_flutter_app/screens/home_bottom_navbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/cart_model.dart';
import '../models/categories_and_food.dart';
import '../models/complete_orders_model.dart';
import '../models/pending_orders_model.dart';
import '../models/table_model.dart';
import '../util/app_constants.dart';
// import '../models/restaurant_table_model.dart';

class TakeOrderProvider with ChangeNotifier {
  double initialStep = 0.1;

  void stepStatusChange(double value, {bool isUpdate = true}) {
    initialStep = value;
    if (isUpdate) {
      notifyListeners();
    }
  }

  CategoryAndFoodModel? categoryAndFoodModel;
  List<Food>? _filteredFoods;
  int? _selectedCategoryId = -1;

  int? get selectedCategoryId => _selectedCategoryId;
  List<Food> get filteredFoods => _filteredFoods ?? [];
  List<Category>? get categories => categoryAndFoodModel?.categories;

  List<CartItem> _selectedProducts = [];
  List<CartItem> get selectedProducts => _selectedProducts;

  int _quantity = 0;
  int get quantity => _quantity;

  void incrementQuantity() {
    _quantity++;
    notifyListeners();
  }

  void decrementQuantity() {
    if (_quantity > 0) {
      _quantity--;
      notifyListeners();
    }
  }

  void setQuantity(int qty, Food? food) {
    _quantity = qty;
    if (food != null && _quantity > 0) {
      addToCart(food, _quantity);
    }
    notifyListeners();
  }

  void filterByCategory(int categoryId) {
    _selectedCategoryId = categoryId;
    if (_selectedCategoryId == -1) {
      _filteredFoods = categoryAndFoodModel?.categories
          .expand((category) => category.foods)
          .toList();
    } else {
      _filteredFoods = categoryAndFoodModel?.categories
          .firstWhere((category) => category.id == categoryId)
          .foods;
    }
    notifyListeners();
  }

  Future<void> getFoods(context) async {
    try {
      final url = Uri.parse('${AppConstants.baseUrl}/menu');
      final headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json'
      };

      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        categoryAndFoodModel = categoryAndFoodModelFromJson(response.body);
        _filteredFoods = categoryAndFoodModel?.categories
            .expand((category) => category.foods)
            .toList();
        notifyListeners();
      } else {
        throw Exception('Failed to get Categories and foods: ${response.statusCode}');
      }
    } catch (error) {
      rethrow;
    }
  }

  List<List<bool>> selectedVariations = [];


  void initializeSelectedVariations(Food food) {
    // Reset and initialize variations for the current food
    selectedVariations = [];

    if (food.hasVariations && food.variations != null) {
      // Create a list for each variation with a single boolean (since each variation is a single option)
      selectedVariations = List.generate(food.variations!.length, (_) => [false]);
    }
  }

  void selectVariationOption(int variationIndex, int optionIndex, String type) {
    if (type == "single") {
      // For single selection, unselect all other variations first
      for (int i = 0; i < selectedVariations.length; i++) {
        for (int j = 0; j < selectedVariations[i].length; j++) {
          selectedVariations[i][j] = false;
        }
      }
      // Select the current variation
      selectedVariations[variationIndex][optionIndex] = true;
    } else {
      // For multiple selection, just toggle the current option
      selectedVariations[variationIndex][optionIndex] =
      !selectedVariations[variationIndex][optionIndex];
    }
    notifyListeners();
  }


  double calculateBasePrice(Food food) {
    // If food has variations and one is selected, use the variation price
    if (food.hasVariations && food.variations != null) {
      for (int i = 0; i < food.variations!.length; i++) {
        if (selectedVariations.length > i &&
            selectedVariations[i].isNotEmpty &&
            selectedVariations[i][0]) {
          final variation = food.variations![i];
          final discountPrice = variation.discountPrice;
          // Use variation's discount price if available, otherwise regular price
          return (discountPrice != null && discountPrice > 0)
              ? discountPrice.toDouble()
              : variation.price.toDouble();
        }
      }
    }
    // Otherwise use the food's base price
    return food.price.toDouble();
  }


  double calculateDiscountedPrice(Food food) {
    // First check if we should use a variation price
    final basePrice = calculateBasePrice(food);

    // Only apply food-level discount if no variation is selected
    if (!food.hasVariations && food.discountPrice != null && food.discountPrice! > 0) {
      return food.discountPrice!.toDouble();
    }
    return basePrice;
  }

  double calculateTotalPrice(Food food, int quantity) {
    return calculateDiscountedPrice(food) * quantity;
  }

  void addToCart(Food food, int quantity) {
    if (quantity <= 0) {
      removeFromCart(food.id);
      return;
    }

    final existingIndex = _selectedProducts.indexWhere((item) => item.foodId == food.id);

    final newItem = CartItem(
      foodId: food.id,
      food: food,
      quantity: quantity,
      selectedVariations: List<List<bool>>.from(
        selectedVariations.map((e) => List<bool>.from(e)),
      ),
      totalPrice: calculateTotalPrice(food, quantity),
    );

    if (existingIndex != -1) {
      _selectedProducts[existingIndex] = newItem;
    } else {
      _selectedProducts.add(newItem);
    }
    notifyListeners();
  }

  void removeFromCart(int foodId) {
    _selectedProducts.removeWhere((item) => item.foodId == foodId);
    notifyListeners();
  }

  // void editCartItem(Food food) {
  //   try {
  //     final existingItem = _selectedProducts.firstWhere(
  //           (item) => item.foodId == food.id,
  //     );
  //     _quantity = existingItem.quantity;
  //     selectedVariations = List<List<bool>>.from(
  //       existingItem.selectedVariations.map((e) => List<bool>.from(e)),
  //     );
  //     notifyListeners();
  //   } catch (e) {
  //     initializeSelectedVariations(food);
  //   }
  // }

  void editCartItem(Food food) {
    try {
      final existingItem = _selectedProducts.firstWhere((item) => item.foodId == food.id);
      _quantity = existingItem.quantity;
      selectedVariations = List<List<bool>>.from(
        existingItem.selectedVariations.map((e) => List<bool>.from(e)),
      );
      notifyListeners();
    } catch (e) {
      _quantity = 1; // Reset to default quantity if not found
      initializeSelectedVariations(food);
    }
  }

  double get cartTotal {
    return _selectedProducts.fold(0.0, (sum, item) => sum + item.totalPrice);
  }

  bool isIndoor = true;
  void toggleIndoorOutdoor() {
    isIndoor = !isIndoor;
    notifyListeners();
  }

  List<RestaurantTableModel> tables = [];
  int? selectedTableId;
  bool isLoadingTables = false;

  Future<void> getRestaurantTable() async {
    try {
      isLoadingTables = true;
      notifyListeners();

      SharedPreferences pref = await SharedPreferences.getInstance();
      var userToken = pref.getString('token');
      final url = Uri.parse('${AppConstants.baseUrl}/restaurant-tables');
      final headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $userToken'
      };

      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        tables = restaurantTableModelFromJson(response.body);
      } else {
        throw Exception('Failed to get Restaurant Tables: ${response.statusCode}');
      }
    } catch (error) {
      debugPrint('Error loading tables: $error');
      tables = []; // Set to empty list on error
    } finally {
      isLoadingTables = false;
      notifyListeners();
    }
  }

  TaxModel? taxModel;

  Future<void> getTax() async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      var userToken = pref.getString('token');
      final url = Uri.parse('${AppConstants.baseUrl}/taxes');
      final headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $userToken'
      };

      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        taxModel = taxModelFromJson(response.body);
        notifyListeners();
      } else {
        throw Exception('Failed to get taxes: ${response.statusCode}');
      }
    } catch (error) {
      rethrow;
    }
  }

  void selectTable(int tableId) {
    selectedTableId = tableId;
    notifyListeners();
  }


  // Add these methods to your TakeOrderProvider class

  double get subtotal {
    return _selectedProducts.fold(0.0, (sum, item) => sum + item.totalPrice);
  }

  double get taxAmount {
    if (taxModel == null || taxModel!.type == null || taxModel!.value == null) return 0.0;

    if (taxModel!.type == 'percentage') {
      return subtotal * (double.parse(taxModel!.value!) / 100);
    } else {
      return double.parse(taxModel!.value!);
    }
  }

  double get totalWithTax {
    return subtotal + taxAmount;
  }


  Future<void> submitOrder(BuildContext context, String? customerName, String? customerPhone, String? customerVehicle) async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      var userToken = pref.getString('token');
      var userId = pref.getInt('id');

      // Prepare items list
      List<Map<String, dynamic>> items = [];
      for (var item in _selectedProducts) {
        if (item.food.hasVariations && item.food.variations != null) {
          bool variationSelected = false;
          int? variationId;

          for (int i = 0; i < item.selectedVariations.length; i++) {
            if (item.selectedVariations[i].isNotEmpty && item.selectedVariations[i][0]) {
              variationId = item.food.variations![i].id;
              variationSelected = true;
              break;
            }
          }

          if (!variationSelected) {
            throw Exception('Please select a variation for ${item.food.name}');
          }

          items.add({
            'food_id': item.food.id,
            'variation_id': variationId!,
            'quantity': item.quantity,
          });
        } else {
          items.add({
            'food_id': item.food.id,
            'quantity': item.quantity,
          });
        }
      }

      Map<String, dynamic> requestBody = {
        'user_id': userId,
        'subtotal': subtotal.toStringAsFixed(2),
        'tax_amount': taxAmount.toStringAsFixed(2),
        'total': totalWithTax.toStringAsFixed(2),
        'items': items,
      };

      debugPrint('=== Order Submission Debug ===');
      debugPrint('Subtotal: ${subtotal.toStringAsFixed(2)}');
      debugPrint('Tax Amount: ${taxAmount.toStringAsFixed(2)}');
      debugPrint('Total: ${totalWithTax.toStringAsFixed(2)}');
      debugPrint('Items Count: ${items.length}');

      if (customerName != null && customerName.isNotEmpty) {
        requestBody['customer_name'] = customerName;
      }

      if (customerPhone != null && customerPhone.isNotEmpty) {
        requestBody['customer_phone'] = customerPhone;
      }

      if (isIndoor) {
        requestBody['table_id'] = selectedTableId;
      } else {
        if (customerVehicle != null && customerVehicle.isNotEmpty) {
          requestBody['vehicle_number'] = customerVehicle;
        }
      }

      final url = Uri.parse('${AppConstants.baseUrl}/orders-store');
      final headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $userToken'
      };

      debugPrint('API URL: $url');
      debugPrint('Request Body: ${jsonEncode(requestBody)}');

      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(requestBody),
      );

      debugPrint('Response Status Code: ${response.statusCode}');
      debugPrint('Response Body: ${response.body}');

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 201) {
        debugPrint('✅ Order placed successfully');
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => HomeBottomNavbar(pageIndex: 0)), (route)=> false);
        clearAllData();
        showCustomSnackBar(context, "Order Placed Successfully ", isError: false);
      } else {
        // Handle different error response formats
        String errorMessage = responseData['message'] ?? 'Failed to submit order';
        if (responseData['errors'] != null) {
          errorMessage = responseData['errors'].values.first.first ?? errorMessage;
        }
        debugPrint('❌ Order submission failed: $errorMessage');
        throw Exception(errorMessage);
      }
    } catch (error, stackTrace) {
      debugPrint('=== Order Submission Error ===');
      debugPrint('Error: $error');
      debugPrint('Stack Trace: $stackTrace');
      rethrow;
    }
  }

  void clearAllData() {
    _selectedProducts.clear();
    selectedTableId = null;
    isIndoor = true;
    initialStep = 0.1;
    taxModel = null;
    _quantity = 0;
    selectedVariations.clear();
    notifyListeners();
  }


  List<Order> pendingOrdersData = [];
  PendingOrdersModel? pendingOrdersModel;
  int pageIndex = 1;
  int totalPages = 1;
  bool? showMore;
  bool? showingMore;

  Future<bool> getPendingOrders(BuildContext context, {bool isRefresh = false}) async {
    if (isRefresh) {
      pageIndex = 1;
    } else {
      if (pageIndex > totalPages) {
        return false;
      }
    }

    final SharedPreferences sharePref = await SharedPreferences.getInstance();
    String? userToken = sharePref.getString('token');
    int? user_id = sharePref.getInt('id');

    debugPrint('=== Pending Orders API Debug ===');
    debugPrint('User ID: $user_id');
    debugPrint('User Token: ${userToken?.substring(0, 20)}...');
    debugPrint('Page Index: $pageIndex');
    debugPrint('Is Refresh: $isRefresh');

    try {
      final url = Uri.parse("${AppConstants.baseUrl}/orders/$user_id/pending");
      debugPrint('API URL: $url');

       var response = await http.get(
         url,
         headers: <String, String>{
           'Content-Type': 'application/json',
           'Accept': 'application/json',
           'Authorization': 'Bearer $userToken'
         },
       );

      debugPrint('Response Status Code: ${response.statusCode}');
      debugPrint('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        debugPrint('Pending Orders API is working');
        pendingOrdersModel = pendingOrdersModelFromJson(response.body);

        if (isRefresh) {
          pendingOrdersData = pendingOrdersModel!.orders;
        } else {
          pendingOrdersData.addAll(pendingOrdersModel!.orders);
        }

        pageIndex++;
        totalPages = pendingOrdersModel!.pagination.lastPage;

        // Update showMore based on whether we've loaded all orders
        showMore = pendingOrdersModel!.pagination.total > pendingOrdersData.length;
        showingMore = false;

        debugPrint('Total Orders Loaded: ${pendingOrdersData.length}');
        debugPrint('Total Available: ${pendingOrdersModel!.pagination.total}');
        notifyListeners();
        return true;
      } else {
        debugPrint('Pending Orders API error: ${response.statusCode} ${response.body}');
        return false;
      }
    } catch (e, stackTrace) {
      debugPrint('Error in getPendingOrders: $e');
      debugPrint('Stack Trace: $stackTrace');
      return false;
    }
  }


  List<OrderComplete> completeOrdersData = [];
  CompleteOrdersModel? completeOrdersModel;
  int completePageIndex = 1;
  int completeTotalPages = 1;
  bool? completeShowMore;
  bool? completeShowingMore;

  Future<bool> getCompleteOrders(BuildContext context, {bool isRefreshComplete = false}) async {
    if (isRefreshComplete) {
      completePageIndex = 1;
    } else {
      if (completePageIndex > completeTotalPages) {
        return false;
      }
    }

    final SharedPreferences sharePref = await SharedPreferences.getInstance();
    String? userToken = sharePref.getString('token');
    int? user_id = sharePref.getInt('id');

    debugPrint('=== Complete Orders API Debug ===');
    debugPrint('User ID: $user_id');
    debugPrint('User Token: ${userToken?.substring(0, 20)}...');
    debugPrint('Page Index: $completePageIndex');
    debugPrint('Is Refresh: $isRefreshComplete');

    try {
      final url = Uri.parse("${AppConstants.baseUrl}/orders/$user_id/complete");
      debugPrint('API URL: $url');

       var response = await http.get(
         url,
         headers: <String, String>{
           'Content-Type': 'application/json',
           'Accept': 'application/json',
           'Authorization': 'Bearer $userToken'
         },
       );

      debugPrint('Response Status Code: ${response.statusCode}');
      debugPrint('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        debugPrint('Complete Orders API is working');
        final responseData = json.decode(response.body);

        // Debug print to check the actual response structure
        debugPrint('API Response: $responseData');

        completeOrdersModel = completeOrdersModelFromJson(response.body);

        if (isRefreshComplete) {
          completeOrdersData = completeOrdersModel!.orders ?? [];
        } else {
          completeOrdersData.addAll(completeOrdersModel!.orders ?? []);
        }

        completePageIndex++;
        completeTotalPages = completeOrdersModel!.pagination.lastPage;

        completeShowMore = completeOrdersModel!.pagination.total > completeOrdersData.length;
        completeShowingMore = false;

        debugPrint('Total Complete Orders Loaded: ${completeOrdersData.length}');
        debugPrint('Total Available: ${completeOrdersModel!.pagination.total}');
        notifyListeners();
        return true;
      } else {
        debugPrint('Complete Orders API error: ${response.statusCode} ${response.body}');
        return false;
      }
    } catch (e, stackTrace) {
      debugPrint('Error in getCompleteOrders: $e');
      debugPrint('Stack Trace: $stackTrace');
      return false;
    }
  }


}