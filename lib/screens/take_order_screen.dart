import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';
import 'package:provider/provider.dart';

import '../../models/cart_model.dart';
import '../../models/categories_and_food.dart';
import '../../providers/take_order_provider.dart';
import '../../util/dimensions.dart';
import '../../util/styles.dart';
import '../common/widgets/confirmation_dialog_widget.dart';
import '../common/widgets/custom_app_bar_widget.dart';
import '../common/widgets/custom_button_widget.dart';
import '../common/widgets/custom_image_widget.dart';
import '../common/widgets/custom_text_field_widget.dart';
import '../common/widgets/dotted_divider.dart';
import '../common/widgets/footer_view_widget.dart';
import '../common/widgets/product_dialog_widget.dart';
import '../common/widgets/snack_bar_widget.dart';
import '../common/widgets/validate_check.dart';
import '../screens/home_bottom_navbar.dart';

class TakeOrderScreen extends StatefulWidget {
  const TakeOrderScreen({super.key});

  @override
  State<TakeOrderScreen> createState() => _TakeOrderScreenState();
}

class _TakeOrderScreenState extends State<TakeOrderScreen> {
  final ScrollController _scrollController = ScrollController();
  final JustTheController tooltipController = JustTheController();
  final TextEditingController customerNameController = TextEditingController();
  final TextEditingController customerVehicleController = TextEditingController();
  final TextEditingController customerPhoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TakeOrderProvider>().getFoods(context);
      context.read<TakeOrderProvider>().getRestaurantTable();
      context.read<TakeOrderProvider>().getTax();
    });
  }

  Future<void> _showBackPressedDialogue(BuildContext context, String title) async {
    showDialog(
      context: context,
      useSafeArea: false,
      builder: (BuildContext context) {
        return ConfirmationDialogWidget(
          title: title,
          icon: "assets/images/support.png",
          description: "Are you sure to go back?",
          onYesPressed: () {
            print("go back function");
            context.read<TakeOrderProvider>().clearAllData();
            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => HomeBottomNavbar(pageIndex: 0)), (route) => false);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        final provider = context.read<TakeOrderProvider>();

        if (provider.initialStep == 1.0) {
          // Move from 1.0 to 0.5 (confirmation back to order details)
          provider.stepStatusChange(0.5);
        } else if (provider.initialStep == 0.5) {
          // Move from 0.5 to 0.1 (order details back to product selection)
          provider.stepStatusChange(0.1);
        } else {
          // Show confirmation dialog if at 0.1
          await _showBackPressedDialogue(context, "You didn't Take Order Yet");
        }
      },
      child: Scaffold(
        appBar: CustomAppBarWidget(
          title: "Take Order",
          onBackPressed: () async {
            final driverFormProvider = context.read<TakeOrderProvider>();

            if (driverFormProvider.initialStep == 1.0) {
              // Move from 0.9 to 0.6
              driverFormProvider.stepStatusChange(0.5);
            } else if (driverFormProvider.initialStep == 0.5) {
              // Move from 0.6 to 0.1
              driverFormProvider.stepStatusChange(0.1);
            } else {
              // Show confirmation dialog if at 0.1
              await _showBackPressedDialogue(context, "You didn't Take Order Yet");
            }
          },
        ),
        body: Consumer<TakeOrderProvider>(
          builder: (context, takeOrderProvider, child) {
            if (takeOrderProvider.categoryAndFoodModel == null) {
              return const Center(child: CircularProgressIndicator());
            }
            return SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge, vertical: Dimensions.paddingSizeSmall),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.watch<TakeOrderProvider>().initialStep == 0.1
                              ? 'Provide order details to proceed next'
                              : context.watch<TakeOrderProvider>().initialStep == 0.5
                              ? 'Provide customer table to confirm'
                              : 'Check the detail & confirm',
                          style: robotoRegular(context).copyWith(fontSize: Dimensions.fontSizeSmall(context), color: Theme.of(context).hintColor),
                        ),
                        const SizedBox(height: Dimensions.paddingSizeSmall),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: context.watch<TakeOrderProvider>().initialStep == 0.1 ||
                                    context.watch<TakeOrderProvider>().initialStep == 0.5 ||
                                    context.watch<TakeOrderProvider>().initialStep == 1.0
                                    ? Theme.of(context).primaryColor.withValues(alpha: 0.8)
                                    : Theme.of(context).disabledColor,
                              ),
                              child: Icon(
                                Icons.check,
                                color: Theme.of(context).cardColor,
                                size: 12,
                              ),
                            ),
                            SizedBox(
                              width: 130,
                              child: DottedDivider(
                                color: context.watch<TakeOrderProvider>().initialStep == 0.1 ||
                                    context.watch<TakeOrderProvider>().initialStep == 0.5 ||
                                    context.watch<TakeOrderProvider>().initialStep == 1.0
                                    ? Theme.of(context).primaryColor.withValues(alpha: 0.8)
                                    : Theme.of(context).disabledColor,
                              ),
                            ),
                            Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: context.watch<TakeOrderProvider>().initialStep == 0.5 || context.watch<TakeOrderProvider>().initialStep == 1.0
                                    ? Theme.of(context).primaryColor.withValues(alpha: 0.8)
                                    : Theme.of(context).disabledColor,
                              ),
                              child:
                              (context.watch<TakeOrderProvider>().initialStep == 0.5) || (context.watch<TakeOrderProvider>().initialStep == 1.0)
                                  ? Icon(
                                Icons.check,
                                color: Theme.of(context).cardColor,
                                size: 12,
                              )
                                  : SizedBox.shrink(),
                            ),
                            SizedBox(
                              width: 130,
                              child: DottedDivider(
                                color: context.watch<TakeOrderProvider>().initialStep == 0.5
                                    ? Theme.of(context).primaryColor
                                    : Theme.of(context).disabledColor,
                              ),
                            ),
                            Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: context.watch<TakeOrderProvider>().initialStep == 1.0
                                    ? Theme.of(context).primaryColor
                                    : Theme.of(context).disabledColor,
                              ),
                              child: (context.watch<TakeOrderProvider>().initialStep == 1.0)
                                  ? Icon(
                                Icons.check,
                                color: Theme.of(context).cardColor,
                                size: 12,
                              )
                                  : SizedBox.shrink(),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      child: FooterViewWidget(
                        child: Column(
                          children: [
                            if (takeOrderProvider.initialStep == 0.1) _buildProductSelection(context),
                            if (takeOrderProvider.initialStep == 0.5) _buildOrderDetails(context),
                            if (takeOrderProvider.initialStep == 1.0) _buildConfirmation(context),
                          ],
                        ),
                      ),
                    ),
                  ),
                  _buildBottomButton(context),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildProductSelection(BuildContext context) {
    final provider = Provider.of<TakeOrderProvider>(context);
    final size = MediaQuery.of(context).size;

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
        boxShadow: [BoxShadow(color: Colors.grey.withValues(alpha:0.1), blurRadius: 10)],
      ),
      child: Padding(
        padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Categories", style: robotoBold(context)),
            const SizedBox(height: Dimensions.paddingSizeSmall),
            SizedBox(
              height: 40,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  final category = index == 0
                      ? Category(id: -1, name: "All", foods: [])
                      : provider.categories![index - 1];
                  final isSelected = provider.selectedCategoryId == category.id;
                  return InkWell(
                    onTap: () => provider.filterByCategory(category.id),
                    child: Container(
                      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                        color: isSelected ? Theme.of(context).primaryColor : Colors.transparent,
                        border: Border.all(color: isSelected ? Theme.of(context).primaryColor : Theme.of(context).hintColor),
                      ),
                      child: Text(
                        category.name,
                        style: robotoRegular(context).copyWith(
                          color: isSelected ? Colors.white : Theme.of(context).textTheme.bodyMedium!.color,
                        ),
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) => const SizedBox(width: Dimensions.paddingSizeSmall),
                itemCount: (provider.categories?.length ?? 0) + 1,
              ),
            ),
            const SizedBox(height: Dimensions.paddingSizeSmall),
            const Divider(),
            const SizedBox(height: Dimensions.paddingSizeSmall),
            Text(
              provider.selectedCategoryId == -1
                  ? "All Categories"
                  : provider.categories!.firstWhere((c) => c.id == provider.selectedCategoryId).name,
              style: robotoBold(context),
            ),
            const SizedBox(height: Dimensions.paddingSizeSmall),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: provider.filteredFoods.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: Dimensions.paddingSizeSmall,
                crossAxisSpacing: Dimensions.paddingSizeSmall,
                childAspectRatio: (size.width / 2) / 200,
              ),
              itemBuilder: (context, index) {
                final food = provider.filteredFoods[index];
                final cartItem = provider.selectedProducts.firstWhere(
                      (item) => item.foodId == food.id,
                  orElse: () => CartItem(
                      foodId: -1,
                      food: food,
                      quantity: 0,
                      selectedVariations: [],
                      totalPrice: 0
                  ),
                );
                final isSelected = cartItem.foodId != -1;

                return InkWell(
                  onTap: () {
                    provider.editCartItem(food); // Load existing selections
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (context) => ProductBottomSheetWidget(food: food),
                    );
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        color: isSelected ? Theme.of(context).primaryColor : Colors.transparent,
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                    ),
                    child: Stack(
                      children: [
                        Column(
                          children: [
                            SizedBox(
                              width: double.infinity,
                              height: 120,
                              child: ClipRRect(
                                borderRadius: const BorderRadius.vertical(top: Radius.circular(Dimensions.radiusDefault)),
                                child: CustomImageWidget(
                                  image: food.image,
                                  placeholder: "assets/images/placeholder.png",
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                              child: Text(food.name, style: robotoBold(context)),
                            ),
                          ],
                        ),
                        if (isSelected)
                          Positioned(
                            top: 8,
                            right: 8,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                cartItem.quantity.toString(),
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderDetails(BuildContext context) {
    final provider = Provider.of<TakeOrderProvider>(context);
    return Container(
      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
        boxShadow: [BoxShadow(color: Colors.grey.withValues(alpha:0.1), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           Padding(
            padding: EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
            child: Text("My Order", style: robotoBold(context)),
          ),
          const SizedBox(height: Dimensions.paddingSizeSmall),
          if (provider.selectedProducts.isEmpty)
            const Text("No products selected.")
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: provider.selectedProducts.length,
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final item = provider.selectedProducts[index];

                // Get the selected variation for this item
                String? selectedVariationText = _getSelectedVariationText(item);

                return Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [BoxShadow(color: Colors.grey.withAlpha(20), blurRadius: 5)],
                  ),
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: SizedBox(
                        width: 60,
                        height: 60,
                        child: CustomImageWidget(
                          image: item.food.image,
                          placeholder: "assets/images/placeholder.png",
                        ),
                      ),
                    ),
                    title: Text(item.food.name),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Qty: ${item.quantity}"),
                        if (selectedVariationText != null)
                          Text(selectedVariationText),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "\$${item.totalPrice.toStringAsFixed(2)}",
                          style: robotoMedium(context),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline),
                          onPressed: () {
                            provider.removeFromCart(item.food.id);
                            if (provider.selectedProducts.isEmpty) {
                              provider.stepStatusChange(0.1);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          const SizedBox(height: Dimensions.paddingSizeSmall),
          const Divider(),
          const SizedBox(height: Dimensions.paddingSizeSmall),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Is order indoor?", style: robotoBold(context)),
              Switch(
                value: provider.isIndoor,
                onChanged: (value) => provider.toggleIndoorOutdoor(),
              ),
            ],
          ),
          const Divider(),
          const SizedBox(height: Dimensions.paddingSizeSmall),
          if (provider.isIndoor) ...[
             Padding(
              padding: EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
              child: Text("Customer Info", style: robotoBold(context)),
            ),
            const SizedBox(height: Dimensions.paddingSizeExtraLarge),
            Column(
              children: [
                CustomTextFieldWidget(
                  controller: customerNameController,
                  labelText: 'Customer Name',
                  hintText: 'Enter customer name',
                  prefixIcon: Icons.person,
                  validator: (value) => ValidateCheck.validateEmptyText(value, "Customer name is required"),
                ),
                const SizedBox(height: Dimensions.paddingSizeLarge),
                CustomTextFieldWidget(
                  controller: customerPhoneController,
                  labelText: 'Customer Phone',
                  hintText: 'Enter phone number',
                  prefixIcon: Icons.phone,
                  isRequired: false,
                ),
              ],
            ),
            const SizedBox(height: Dimensions.paddingSizeExtraLarge),
             Padding(
              padding: EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
              child: Text("Select Table", style: robotoBold(context)),
            ),
            const SizedBox(height: Dimensions.paddingSizeDefault),
            if (provider.tables.isEmpty)
              const Center(child: CircularProgressIndicator())
            else
              GridView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.all(16),
                itemCount: provider.tables.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 1,
                ),
                itemBuilder: (context, index) {
                  final table = provider.tables[index];
                  final isSelected = provider.selectedTableId == table.restaurantTableId;
                  return InkWell(
                    onTap: () => provider.selectTable(table.restaurantTableId),
                    child: Card(
                      elevation: isSelected ? 6 : 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: isSelected
                            ? BorderSide(color: Theme.of(context).primaryColor, width: 1.5)
                            : BorderSide.none,
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.table_restaurant, size: 32, color: isSelected ? Theme.of(context).primaryColor : Colors.grey),
                            const SizedBox(height: 8),
                            Text(table.restaurantTableName, textAlign: TextAlign.center),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
          ] else ...[
             Padding(
              padding: EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
              child: Text("Customer Info", style: robotoBold(context)),
            ),
            const SizedBox(height: Dimensions.paddingSizeExtraLarge),
            Column(
              children: [
                CustomTextFieldWidget(
                  controller: customerVehicleController,
                  labelText: 'Vehicle Number',
                  hintText: 'Enter vehicle number',
                  prefixIcon: Icons.directions_car,
                  validator: (value) => ValidateCheck.validateEmptyText(value, "Vehicle number is required"),
                ),
                const SizedBox(height: Dimensions.paddingSizeLarge),
                CustomTextFieldWidget(
                  controller: customerNameController,
                  labelText: 'Customer Name',
                  hintText: 'Enter customer name',
                  prefixIcon: Icons.person,
                  validator: (value) => ValidateCheck.validateEmptyText(value, "Customer name is required"),
                ),
                const SizedBox(height: Dimensions.paddingSizeLarge),
                CustomTextFieldWidget(
                  controller: customerPhoneController,
                  labelText: 'Customer Phone',
                  hintText: 'Enter phone number',
                  prefixIcon: Icons.phone,
                  isRequired: false,
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  // Helper function to get the selected variation text
  String? _getSelectedVariationText(CartItem item) {
    if (!item.food.hasVariations || item.food.variations == null) {
      return null;
    }

    for (int i = 0; i < item.selectedVariations.length; i++) {
      for (int j = 0; j < item.selectedVariations[i].length; j++) {
        if (item.selectedVariations[i][j]) {
          final variation = item.food.variations![i];
          return variation.size;
        }
      }
    }

    return null;
  }


  Widget _buildConfirmation(BuildContext context) {
    final provider = Provider.of<TakeOrderProvider>(context);
    return Container(
      padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(Dimensions.radiusExtraLarge),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha:0.05), blurRadius: 20)],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeLarge),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Theme.of(context).dividerColor.withValues(alpha:0.3))),
            ),
            child: Column(
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).primaryColor.withValues(alpha:0.1),
                    border: Border.all(color: Theme.of(context).primaryColor.withValues(alpha:0.3), width: 2),
                  ),
                  child: Icon(Icons.restaurant, size: 40, color: Theme.of(context).primaryColor),
                ),
                const SizedBox(height: Dimensions.paddingSizeDefault),
                Text("ORDER CONFIRMATION", style: robotoBold(context).copyWith(color: Theme.of(context).primaryColor)),
                const SizedBox(height: Dimensions.paddingSizeSmall),
                Text(DateFormat('MMMM dd, yyyy - hh:mm a').format(DateTime.now())),
              ],
            ),
          ),
          const SizedBox(height: Dimensions.paddingSizeLarge),
          // Container(
          //   padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeSmall),
          //   decoration: BoxDecoration(
          //     color: provider.isIndoor ? Colors.blue[50] : Colors.green[50],
          //     borderRadius: BorderRadius.circular(20),
          //   ),
          //   child: Row(
          //     mainAxisSize: MainAxisSize.min,
          //     children: [
          //       Icon(provider.isIndoor ? Icons.table_restaurant : Icons.delivery_dining,
          //           color: provider.isIndoor ? Colors.blue : Colors.green),
          //       const SizedBox(width: Dimensions.paddingSizeSmall),
          //       Text(provider.isIndoor ? "INDOOR DINING" : "TAKEAWAY",
          //           style: TextStyle(color: provider.isIndoor ? Colors.blue : Colors.green)),
          //     ],
          //   ),
          // ),
          // const SizedBox(height: Dimensions.paddingSizeLarge),
          // Container(
          //   padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall, vertical: Dimensions.paddingSizeDefault),
          //   decoration: BoxDecoration(
          //     color: Theme.of(context).cardColor,
          //     borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
          //     border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha:0.2)),
          //   ),
          //   child: Row(
          //     children: [
          //       if (provider.isIndoor) ...[
          //         _buildInfoRow(context, icon: Icons.table_bar, title: "Table", value: provider.tables.firstWhere((t) => t.restaurantTableId == provider.selectedTableId).restaurantTableName),
          //         const SizedBox(width: Dimensions.paddingSizeLarge),
          //       ] else ...[
          //         _buildInfoRow(context, icon: Icons.directions_car, title: "Vehicle", value: customerVehicleController.text),
          //         const SizedBox(width: Dimensions.paddingSizeLarge),
          //       ],
          //       _buildInfoRow(context, icon: Icons.person, title: "Customer", value: customerNameController.text),
          //       if (customerPhoneController.text.isNotEmpty) ...[
          //         const SizedBox(width: Dimensions.paddingSizeLarge),
          //         _buildInfoRow(context, icon: Icons.phone, title: "Phone", value: customerPhoneController.text),
          //       ],
          //     ],
          //   ),
          // ),
          // First container for indoor/outdoor indicator
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: Dimensions.paddingSizeDefault,
                vertical: Dimensions.paddingSizeSmall
            ),
            decoration: BoxDecoration(
              color: provider.isIndoor ? Colors.blue[50] : Colors.green[50],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                    provider.isIndoor ? Icons.table_restaurant : Icons.delivery_dining,
                    color: provider.isIndoor ? Colors.blue : Colors.green
                ),
                const SizedBox(width: Dimensions.paddingSizeSmall),
                Text(
                  provider.isIndoor ?
                  "TABLE ${provider.tables.firstWhere((t) => t.restaurantTableId == provider.selectedTableId).restaurantTableName}" :
                  "VEHICLE ${customerVehicleController.text}",
                  style: TextStyle(
                    color: provider.isIndoor ? Colors.blue : Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: Dimensions.paddingSizeLarge),

// Second container for customer info only
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: Dimensions.paddingSizeExtraSmall,
                vertical: Dimensions.paddingSizeDefault
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
              border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha:0.2)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildInfoRow(
                    context,
                    icon: Icons.person,
                    title: "Customer",
                    value: customerNameController.text
                ),
                if (customerPhoneController.text.isNotEmpty) ...[
                  const SizedBox(width: Dimensions.paddingSizeLarge),
                  _buildInfoRow(
                      context,
                      icon: Icons.phone,
                      title: "Phone",
                      value: customerPhoneController.text
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: Dimensions.paddingSizeLarge),
           Padding(
            padding: EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
            child: Text("ORDER ITEMS", style: robotoBold(context)),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
              border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha:0.2)),
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeSmall),
                  color: Theme.of(context).primaryColor.withValues(alpha:0.05),
                  child: const Row(
                    children: [
                      Expanded(flex: 3, child: Text("ITEM")),
                      Expanded(child: Text("QTY", textAlign: TextAlign.center)),
                      Expanded(child: Text("PRICE", textAlign: TextAlign.right)),
                    ],
                  ),
                ),
                ListView.separated(
                  shrinkWrap: true,
                  itemCount: provider.selectedProducts.length,
                  separatorBuilder: (context, index) => Divider(height: 1, color: Theme.of(context).dividerColor.withAlpha(10)),
                  itemBuilder: (context, index) {
                    final item = provider.selectedProducts[index];
                    // Get the selected variation text
                    String? variationText = _getSelectedVariationText(item);

                    return Container(
                      color: index.isEven ? Theme.of(context).cardColor : Theme.of(context).cardColor.withAlpha(50),
                      padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(flex: 3, child: Text(item.food.name)),
                              Expanded(child: Text("x${item.quantity}", textAlign: TextAlign.center)),
                              Expanded(child: Text("${item.totalPrice.toStringAsFixed(2)} PKR", textAlign: TextAlign.right)),
                            ],
                          ),
                          if (variationText != null) // Show variation if it exists
                            Padding(
                              padding: const EdgeInsets.only(top: 0.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: Text(
                                      variationText,
                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        color: Theme.of(context).hintColor,
                                      ),
                                    ),
                                  ),
                                  const Expanded(child: SizedBox()), // Empty space for alignment
                                  const Expanded(child: SizedBox()), // Empty space for alignment
                                ],
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                ),
                Container(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withValues(alpha:0.05),
                    border: Border(top: BorderSide(color: Theme.of(context).dividerColor.withValues(alpha:0.1))),
                  ),
                  child:

                  Column(
                    children: [
                      // Subtotal
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall),
                        child: Row(
                          children: [
                            Expanded(flex: 3, child: Text("SUBTOTAL", style: robotoBold(context))),
                            Expanded(
                              child: Text(
                                "${provider.subtotal.toStringAsFixed(2)} PKR",
                                style: robotoMedium(context),
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Tax
                      if (provider.taxModel != null) ...[
                        const Divider(),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: Text(
                                  "TAX (${provider.taxModel!.type == 'percentage' ? '${provider.taxModel!.value}%' : 'Fixed'})",
                                  style: robotoBold(context),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  "${provider.taxAmount.toStringAsFixed(2)} PKR",
                                  style: robotoMedium(context),
                                  textAlign: TextAlign.right,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],

                      const Divider(),
                      // Total
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall),
                        child: Row(
                          children: [
                            Expanded(flex: 3, child: Text("TOTAL", style: robotoBold(context))),
                            Expanded(
                              child: Text(
                                "${provider.totalWithTax.toStringAsFixed(2)} PKR",
                                style: robotoBold(context).copyWith(color: Theme.of(context).primaryColor),
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  // Row(
                  //   children: [
                  //     Expanded(flex: 4, child: Text("TOTAL", style: robotoBold(context))),
                  //     Expanded(
                  //       child: Text(
                  //         "${provider.cartTotal.toStringAsFixed(2)}  PKR",
                  //         style: robotoBold(context).copyWith(color: Theme.of(context).primaryColor),
                  //         textAlign: TextAlign.right,
                  //       ),
                  //     ),
                  //   ],
                  // ),
                ),
              ],
            ),
          ),
          const SizedBox(height: Dimensions.paddingSizeLarge),
          Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withValues(alpha:0.03),
              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
            ),
            child: Column(
              children: [
                const Icon(Icons.verified, size: 40, color: Colors.green),
                const SizedBox(height: Dimensions.paddingSizeSmall),
                const Text("Thank you for your order!"),
                // const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                // Text("Your order ID: #${DateTime.now().millisecondsSinceEpoch.toString().substring(6)}"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, {required IconData icon, required String title, required String value}) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withValues(alpha:0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 18, color: Theme.of(context).primaryColor),
        ),
        const SizedBox(width: Dimensions.paddingSizeExtraSmall),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: robotoRegular(context).copyWith(color: Theme.of(context).hintColor)),
            const SizedBox(height: 2),
            Text(value, style: robotoMedium(context).copyWith(
              fontSize: Dimensions.fontSizeSmall(context),
            ),),
          ],
        ),
      ],
    );
  }

  Widget _buildBottomButton(BuildContext context) {
    final provider = Provider.of<TakeOrderProvider>(context);
    return CustomButtonWidget(
      margin: const EdgeInsets.all(Dimensions.paddingSizeSmall),
      buttonText: provider.initialStep == 1.0 ? 'Submit' : 'Next',
      onPressed: () async {
        if (provider.initialStep == 0.1) {
          if (provider.selectedProducts.isEmpty) {
            showCustomSnackBar(context, 'Please add at least one product');
          } else {
            _scrollController.jumpTo(0);
            provider.stepStatusChange(0.5);
          }
        } else if (provider.initialStep == 0.5) {
          if (provider.isIndoor) {
            if (customerNameController.text.isEmpty) {
              showCustomSnackBar(context, 'Please enter customer name');
            } else if (provider.selectedTableId == null) {
              showCustomSnackBar(context, 'Please select a table');
            } else {
              _scrollController.jumpTo(0);
              provider.stepStatusChange(1.0);
            }
          } else {
            if (customerNameController.text.isEmpty || customerVehicleController.text.isEmpty) {
              showCustomSnackBar(context, 'Please fill all required fields');
            } else {
              _scrollController.jumpTo(0);
              provider.stepStatusChange(1.0);
            }
          }
        } else {
            provider.submitOrder(
              context,
              customerNameController.text,
              customerPhoneController.text.isEmpty ? null : customerPhoneController.text,
              customerVehicleController.text.isEmpty ? null : customerVehicleController.text,
            );


        }
      },
    );
  }
}
