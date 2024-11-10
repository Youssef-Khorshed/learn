import 'package:flutter/material.dart';
import 'package:flutter_complete_project/Features/Maps/Data/Model/autoCompleteModel.dart';

class PlaceItem extends StatelessWidget {
  final Predictions suggestion;

  const PlaceItem({Key? key, required this.suggestion}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var subTitle = suggestion.description!
        .replaceAll(suggestion.description!.split(',')[0], '');
    return Container(
      width: double.infinity,
      margin: const EdgeInsetsDirectional.all(8),
      padding: const EdgeInsetsDirectional.all(4),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(8)),
      child: Column(
        children: [
          ListTile(
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                  shape: BoxShape.circle, color: Colors.blue.shade300),
              child: const Icon(
                Icons.place,
                color: Colors.blue,
              ),
            ),
            title: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '${suggestion.description!.split(',')[0]}\n',
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: subTitle,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
