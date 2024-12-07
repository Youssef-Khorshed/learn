import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomFoodtitle extends StatelessWidget {
  String title;
  CustomFoodtitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(delegate: FoodTitle(title: title));
  }
}

class FoodTitle extends SliverPersistentHeaderDelegate {
  String title;
  bool isvisible = true;
  FoodTitle({required this.title});

  @override
  double get maxExtent => 60;

  @override
  double get minExtent => 50;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Visibility(
        visible: title == "Fried Foods" ? false : true,
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            AutoSizeText(
              title,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
