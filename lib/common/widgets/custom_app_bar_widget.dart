import 'package:flutter/material.dart';

import '../../util/dimensions.dart';
import '../../util/styles.dart';

class CustomAppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool isBackButtonExist;
  final bool centerTitle;
  final TextStyle? titleStyle;
  final Function? onBackPressed;
  final Color? bgColor;
  final List<Widget>? action;
  const CustomAppBarWidget({super.key, required this.title, this.isBackButtonExist = true, this.centerTitle = true, this.titleStyle, this.onBackPressed,
    this.bgColor, this.action,});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title, style: titleStyle ?? robotoMedium(context).copyWith(fontSize: Dimensions.fontSizeLarge(context), color: bgColor == null ? Theme.of(context).textTheme.bodyLarge!.color : Theme.of(context).cardColor)),
      centerTitle: centerTitle,
      leading: isBackButtonExist ? IconButton(
        icon: const Icon(Icons.arrow_back_ios),
        color: bgColor == null ? Theme.of(context).textTheme.bodyLarge!.color : Theme.of(context).cardColor,
        onPressed: () => onBackPressed != null ? onBackPressed!() : Navigator.pop(context),
      ) : null,
      backgroundColor: bgColor ?? Theme.of(context).cardColor,
      surfaceTintColor: Theme.of(context).cardColor,
      shadowColor: Theme.of(context).disabledColor.withValues(alpha: 0.5),
      elevation: 2,
      actions: action,
    );
  }

  @override
  Size get preferredSize => Size(Dimensions.webMaxWidth, 50);
}
