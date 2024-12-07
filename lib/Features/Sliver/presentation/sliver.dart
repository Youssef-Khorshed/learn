import 'package:flutter/material.dart';
import 'package:flutter_complete_project/Features/Sliver/presentation/widgets/custom_cateogriesitems.dart';
import 'package:flutter_complete_project/Features/Sliver/presentation/widgets/custom_foodList.dart';
import 'package:flutter_complete_project/Features/Sliver/presentation/widgets/custom_foodTitle.dart';
import 'package:flutter_complete_project/Features/Sliver/presentation/widgets/custom_sliverappbar.dart';
import 'package:flutter_complete_project/Features/Sliver/presentation/widgets/custom_sliverpresistentheader.dart';

class SliverExample extends StatelessWidget {
  const SliverExample({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Scrollbar(
          radius: Radius.circular(0),
          child: CustomScrollView(
            slivers: [
              CustomSliverappbar(),
              CustomSliverpresistentheader(),
              for (int i = 0; i < categories.length; i++) ...[
                CustomFoodtitle(title: categories[i].title),
                customFoodList(index: i)
              ],
            ],
          ),
        ),
      ),
    );
  }
}
