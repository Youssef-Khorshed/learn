import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_complete_project/Features/Sliver/presentation/widgets/custom_cateogriesitems.dart';

// ignore: must_be_immutable
class CustomSliverheaderdataitems extends StatelessWidget {
  double percent;
  CustomSliverheaderdataitems({super.key, required this.percent});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: AnimatedSwitcher(
          duration: Duration(milliseconds: 300),
          child: percent < 0.1
              ? Column(
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: 5,
                        ),
                        AutoSizeText(
                          'Fast',
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 6,
                        ),
                        AutoSizeText(
                          'Quality',
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 6,
                        ),
                        AutoSizeText(
                          'Serverice',
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.timer),
                        AutoSizeText(
                          '30-40 min',
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Icon(Icons.star_rounded),
                        AutoSizeText(
                          '4.8 rate',
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 6,
                        ),
                      ],
                    )
                  ],
                )
              : Container(
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: List.generate(
                      categories.length,
                      (index) => GestureDetector(
                        onTap: () {
                          print(
                              'Tapped on category: ${categories[index].title}');
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 10),
                          padding: EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: AutoSizeText(
                            categories[index].title,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                )),
    );
  }
}
