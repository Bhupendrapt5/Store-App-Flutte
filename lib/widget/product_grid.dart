import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widget/product_item.dart';
import '../providers/products_provider.dart';

class ProductGrid extends StatelessWidget {
  final bool showFavoritesOnly;
  ProductGrid(this.showFavoritesOnly);

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductsProvider>(context);
    final _loadProduct = showFavoritesOnly
        ? productProvider.getFavoriteProducts
        : productProvider.getProducts;

    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: _loadProduct.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 15,
        mainAxisSpacing: 20,
      ),
      itemBuilder: (ctx, index) => ChangeNotifierProvider.value(
        //*When using provider in single List or Grid item, flutter removes items when
        //*they leave the screen and re-adds them when they are re-entered the screen
        //*In such situation flutter resues the widget but the data attached to it changes
        //* and [builder] constructor is unable to keep up with chagnes. Hence we are using [value] constructor
        // create: (context) => _loadProduct[index],
        value: _loadProduct[index],
        child: ProductItem(
            // productItem: _loadProduct[index],
            ),
      ),
    );
  }
}
