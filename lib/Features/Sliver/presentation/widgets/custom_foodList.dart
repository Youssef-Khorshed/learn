import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_complete_project/Features/Sliver/presentation/widgets/custom_cateogriesitems.dart';

Widget customFoodList({required int index}) {
  if (index == 0) {
    return _buildSliverList();
  } else if (index == 1) {
    return _buildSliverGrid();
  } else if (index == 2) {
    return _buildSliverToBoxAdapter();
  } else {
    return _buildThankYouMessage();
  }
}

Widget _buildSliverList() {
  return SliverList(
    delegate: SliverChildBuilderDelegate(
      (context, index) {
        final foodItem = categories[index].items[index];

        return _buildListTile(foodItem);
      },
      childCount: categories[0].items.length,
    ),
  );
}

Widget _buildListTile(foodItem) {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8.0),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.2),
          blurRadius: 6.0,
          spreadRadius: 2.0,
        ),
      ],
    ),
    margin: EdgeInsets.symmetric(vertical: 8.0),
    child: ListTile(
      leading: _buildImage(foodItem.imageUrl),
      title: _buildTitle(foodItem.title),
      subtitle: _buildSubtitle(foodItem.description),
    ),
  );
}

Widget _buildSliverGrid() {
  return SliverGrid(
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      crossAxisSpacing: 8.0,
      mainAxisSpacing: 8.0,
    ),
    delegate: SliverChildBuilderDelegate(
      (context, index) {
        final foodItem = categories[2].items[index];

        return _buildGridItem(foodItem);
      },
      childCount: categories[2].items.length,
    ),
  );
}

Widget _buildGridItem(foodItem) {
  return GestureDetector(
    onTap: () {
      print('Tapped on ${foodItem.title}');
    },
    child: Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4.0,
            spreadRadius: 2.0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12.0),
            child: CachedNetworkImage(
              imageUrl: foodItem.imageUrl,
              errorWidget: (context, url, error) => Icon(Icons.error),
              placeholder: (context, url) => CircularProgressIndicator(),
              fit: BoxFit.cover,
              width: double.infinity,
              height: 120,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AutoSizeText(
                  foodItem.title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 4),
                Container(
                  height: 30,
                  child: AutoSizeText(
                    foodItem.description,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade800,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _buildSliverToBoxAdapter() {
  return SliverToBoxAdapter(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(
        categories[2].items.length,
        (index) => Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AutoSizeText(
                  categories[2].items[index].title,
                  style: TextStyle(color: Colors.white),
                ),
                Container(
                  height: 100,
                  width: 200,
                  child: AutoSizeText(
                    categories[2].items[index].description,
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ],
            ),
            Spacer(),
            Container(
              height: 100,
              width: 100,
              child: CachedNetworkImage(
                imageUrl: categories[3].items[index].imageUrl,
                errorWidget: (context, url, error) => Icon(Icons.error),
                placeholder: (context, url) => CircularProgressIndicator(),
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _buildThankYouMessage() {
  return SliverToBoxAdapter(
    child: Center(
      child: AutoSizeText(
        'Thank You for Visiting Us',
        style: TextStyle(
            fontSize: 15, color: Colors.white, fontWeight: FontWeight.bold),
      ),
    ),
  );
}

Widget _buildImage(String imageUrl) {
  return CachedNetworkImage(
    imageUrl: imageUrl,
    errorWidget: (context, url, error) => Icon(Icons.error),
    placeholder: (context, url) => CircularProgressIndicator(),
    width: 50,
    height: 50,
    fit: BoxFit.cover,
  );
}

Widget _buildTitle(String title) {
  return AutoSizeText(
    title,
    style: TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
    ),
  );
}

Widget _buildSubtitle(String description) {
  return Text(
    description,
    style: TextStyle(
      color: Color(0xFFFAFAFA),
    ),
  );
}
