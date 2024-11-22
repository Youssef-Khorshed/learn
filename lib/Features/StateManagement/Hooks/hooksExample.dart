import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class Hooksexample extends HookWidget {
  const Hooksexample({super.key});

  @override
  Widget build(BuildContext context) {
    ValueNotifier<int> counter =
        useState(0); // like setState in stateful widget
    useEffect(() {
      print('counter is $counter'); // for initial state
      return; // for end of useEffect like dispose method
    }, [counter]);
    return const Placeholder();
  }
}
