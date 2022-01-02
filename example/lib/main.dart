import 'package:digibear_icons_flutter/digibear_icons_flutter.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Digibear Icons',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Digibear Icons'),
        ),
        body: const Center(
          child: DbIcon(
            DbIcons.superheroFill,
            size: 128,
          ),
        ),
      ),
    );
  }
}
