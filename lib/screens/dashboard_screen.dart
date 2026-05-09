import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_flutter_app/common/widgets/banner_view_widget.dart';
import 'package:restaurant_flutter_app/screens/order_status_screen.dart';
import 'package:restaurant_flutter_app/screens/take_order_screen.dart';
import 'package:restaurant_flutter_app/providers/dashboard_provider.dart';

import '../../screens/notification_screen.dart';
import '../../common/widgets/dotted_divider.dart';
import '../../common/widgets/custom_app_bar_widget.dart';
import '../../common/widgets/custom_asset_image_widget.dart';
import '../../util/styles.dart';
import '../../util/dimensions.dart';
import '../models/dashboard_model.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool _hasInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_hasInitialized) {
      _hasInitialized = true;
      Future.microtask(() => _loadDashboardData());
    }
  }

  void _loadDashboardData() {
    final dashboardProvider = Provider.of<DashboardProvider>(context, listen: false);
    final now = DateTime.now();
    final formattedDate = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';

    // Replace '2' with your actual user ID (you might want to get this from auth provider)
    dashboardProvider.fetchDashboardStats(date: formattedDate);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final dashboardProvider = Provider.of<DashboardProvider>(context);

    return Scaffold(
      appBar: CustomAppBarWidget(
        title: "Restaurant App",
        bgColor: Theme.of(context).secondaryHeaderColor,
        isBackButtonExist: false,
        centerTitle: false,
        titleStyle: robotoBold(context).copyWith(fontSize: Dimensions.fontSizeExtraLarge(context), color: Theme.of(context).cardColor),
        action: [
          // InkWell(
          //   onTap: () {
          //     Navigator.of(context).push(MaterialPageRoute(builder: (context) => const NotificationScreen()));
          //   },
          //   child: Container(
          //     margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
          //     decoration: BoxDecoration(
          //       color: Theme.of(context).cardColor.withValues(alpha: 0.9),
          //       borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
          //     ),
          //     padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
          //     child: Stack(
          //       children: [
          //         Icon(
          //           Icons.notifications_outlined,
          //           size: 25,
          //           color: Theme.of(context).primaryColor,
          //         ),
          //         Positioned(
          //           top: 0,
          //           right: 0,
          //           child: Container(
          //             height: 10,
          //             width: 10,
          //             decoration: BoxDecoration(
          //               color: Theme.of(context).primaryColor,
          //               shape: BoxShape.circle,
          //               border: Border.all(
          //                 width: 1,
          //                 color: Theme.of(context).cardColor,
          //               ),
          //             ),
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
        ],
      ),
      body: SafeArea(
        bottom: true,
        child: Padding(
          padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
          child: RefreshIndicator(
            onRefresh: () => dashboardProvider.refreshData(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.78,
                // color: Colors.green,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    if (dashboardProvider.isLoading)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(32.0),
                          child: CircularProgressIndicator(),
                        ),
                      )
                    else if (dashboardProvider.error != null)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(32.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.error_outline,
                                size: 64,
                                color: Colors.red.withOpacity(0.6),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                dashboardProvider.error!,
                                style: robotoBold(context).copyWith(
                                  fontSize: Dimensions.fontSizeDefault(context),
                                  color: Colors.red,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 24),
                              ElevatedButton.icon(
                                onPressed: () => _loadDashboardData(),
                                icon: const Icon(Icons.refresh),
                                label: const Text('Retry'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Theme.of(context).primaryColor,
                                  foregroundColor: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    else if (dashboardProvider.dashboardStats != null) ...[
                        _buildStatsCards(context, size, dashboardProvider.dashboardStats!),
                        SizedBox(height: Dimensions.paddingSizeDefault),
                        const DottedDivider(),
                        SizedBox(height: Dimensions.paddingSizeDefault),
                        _buildDashboardActions(context, size),
                        SizedBox(height: Dimensions.paddingSizeDefault),
                        // const DottedDivider(),
                        // SizedBox(height: Dimensions.paddingSizeDefault),
                        // _buildTodayDeals(context),
                      ]
                    else
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(32.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.info_outline,
                                size: 64,
                                color: Theme.of(context).hintColor.withOpacity(0.5),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'No data available',
                                style: robotoBold(context).copyWith(
                                  fontSize: Dimensions.fontSizeDefault(context),
                                  color: Theme.of(context).hintColor,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Pull down to refresh',
                                style: robotoRegular(context).copyWith(
                                  fontSize: Dimensions.fontSizeSmall(context),
                                  color: Theme.of(context).hintColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatsCards(BuildContext context, Size size, DashboardModel stats) {
    return Column(
      children: [
        Card(
          color: Theme.of(context).colorScheme.tertiaryContainer,
          child: Container(
            width: size.width,
            padding: EdgeInsets.all(Dimensions.paddingSizeDefault),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Total Orders",
                      style: robotoBold(context).copyWith(
                        fontSize: Dimensions.fontSizeExtraLarge(context),
                        color: Theme.of(context).cardColor,
                      ),
                    ),
                    SizedBox(height: Dimensions.paddingSizeSmall),
                    Text(
                      stats.totalOrders.toString(),
                      style: robotoBold(context).copyWith(
                        fontSize: Dimensions.fontSizeOverLarge(context),
                        color: Theme.of(context).cardColor,
                      ),
                    )
                  ],
                ),
                CustomAssetImageWidget(
                  "assets/images/regular_order.png",
                  width: 55,
                  height: 55,
                  color: Theme.of(context).cardColor,
                )
              ],
            ),
          ),
        ),
        SizedBox(height: Dimensions.paddingSizeSmall),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Card(
                color: Colors.amber.withValues(alpha: 0.8),
                child: Container(
                  padding: EdgeInsets.all(Dimensions.paddingSizeDefault),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "Pending Orders",
                              style: robotoBold(context).copyWith(
                                fontSize: Dimensions.fontSizeDefault(context),
                                color: Theme.of(context).cardColor,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: Dimensions.paddingSizeSmall),
                            Text(
                              stats.pendingOrders.toString(),
                              style: robotoBold(context).copyWith(
                                fontSize: Dimensions.fontSizeLarge(context),
                                color: Theme.of(context).cardColor,
                              ),
                            )
                          ],
                        ),
                      ),
                      CustomAssetImageWidget(
                        "assets/images/regular_order.png",
                        width: 20,
                        height: 20,
                        color: Theme.of(context).cardColor,
                      )
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(width: Dimensions.paddingSizeSmall),
            Expanded(
              child: Card(
                color: Theme.of(context).primaryColor.withValues(alpha: 0.8),
                child: Container(
                  padding: EdgeInsets.all(Dimensions.paddingSizeDefault),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "Complete Orders",
                              style: robotoBold(context).copyWith(
                                fontSize: Dimensions.fontSizeDefault(context),
                                color: Theme.of(context).cardColor,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: Dimensions.paddingSizeSmall),
                            Text(
                              stats.completedOrders.toString(),
                              style: robotoBold(context).copyWith(
                                fontSize: Dimensions.fontSizeLarge(context),
                                color: Theme.of(context).cardColor,
                              ),
                            )
                          ],
                        ),
                      ),
                      CustomAssetImageWidget(
                        "assets/images/regular_order.png",
                        width: 20,
                        height: 20,
                        color: Theme.of(context).cardColor,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: Dimensions.paddingSizeSmall),
        Card(
          color: Colors.red.withValues(alpha: 0.8),
          child: Container(
            width: size.width,
            padding: EdgeInsets.all(Dimensions.paddingSizeDefault),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Cancelled Orders",
                      style: robotoBold(context).copyWith(
                        fontSize: Dimensions.fontSizeDefault(context),
                        color: Theme.of(context).cardColor,
                      ),
                    ),
                    SizedBox(height: Dimensions.paddingSizeSmall),
                    Text(
                      stats.cancelledOrders.toString(),
                      style: robotoBold(context).copyWith(
                        fontSize: Dimensions.fontSizeLarge(context),
                        color: Theme.of(context).cardColor,
                      ),
                    )
                  ],
                ),
                CustomAssetImageWidget(
                  "assets/images/regular_order.png",
                  width: 30,
                  height: 30,
                  color: Theme.of(context).cardColor,
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDashboardActions(BuildContext context, Size size) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Dashboard",
          style: robotoBold(context).copyWith(
            fontSize: Dimensions.fontSizeExtraLarge(context),
          ),
        ),
        SizedBox(height: Dimensions.paddingSizeSmall),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Card(
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const TakeOrderScreen(),
                    ));
                  },
                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                  child: Container(
                    padding: EdgeInsets.all(Dimensions.paddingSizeDefault),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "Take Order",
                              style: robotoBold(context).copyWith(
                                fontSize: Dimensions.fontSizeDefault(context),
                              ),
                            ),
                          ],
                        ),
                        CustomAssetImageWidget(
                          "assets/images/order_menu_icon.png",
                          width: 30,
                          height: 30,
                          color: Theme.of(context).colorScheme.onSecondaryContainer,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: Dimensions.paddingSizeSmall),
            Expanded(
              child: Card(
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const OrderStatusScreen(),
                    ));
                  },
                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                  child: Container(
                    padding: EdgeInsets.all(Dimensions.paddingSizeDefault),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "Orders Status",
                              style: robotoBold(context).copyWith(
                                fontSize: Dimensions.fontSizeDefault(context),
                              ),
                            ),
                          ],
                        ),
                        CustomAssetImageWidget(
                          "assets/images/order_confirm_icon.svg",
                          width: 30,
                          height: 30,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTodayDeals(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Today Deal's",
          style: robotoBold(context).copyWith(
            fontSize: Dimensions.fontSizeExtraLarge(context),
          ),
        ),
        SizedBox(height: Dimensions.paddingSizeExtraSmall),
        const BannerViewWidget(),
      ],
    );
  }
}