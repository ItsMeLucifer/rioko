import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rioko/view/map_display.dart';
import 'package:rioko/viewmodel/map/map_service.dart';

final ChangeNotifierProvider<MapServiceViewModel> mapServiceProvider =
    ChangeNotifierProvider((_) => MapServiceViewModel());
void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rioko',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MapDisplay(),
    );
  }
}
