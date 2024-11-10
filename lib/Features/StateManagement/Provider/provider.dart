import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CounterNotifier extends ChangeNotifier {
  int counter = 0;
  bool get isEmpty => items.isEmpty;
  List<String> items = [];
  void increment() {
    counter = counter + 1;
    items = List.from(items)..add('Item $counter');
    notifyListeners();
  }
}

// UI
class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final countState = context.read<CounterNotifier>();
    return Scaffold(
      appBar: AppBar(title: Text('Riverpod Example')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Consumer<CounterNotifier>(
              builder: (context, countState, child) {
                return Text('Counter: ${countState.counter}');
              },
            ),
            if (!countState.isEmpty)
              ...countState.items.map((item) => Text(item)).toList(),
            if (countState.isEmpty) Text('No items yet.'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => countState..increment(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
