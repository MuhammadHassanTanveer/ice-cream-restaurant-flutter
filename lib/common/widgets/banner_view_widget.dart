import 'package:carousel_slider/carousel_slider.dart';
import 'package:restaurant_flutter_app/common/widgets/custom_asset_image_widget.dart';
import '../../util/dimensions.dart';
import '../../util/styles.dart';
import 'package:flutter/material.dart';
// import 'package:shimmer_animation/shimmer_animation.dart';

class BannerViewWidget extends StatelessWidget {
  const BannerViewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Container(
        width: size.width,
        height:215,
        padding: const EdgeInsets.only(top: Dimensions.paddingSizeDefault),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CarouselSlider.builder(
              options: CarouselOptions(
                aspectRatio: 2.5,
                enlargeFactor: 0.3,
                autoPlay: true,
                enlargeCenterPage: true,
                disableCenter: true,
                autoPlayInterval: const Duration(seconds: 7),
                onPageChanged: (index, reason) {
                  // homeController.setCurrentIndex(index, true);
                },
              ),
              itemCount: 1,
              itemBuilder: (context, index, _) {
                return InkWell(
                  onTap: () {},
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme
                          .of(context)
                          .cardColor,
                      borderRadius: BorderRadius.circular(
                          Dimensions.radiusSmall),
                      boxShadow: [
                        BoxShadow(color: Colors.grey.withValues(alpha: 0.1),
                            spreadRadius: 1,
                            blurRadius: 2,
                            offset: const Offset(0, 1))
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(
                          Dimensions.radiusSmall),
                      child: CustomAssetImageWidget("assets/images/banner1.jpg", fit: BoxFit.cover,),
                      // CustomImageWidget(
                      //   image: 'assets/images/banner1.jpg',
                      //   fit: BoxFit.cover,
                      // ),
                    ),
                  ),
                );
              }
                ),
            const SizedBox(height: Dimensions.paddingSizeExtraSmall),
            // Pagination indicators
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(1, (index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 3),
                  child: index == 1
                      ? Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                    child: Text(
                      '${index + 1}/1',
                      style: robotoRegular(context).copyWith(color: Colors.white, fontSize: 12),
                    ),
                  )
                      : Container(
                    height: 4.18,
                    width: 5.57,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                    ),
                  ),
                );
              }),
            ),
          ],
        )
    //         : Padding(
    // padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
    // child: ClipRRect(
    // borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
    // child: Shimmer(
    // child: Container(decoration: BoxDecoration(
    // borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
    // color: Theme.of(context).shadowColor,
    // )),
    // ),
    // ),
    // ),
      );
  }

}
