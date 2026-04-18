import 'package:flutter/material.dart';

import '../../common/widgets/custom_button_widget.dart';

import '../../util/dimensions.dart';
import '../../util/styles.dart';

class ConfirmationDialogWidget extends StatelessWidget {
  final String icon;
  final String? title;
  final String description;
  final Function onYesPressed;
  final bool isLogOut;
  final Function? onNoPressed;
  final Color? titleColor;
  final bool? isDelete;

  const ConfirmationDialogWidget({
    super.key,
    required this.icon,
    this.title,
    required this.description,
    required this.onYesPressed,
    this.isLogOut = false,
    this.onNoPressed,
    this.titleColor = Colors.red,
    this.isDelete = false,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimensions.radiusExtraLarge)),
      insetPadding: EdgeInsets.all(isDelete == true ? 22 : 30),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: SizedBox(
        width: 500,
        child: Padding(
          padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                child: Image.asset(icon, width: 50, height: 50),
              ),
              title != null
                  ? Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: Dimensions.paddingSizeLarge),
                child: Text(
                  title!,
                  textAlign: TextAlign.center,
                  style: robotoMedium(context).copyWith(
                      fontSize: Dimensions.fontSizeExtraLarge(context),
                      color: titleColor),
                ),
              )
                  : const SizedBox(),
              Padding(
                padding: EdgeInsets.all(
                    isDelete == true
                        ? Dimensions.paddingSizeSmall
                        : Dimensions.paddingSizeLarge),
                child: Text(
                  description,
                  style: isDelete == true
                      ? robotoRegular(context)
                      : robotoMedium(context).copyWith(fontSize: Dimensions.fontSizeLarge(context),),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: Dimensions.paddingSizeLarge),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        if (isLogOut) {
                          onYesPressed();
                        } else {
                          if (onNoPressed != null) {
                            onNoPressed!();
                          } else {
                            Navigator.of(context).pop();
                          }
                        }
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: isDelete == true
                            ? Theme.of(context).colorScheme.error
                            : Theme.of(context)
                            .disabledColor
                            .withValues(alpha: 0.3),
                        minimumSize: const Size(Dimensions.webMaxWidth, 40),
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(Dimensions.radiusSmall)),
                      ),
                      child: Text(
                        isLogOut
                            ? (isDelete == true ? 'Delete' : 'Yes')
                            : (isDelete == true ? 'Cancel' : 'No'),
                        textAlign: TextAlign.center,
                        style: robotoBold(context).copyWith(
                          color: isDelete == true
                              ? Theme.of(context).cardColor
                              : Theme.of(context).textTheme.bodyLarge!.color,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: Dimensions.paddingSizeLarge),
                  Expanded(
                    child: CustomButtonWidget(
                      color: isDelete == true
                          ? Theme.of(context).disabledColor.withValues(alpha: 0.3)
                          : Theme.of(context).primaryColor,
                      textColor: isDelete == true
                          ? Theme.of(context).disabledColor
                          : Theme.of(context).cardColor,
                      buttonText: isLogOut
                          ? (isDelete == true ? 'Cancel' : 'No')
                          : (isDelete == true ? 'Delete' : 'Yes'),
                      onPressed: () {
                        if (isLogOut) {
                          Navigator.of(context).pop();
                        } else {
                          onYesPressed();
                        }
                      },
                      radius: Dimensions.radiusSmall,
                      height: 40,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
