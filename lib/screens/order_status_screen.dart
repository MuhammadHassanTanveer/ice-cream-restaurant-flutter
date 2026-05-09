// import 'package:flutter/material.dart';
// import 'package:pull_to_refresh/pull_to_refresh.dart';
// import 'package:provider/provider.dart';
// import 'package:restaurant_flutter_app/common/widgets/dotted_divider.dart';
// import 'package:restaurant_flutter_app/providers/take_order_provider.dart';
// import 'package:restaurant_flutter_app/util/styles.dart';
//
// import '../../screens/home_bottom_navbar.dart';
// import '../common/widgets/custom_image_widget.dart';
// import '../models/complete_orders_model.dart';
// import '../models/pending_orders_model.dart';
// import '../util/dimensions.dart';
//
// class OrderStatusScreen extends StatefulWidget {
//   const OrderStatusScreen({super.key});
//
//   @override
//   State<OrderStatusScreen> createState() => _OrderStatusScreenState();
// }
//
// class _OrderStatusScreenState extends State<OrderStatusScreen>
//     with SingleTickerProviderStateMixin {
//   late TabController _tabController;
//   final RefreshController _refreshController = RefreshController(initialRefresh: false);
//
//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 2, vsync: this);
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       Provider.of<TakeOrderProvider>(context, listen: false).getPendingOrders(context);
//     });
//   }
//
//   @override
//   void dispose() {
//     _tabController.dispose();
//     _refreshController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Theme.of(context).cardColor,
//       appBar: AppBar(
//         backgroundColor: Theme.of(context).cardColor,
//         title: const Text("Orders List"),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () {
//             Navigator.of(context).pushAndRemoveUntil(
//               MaterialPageRoute(builder: (context) => HomeBottomNavbar(pageIndex: 0)),
//                   (route) => false,
//             );
//           },
//         ),
//         bottom: TabBar(
//           controller: _tabController,
//           labelColor: Theme.of(context).primaryColor,
//           unselectedLabelColor: Colors.grey,
//           indicatorColor: Theme.of(context).primaryColor,
//           tabs: const [
//             Tab(text: "Pending"),
//             Tab(text: "Complete"),
//           ],
//         ),
//       ),
//       body: TabBarView(
//         controller: _tabController,
//         children: [
//           _buildPendingOrdersList(),
//           const CompleteOrderListState(),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildPendingOrdersList() {
//     return Consumer<TakeOrderProvider>(
//       builder: (context, orderProvider, child) {
//         // Check if data is loading
//         final isLoading =orderProvider.pageIndex == 1;
//
//         if (isLoading) {
//           return const Center(child: CircularProgressIndicator());
//         }
//
//         if (orderProvider.pendingOrdersData.isEmpty) {
//           return Center(
//             child: Text(
//               "No pending orders",
//               style: robotoMedium(context).copyWith(
//                 fontSize: Dimensions.fontSizeLarge(context),
//                 color: Theme.of(context).hintColor,
//               ),
//             ),
//           );
//         }
//
//         return SmartRefresher(
//           controller: _refreshController,
//           enablePullUp: orderProvider.showMore ?? false,
//           onRefresh: () async {
//             final result = await orderProvider.getPendingOrders(context, isRefresh: true);
//             if (result) {
//               _refreshController.refreshCompleted();
//             } else {
//               _refreshController.refreshFailed();
//             }
//           },
//           onLoading: () async {
//             final result = await orderProvider.getPendingOrders(context);
//             if (result) {
//               _refreshController.loadComplete();
//             } else {
//               _refreshController.loadNoData();
//             }
//           },
//           child: ListView.separated(
//             padding: EdgeInsets.all(Dimensions.paddingSizeLarge),
//             itemCount: orderProvider.pendingOrdersData.length,
//             separatorBuilder: (context, index) =>
//             const SizedBox(height: Dimensions.paddingSizeSmall),
//             itemBuilder: (context, index) {
//               final order = orderProvider.pendingOrdersData[index];
//               return _buildOrderCard(context, order);
//             },
//           ),
//         );
//       },
//     );
//   }
//
//   Widget _buildOrderCard(BuildContext context, Order order) {
//     return Card(
//       child: Container(
//         padding: EdgeInsets.all(Dimensions.paddingSizeSmall),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
//         ),
//         child: Column(
//           children: <Widget>[
//             // Order header with number and table/vehicle info
//             Padding(
//               padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: <Widget>[
//                   RichText(
//                     text: TextSpan(
//                       text: "Order #: ",
//                       style: robotoBold(context).copyWith(
//                         fontSize: Dimensions.fontSizeSmall(context),
//                         color: Theme.of(context).hintColor,
//                       ),
//                       children: [
//                         TextSpan(
//                           text: order.orderNumber,
//                           style: robotoRegular(context).copyWith(
//                             fontSize: Dimensions.fontSizeSmall(context),
//                             color: Theme.of(context).hintColor,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   if (order.table != null)
//                     RichText(
//                       text: TextSpan(
//                         text: "Table: ",
//                         style: robotoBold(context).copyWith(
//                           fontSize: Dimensions.fontSizeSmall(context),
//                           color: Theme.of(context).hintColor,
//                         ),
//                         children: [
//                           TextSpan(
//                             text: order.table!.tableName,
//                             style: robotoRegular(context).copyWith(
//                               fontSize: Dimensions.fontSizeSmall(context),
//                               color: Theme.of(context).hintColor,
//                             ),
//                           ),
//                         ],
//                       ),
//                     )
//                   else if (order.vehicleNumber != null)
//                     RichText(
//                       text: TextSpan(
//                         text: "Vehicle: ",
//                         style: robotoBold(context).copyWith(
//                           fontSize: Dimensions.fontSizeSmall(context),
//                           color: Theme.of(context).hintColor,
//                         ),
//                         children: [
//                           TextSpan(
//                             text: order.vehicleNumber!,
//                             style: robotoRegular(context).copyWith(
//                               fontSize: Dimensions.fontSizeSmall(context),
//                               color: Theme.of(context).hintColor,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                 ],
//               ),
//             ),
//
//             SizedBox(height: Dimensions.paddingSizeSmall),
//             DottedDivider(
//               color: Theme.of(context).hintColor.withOpacity(0.6),
//             ),
//             SizedBox(height: Dimensions.paddingSizeSmall),
//
//             // Order items
//             Stack(
//               children: <Widget>[
//                 Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: <Widget>[
//                     // Food images grid
//                     if (order.items.isNotEmpty)
//                       SizedBox(
//                         width: 80,
//                         child: _buildFoodImagesGrid(order.items),
//                       ),
//                     SizedBox(width: Dimensions.paddingSizeSmall),
//                     // Food details
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           ...order.items.asMap().entries.map((entry) =>
//                               _buildOrderItem(context, entry.value, entry.key, order.items)
//                           ).toList(),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//             SizedBox(height: Dimensions.paddingSizeSmall),
//             const Divider(),
//             SizedBox(height: Dimensions.paddingSizeSmall),
//             // Footer with total and status
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: <Widget>[
//                 RichText(
//                   text: TextSpan(
//                     text: "Total: ",
//                     style: robotoBold(context).copyWith(
//                       fontSize: Dimensions.fontSizeSmall(context),
//                       color: Theme.of(context).hintColor,
//                     ),
//                     children: [
//                       TextSpan(
//                         text: order.total,
//                         style: robotoRegular(context).copyWith(
//                           fontSize: Dimensions.fontSizeSmall(context),
//                           color: Theme.of(context).hintColor,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Container(
//                   width: 80,
//                   padding: EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
//                     color: Colors.amber.withOpacity(0.7),
//                   ),
//                   alignment: Alignment.center,
//                   child: Text(
//                     order.status,
//                     style: robotoBold(context).copyWith(
//                       fontSize: Dimensions.fontSizeSmall(context),
//                       color: Theme.of(context).hintColor,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildFoodImagesGrid(List<Item> items) {
//     final itemCount = items.length;
//
//     if (itemCount == 1) {
//       return ClipRRect(
//         borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
//         child: CustomImageWidget(
//           image: "http://ice_cream_restaurant.test/${items[0].foodImage}",
//           placeholder: "assets/images/placeholder.png",
//           fit: BoxFit.cover,
//         ),
//       );
//     } else if (itemCount == 2) {
//       return GridView.count(
//         crossAxisCount: 2,
//         crossAxisSpacing: 1,
//         mainAxisSpacing: 1,
//         shrinkWrap: true,
//         childAspectRatio: 0.6,
//         physics: const NeverScrollableScrollPhysics(),
//         children: items.take(2).map((item) =>
//             ClipRRect(
//               borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
//               child: CustomImageWidget(
//                 image: "http://ice_cream_restaurant.test/${item.foodImage}",
//                 placeholder: "assets/images/placeholder.png",
//                 fit: BoxFit.cover,
//               ),
//             ),
//         ).toList(),
//       );
//     } else if (itemCount == 3) {
//       return Column(
//         children: [
//           SizedBox(
//             height: 40,
//             child: Row(
//               children: [
//                 Expanded(
//                   child: ClipRRect(
//                     borderRadius: BorderRadius.only(
//                       topLeft: Radius.circular(Dimensions.radiusSmall),
//                     ),
//                     child: CustomImageWidget(
//                       image: "http://ice_cream_restaurant.test/${items[0].foodImage}",
//                       placeholder: "assets/images/placeholder.png",
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                 ),
//                 SizedBox(width: 1),
//                 Expanded(
//                   child: ClipRRect(
//                     borderRadius: BorderRadius.only(
//                       topRight: Radius.circular(Dimensions.radiusSmall),
//                     ),
//                     child: CustomImageWidget(
//                       image: "http://ice_cream_restaurant.test/${items[1].foodImage}",
//                       placeholder: "assets/images/placeholder.png",
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           SizedBox(height: 1),
//           ClipRRect(
//             borderRadius: BorderRadius.only(
//               bottomLeft: Radius.circular(Dimensions.radiusSmall),
//               bottomRight: Radius.circular(Dimensions.radiusSmall),
//             ),
//             child: CustomImageWidget(
//               image: "http://ice_cream_restaurant.test/${items[2].foodImage}",
//               placeholder: "assets/images/placeholder.png",
//               fit: BoxFit.cover,
//               height: 40,
//             ),
//           ),
//         ],
//       );
//     } else {
//       return Stack(
//         children: [
//           GridView.count(
//             crossAxisCount: 2,
//             crossAxisSpacing: 1,
//             mainAxisSpacing: 1,
//             shrinkWrap: true,
//             physics: const NeverScrollableScrollPhysics(),
//             children: items.take(3).map((item) =>
//                 ClipRRect(
//                   borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
//                   child: CustomImageWidget(
//                     image: 'http://ice_cream_restaurant.test/${item.foodImage}',
//                     placeholder: "assets/images/placeholder.png",
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//             ).toList(),
//           ),
//           if (itemCount > 3)
//             Positioned(
//               right: 0,
//               bottom: 0,
//               child: Container(
//                 width: 40,
//                 height: 40,
//                 decoration: BoxDecoration(
//                   color: Colors.black.withOpacity(0.5),
//                   borderRadius: BorderRadius.only(
//                     bottomRight: Radius.circular(Dimensions.radiusSmall),
//                   ),
//                 ),
//                 child: Center(
//                   child: Text(
//                     "+${itemCount - 3}",
//                     style: const TextStyle(
//                       color: Colors.white,
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//         ],
//       );
//     }
//   }
//
//
//   Widget _buildOrderItem(BuildContext context, Item item, int index, List<Item> items) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Padding(
//           padding: EdgeInsets.zero,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 item.foodName,
//                 style: robotoBold(context).copyWith(
//                   fontSize: Dimensions.fontSizeDefault(context),
//                   color: Theme.of(context).hintColor,
//                 ),
//               ),
//               Row(
//                 children: [
//                   if (item.variationName != null) ...[
//                     RichText(
//                       text: TextSpan(
//                         text: "Size: ",
//                         style: robotoBold(context).copyWith(
//                           fontSize: Dimensions.fontSizeSmall(context),
//                           color: Theme.of(context).hintColor,
//                         ),
//                         children: [
//                           TextSpan(
//                             text: item.variationName!,
//                             style: robotoRegular(context).copyWith(
//                               fontSize: Dimensions.fontSizeSmall(context),
//                               color: Theme.of(context).hintColor,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     const SizedBox(width: Dimensions.paddingSizeExtraLarge),
//                   ],
//                   RichText(
//                     text: TextSpan(
//                       text: "Price: ",
//                       style: robotoBold(context).copyWith(
//                         fontSize: Dimensions.fontSizeSmall(context),
//                         color: Theme.of(context).hintColor,
//                       ),
//                       children: [
//                         TextSpan(
//                           text: item.unitPrice,
//                           style: robotoRegular(context).copyWith(
//                             fontSize: Dimensions.fontSizeSmall(context),
//                             color: Theme.of(context).hintColor,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(width: Dimensions.paddingSizeExtraLarge),
//                   Text(
//                     "X ${item.quantity}",
//                     style: robotoBold(context).copyWith(
//                       fontSize: Dimensions.fontSizeSmall(context),
//                       color: Theme.of(context).hintColor,
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//         if (index < items.length - 1) const Divider(),
//       ],
//     );
//   }
// }
//
//
// class CompleteOrderListState extends StatefulWidget {
//   const CompleteOrderListState({super.key});
//
//   @override
//   State<CompleteOrderListState> createState() => _CompleteOrderListStateState();
// }
//
// class _CompleteOrderListStateState extends State<CompleteOrderListState> {
//   final RefreshController _refreshController = RefreshController(initialRefresh: false);
//   List<bool> isExpandedList = [];
//
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       Provider.of<TakeOrderProvider>(context, listen: false).getCompleteOrders(context);
//     });
//   }
//
//   @override
//   void dispose() {
//     _refreshController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Consumer<TakeOrderProvider>(
//       builder: (context, orderProvider, child) {
//         // Check if data is loading
//         final isLoading =
//             orderProvider.completePageIndex == 1;
//
//         if (isLoading) {
//           return const Center(child: CircularProgressIndicator());
//         }
//
//         if (orderProvider.completeOrdersData.isEmpty) {
//           return Center(
//             child: Text(
//               "No completed orders",
//               style: robotoMedium(context).copyWith(
//                 fontSize: Dimensions.fontSizeLarge(context),
//                 color: Theme.of(context).hintColor,
//               ),
//             ),
//           );
//         }
//
//         return SmartRefresher(
//           controller: _refreshController,
//           enablePullUp: orderProvider.completeShowMore ?? false,
//           onRefresh: () async {
//             final result = await orderProvider.getCompleteOrders(context, isRefreshComplete: true);
//             if (result) {
//               _refreshController.refreshCompleted();
//             } else {
//               _refreshController.refreshFailed();
//             }
//           },
//           onLoading: () async {
//             final result = await orderProvider.getCompleteOrders(context);
//             if (result) {
//               _refreshController.loadComplete();
//             } else {
//               _refreshController.loadNoData();
//             }
//           },
//           child: ListView.separated(
//             padding: EdgeInsets.all(Dimensions.paddingSizeLarge),
//             itemCount: orderProvider.completeOrdersData.length,
//             separatorBuilder: (context, index) =>
//             const SizedBox(height: Dimensions.paddingSizeSmall),
//             itemBuilder: (context, index) {
//               final order = orderProvider.completeOrdersData[index];
//               if (isExpandedList.length <= index) {
//                 isExpandedList.add(false);
//               }
//               return _buildOrderCard(context, order, index);
//             },
//           ),
//         );
//       },
//     );
//   }
//
//   Widget _buildOrderCard(BuildContext context, OrderComplete order, int index) {
//     return Card(
//       child: InkWell(
//         onTap: () {
//           setState(() {
//             isExpandedList[index] = !isExpandedList[index];
//           });
//         },
//         child: Container(
//           padding: EdgeInsets.all(Dimensions.paddingSizeSmall),
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
//           ),
//           child: Column(
//             children: <Widget>[
//               // Order header with number and table/vehicle info
//               Padding(
//                 padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: <Widget>[
//                     RichText(
//                       text: TextSpan(
//                         text: "Order #: ",
//                         style: robotoBold(context).copyWith(
//                           fontSize: Dimensions.fontSizeSmall(context),
//                           color: Theme.of(context).hintColor,
//                         ),
//                         children: [
//                           TextSpan(
//                             text: order.orderNumber,
//                             style: robotoRegular(context).copyWith(
//                               fontSize: Dimensions.fontSizeSmall(context),
//                               color: Theme.of(context).hintColor,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     if (order.table != null)
//                       RichText(
//                         text: TextSpan(
//                           text: "Table: ",
//                           style: robotoBold(context).copyWith(
//                             fontSize: Dimensions.fontSizeSmall(context),
//                             color: Theme.of(context).hintColor,
//                           ),
//                           children: [
//                             TextSpan(
//                               text: order.table!.tableName,
//                               style: robotoRegular(context).copyWith(
//                                 fontSize: Dimensions.fontSizeSmall(context),
//                                 color: Theme.of(context).hintColor,
//                               ),
//                             ),
//                           ],
//                         ),
//                       )
//                     else if (order.vehicleNumber != null)
//                       RichText(
//                         text: TextSpan(
//                           text: "Vehicle: ",
//                           style: robotoBold(context).copyWith(
//                             fontSize: Dimensions.fontSizeSmall(context),
//                             color: Theme.of(context).hintColor,
//                           ),
//                           children: [
//                             TextSpan(
//                               text: order.vehicleNumber!,
//                               style: robotoRegular(context).copyWith(
//                                 fontSize: Dimensions.fontSizeSmall(context),
//                                 color: Theme.of(context).hintColor,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                   ],
//                 ),
//               ),
//
//               if (isExpandedList[index]) ...[
//                 SizedBox(height: Dimensions.paddingSizeSmall),
//                 DottedDivider(
//                   color: Theme.of(context).hintColor.withOpacity(0.6),
//                 ),
//                 SizedBox(height: Dimensions.paddingSizeSmall),
//
//                 // Order items
//                 Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: <Widget>[
//                     // Food images grid
//                     if (order.items.isNotEmpty)
//                       SizedBox(
//                         width: 80,
//                         child: _buildFoodImagesGrid(order.items),
//                       ),
//                     SizedBox(width: Dimensions.paddingSizeSmall),
//
//                     // Food details
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           ...order.items.asMap().entries.map((entry) =>
//                               _buildOrderItem(context, entry.value, entry.key, order.items)
//                           ).toList(),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: Dimensions.paddingSizeSmall),
//                 const Divider(),
//                 SizedBox(height: Dimensions.paddingSizeSmall),
//               ],
//
//               // Footer with total and status
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: <Widget>[
//                   RichText(
//                     text: TextSpan(
//                       text: "Total: ",
//                       style: robotoBold(context).copyWith(
//                         fontSize: Dimensions.fontSizeSmall(context),
//                         color: Theme.of(context).hintColor,
//                       ),
//                       children: [
//                         TextSpan(
//                           text: order.total,
//                           style: robotoRegular(context).copyWith(
//                             fontSize: Dimensions.fontSizeSmall(context),
//                             color: Theme.of(context).hintColor,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Container(
//                     width: 80,
//                     padding: EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
//                       color: Colors.green.withOpacity(0.7),
//                     ),
//                     alignment: Alignment.center,
//                     child: Text(
//                       "Complete",
//                       style: robotoBold(context).copyWith(
//                         fontSize: Dimensions.fontSizeSmall(context),
//                         color: Theme.of(context).cardColor,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildFoodImagesGrid(List<ItemComplete> items) {
//     final itemCount = items.length;
//
//     if (itemCount == 1) {
//       return ClipRRect(
//         borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
//         child: CustomImageWidget(
//           image: "http://ice_cream_restaurant.test/${items[0].foodImage}",
//           placeholder: "assets/images/placeholder.png",
//           fit: BoxFit.cover,
//         ),
//       );
//     } else if (itemCount == 2) {
//       return GridView.count(
//         crossAxisCount: 2,
//         crossAxisSpacing: 1,
//         mainAxisSpacing: 1,
//         shrinkWrap: true,
//         physics: const NeverScrollableScrollPhysics(),
//         children: items.take(2).map((item) =>
//             ClipRRect(
//               borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
//               child: CustomImageWidget(
//                 image: "http://ice_cream_restaurant.test/${item.foodImage}",
//                 placeholder: "assets/images/placeholder.png",
//                 fit: BoxFit.cover,
//               ),
//             ),
//         ).toList(),
//       );
//     } else {
//       return Stack(
//         children: [
//           GridView.count(
//             crossAxisCount: 2,
//             crossAxisSpacing: 1,
//             mainAxisSpacing: 1,
//             shrinkWrap: true,
//             physics: const NeverScrollableScrollPhysics(),
//             children: items.take(3).map((item) =>
//                 ClipRRect(
//                   borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
//                   child: CustomImageWidget(
//                     image: "http://ice_cream_restaurant.test/${item.foodImage}",
//                     placeholder: "assets/images/placeholder.png",
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//             ).toList(),
//           ),
//           if (itemCount > 3)
//             Positioned(
//               right: 0,
//               bottom: 0,
//               child: Container(
//                 width: 40,
//                 height: 40,
//                 decoration: BoxDecoration(
//                   color: Colors.black.withOpacity(0.5),
//                   borderRadius: BorderRadius.only(
//                     bottomRight: Radius.circular(Dimensions.radiusSmall),
//                   ),
//                 ),
//                 child: Center(
//                   child: Text(
//                     "+${itemCount - 3}",
//                     style: const TextStyle(
//                       color: Colors.white,
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//         ],
//       );
//     }
//   }
//
//   Widget _buildOrderItem(BuildContext context, ItemComplete item, int index, List<ItemComplete> items) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Padding(
//           padding: EdgeInsets.zero,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 item.foodName,
//                 style: robotoBold(context).copyWith(
//                   fontSize: Dimensions.fontSizeDefault(context),
//                   color: Theme.of(context).hintColor,
//                 ),
//               ),
//               Row(
//                 children: [
//                   if (item.variationName != null) ...[
//                     RichText(
//                       text: TextSpan(
//                         text: "Size: ",
//                         style: robotoBold(context).copyWith(
//                           fontSize: Dimensions.fontSizeSmall(context),
//                           color: Theme.of(context).hintColor,
//                         ),
//                         children: [
//                           TextSpan(
//                             text: item.variationName!,
//                             style: robotoRegular(context).copyWith(
//                               fontSize: Dimensions.fontSizeSmall(context),
//                               color: Theme.of(context).hintColor,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     const SizedBox(width: Dimensions.paddingSizeExtraLarge),
//                   ],
//                   RichText(
//                     text: TextSpan(
//                       text: "Price: ",
//                       style: robotoBold(context).copyWith(
//                         fontSize: Dimensions.fontSizeSmall(context),
//                         color: Theme.of(context).hintColor,
//                       ),
//                       children: [
//                         TextSpan(
//                           text: item.unitPrice,
//                           style: robotoRegular(context).copyWith(
//                             fontSize: Dimensions.fontSizeSmall(context),
//                             color: Theme.of(context).hintColor,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(width: Dimensions.paddingSizeExtraLarge),
//                   Text(
//                     "X ${item.quantity}",
//                     style: robotoBold(context).copyWith(
//                       fontSize: Dimensions.fontSizeSmall(context),
//                       color: Theme.of(context).hintColor,
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//         if (index < items.length - 1) const Divider(),
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_flutter_app/common/widgets/dotted_divider.dart';
import 'package:restaurant_flutter_app/providers/take_order_provider.dart';
import 'package:restaurant_flutter_app/util/styles.dart';
import 'package:restaurant_flutter_app/util/app_constants.dart';

import '../../screens/home_bottom_navbar.dart';
import '../common/widgets/custom_image_widget.dart';
import '../models/complete_orders_model.dart';
import '../models/pending_orders_model.dart';
import '../util/dimensions.dart';

class OrderStatusScreen extends StatefulWidget {
  const OrderStatusScreen({super.key});

  @override
  State<OrderStatusScreen> createState() => _OrderStatusScreenState();
}

class _OrderStatusScreenState extends State<OrderStatusScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final RefreshController _refreshController = RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabSelection);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TakeOrderProvider>(context, listen: false).getPendingOrders(context);
    });
  }

  void _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      final orderProvider = Provider.of<TakeOrderProvider>(context, listen: false);
      if (_tabController.index == 0) {
        orderProvider.getPendingOrders(context);
      } else {
        orderProvider.getCompleteOrders(context);
      }
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabSelection);
    _tabController.dispose();
    _refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).cardColor,
        title: const Text("Orders List"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => HomeBottomNavbar(pageIndex: 0)),
                  (route) => false,
            );
          },
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Theme.of(context).primaryColor,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Theme.of(context).primaryColor,
          dividerColor: Theme.of(context).disabledColor.withValues(alpha: 0.3),
          tabs: const [
            Tab(text: "Pending"),
            Tab(text: "Complete"),
          ],
        ),
      ),
      body: SafeArea(
        bottom: true,
        child: TabBarView(
          controller: _tabController,
          children: [
            _buildPendingOrdersList(),
            _buildCompleteOrdersList(),
          ],
        ),
      ),
    );
  }

  Widget _buildPendingOrdersList() {
    return Consumer<TakeOrderProvider>(
      builder: (context, orderProvider, child) {
        final isLoading = orderProvider.pageIndex == 1;

        return SmartRefresher(
          controller: _refreshController,
          enablePullDown: true,
          enablePullUp: orderProvider.showMore ?? false,
          onRefresh: () async {
            final result = await orderProvider.getPendingOrders(context, isRefresh: true);
            if (result) {
              _refreshController.refreshCompleted();
            } else {
              _refreshController.refreshFailed();
            }
          },
          onLoading: () async {
            final result = await orderProvider.getPendingOrders(context);
            if (result) {
              _refreshController.loadComplete();
            } else {
              _refreshController.loadNoData();
            }
          },
          child: orderProvider.pendingOrdersData.isEmpty && !isLoading
              ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "No pending orders",
                  style: robotoMedium(context).copyWith(
                    fontSize: Dimensions.fontSizeLarge(context),
                    color: Theme.of(context).hintColor,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  "Pull down to refresh",
                  style: robotoRegular(context).copyWith(
                    fontSize: Dimensions.fontSizeSmall(context),
                    color: Theme.of(context).hintColor,
                  ),
                ),
              ],
            ),
          )
              : isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView.separated(
            padding: EdgeInsets.all(Dimensions.paddingSizeLarge),
            itemCount: orderProvider.pendingOrdersData.length,
            separatorBuilder: (context, index) =>
            const SizedBox(height: Dimensions.paddingSizeSmall),
            itemBuilder: (context, index) {
              final order = orderProvider.pendingOrdersData[index];
              return _buildOrderCard(context, order);
            },
          ),
        );
      },
    );
  }

  Widget _buildCompleteOrdersList() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TakeOrderProvider>(context, listen: false).getCompleteOrders(context);
    });

    return const CompleteOrderListState();
  }

  Widget _buildOrderCard(BuildContext context, Order order) {
    return Card(
      child: Container(
        padding: EdgeInsets.all(Dimensions.paddingSizeSmall),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
        ),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  RichText(
                    text: TextSpan(
                      text: "Order #: ",
                      style: robotoBold(context).copyWith(
                        fontSize: Dimensions.fontSizeSmall(context),
                        color: Theme.of(context).hintColor,
                      ),
                      children: [
                        TextSpan(
                          text: order.orderNumber,
                          style: robotoRegular(context).copyWith(
                            fontSize: Dimensions.fontSizeSmall(context),
                            color: Theme.of(context).hintColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (order.table != null)
                    RichText(
                      text: TextSpan(
                        text: "Table: ",
                        style: robotoBold(context).copyWith(
                          fontSize: Dimensions.fontSizeSmall(context),
                          color: Theme.of(context).hintColor,
                        ),
                        children: [
                          TextSpan(
                            text: order.table!.tableName,
                            style: robotoRegular(context).copyWith(
                              fontSize: Dimensions.fontSizeSmall(context),
                              color: Theme.of(context).hintColor,
                            ),
                          ),
                        ],
                      ),
                    )
                  else if (order.vehicleNumber != null)
                    RichText(
                      text: TextSpan(
                        text: "Vehicle: ",
                        style: robotoBold(context).copyWith(
                          fontSize: Dimensions.fontSizeSmall(context),
                          color: Theme.of(context).hintColor,
                        ),
                        children: [
                          TextSpan(
                            text: order.vehicleNumber!,
                            style: robotoRegular(context).copyWith(
                              fontSize: Dimensions.fontSizeSmall(context),
                              color: Theme.of(context).hintColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),

            SizedBox(height: Dimensions.paddingSizeSmall),
            DottedDivider(
              color: Theme.of(context).hintColor.withOpacity(0.6),
            ),
            SizedBox(height: Dimensions.paddingSizeSmall),

            Stack(
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    if (order.items.isNotEmpty)
                      SizedBox(
                        width: 80,
                        child: _buildFoodImagesGrid(order.items),
                      ),
                    SizedBox(width: Dimensions.paddingSizeSmall),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ...order.items.asMap().entries.map((entry) =>
                              _buildOrderItem(context, entry.value, entry.key, order.items)
                          ).toList(),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: Dimensions.paddingSizeSmall),
            const Divider(),
            SizedBox(height: Dimensions.paddingSizeSmall),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                RichText(
                  text: TextSpan(
                    text: "Total: ",
                    style: robotoBold(context).copyWith(
                      fontSize: Dimensions.fontSizeSmall(context),
                      color: Theme.of(context).hintColor,
                    ),
                    children: [
                      TextSpan(
                        text: order.total,
                        style: robotoRegular(context).copyWith(
                          fontSize: Dimensions.fontSizeSmall(context),
                          color: Theme.of(context).hintColor,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 80,
                  padding: EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                    color: Colors.amber.withOpacity(0.7),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    order.status,
                    style: robotoBold(context).copyWith(
                      fontSize: Dimensions.fontSizeSmall(context),
                      color: Theme.of(context).hintColor,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFoodImagesGrid(List<Item> items) {
    final itemCount = items.length;

    if (itemCount == 1) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
        child: CustomImageWidget(
          image: AppConstants.getImageUrl(items[0].foodImage),
          placeholder: "assets/images/placeholder.png",
          fit: BoxFit.cover,
        ),
      );
    } else if (itemCount == 2) {
      return GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 1,
        mainAxisSpacing: 1,
        shrinkWrap: true,
        childAspectRatio: 0.6,
        physics: const NeverScrollableScrollPhysics(),
        children: items.take(2).map((item) =>
            ClipRRect(
              borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
              child: CustomImageWidget(
                image: AppConstants.getImageUrl(item.foodImage),
                placeholder: "assets/images/placeholder.png",
                fit: BoxFit.cover,
              ),
            ),
        ).toList(),
      );
    } else if (itemCount == 3) {
      return Column(
        children: [
          SizedBox(
            height: 40,
            child: Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(Dimensions.radiusSmall),
                    ),
                    child: CustomImageWidget(
                      image: AppConstants.getImageUrl(items[0].foodImage),
                      placeholder: "assets/images/placeholder.png",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(width: 1),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(Dimensions.radiusSmall),
                    ),
                    child: CustomImageWidget(
                      image: AppConstants.getImageUrl(items[1].foodImage),
                      placeholder: "assets/images/placeholder.png",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 1),
          ClipRRect(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(Dimensions.radiusSmall),
              bottomRight: Radius.circular(Dimensions.radiusSmall),
            ),
            child: CustomImageWidget(
              image: AppConstants.getImageUrl(items[2].foodImage),
              placeholder: "assets/images/placeholder.png",
              fit: BoxFit.cover,
              height: 40,
            ),
          ),
        ],
      );
    } else {
      return Stack(
        children: [
          GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 1,
            mainAxisSpacing: 1,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: items.take(3).map((item) =>
                ClipRRect(
                  borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                  child: CustomImageWidget(
                    image: AppConstants.getImageUrl(item.foodImage),
                    placeholder: "assets/images/placeholder.png",
                    fit: BoxFit.cover,
                  ),
                ),
            ).toList(),
          ),
          if (itemCount > 3)
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(Dimensions.radiusSmall),
                  ),
                ),
                child: Center(
                  child: Text(
                    "+${itemCount - 3}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
        ],
      );
    }
  }

  Widget _buildOrderItem(BuildContext context, Item item, int index, List<Item> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.zero,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.foodName,
                style: robotoBold(context).copyWith(
                  fontSize: Dimensions.fontSizeDefault(context),
                  color: Theme.of(context).hintColor,
                ),
              ),
              Row(
                children: [
                  if (item.variationName != null) ...[
                    RichText(
                      text: TextSpan(
                        text: "Size: ",
                        style: robotoBold(context).copyWith(
                          fontSize: Dimensions.fontSizeSmall(context),
                          color: Theme.of(context).hintColor,
                        ),
                        children: [
                          TextSpan(
                            text: item.variationName!,
                            style: robotoRegular(context).copyWith(
                              fontSize: Dimensions.fontSizeSmall(context),
                              color: Theme.of(context).hintColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: Dimensions.paddingSizeExtraLarge),
                  ],
                  RichText(
                    text: TextSpan(
                      text: "Price: ",
                      style: robotoBold(context).copyWith(
                        fontSize: Dimensions.fontSizeSmall(context),
                        color: Theme.of(context).hintColor,
                      ),
                      children: [
                        TextSpan(
                          text: item.unitPrice,
                          style: robotoRegular(context).copyWith(
                            fontSize: Dimensions.fontSizeSmall(context),
                            color: Theme.of(context).hintColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: Dimensions.paddingSizeExtraLarge),
                  Text(
                    "X ${item.quantity}",
                    style: robotoBold(context).copyWith(
                      fontSize: Dimensions.fontSizeSmall(context),
                      color: Theme.of(context).hintColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        if (index < items.length - 1) const Divider(),
      ],
    );
  }
}

class CompleteOrderListState extends StatefulWidget {
  const CompleteOrderListState({super.key});

  @override
  State<CompleteOrderListState> createState() => _CompleteOrderListStateState();
}

class _CompleteOrderListStateState extends State<CompleteOrderListState> {
  final RefreshController _refreshController = RefreshController(initialRefresh: false);
  List<bool> isExpandedList = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TakeOrderProvider>(context, listen: false).getCompleteOrders(context);
    });
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TakeOrderProvider>(
      builder: (context, orderProvider, child) {
        final isLoading = orderProvider.completePageIndex == 1;

        return SmartRefresher(
          controller: _refreshController,
          enablePullDown: true,
          enablePullUp: orderProvider.completeShowMore ?? false,
          onRefresh: () async {
            final result = await orderProvider.getCompleteOrders(context, isRefreshComplete: true);
            if (result) {
              _refreshController.refreshCompleted();
            } else {
              _refreshController.refreshFailed();
            }
          },
          onLoading: () async {
            final result = await orderProvider.getCompleteOrders(context);
            if (result) {
              _refreshController.loadComplete();
            } else {
              _refreshController.loadNoData();
            }
          },
          child: orderProvider.completeOrdersData.isEmpty && !isLoading
              ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "No completed orders",
                  style: robotoMedium(context).copyWith(
                    fontSize: Dimensions.fontSizeLarge(context),
                    color: Theme.of(context).hintColor,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  "Pull down to refresh",
                  style: robotoRegular(context).copyWith(
                    fontSize: Dimensions.fontSizeSmall(context),
                    color: Theme.of(context).hintColor,
                  ),
                ),
              ],
            ),
          )
              : isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView.separated(
            padding: EdgeInsets.all(Dimensions.paddingSizeLarge),
            itemCount: orderProvider.completeOrdersData.length,
            separatorBuilder: (context, index) =>
            const SizedBox(height: Dimensions.paddingSizeSmall),
            itemBuilder: (context, index) {
              final order = orderProvider.completeOrdersData[index];
              if (isExpandedList.length <= index) {
                isExpandedList.add(false);
              }
              return _buildOrderCard(context, order, index);
            },
          ),
        );
      },
    );
  }

  Widget _buildOrderCard(BuildContext context, OrderComplete order, int index) {
    return Card(
      child: InkWell(
        onTap: () {
          setState(() {
            isExpandedList[index] = !isExpandedList[index];
          });
        },
        child: Container(
          padding: EdgeInsets.all(Dimensions.paddingSizeSmall),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
          ),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    RichText(
                      text: TextSpan(
                        text: "Order #: ",
                        style: robotoBold(context).copyWith(
                          fontSize: Dimensions.fontSizeSmall(context),
                          color: Theme.of(context).hintColor,
                        ),
                        children: [
                          TextSpan(
                            text: order.orderNumber,
                            style: robotoRegular(context).copyWith(
                              fontSize: Dimensions.fontSizeSmall(context),
                              color: Theme.of(context).hintColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (order.table != null)
                      RichText(
                        text: TextSpan(
                          text: "Table: ",
                          style: robotoBold(context).copyWith(
                            fontSize: Dimensions.fontSizeSmall(context),
                            color: Theme.of(context).hintColor,
                          ),
                          children: [
                            TextSpan(
                              text: order.table!.tableName,
                              style: robotoRegular(context).copyWith(
                                fontSize: Dimensions.fontSizeSmall(context),
                                color: Theme.of(context).hintColor,
                              ),
                            ),
                          ],
                        ),
                      )
                    else if (order.vehicleNumber != null)
                      RichText(
                        text: TextSpan(
                          text: "Vehicle: ",
                          style: robotoBold(context).copyWith(
                            fontSize: Dimensions.fontSizeSmall(context),
                            color: Theme.of(context).hintColor,
                          ),
                          children: [
                            TextSpan(
                              text: order.vehicleNumber!,
                              style: robotoRegular(context).copyWith(
                                fontSize: Dimensions.fontSizeSmall(context),
                                color: Theme.of(context).hintColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),

              if (isExpandedList[index]) ...[
                SizedBox(height: Dimensions.paddingSizeSmall),
                DottedDivider(
                  color: Theme.of(context).hintColor.withOpacity(0.6),
                ),
                SizedBox(height: Dimensions.paddingSizeSmall),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    if (order.items.isNotEmpty)
                      SizedBox(
                        width: 80,
                        child: _buildFoodImagesGrid(order.items),
                      ),
                    SizedBox(width: Dimensions.paddingSizeSmall),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ...order.items.asMap().entries.map((entry) =>
                              _buildOrderItem(context, entry.value, entry.key, order.items)
                          ).toList(),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: Dimensions.paddingSizeSmall),
                const Divider(),
                SizedBox(height: Dimensions.paddingSizeSmall),
              ],

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  RichText(
                    text: TextSpan(
                      text: "Total: ",
                      style: robotoBold(context).copyWith(
                        fontSize: Dimensions.fontSizeSmall(context),
                        color: Theme.of(context).hintColor,
                      ),
                      children: [
                        TextSpan(
                          text: order.total,
                          style: robotoRegular(context).copyWith(
                            fontSize: Dimensions.fontSizeSmall(context),
                            color: Theme.of(context).hintColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 80,
                    padding: EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                      color: Colors.green.withOpacity(0.7),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      "Complete",
                      style: robotoBold(context).copyWith(
                        fontSize: Dimensions.fontSizeSmall(context),
                        color: Theme.of(context).cardColor,
                      ),
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

  Widget _buildFoodImagesGrid(List<ItemComplete> items) {
    final itemCount = items.length;

    if (itemCount == 1) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
        child: CustomImageWidget(
          image: AppConstants.getImageUrl(items[0].foodImage),
          placeholder: "assets/images/placeholder.png",
          fit: BoxFit.cover,
        ),
      );
    } else if (itemCount == 2) {
      return GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 1,
        mainAxisSpacing: 1,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: items.take(2).map((item) =>
            ClipRRect(
              borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
              child: CustomImageWidget(
                image: AppConstants.getImageUrl(item.foodImage),
                placeholder: "assets/images/placeholder.png",
                fit: BoxFit.cover,
              ),
            ),
        ).toList(),
      );
    } else {
      return Stack(
        children: [
          GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 1,
            mainAxisSpacing: 1,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: items.take(3).map((item) =>
                ClipRRect(
                  borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                  child: CustomImageWidget(
                    image: AppConstants.getImageUrl(item.foodImage),
                    placeholder: "assets/images/placeholder.png",
                    fit: BoxFit.cover,
                  ),
                ),
            ).toList(),
          ),
          if (itemCount > 3)
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(Dimensions.radiusSmall),
                  ),
                ),
                child: Center(
                  child: Text(
                    "+${itemCount - 3}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
        ],
      );
    }
  }

  Widget _buildOrderItem(BuildContext context, ItemComplete item, int index, List<ItemComplete> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.zero,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.foodName,
                style: robotoBold(context).copyWith(
                  fontSize: Dimensions.fontSizeDefault(context),
                  color: Theme.of(context).hintColor,
                ),
              ),
              Row(
                children: [
                  if (item.variationName != null) ...[
                    RichText(
                      text: TextSpan(
                        text: "Size: ",
                        style: robotoBold(context).copyWith(
                          fontSize: Dimensions.fontSizeSmall(context),
                          color: Theme.of(context).hintColor,
                        ),
                        children: [
                          TextSpan(
                            text: item.variationName!,
                            style: robotoRegular(context).copyWith(
                              fontSize: Dimensions.fontSizeSmall(context),
                              color: Theme.of(context).hintColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: Dimensions.paddingSizeExtraLarge),
                  ],
                  RichText(
                    text: TextSpan(
                      text: "Price: ",
                      style: robotoBold(context).copyWith(
                        fontSize: Dimensions.fontSizeSmall(context),
                        color: Theme.of(context).hintColor,
                      ),
                      children: [
                        TextSpan(
                          text: item.unitPrice,
                          style: robotoRegular(context).copyWith(
                            fontSize: Dimensions.fontSizeSmall(context),
                            color: Theme.of(context).hintColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: Dimensions.paddingSizeExtraLarge),
                  Text(
                    "X ${item.quantity}",
                    style: robotoBold(context).copyWith(
                      fontSize: Dimensions.fontSizeSmall(context),
                      color: Theme.of(context).hintColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        if (index < items.length - 1) const Divider(),
      ],
    );
  }
}