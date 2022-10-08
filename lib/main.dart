import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rioko/common/route_names.dart';
import 'package:rioko/view/authentication/authentication_page.dart';
import 'package:rioko/view/map/map_display.dart';
import 'package:rioko/viewmodel/firebase/authentication_view_model.dart';
import 'package:rioko/viewmodel/firebase/firestore_database_view_model.dart';
import 'package:rioko/viewmodel/geolocation/geolocation_view_model.dart';
import 'package:rioko/viewmodel/map/map_service.dart';

final ChangeNotifierProvider<MapServiceViewModel> mapServiceProvider =
    ChangeNotifierProvider((_) => MapServiceViewModel());
final ChangeNotifierProvider<AuthenticationViewModel> authenticationProvider =
    ChangeNotifierProvider((_) => AuthenticationViewModel());
final ChangeNotifierProvider<FirestoreDatabaseViewModel>
    firestoreDatabaseProvider =
    ChangeNotifierProvider((_) => FirestoreDatabaseViewModel());
final ChangeNotifierProvider<GeolocationViewModel> geolocationProvider =
    ChangeNotifierProvider((_) => GeolocationViewModel());
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
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
      navigatorKey: MyApp.navigatorKey,
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case RouteNames.map:
            return customPageRoute(settings, const MapDisplay());
          default:
            return customPageRoute(settings, AuthenticationPage());
        }
      },
    );
  }
}
