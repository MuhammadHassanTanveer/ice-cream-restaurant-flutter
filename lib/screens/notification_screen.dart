import 'package:flutter/material.dart';

import '../../common/widgets/custom_app_bar_widget.dart';

import '../../util/dimensions.dart';
import '../../util/styles.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(
        title: "Notifications" ,
        isBackButtonExist: true,
        centerTitle: true,
        titleStyle: robotoBold(context).copyWith(
          fontSize: Dimensions.fontSizeOverLarge(context),
        ),
      ),
      body: SafeArea(
        bottom: true,
        child: Padding(
          padding: EdgeInsets.all(Dimensions.paddingSizeDefault),
          child: ListView.separated(
            itemBuilder: (context, index){
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                  child: IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width: 70,
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor.withValues(alpha: 0.2 ),
                            borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text("22",
                                  style: robotoBold(context).copyWith(
                                    fontSize: Dimensions.fontSizeLarge(context),
                                    // color: Theme.of(context).cardColor,
                                  ),
                                ),
                                const SizedBox(height: Dimensions.paddingSizeExtraSmall,),
                                Text("January",
                                  style: robotoBold(context).copyWith(
                                    fontSize: Dimensions.fontSizeDefault(context),
                                    // color: Theme.of(context).cardColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: Dimensions.paddingSizeSmall,),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text("Notification Title", style: robotoBold(context),),
                              const SizedBox(height: Dimensions.paddingSizeSmall,),
                              Text("Lorem Ipsum is simply dummy text of the printing and typesetting industry. ",
                                textAlign: TextAlign.justify,
                                maxLines: 2,
                                style: robotoRegular(context).copyWith(fontSize: Dimensions.fontSizeSmall(context)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
            separatorBuilder: (context, index) => const SizedBox(
              height: Dimensions.paddingSizeExtraSmall,
            ),
            itemCount: 10,
          ),
        ),
      ),
    );
  }
}
