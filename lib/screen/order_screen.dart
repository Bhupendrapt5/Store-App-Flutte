import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/order_provider.dart';
import 'package:shop_app/widget/app_drawer.dart';
import 'package:shop_app/widget/order_item.dart';

class OrderScreen extends StatelessWidget {
  Future<void> _refreshScreen(BuildContext context, _ordersProvider) async {
    await _ordersProvider.fetchOrders();
  }

  @override
  Widget build(BuildContext context) {
    final _ordersProvider = Provider.of<Orders>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text('Orders'),
      ),
      drawer: AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () => _refreshScreen(context, _ordersProvider),
        child: FutureBuilder(
            future: _ordersProvider.fetchOrders(),
            builder: (ctx, dataSnapshot) {
              if (dataSnapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                if (dataSnapshot != null) {
                  return Consumer<Orders>(
                    builder: (BuildContext context, orderData, Widget child) =>
                        ListView.builder(
                      itemBuilder: (_, i) {
                        return OrderItem(
                          order: orderData.orderItmes[i],
                        );
                      },
                      itemCount: orderData.orderItmes.length,
                    ),
                  );
                }
                return Center(
                  child: Text('No oreders yet..'),
                );
              }
            }),
      ),
    );
  }
}
