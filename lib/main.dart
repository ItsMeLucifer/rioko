import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rioko/common/color_palette.dart';
import 'package:rioko/common/route_names.dart';
import 'package:rioko/view/authentication/authentication_page.dart';
import 'package:rioko/view/data_completion/data_completion_page.dart';
import 'package:rioko/view/friends/friend_requests_page.dart';
import 'package:rioko/view/friends/friend_search_page.dart';
import 'package:rioko/view/friends/friends_page.dart';
import 'package:rioko/view/leaderboard/leaderboard_page.dart';
import 'package:rioko/view/map/map_display.dart';
import 'package:rioko/view/profile/profile_page.dart';
import 'package:rioko/viewmodel/base_view_model.dart';
import 'package:rioko/viewmodel/firebase/authentication_view_model.dart';
import 'package:rioko/viewmodel/firebase/firestore_database_view_model.dart';
import 'package:rioko/viewmodel/friends/friends_view_model.dart';
import 'package:rioko/viewmodel/geolocation/geolocation_view_model.dart';
import 'package:rioko/viewmodel/map/add_new_trip_view_model.dart';
import 'package:rioko/viewmodel/map/map_view_model.dart';
import 'package:rioko/viewmodel/map/trip_details_view_model.dart';
import 'package:rioko/viewmodel/leaderboard/leaderboard_view_model.dart';
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
final ChangeNotifierProvider<AddNewTripViewModel> addNewTripProvider =
    ChangeNotifierProvider((_) => AddNewTripViewModel());
final ChangeNotifierProvider<FriendsViewModel> friendsProvider =
    ChangeNotifierProvider((_) => FriendsViewModel());
final ChangeNotifierProvider<BaseViewModel> baseProvider =
    ChangeNotifierProvider((_) {
  final mapVM = _.watch(mapProvider);
  final firestoreDBVM = _.watch(firestoreDatabaseProvider);
  final addNewTripVM = _.watch(addNewTripProvider);
  final geolocationVM = _.watch(geolocationProvider);
  final authVM = _.watch(authenticationProvider);
  final friendsVM = _.watch(friendsProvider);
  return BaseViewModel(
    firestoreDBVM: firestoreDBVM,
    mapVM: mapVM,
    addNewTripVM: addNewTripVM,
    geolocationVM: geolocationVM,
    authVM: authVM,
    friendsVM: friendsVM,
  );
});
final ChangeNotifierProvider<DataCompletionViewModel> dataCompletionProvider =
    ChangeNotifierProvider((_) => DataCompletionViewModel());
final ChangeNotifierProvider<TripDetailsViewModel> tripDetailsProvider =
    ChangeNotifierProvider((_) => TripDetailsViewModel());
final ChangeNotifierProvider<LeaderboardViewModel> leaderboardProvider =
    ChangeNotifierProvider((_) => LeaderboardViewModel());

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    final authVM = ref.watch(authenticationProvider);
    return MaterialApp(
      title: 'Rioko',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        backgroundColor: Colors.white,
        colorScheme:
            ColorScheme.fromSwatch(primarySwatch: Colors.blue).copyWith(
          primary: ColorPalette.babyBlue,
          secondary: ColorPalette.tickleMePink,
          onSecondary: ColorPalette.cyclamen,
          tertiary: Colors.black,
        ),
        textTheme: ThemeData.light().textTheme.copyWith(
              headlineLarge: const TextStyle(
                fontFamily: 'CeasarDressing',
                fontSize: 80,
                color: Colors.black,
              ),
              headlineSmall: const TextStyle(
                color: Colors.black,
                fontSize: 18,
              ),
              bodyLarge: const TextStyle(
                fontSize: 16,
                color: ColorPalette.cyclamen,
                fontWeight: FontWeight.bold,
              ),
              bodySmall: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
        buttonTheme: ButtonThemeData(
          colorScheme:
              ColorScheme.fromSwatch(primarySwatch: Colors.pink).copyWith(
            background: ColorPalette.tickleMePink,
          ),
        ),
        listTileTheme: ListTileThemeData(
          tileColor: Colors.grey[300],
          textColor: Colors.grey[500],
        ),
        progressIndicatorTheme: const ProgressIndicatorThemeData(
          color: ColorPalette.tickleMePink,
        ),
        useMaterial3: true,
      ),
      home: const MapDisplay(),
      debugShowCheckedModeBanner: false,
      initialRoute: RouteNames.authentication,
      navigatorKey: MyApp.navigatorKey,
      onGenerateRoute: (settings) {
        if (authVM.currentUser == null) {
          return customPageRoute(settings, const AuthenticationPage());
        }
        switch (settings.name) {
          case RouteNames.map:
            return customPageRoute(settings, const MapDisplay());
          case RouteNames.dataCompletion:
            return customPageRoute(settings, DataCompletionPage());
          case RouteNames.friends:
            return customPageRoute(settings, const FriendsPage());
          case RouteNames.friendRequests:
            return customPageRoute(settings, const FriendRequestsPage());
          case RouteNames.searchFriends:
            return customPageRoute(settings, const FriendSearchPage());
          case RouteNames.profile:
            return customPageRoute(settings, const ProfilePage());
          case RouteNames.leaderboard:
            return customPageRoute(settings, const LeaderboardPage());
          default:
            return customPageRoute(settings, const AuthenticationPage());
        }
      },
    );
  }
}
