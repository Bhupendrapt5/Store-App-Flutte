import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/product.dart';
import 'package:shop_app/providers/products_provider.dart';

class AddEditProductScreen extends StatefulWidget {
  // final Product prodcut;

  // const AddEditProductScreen({Key key, this.prodcut}) : super(key: key);
  @override
  _AddEditProductScreenState createState() => _AddEditProductScreenState();
}

class _AddEditProductScreenState extends State<AddEditProductScreen> {
  // final _formKey = GlobalSta
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imgUrlFocusNode = FocusNode();
  final _imagUrlController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  var _editProduct = Product(
    id: null,
    description: '',
    imageUrl: '',
    price: 0,
    title: '',
  );
  var _isLoading = false;
  var _isInit = true;
  var _initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imgUrl': '',
  };

  @override
  void initState() {
    _imagUrlController.addListener(_updateImage);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit && ModalRoute.of(context).settings.arguments != null) {
      _editProduct = ModalRoute.of(context).settings.arguments as Product;
      _initValues = {
        'title': _editProduct.title,
        'description': _editProduct.description,
        'price': _editProduct.price.toString(),
        'imgUrl': '',
      };
      _imagUrlController.text = _editProduct.imageUrl;
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    //*Need to dispose FocusNodes, because they dont get dispose automatically and stick around in memory,
    //*which can cause memory leak
    _imagUrlController.removeListener(_updateImage);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imagUrlController.dispose();
    _imgUrlFocusNode.dispose();
    super.dispose();
  }

  void _updateImage() {
    if (!_imgUrlFocusNode.hasFocus) {
      if ((!_imagUrlController.text.startsWith('http') &&
              !_imagUrlController.text.startsWith('https')) ||
          (!_imagUrlController.text.endsWith('.jpg') &&
              !_imagUrlController.text.endsWith('.png') &&
              !_imagUrlController.text.endsWith('.png') &&
              !_imagUrlController.text.contains('images?=') &&
              !_imagUrlController.text.endsWith('.jpeg'))) {
        return;
      }
      setState(() {});
    }
  }

  Future _saveForm() async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });

    try {
      if (_editProduct.id != null) {
        await Provider.of<ProductsProvider>(context, listen: false)
            .updateProducts(id: _editProduct.id, product: _editProduct);
      } else {
        await Provider.of<ProductsProvider>(context, listen: false)
            .addProducts(_editProduct);
      }
    } catch (error) {
      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('An error occurred!'),
          content: Text('Something went wrong.'),
          actions: <Widget>[
            FlatButton(
              child: Text('Okay'),
              onPressed: () {
                Navigator.of(ctx).pop();
              },
            )
          ],
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pop();
    }
    // print('Product Saved');
    // print(_editProduct.title);
    // print(_editProduct.imageUrl);
    // print(_editProduct.price);
    // print(_editProduct.description);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add/Edit Product'),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Form(
                      key: _formKey,
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextFormField(
                              initialValue: _initValues['title'],
                              decoration: InputDecoration(labelText: 'Title'),
                              textInputAction: TextInputAction.next,
                              onFieldSubmitted: (val) => FocusScope.of(context)
                                  .requestFocus(_priceFocusNode),
                              onSaved: (newValue) {
                                _editProduct = Product(
                                  id: _editProduct.id,
                                  isFavorite: _editProduct.isFavorite,
                                  title: newValue,
                                  imageUrl: _editProduct.imageUrl,
                                  description: _editProduct.description,
                                  price: _editProduct.price,
                                );
                              },
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Title cannot be empty';
                                } else if (value.length < 4) {
                                  return 'Title must be at least 4 char long';
                                }
                                return null;
                              },
                            ),
                            TextFormField(
                              initialValue: _initValues['price'],
                              decoration: InputDecoration(labelText: 'Price'),
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.number,
                              focusNode: _priceFocusNode,
                              onFieldSubmitted: (val) => FocusScope.of(context)
                                  .requestFocus(_descriptionFocusNode),
                              onSaved: (newValue) {
                                _editProduct = Product(
                                  id: _editProduct.id,
                                  isFavorite: _editProduct.isFavorite,
                                  title: _editProduct.title,
                                  imageUrl: _editProduct.imageUrl,
                                  description: _editProduct.description,
                                  price: double.parse(newValue),
                                );
                              },
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Price cannot be empty';
                                } else if (double.tryParse(value) == null) {
                                  return 'Enter valid price';
                                } else if (double.tryParse(value) <= 0) {
                                  return 'Price cannot be zero or less';
                                }
                                return null;
                              },
                            ),
                            TextFormField(
                              initialValue: _initValues['description'],
                              decoration:
                                  InputDecoration(labelText: 'Description'),
                              minLines: 1,
                              maxLines: 4,
                              keyboardType: TextInputType.multiline,
                              focusNode: _descriptionFocusNode,
                              onSaved: (newValue) {
                                _editProduct = Product(
                                  id: _editProduct.id,
                                  isFavorite: _editProduct.isFavorite,
                                  title: _editProduct.title,
                                  imageUrl: _editProduct.imageUrl,
                                  description: newValue,
                                  price: _editProduct.price,
                                );
                              },
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Description cannot be empty';
                                } else if (value.length < 10) {
                                  return 'Description must be at least 10 char long';
                                }
                                return null;
                              },
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.25,
                                  height:
                                      MediaQuery.of(context).size.height * 0.2,
                                  margin:
                                      const EdgeInsets.only(top: 16, right: 10),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 1, color: Colors.black45),
                                  ),
                                  child: _imagUrlController.text.isEmpty
                                      ? Text('Enter a URL')
                                      : FittedBox(
                                          child: Image.network(
                                              _imagUrlController.text),
                                          fit: BoxFit.cover,
                                        ),
                                ),
                                Expanded(
                                  child: TextFormField(
                                    // initialValue: _initValues['imgUrl'],
                                    decoration:
                                        InputDecoration(labelText: 'Image URL'),
                                    keyboardType: TextInputType.url,
                                    textInputAction: TextInputAction.done,
                                    controller: _imagUrlController,
                                    focusNode: _imgUrlFocusNode,
                                    onFieldSubmitted: (value) => _saveForm(),
                                    onSaved: (newValue) {
                                      _editProduct = Product(
                                        id: _editProduct.id,
                                        isFavorite: _editProduct.isFavorite,
                                        title: _editProduct.title,
                                        imageUrl: newValue,
                                        description: _editProduct.description,
                                        price: _editProduct.price,
                                      );
                                    },
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return 'Url  cannot be empty';
                                      } else if (!value.startsWith('http') &&
                                          !value.startsWith('https')) {
                                        return 'Invalid URL';
                                      } else if (!value.endsWith('.jpg') &&
                                          !value.endsWith('.png') &&
                                          !_imagUrlController.text
                                              .contains('images?') &&
                                          !value.endsWith('CAU') &&
                                          !value.endsWith('.jpeg')) {
                                        return 'Invalid Image URL';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Material(
                    child: Ink(
                      height: MediaQuery.of(context).size.height * 0.075,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.transparent,
                          style: BorderStyle.solid,
                          width: 1.0,
                        ),
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(30.0),
                        onTap: _saveForm,
                        child: Center(
                          child: Text(
                            "SAVE",
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Montserrat',
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
