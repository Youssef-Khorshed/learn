import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_complete_project/Features/TTD/Presentation/logic/bloc/weather_bloc.dart';

class Weatherwidget extends StatelessWidget {
  const Weatherwidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Weather'),
          elevation: 0,
          centerTitle: true,
        ),
        body: ListView(
          children: [
            Center(
                child: Column(
              children: [
                TextField(
                    key: Key('cityname'),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'City Name',
                    )),
                // BlocBuilder<WeatherBloc, WeatherState>(
                //   builder: (context, state) {
                //     if(state is WeatherLoading )
                //     return DataTable(
                //       columns: [
                //         DataColumn(label: Text('Property')),
                //         DataColumn(label: Text('Value')),
                //       ],
                //       rows: [
                //         DataRow(cells: [
                //           DataCell(Text('Temperature')),
                //           DataCell(Text('${weather.temp}°C')),
                //         ]),
                //         DataRow(cells: [
                //           DataCell(Text('Description')),
                //           DataCell(Text(weather.description)),
                //         ]),
                //         DataRow(cells: [
                //           DataCell(Text('Icon')),
                //           DataCell(Text(weather.icon)),
                //         ]),
                //         DataRow(cells: [
                //           DataCell(Text('Main')),
                //           DataCell(Text(weather.main)),
                //         ]),
                //         DataRow(cells: [
                //           DataCell(Text('Pressure')),
                //           DataCell(Text('${weather.pressure} hPa')),
                //         ]),
                //         DataRow(cells: [
                //           DataCell(Text('Humidity')),
                //           DataCell(Text('${weather.humidity}%')),
                //         ]),
                //       ],
                //     );
                //   },
                // ),
              ],
            ))
          ],
        ));
  }
}
