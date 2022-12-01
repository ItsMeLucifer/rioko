import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rioko/common/color_palette.dart';
import 'package:rioko/common/route_names.dart';
import 'package:rioko/view/authentication/authentication_page.dart';
import 'package:rioko/view/data_completion/data_completion_page.dart';
import 'package:rioko/view/map/map_display.dart';
import 'package:rioko/viewmodel/base_view_model.dart';
import 'package:rioko/viewmodel/firebase/authentication_view_model.dart';
import 'package:rioko/viewmodel/firebase/firestore_database_view_model.dart';
import 'package:rioko/viewmodel/geolocation/geolocation_view_model.dart';
import 'package:rioko/viewmodel/map/add_new_place_view_model.dart';
import 'package:rioko/viewmodel/map/map_view_model.dart';
import 'package:rioko/viewmodel/registration/data_completion_view_model.dart';

final ChangeNotifierProvider<MapViewModel> mapProvider =
    ChangeNotifierProvider((_) => MapViewModel());
final ChangeNotifierProvider<AuthenticationViewModel> authenticationProvider =
    ChangeNotifierProvider((_) => AuthenticationViewModel());
final ChangeNotifierProvider<FirestoreDatabaseViewModel>
    firestoreDatabaseProvider =
    ChangeNotifierProvider((_) => FirestoreDatabaseViewModel());
final ChangeNotifierProvider<GeolocationViewModel> geolocationProvider =
    ChangeNotifierProvider((_) => GeolocationViewModel());
final ChangeNotifierProvider<AddNewPlaceViewModel> addNewPlaceProvider =
    ChangeNotifierProvider((_) => AddNewPlaceViewModel());
final ChangeNotifierProvider<BaseViewModel> baseProvider =
    ChangeNotifierProvider((_) {
  final mapVM = _.watch(mapProvider);
  final firestoreDBVM = _.watch(firestoreDatabaseProvider);
  final addNewPlaceVM = _.watch(addNewPlaceProvider);
  final geolocationVM = _.watch(geolocationProvider);
  final authVM = _.watch(authenticationProvider);
  return BaseViewModel(
    firestoreDBVM: firestoreDBVM,
    mapVM: mapVM,
    addNewPlaceVM: addNewPlaceVM,
    geolocationVM: geolocationVM,
    authVM: authVM,
  );
});
final ChangeNotifierProvider<DataCompletionViewModel> dataCompletionProvider =
    ChangeNotifierProvider((_) {
  final geolocationVM = _.watch(geolocationProvider);
  final authVM = _.watch(authenticationProvider);
  return DataCompletionViewModel(
    geolocationVM: geolocationVM,
    authVM: authVM,
  );
});
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
        colorScheme:
            ColorScheme.fromSwatch(primarySwatch: Colors.blue).copyWith(
          primary: ColorPalette.babyBlue,
        ),
        textTheme: ThemeData.light().textTheme.copyWith(
              headline1: const TextStyle(
                fontFamily: 'CeasarDressing',
                fontSize: 80,
                color: Colors.black,
              ),
            ),
        buttonTheme: ButtonThemeData(
            colorScheme:
                ColorScheme.fromSwatch(primarySwatch: Colors.pink).copyWith(
          background: ColorPalette.tickleMePink,
        )),
      ),
      home: const MapDisplay(),
      debugShowCheckedModeBanner: false,
      initialRoute: RouteNames.authentication,
      navigatorKey: MyApp.navigatorKey,
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case RouteNames.map:
            return customPageRoute(settings, const MapDisplay());
          case RouteNames.dataCompletion:
            return customPageRoute(settings, DataCompletionPage());
          default:
            return customPageRoute(settings, AuthenticationPage());
        }
      },
    );
  }
}
