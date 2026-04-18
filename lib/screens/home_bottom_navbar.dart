import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/preferences_provider.dart';

import '../../screens/order_status_screen.dart';
import '../../screens/dashboard_screen.dart';

import '../../common/widgets/custom_asset_image_widget.dart';
import '../../common/widgets/custom_dialog_widget.dart';
import '../../common/widgets/confirmation_dialog_widget.dart';

import '../util/dimensions.dart';
import '../util/styles.dart';

class HomeBottomNavbar extends StatefulWidget {
  final int pageIndex;
  const HomeBottomNavbar({super.key, required this.pageIndex});

  @override
  State<HomeBottomNavbar> createState() => _HomeBottomNavbarState();
}

class _HomeBottomNavbarState extends State<HomeBottomNavbar> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.pageIndex;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  List<Widget> screenWidgets = [
    DashboardScreen(),
    OrderStatusScreen(),
    Container(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: IconButton(
                padding: const EdgeInsets.symmetric(
                    vertical: Dimensions.paddingSizeExtraSmall),
                icon: Column(
                  children: [
                    CustomAssetImageWidget(
                      "assets/images/home_icon.png",
                      width: 23,
                      color: _selectedIndex == 0
                          ? Theme.of(context).secondaryHeaderColor
                          : Theme.of(context).hintColor,
                    ),
                    Text(
                      "Home",
                      style: robotoMedium(context).copyWith(
                          color: _selectedIndex == 0
                              ? Theme.of(context).secondaryHeaderColor
                              : Theme.of(context).hintColor,
                          fontSize: Dimensions.fontSizeExtraSmall(context)),
                    ),
                  ],
                ),
                onPressed: () {
                  _onItemTapped(0);
                },
              ),
            ),
            Expanded(
              child: IconButton(
                padding: const EdgeInsets.symmetric(
                    vertical: Dimensions.paddingSizeExtraSmall),
                icon: Column(
                  children: [
                    CustomAssetImageWidget(
                      "assets/images/regular_order.png",
                      width: 23,
                      color: _selectedIndex == 2
                          ? Theme.of(context).secondaryHeaderColor
                          : Theme.of(context).hintColor,
                    ),
                    Text(
                      "Orders",
                      style: robotoMedium(context).copyWith(
                          color: _selectedIndex == 2
                              ? Theme.of(context).secondaryHeaderColor
                              : Theme.of(context).hintColor,
                          fontSize: Dimensions.fontSizeExtraSmall(context)),
                    ),
                  ],
                ),
                onPressed: () {
                  _onItemTapped(1);
                },
              ),
            ),
            Expanded(
              child: IconButton(
                padding: const EdgeInsets.symmetric(
                    vertical: Dimensions.paddingSizeExtraSmall),
                icon: Column(
                  children: [
                    CustomAssetImageWidget(
                      "assets/images/logout_icon.png",
                      width: 23,
                      color: _selectedIndex == 1
                          ? Theme.of(context).secondaryHeaderColor
                          : Theme.of(context).hintColor,
                    ),
                    Text(
                      "Logout",
                      style: robotoMedium(context).copyWith(
                          color: _selectedIndex == 1
                              ? Theme.of(context).secondaryHeaderColor
                              : Theme.of(context).hintColor,
                          fontSize: Dimensions.fontSizeExtraSmall(context)),
                    ),
                  ],
                ),
                onPressed: () {
                  showAnimatedDialog(context, ConfirmationDialogWidget(icon: "assets/images/logout_icon.png", title: "Logout", description: "Are You Sure you want to logout", onYesPressed: (){
                    context.read<PreferencesProvider>().logOut(context);
                  },),);
                },
              ),
            ),
          ],
        ),
      ),
      body: screenWidgets.elementAt(_selectedIndex),
    );
  }
}
