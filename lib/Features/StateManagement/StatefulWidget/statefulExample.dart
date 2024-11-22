import 'package:flutter/material.dart';

class Statefulexample extends StatefulWidget {
  const Statefulexample({super.key});

// first state
  @override
  State<Statefulexample> createState() => _StatefulexampleState();
}

class _StatefulexampleState extends State<Statefulexample> {
  @override
  // TODO: implement mounted
  bool get mounted => super.mounted;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }

  @override
  void didUpdateWidget(covariant Statefulexample oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
  }

  //fifth state
  @override
  void setState(VoidCallback fn) {
    // TODO: implement setState
    super.setState(fn);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

// create -> mounted -> didchangeDependencies -> initState ->  build ->  didupdatewidget -> setstate -> dispose   // 8 states
}
