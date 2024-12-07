import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_complete_project/Features/Sliver/presentation/widgets/custom_sliverheaderDataitems.dart';

class CustomSliverpresistentheader extends StatelessWidget {
  const CustomSliverpresistentheader({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: HeaderDelegate(),
    );
  }
}

const double _maxHeaderExtend = 100.0;

class HeaderDelegate extends SliverPersistentHeaderDelegate {
  @override
  double get maxExtent => _maxHeaderExtend;

  @override
  double get minExtent => _maxHeaderExtend;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final percent = (shrinkOffset / _maxHeaderExtend);
    return Stack(
      children: [
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [Colors.grey, Colors.black])),
            height: _maxHeaderExtend,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      AnimatedOpacity(
                          opacity: percent > 0.1 ? 1 : 0,
                          duration: Duration(milliseconds: 300),
                          child: Icon(Icons.arrow_back)),
                      SizedBox(
                        width: 5,
                      ),
                      AnimatedSlide(
                        duration: const Duration(milliseconds: 300),
                        offset: Offset(percent < 0.1 ? -0.18 : 0.1, 0),
                        child: AutoSizeText(
                          'Youssef',
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  CustomSliverheaderdataitems(
                    percent: percent,
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
