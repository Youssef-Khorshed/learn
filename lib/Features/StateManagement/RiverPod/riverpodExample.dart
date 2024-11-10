import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// void main() {
//   // wrap the entire app with a ProviderScope so that widgets
//   // will be able to read providers
//   runApp(ProviderScope(
//     child: MyApp(),
//   ));
// }

// Provider
final counterProvider = ChangeNotifierProvider<CounterNotifier>((ref) {
  return CounterNotifier();
});

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
class MyHomePage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final countState = ref.watch(counterProvider);

    return Scaffold(
      appBar: AppBar(title: Text('Riverpod Example')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Counter: ${countState.counter}'),
            if (!countState.isEmpty)
              ...countState.items.map((item) => Text(item)).toList(),
            if (countState.isEmpty) Text('No items yet.'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => countState..increment(),
        child: Icon(Icons.add),
      ),
    );
  }
}
