import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/misc/routeNames.dart';
import 'package:shop_app/providers/auth_provider.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: Text('Hello User'),
            automaticallyImplyLeading: false,
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.shop),
            title: Text('Shop'),
            onTap: () {
              Navigator.pushReplacementNamed(
                  context, RouteNames.productOverviewScreen);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text('Your Orders'),
            onTap: () {
              Navigator.pushReplacementNamed(context, RouteNames.orderScreen);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text('Add/Manage Products'),
            onTap: () {
              Navigator.pushReplacementNamed(
                  context, RouteNames.userProductScreen);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: () {
              Navigator.pop(context);
              Provider.of<AuthProvider>(context, listen: false).logOut();

              Navigator.pushReplacementNamed(context, RouteNames.homeScreen);
            },
          ),
        ],
      ),
    );
  }
}
