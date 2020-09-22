import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/misc/routeNames.dart';
import 'package:shop_app/providers/products_provider.dart';
import 'package:shop_app/widget/app_drawer.dart';
import 'package:shop_app/widget/user_product_item.dart';

class UserProductScreen extends StatelessWidget {
  Future<void> _refreshScreen(BuildContext context) async {
    await Provider.of<ProductsProvider>(context, listen: false)
        .fetchProducts(filterByUser: true);
  }

  @override
  Widget build(BuildContext context) {
    // final _productsProvider = Provider.of<ProductsProvider>(context);
    print('User Prodcut Screen...');
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Products'),
      ),
      drawer: AppDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, RouteNames.addEditProductScreen);
        },
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder(
          future: _refreshScreen(context),
          builder: (BuildContext context, AsyncSnapshot<dynamic> dataSnapshot) {
            if (dataSnapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              if (dataSnapshot != null) {
                return RefreshIndicator(
                  onRefresh: () => _refreshScreen(context),
                  child: Consumer<ProductsProvider>(
                    builder: (BuildContext context, _productsProvider,
                            Widget child) =>
                        Padding(
                      padding: const EdgeInsets.all(16),
                      child: ListView.builder(
                        itemBuilder: (_, i) => ChangeNotifierProvider.value(
                          value: _productsProvider.getProducts[i],
                          child: Column(children: [
                            UserProductItem(),
                            Divider(),
                          ]),
                        ),
                        itemCount: _productsProvider.getProducts.length,
                      ),
                    ),
                  ),
                );
              }
              return Center(
                child: Text('Something went Wrong..'),
              );
            }
          }),
    );
  }
}
