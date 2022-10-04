import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rioko/common/route_names.dart';
import 'package:rioko/view/authentication_page.dart';
import 'package:rioko/view/map_display.dart';
import 'package:rioko/viewmodel/map/map_service.dart';

final ChangeNotifierProvider<MapServiceViewModel> mapServiceProvider =
    ChangeNotifierProvider((_) => MapServiceViewModel());
void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  PageRouteBuilder customPageRoute(dynamic settings, Widget page) =>
      PageRouteBuilder(
        settings: settings,
        pageBuilder: (_, __, ___) => page,
        transitionsBuilder: (_, a, __, c) =>
            FadeTransition(opacity: a, child: c),
      );
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rioko',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MapDisplay(),
      debugShowCheckedModeBanner: false,
      initialRoute: RouteNames.authentication,
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case RouteNames.map:
            return customPageRoute(settings, const MapDisplay());
          default:
            return customPageRoute(settings, const AuthenticationPage());
        }
      },
    );
  }
}
