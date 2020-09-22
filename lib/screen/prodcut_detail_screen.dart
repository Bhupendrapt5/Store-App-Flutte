import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products_provider.dart';

class ProductDetailScreen extends StatelessWidget {
  // final String productId;

  // const ProductDetailScreen({Key key, this.productId}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    //Extracting Product model Data, passed from ProductItem
    final productId = ModalRoute.of(context).settings.arguments as String;
    final loadProduct = Provider.of<ProductsProvider>(
      context,
      listen: false,
    ).findById(productId);

    var _topMargin = 0.0;

    var _appBarSize = AppBar().preferredSize.height;

    return Scaffold(
      body: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          var sizeDiff = notification.metrics.maxScrollExtent - _appBarSize;
          if (notification.metrics.pixels > sizeDiff) {
            _topMargin = notification.metrics.pixels - sizeDiff + 16;

            Provider.of<ProductsProvider>(
              context,
              listen: false,
            ).topMargin = _topMargin;
          } else {
            _topMargin =
                _topMargin <= 0 ? 0 : notification.metrics.pixels - sizeDiff;

            Provider.of<ProductsProvider>(
              context,
              listen: false,
            ).topMargin = _topMargin;
          }
          return null;
        },
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: MediaQuery.of(context).size.height * 0.3,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(loadProduct.title),
                background: Hero(
                  tag: loadProduct.id,
                  child: FadeInImage(
                    placeholder:
                        AssetImage('assets/images/product-placeholder.png'),
                    image: NetworkImage(
                      loadProduct.imageUrl,
                    ),
                    fit: BoxFit.fitHeight,
                  ),
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Consumer<ProductsProvider>(
                    builder: (context, value, ch) => Container(
                      height: MediaQuery.of(context).size.height,
                      padding: EdgeInsets.only(
                          left: 16,
                          bottom: 16,
                          right: 16,
                          top: 16 + value.topMargin),
                      // margin: EdgeInsets.only(top: value.topMargin),
                      child: ch,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          '\$${loadProduct.price}',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          '${loadProduct.title}',
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            '${loadProduct.description}',
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.start,
                            softWrap: true,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // SizedBox(height: 800,)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
