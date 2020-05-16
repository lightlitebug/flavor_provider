import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proxyprov/providers/app_config.dart';
import 'package:proxyprov/providers/auth.dart';
import 'package:proxyprov/providers/get_data.dart';

import 'package:proxyprov/screens/dashboard_screen.dart';
import 'package:proxyprov/screens/login_screen.dart';

class MyApp extends StatelessWidget {
  final appConfiguration;

  MyApp(this.appConfiguration);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AppConfig>.value(
          value: appConfiguration,
        ),
        ChangeNotifierProxyProvider<AppConfig, AuthProvider>(
            create: (_) => AuthProvider(),
            update: (_, appConfig, authNotifier) {
              authNotifier.appConfig = appConfig;
              return authNotifier;
            }),
        ChangeNotifierProxyProvider2<AppConfig, AuthProvider, GetDataProvider>(
          create: (_) => GetDataProvider(),
          update: (_, appConfig, auth, getDataNotifier) {
            getDataNotifier.appConfig = appConfig;
            getDataNotifier.auth = auth;
            return getDataNotifier;
          },
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: LoginScreen(),
        routes: {
          LoginScreen.routeName: (context) => LoginScreen(),
          DashboardScreen.routeName: (context) => DashboardScreen(),
        },
      ),
    );
  }
}
