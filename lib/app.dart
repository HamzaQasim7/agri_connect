import 'package:agriconnect/app_theme.dart';
import 'package:agriconnect/bloc/authentication/authentication.dart';
import 'package:agriconnect/data/authentication/authentication_repository.dart';
import 'package:agriconnect/data/farm/resources/repository.dart';
import 'package:agriconnect/ui/farm/news/bloc/nBloc.dart';
import 'package:agriconnect/ui/farm/news/bloc/nEvent.dart';
import 'package:agriconnect/ui/farm/news_details/bloc/dBloc.dart';
import 'package:agriconnect/ui/farm/news_details/bloc/dState.dart';
import 'package:agriconnect/ui/home_page.dart';
import 'package:agriconnect/ui/login/login_page.dart';
import 'package:agriconnect/ui/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import 'data/farm/view_model/cityEntryViewModel.dart';
import 'data/farm/view_model/weather_app_forecast_viewmodel.dart';

class App extends StatelessWidget {
  final AuthenticationRepository _authenticationRepository =
      AuthenticationRepository();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        BlocProvider<AuthenticationBloc>(
            create: (_) => AuthenticationBloc(
                authenticationRepository: _authenticationRepository)),
        BlocProvider<NewsBloc>(
          create: (_) =>
              NewsBloc(repository: Repository())..add(Fetch(type: 'Science')),
        ),
        BlocProvider<DetailBloc>(
          create: (_) => DetailBloc(LoadingDetail()),
        ),
        ChangeNotifierProvider<ForecastViewModel>(
            create: (_) => ForecastViewModel()),
        ChangeNotifierProvider<CityEntryViewModel>(
            create: (_) => CityEntryViewModel()),
      ],
      child: MultiRepositoryProvider(
        providers: [
          RepositoryProvider<AuthenticationRepository>.value(
            value: _authenticationRepository,
          ),
        ],
        child: AppView(),
      ),
    );
  }
}

class AppView extends StatefulWidget {
  @override
  _AppViewState createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  NavigatorState? get _navigator => _navigatorKey.currentState;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AgriConnect',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppTheme.nearlyGreen,
        hintColor: AppTheme.nearlyGreen,
        appBarTheme: AppTheme.appBarTheme,
        scaffoldBackgroundColor: AppTheme.background,
        textTheme: AppTheme.textTheme,
        inputDecorationTheme: AppTheme.inputDecorationTheme,
      ),
      navigatorKey: _navigatorKey,
      builder: (context, child) {
        return BlocListener<AuthenticationBloc, AuthenticationState>(
          listener: (context, state) {
            switch (state.status) {
              case AuthenticationStatus.authenticated:
                _navigator!.pushAndRemoveUntil<void>(
                  HomePage.route(),
                  (route) => false,
                );
                break;
              case AuthenticationStatus.unauthenticated:
                _navigator!.pushAndRemoveUntil<void>(
                  LoginPage.route(),
                  (route) => false,
                );
                break;
              default:
                break;
            }
          },
          child: child,
        );
      },
      onGenerateRoute: (_) => SplashPage.route(),
    );
  }
}
