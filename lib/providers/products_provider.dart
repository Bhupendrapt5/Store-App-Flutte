import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/misc/api_key.dart';
import 'package:shop_app/model/http_exception.dart';
import '../providers/product.dart';

class ProductsProvider with ChangeNotifier {
  final String auhToken;
  final String userId;
  ProductsProvider(
    this.auhToken,
    this.userId,
    this._productList,
  );
  List<Product> _productList = [
    // new Product(
    //   id: 'p1',
    //   title: 'Hand Gun',
    //   image_Url:
    //       'https://news.guns.com/wp-content/uploads/2019/06/BuyGun-2621.jpg',
    //   description: 'effective home-defense weapon,',
    //   price: 500,
    // ),
    // new Product(
    //   id: 'p2',
    //   title: 'Bat Rang',
    //   image_Url:
    //       'https://www.renderhub.com/dmitriykotliar/telltale-batarang/telltale-batarang-01.jpg',
    //   description: 'Cool batrang - defense weapon',
    //   price: 250,
    // ),
    // new Product(
    //   id: 'p3',
    //   title: 'Sherlock Homes Book',
    //   image_Url:
    //       'https://images-na.ssl-images-amazon.com/images/I/91dDv9WOcFL.jpg',
    //   description:
    //       'Here are the original Sherlock Holmes stories by Arthur Conan Doyle as they first appeared in the famed British magazine The Strand.',
    //   price: 550,
    // ),
    // new Product(
    //   id: 'p4',
    //   title: 'Macbook Pro',
    //   image_Url:
    //       'https://www.apple.com/newsroom/images/product/mac/standard/Apple_macbookpro-13-inch_screen_05042020_big.jpg.large.jpg',
    //   description: 'Coool highly overpriced Laptop. Worth every penny',
    //   price: 122000,
    // ),
    // new Product(
    //   id: 'p5',
    //   title: 'Bagpack',
    //   image_Url:
    //       'https://rukminim1.flixcart.com/image/714/857/jw5a2kw0/backpack/g/m/g/stream-sbstr1hblu-backpack-skybags-original-imafgwchztjgghzd.jpeg?q=50',
    //   description: 'Cool Looking bagpack bag raincot',
    //   price: 1650,
    // ),
  ];
  double _topMargin = 0.0;

  // ignore: unnecessary_getters_setters
  set topMargin(double val) {
    _topMargin = val;
    notifyListeners();
  }

  // ignore: unnecessary_getters_setters
  double get topMargin => _topMargin;

  // var _showOnlyFavorites = false;
  List<Product> get getProducts {
    // if (_showOnlyFavorites) {
    //   return _productList.where((product) => product.isFavorite).toList();
    // }
    return [..._productList];
  }

  List<Product> get getFavoriteProducts {
    return _productList
        .where(
          (product) => product.isFavorite,
        )
        .toList();
  }

  // void showOnlyFavorites() {
  //   _showOnlyFavorites = true;
  //   notifyListeners();
  // }

  // void showAll() {
  //   _showOnlyFavorites = false;

  //   notifyListeners();
  // }

  //* Single Product by Id
  Product findById(String id) {
    return _productList.firstWhere((prod) => prod.id == id);
  }

  Future fetchProducts({bool filterByUser = false}) async {
    final _filterString =
        filterByUser ? 'orderBy="userId"&equalTo="$userId"' : '';
    final _url =
        '${APIKeys.baseUrl}/products.json?auth=$auhToken&$_filterString';
    final _favItemUrl =
        '${APIKeys.baseUrl}/userFavorites/$userId.json?auth=$auhToken';
    try {
      final res = await http.get(_url);
      // print('procuts response ${json.decode(res.body)}');
      final extractedData = json.decode(res.body) as Map<String, dynamic>;
      final List<Product> _loadedProdcuts = [];
      if (extractedData != null) {
        final favoriteRes = await http.get(_favItemUrl);
        final _favoritedata =
            json.decode(favoriteRes.body) as Map<String, dynamic> ?? {};
        print('_favoritedata : $_favoritedata');
        extractedData.forEach((prodId, prodData) {
          _loadedProdcuts.insert(
              0,
              Product(
                id: prodId,
                title: prodData['title'],
                imageUrl: prodData['imgUrl'],
                description: prodData['description'],
                isFavorite: _favoritedata[prodId] ?? false,
                price: double.tryParse(prodData['price'].toString()),
              ));
        });
        _productList = _loadedProdcuts;
        notifyListeners();
      }
    } catch (error) {
      throw error;
    }
  }

  Future<void> addProducts(Product product) async {
    final _url = '${APIKeys.baseUrl}/products.json?auth=$auhToken';
    try {
      print('prodcut to be saves ${product.toJson()}');
      //* Body data must be json
      var response =
          await http.post(_url, body: product.toJson(userId: userId));

      final newProduct = Product(
          id: json.decode(response.body)['name'],
          title: product.title,
          imageUrl: product.imageUrl,
          description: product.description,
          price: product.price);

      //* Adding Product at first index
      _productList.insert(0, newProduct);
      // _productList.add(newProduct);
      notifyListeners();
    } catch (error) {
      print('Add error : => $error');
      throw error;
    }
  }

  Future<void> updateProducts({String id, Product product}) async {
    final _prodIndex = _productList.indexWhere((element) => element.id == id);
    if (_prodIndex >= 0) {
      try {
        final __url = '${APIKeys.baseUrl}/products/$id.json?auth=$auhToken';
        var res = await http.patch(__url, body: product.toJson());
        print('res code : ${res.statusCode}');
        if (res.statusCode >= 400) {
          throw HttpException(messge: 'Could Not update..');
        }
        _productList[_prodIndex] = product;
        notifyListeners();
      } catch (error) {
        print('update error : => $error');
        throw error;
      }
    }
  }

  Future<void> removeProduct({String id}) async {
    final _url = '${APIKeys.baseUrl}/products/$id.json?auth=$auhToken';
    final existingProductIndex =
        _productList.indexWhere((prod) => prod.id == id);
    var existingProduct = _productList[existingProductIndex];
    _productList.removeAt(existingProductIndex);
    notifyListeners();
    final response = await http.delete(_url);
    if (response.statusCode >= 400) {
      _productList.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException(messge: 'Could not delete product.');
    }
    existingProduct = null;
  }
  // Future<void> removeProduct({String id}) async {
  //   final __url = 'https://fcm-example-flutter.firebaseio.com/products/$id.json';
  //   try {
  //    var res =  await http.delete(__url);
  //    print('res : ${res.statusCode}');
  //    if(res.statusCode>=400){
  //         throw HttpException('Could Not Delete..');
  //       }
  //       print('post status code');
  //     _productList.removeWhere((element) => element.id == id);
  //     notifyListeners();
  //   } catch (error) {
  //     print('Delete error : => $error');
  //     throw error;
  //   }
  // }
}
