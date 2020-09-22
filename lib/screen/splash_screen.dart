import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/misc/routeNames.dart';
import 'package:shop_app/providers/auth_provider.dart';
import 'package:shop_app/widget/loading_widget.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _authProvider = Provider.of<AuthProvider>(context, listen: false);
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ),
    );
    _navigateToHome(context, _authProvider);
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'My Shop App',
            style: TextStyle(
              color: Colors.black,
              fontSize: 48.0,
              letterSpacing: 2,
            ),
          ),
          Loading()
        ],
      ),
    );
  }

  void _navigateToHome(BuildContext context, AuthProvider _authProvider) async {
    await _authProvider.autoLogin();
    String routeName;

    Timer(
      Duration(seconds: 3),
      () async {
        if (_authProvider.isAuth) {
          routeName = RouteNames.productOverviewScreen;
        } else {
          routeName = RouteNames.auth_screen;
        }
        // ignore: unawaited_futures
        Navigator.pushReplacementNamed(context, routeName);
      },
    );
  }
}
