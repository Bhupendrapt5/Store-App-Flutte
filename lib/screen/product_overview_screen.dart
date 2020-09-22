import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/misc/routeNames.dart';
import 'package:shop_app/providers/cart_provider.dart';
import 'package:shop_app/providers/products_provider.dart';
import 'package:shop_app/widget/app_drawer.dart';

import '../widget/product_grid.dart';
import '../widget/badge.dart';

enum FilterItems {
  Favorites,
  All,
}

class ProdcutOverviewScreen extends StatefulWidget {
  @override
  _ProdcutOverviewScreenState createState() => _ProdcutOverviewScreenState();
}

class _ProdcutOverviewScreenState extends State<ProdcutOverviewScreen> {
  var _showFavoritesOnly = false; 

  @override
  Widget build(BuildContext context) {
    // final productProvider = Provider.of<ProductsProvider>(context, listen: false);

    return Scaffold(
        appBar: AppBar(
          title: Text('My Shop'),
          actions: [
            PopupMenuButton(
              itemBuilder: (_) => [
                PopupMenuItem(
                  child: Text('Only Favorites'),
                  value: FilterItems.Favorites,
                ),
                PopupMenuItem(
                  child: Text('Show All'),
                  value: FilterItems.All,
                ),
              ],
              onSelected: (FilterItems selectedValue) {
                setState(() {
                  if (selectedValue == FilterItems.Favorites) {
                    // productProvider.showOnlyFavorites();
                    _showFavoritesOnly = true;
                  } else {
                    // productProvider.showAll();
                    _showFavoritesOnly = false;
                  }
                });
                print('----> $selectedValue');
              },
              icon: Icon(Icons.more_vert),
            ),
            Consumer<Cart>(
              builder: (context, cart, ch) => Badge(
                child: ch,
                value: cart.cartItemLength.toString(),
              ),
              child: IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    RouteNames.cartScreen,
                  );
                },
              ),
            ),
          ],
        ),
        drawer: AppDrawer(),
        body: FutureBuilder(
          future: Provider.of<ProductsProvider>(context, listen: false)
              .fetchProducts(),
          builder: (ctx, dataSnapshot) {
            if (dataSnapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              if (dataSnapshot != null) {
                return ProductGrid(_showFavoritesOnly);
              }
              return Center(
                child: Text('Something went Wrong..'),
              );
            }
          },
        ));
  }
}
