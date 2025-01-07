import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CustomSliverappbar extends StatelessWidget {
  const CustomSliverappbar({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      leading: SizedBox(),
      expandedHeight: 200,
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.pin // fade  // none  // parallax
        ,
        stretchModes: [StretchMode.zoomBackground],
        background: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              width: double.infinity,
              child: CachedNetworkImage(
                fit: BoxFit.fill,
                imageUrl:
                    'https://artandcreativity.com/wp-content/uploads/2019/03/food-photography-101.jpg',
                placeholder: (context, url) =>
                    const Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            )
          ],
        ),
      ),
    );
  }
}
