import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_flutter_app/common/widgets/dotted_divider.dart';

import '../../models/categories_and_food.dart';
import '../../providers/take_order_provider.dart';
import '../../util/dimensions.dart';
import '../../util/styles.dart';
import 'custom_button_widget.dart';

class ProductBottomSheetWidget extends StatefulWidget {
  final Food food;
  const ProductBottomSheetWidget({super.key, required this.food});

  @override
  State<ProductBottomSheetWidget> createState() => _ProductBottomSheetWidgetState();
}

class _ProductBottomSheetWidgetState extends State<ProductBottomSheetWidget> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<TakeOrderProvider>(context, listen: false);
      provider.editCartItem(widget.food); // This will load existing selections if item is in cart
    });
  }

  @override
  Widget build(BuildContext context) {
    final takeOrderProvider = Provider.of<TakeOrderProvider>(context);
    final food = widget.food;
    final hasVariations = food.hasVariations && food.variations != null && food.variations!.isNotEmpty;

    Variation? selectedVariation;
    if (hasVariations) {
      for (int i = 0; i < food.variations!.length; i++) {
        if (takeOrderProvider.selectedVariations.length > i &&
            takeOrderProvider.selectedVariations[i].isNotEmpty &&
            takeOrderProvider.selectedVariations[i][0]) {
          selectedVariation = food.variations![i];
          break;
        }
      }
    }

    final currentPrice = hasVariations
        ? (selectedVariation?.discountPrice ?? selectedVariation?.price)?.toDouble() ?? food.price.toDouble()
        : takeOrderProvider.calculateDiscountedPrice(food);

    final hasDiscount = hasVariations
        ? (selectedVariation?.discountPrice != null && selectedVariation!.discountPrice! > 0)
        : (food.discountPrice != null && food.discountPrice! > 0);

    final basePrice = hasVariations
        ? selectedVariation?.price.toDouble() ?? food.price.toDouble()
        : food.price.toDouble();

    final isAddToCartEnabled = !hasVariations || selectedVariation != null;

    return SafeArea(
      child: Container(
        width: 550,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header with close button
            Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              children: [
                if (food.image != null && food.image!.isNotEmpty)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      food.image!,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                  ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(food.name,
                          style: robotoBold(context).copyWith(
                              fontSize: Dimensions.fontSizeLarge(context))),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          if (hasDiscount)
                            Text(
                              '${basePrice.toStringAsFixed(2)} PKR',
                              style: robotoRegular(context).copyWith(
                                decoration: TextDecoration.lineThrough,
                                color: Colors.grey,
                              ),
                            ),
                          if (hasDiscount) const SizedBox(width: 6),
                          Text(
                            '${currentPrice.toStringAsFixed(2)} PKR',
                            style: robotoBold(context).copyWith(
                              fontSize: 16,
                              color: hasDiscount
                                  ? Theme.of(context).primaryColor
                                  : null,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),

          // Variations
          if (hasVariations) ...[
            const SizedBox(height: Dimensions.paddingSizeDefault,),
            DottedDivider(
              color: Theme.of(context).hintColor.withValues(alpha: 0.4),
            ),
            const SizedBox(height: Dimensions.paddingSizeDefault,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Select Variation',
                    style: robotoBold(context).copyWith(
                        fontSize: Dimensions.fontSizeLarge(context)),
                  ),
                  const SizedBox(height: 8),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: food.variations!.length,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final variation = food.variations![index];
                      final isSelected = takeOrderProvider.selectedVariations.length > index &&
                          takeOrderProvider.selectedVariations[index].isNotEmpty &&
                          takeOrderProvider.selectedVariations[index][0];

                      final hasVarDiscount = variation.discountPrice != null &&
                          variation.discountPrice! > 0;

                      return GestureDetector(
                        onTap: () {
                          takeOrderProvider.selectVariationOption(index, 0, "single");
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: isSelected
                                    ? Theme.of(context).primaryColor
                                    : Colors.grey.shade300,
                                width: isSelected ? 2 : 1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  variation.size,
                                  style: robotoBold(context),
                                ),
                              ),
                              if (hasVarDiscount)
                                Text(
                                  '${variation.price.toStringAsFixed(2)} PKR',
                                  style: robotoRegular(context).copyWith(
                                    decoration: TextDecoration.lineThrough,
                                    color: Colors.grey,
                                  ),
                                ),
                              const SizedBox(width: 6),
                              Text(
                                '${(hasVarDiscount ? (variation.discountPrice ?? variation.price) : variation.price).toStringAsFixed(2)} PKR',
                                style: robotoBold(context).copyWith(
                                    color: hasVarDiscount
                                        ? Theme.of(context).primaryColor
                                        : null),
                              ),
                              if (isSelected)
                                const Padding(
                                  padding: EdgeInsets.only(left: 8),
                                  child: Icon(Icons.check_circle,
                                      color: Colors.green),
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
          ],

          const SizedBox(height: 16),

          // Bottom Bar
          Container(
            padding: EdgeInsets.fromLTRB(
              16,
              16,
              16,
              16 + MediaQuery.of(context).viewInsets.bottom,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              boxShadow: [BoxShadow(color: Colors.grey[300]!, blurRadius: 10)],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total:', style: robotoBold(context)),
                    Text(
                      '${takeOrderProvider.calculateTotalPrice(food, takeOrderProvider.quantity).toStringAsFixed(2)} PKR',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed: takeOrderProvider.decrementQuantity,
                        ),
                        Text(takeOrderProvider.quantity.toString()),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: takeOrderProvider.incrementQuantity,
                        ),
                      ],
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: CustomButtonWidget(
                        buttonText: takeOrderProvider.selectedProducts.any((item) => item.foodId == food.id)
                            ? "Update Cart"
                            : "Add to Cart",
                        onPressed: isAddToCartEnabled
                            ? () {
                          takeOrderProvider.addToCart(food, takeOrderProvider.quantity);
                          Navigator.pop(context);
                        }
                            : null,
                        color: isAddToCartEnabled
                            ? Theme.of(context).primaryColor
                            : Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          ],
        ),
      ),
    );
  }
}