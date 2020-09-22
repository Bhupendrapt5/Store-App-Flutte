import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/misc/routeNames.dart';
import 'package:shop_app/providers/product.dart';
import 'package:shop_app/providers/products_provider.dart';

class UserProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productItem = Provider.of<Product>(context, listen: false);
    final _scaffold = Scaffold.of(context);
    return ListTile(
      title: Text(productItem.title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(productItem.imageUrl),
        radius: 25,
      ),
      trailing: Container(
        width: MediaQuery.of(context).size.width * 0.25,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              icon: Icon(Icons.edit),
              color: Theme.of(context).primaryColor,
              onPressed: () {
                Navigator.pushNamed(context, RouteNames.addEditProductScreen,
                    arguments: productItem);
              },
            ),
            IconButton(
              icon: Icon(Icons.delete),
              color: Theme.of(context).errorColor,
              onPressed: () async {
                try {
                  await Provider.of<ProductsProvider>(context, listen: false)
                      .removeProduct(id: productItem.id);
                } catch (error) {
                  _scaffold.showSnackBar(SnackBar(
                    content: Text(
                      'Deleting failed..!!',
                      textAlign: TextAlign.center,
                    ),
                  ));
                  // await showDialog(
                  //   context: context,
                  //   builder: (ctx) => AlertDialog(
                  //     title: Text('An error occurred!'),
                  //     content: Text('Something went wrong.'),
                  //     actions: <Widget>[
                  //       FlatButton(
                  //         child: Text('Okay'),
                  //         onPressed: () {
                  //           Navigator.of(ctx).pop();
                  //         },
                  //       )
                  //     ],
                  //   ),
                  // );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
