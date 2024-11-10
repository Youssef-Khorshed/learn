import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_complete_project/Features/Maps/Presentation/Logic/cubit/maps/maps_cubit.dart';
import 'package:flutter_complete_project/Features/Maps/Presentation/UI/widgets/place_item.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:material_floating_search_bar_2/material_floating_search_bar_2.dart';
import 'package:uuid/uuid.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  FloatingSearchBarController controller = FloatingSearchBarController();
  @override
  Widget build(BuildContext context) {
    final c = context.watch<MapsCubit>();
    return Stack(
      children: [
        FloatingSearchBar(
          controller: controller,
          onQueryChanged: (query) async {
            final sessionToken = const Uuid().v4();
            await c.emitPlaceSuggestions(
                searchQuery: query, sessionToken: sessionToken);
          },
          hint: 'Search...',
          builder: (context, transition) {
            return c.state is PlacesLoaded
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: 400, child: buildPlacesList()),
                    ],
                  )
                : Text('No items ${c.predictions.length}');
          },
        ),
      ],
    );
  }

  Widget buildPlacesList() {
    final c = context.watch<MapsCubit>();
    return ListView.builder(
      itemCount: c.predictions.length,
      itemBuilder: (context, index) {
        return InkWell(
            onTap: () async {
              final sessionToken = const Uuid().v4();
              setState(() {
                c.destinationInfo = c.predictions[index].description!;
              });
              await c.emitPlaceLocation(
                  c.predictions[index].placeId!, sessionToken);
              controller.close();
            },
            child: PlaceItem(suggestion: c.predictions[index]));
      },
    );
  }
}
