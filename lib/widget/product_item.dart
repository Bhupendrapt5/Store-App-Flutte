import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/auth_provider.dart';
import 'package:shop_app/providers/cart_provider.dart';

import '../providers/product.dart';
import '../misc/routeNames.dart';

class ProductItem extends StatelessWidget {
  // final Product _productItem;

  // const _ProductItem({Key key, this._productItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _productItem = Provider.of<Product>(context, listen: false);
    final _cartProvider = Provider.of<Cart>(context, listen: false);
    final _authProvider = Provider.of<AuthProvider>(context, listen: false);
    final _scaffold = Scaffold.of(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: InkWell(
          onTap: () => Navigator.of(context).pushNamed(
            RouteNames.productDetailScreen,
            arguments: _productItem.id,
          ),
          child: Hero(
            tag: _productItem.id,
            child: FadeInImage(
              placeholder: AssetImage('assets/images/product-placeholder.png'),
              image: NetworkImage(
                _productItem.imageUrl,
              ),
              fit: BoxFit.fitHeight,
            ),
          ),
        ),
        footer: GridTileBar(
          leading: IconButton(
            icon: Consumer<Product>(
              builder: (context, value, child) => Icon(
                value.isFavorite ? Icons.favorite : Icons.favorite_border,
              ),
            ),
            onPressed: () async {
              try {
                await _productItem.toggleFavoriteStatus(
                  token: _authProvider.token,
                  userId: _authProvider.userId,
                );
              } catch (error) {
                _scaffold.showSnackBar(SnackBar(
                  content: Text(
                    'Could not update',
                  ),
                  action: SnackBarAction(
                    label: 'Ok',
                    onPressed: () => _scaffold.hideCurrentSnackBar(),
                  ),
                  duration: Duration(seconds: 2),
                ));
              }
            },
            color: Theme.of(context).accentColor,
          ),
          backgroundColor: Colors.black87,
          title: Text(
            _productItem.title,
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              _cartProvider.addCartItem(
                productId: _productItem.id,
                price: _productItem.price,
                title: _productItem.title,
              );
              Scaffold.of(context).hideCurrentSnackBar();
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Text('Added ${_productItem.title} to cart..'),
                duration: Duration(seconds: 2),
                action: SnackBarAction(
                    label: 'Undo',
                    onPressed: () {
                      _cartProvider.removeLatestItem(_productItem.id);
                    }),
              ));
            },
            color: Theme.of(context).accentColor,
          ),
        ),
      ),
    );
  }
}
