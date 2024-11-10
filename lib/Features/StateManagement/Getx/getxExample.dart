import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Controller
class CounterController extends GetxController {
  var count = 0.obs;
  var items = <String>[].obs;
  bool get isEmpty => items.isEmpty;

  void increment() {
    count++;
    items.add('Item $count');
  }
}

// UI
class MyHomePage extends StatelessWidget {
  final CounterController controller = Get.put(CounterController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('GetX Example')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
                onPressed: () {
                  Get.off(() => MyHomePage());
                },
                child: Text('Increment')),
            Obx(() => Text('Counter: ${controller.count}')),
            Obx(() => controller.isEmpty
                ? Text('No items yet.')
                : Column(
                    children:
                        controller.items.map((item) => Text(item)).toList(),
                  )),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: controller.increment,
        child: Icon(Icons.add),
      ),
    );
  }
}
