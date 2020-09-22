import 'package:flutter/material.dart';
import 'package:shop_app/misc/route_generator.dart';
import 'package:shop_app/providers/auth_provider.dart';
import 'package:shop_app/providers/cart_provider.dart';
import 'package:shop_app/providers/order_provider.dart';
import 'package:provider/provider.dart';

import './providers/products_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //*To use provider we need to wrap the most top widget with ChangeNotiferProvider
    //*In this case it is our Main App()

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AuthProvider(),
        ),
        ChangeNotifierProxyProvider<AuthProvider, ProductsProvider>(
          //* In provider 3.0 version , use 'builder' property instead of 'create'
          update: (context, auth, previousProduct) => ProductsProvider(
            auth.token,
            auth.userId,
            previousProduct == null ? [] : previousProduct.getProducts,
          ),
          create: (BuildContext context) => ProductsProvider(
            '',
            '',
            [],
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => Cart(),
        ),
        ChangeNotifierProxyProvider<AuthProvider, Orders>(
          create: (context) => Orders(null, [], null),
          update: (BuildContext context, auth, Orders previous) => Orders(
            auth.token,
            previous == null ? [] : previous.orderItmes,
            auth.userId,
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Store App',
        theme: ThemeData(
          primarySwatch: Colors.teal,
          accentColor: Colors.tealAccent[100],
          visualDensity: VisualDensity.adaptivePlatformDensity,
          fontFamily: 'Lato',
        ),
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        // home: authData.isAuth
        //     ? ProdcutOverviewScreen()
        //     : FutureBuilder(
        //         future: authData.autoLogin(),
        //         builder: (ctx, authSnapshot) =>
        //             authSnapshot.connectionState == ConnectionState.waiting
        //                 ? SplashScreen()
        //                 : AuthScreen(),
        //       ),
        onGenerateRoute: RouteGenerator.generateRoute,
      ),
    );
  }
}
