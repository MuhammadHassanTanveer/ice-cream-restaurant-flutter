import 'package:flutter/material.dart';

import '../../util/dimensions.dart';
import '../../util/styles.dart';
import 'custom_asset_image_widget.dart';

class CustomDashboardCardWidget extends StatelessWidget {
  final Function() onTap;
  final String iconPath;
  final Color? iconColor;
  final String label;
  const CustomDashboardCardWidget({super.key, required this.onTap, required this.iconPath, this.iconColor, required this.label});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
          child: Column(
            children: <Widget>[
              CustomAssetImageWidget(iconPath, width: 50, height: 50, color: iconColor),
              const SizedBox(height: Dimensions.paddingSizeDefault),
              Align(
                  alignment: Alignment.center,
                  child: Text(label, style: robotoMedium(context).copyWith(fontSize: Dimensions.fontSizeExtraSmall(context), fontWeight: FontWeight.w600))),
            ],
          ),
        ),
      ),
    );
  }
}
