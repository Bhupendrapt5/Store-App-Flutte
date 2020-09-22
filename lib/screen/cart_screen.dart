import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart_provider.dart';
import 'package:shop_app/providers/order_provider.dart';
import 'package:shop_app/widget/cart_itme.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total',
                    style: TextStyle(fontSize: 20),
                  ),
                  Spacer(),
                  Chip(
                    label: Consumer<Cart>(
                      builder: (context, cart, child) => Text(
                        '\$${cart.totalAmount.toStringAsFixed(2)}',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  OrderButton(cart: _cart),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 16,
          ),
          Expanded(
            child: ListView.builder(
              itemBuilder: (_, index) {
                return CartItem(
                  id: _cart.items.values.toList()[index].id,
                  price: _cart.items.values.toList()[index].price,
                  title: _cart.items.values.toList()[index].title,
                  quantity: _cart.items.values.toList()[index].quantity,
                  productId: _cart.items.keys.toList()[index],
                );
              },
              itemCount: _cart.cartItemLength,
            ),
          ),
        ],
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key key,
    @required Cart cart,
  })  : _cart = cart,
        super(key: key);

  final Cart _cart;

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading = false;
  @override
  Widget build(BuildContext context) {
    final _scaffold = Scaffold.of(context);
    return FlatButton(
      onPressed: (widget._cart.totalAmount <= 0 || _isLoading)
          ? null
          : () async {
              setState(() {
                _isLoading = true;
              });
              try {
                await Provider.of<Orders>(
                  context,
                  listen: false,
                ).addOrder(
                  cartProducts: widget._cart.items.values.toList(),
                  totalAmount: widget._cart.totalAmount,
                );
                widget._cart.clearCart();
              } catch (error) {
                _scaffold.showSnackBar(SnackBar(
                  content: Text(
                    'Something went wrong. Could not Place order yet....',
                  ),
                  action: SnackBarAction(
                    label: 'Ok',
                    onPressed: () => _scaffold.hideCurrentSnackBar(),
                  ),
                  duration: Duration(seconds: 2),
                ));
              }
              setState(() {
                _isLoading = false;
              });
            },
      child: _isLoading
          ? SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
              width: MediaQuery.of(context).size.height * 0.02,
              child: CircularProgressIndicator())
          : Text(
              'Order Now',
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
    );
  }
}
