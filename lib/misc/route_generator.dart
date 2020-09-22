import 'package:flutter/material.dart';
import 'package:shop_app/misc/page_transition.dart';
import 'package:shop_app/misc/routeNames.dart';
import 'package:shop_app/screen/add_edit_product_screen.dart';
import 'package:shop_app/screen/auth_screen.dart';
import 'package:shop_app/screen/cart_screen.dart';
import 'package:shop_app/screen/order_screen.dart';
import 'package:shop_app/screen/prodcut_detail_screen.dart';
import 'package:shop_app/screen/product_overview_screen.dart';
import 'package:shop_app/screen/splash_screen.dart';
import 'package:shop_app/screen/user_product_screen.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Getting arguments passed in while calling Navigator.pushNamed

    switch (settings.name) {
      case '/':
        return SlideRightRoute(
          page: SplashScreen(),
          settings: settings,
        );
        break;
      case RouteNames.homeScreen:
        return SlideRightRoute(
          page: AuthScreen(),
          settings: settings,
        );
        break;
      case RouteNames.auth_screen:
        return SlideRightRoute(
          page: AuthScreen(),
          settings: settings,
        );
        break;
      case RouteNames.productOverviewScreen:
        return SlideRightRoute(
          settings: settings,
          page: ProdcutOverviewScreen(),
        );
        break;
      case RouteNames.productDetailScreen:
        return MaterialPageRoute(
            builder: (_) => ProductDetailScreen(), settings: settings);
        break;
      case RouteNames.cartScreen:
        return SlideRightRoute(
          settings: settings,
          page: CartScreen(),
        );
        break;
      case RouteNames.orderScreen:
        return SlideRightRoute(
          settings: settings,
          page: OrderScreen(),
        );
        break;
      case RouteNames.userProductScreen:
        return SlideRightRoute(
          settings: settings,
          page: UserProductScreen(),
        );
        break;
      case RouteNames.addEditProductScreen:
        return SlideRightRoute(
          settings: settings,
          page: AddEditProductScreen(),
        );
        break;
      default:
        // If there is no such named route in the switch statement, e.g. /third
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Sorry!'),
        ),
        body: Center(
          child: Text('Something went wrong'),
        ),
      );
    });
  }
}
