import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/http_exception.dart';
import 'product.dart';

class Products with ChangeNotifier {
  //List<Product> _items = [
  //  Product(
  // id: 'p1',
  // title: 'Red Shirt',
  // description: 'A red shirt - it is pretty red!',
  // price: 29.99,
  // imageUrl:
  //      'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
  // ),
  // Product(
  // id: 'p2',
  // title: 'Trousers',
  //description: 'A nice pair of trousers.',
  //price: 59.99,
  //imageUrl:
  //'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
  //),
  //Product(
  //id: 'p3',
  //title: 'Yellow Scarf',
  //description: 'Warm and cozy - exactly what you need for the winter.',
  //price: 19.99,
  //imageUrl:
  //'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
  //),
  //Product(
  //id: 'p4',
  //title: 'A Pan',
  //description: 'Prepare any meal you want.',
  //price: 49.99,
  //imageUrl:
  //'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
  //),
  //];

  List<Product> _items = <Product>[];
  final String authToken;
  final String userId;

  Products(this.authToken, this.userId, this._items);

  var _showFavoritesOnly = false;

  List<Product> get items {
    if (_items != <Product>[]) {
      if (_showFavoritesOnly) {
        return _items.where((prodItem) => prodItem.isFavorite).toList();
      }
      return [..._items];
    } else {
      return _items;
    }
  }

  List<Product> get favoriteItems {
    return _items.where((prodItem) => prodItem.isFavorite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  Future<void> fetchAndSetProducts([bool filterByUser = false]) async {
    //TODO: create env files
    final url = Uri.parse(filterByUser
        ? 'https://shop-app-2705c-default-rtdb.firebaseio.com/products.json?auth=$authToken&orderBy="creatorId"&equalTo="$userId"'
        : 'https://shop-app-2705c-default-rtdb.firebaseio.com/products.json?auth=$authToken');
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body);
      final favoriteResponse = await http.get(
        Uri.parse(
            'https://shop-app-2705c-default-rtdb.firebaseio.com/userFavorites/$userId.json?auth=$authToken'),
      );
      final favoriteData = json.decode(favoriteResponse.body);
      final List<Product> loadedProducts = [];
      if (extractedData != null) {
        extractedData.forEach(
          (prodId, prodData) {
            loadedProducts.add(
              Product(
                id: prodId,
                title: prodData['title'],
                description: prodData['description'],
                price: prodData['price'],
                isFavorite: favoriteData != null
                    ? favoriteData[prodId] ?? false
                    : false,
                imageUrl: prodData['imageUrl'],
              ),
            );
          },
        );
      }
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addProduct(Product product) async {
    // we will add some http interaction to our products list
    final url = Uri.parse(
        'https://shop-app-2705c-default-rtdb.firebaseio.com/products.json?auth=$authToken');

    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'title': product.title,
            'description': product.description,
            'imageUrl': product.imageUrl,
            'price': product.price,
            'creatorId': userId,
          },
        ),
      );
      final newProduct = Product(
        //if we managed it from here now we can acces to response data
        // in this particular case json.decode(response.body) will raturn a
        // with the name (id) of the created object on firebase (Database)
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
        //id: DateTime.now().toString(),
        //now we can use firebase id as id on product
        id: json.decode(response.body)['name'],
      );
      _items.add(newProduct);
      //this will be usefull if we want to insert it on specifir condition, with
      //zero it will be added at start
      //items.insert(0,newProduct);
      //_items.add(value);
      // this methos allowus to tell te Listeners when are new info avaliable to
      // rebuild
      notifyListeners();
    } catch (error) {
      throw error;
    }
    ;

    // print(error);
    //throw is a keyword on dart who allow us to create a new error
    //throw error;
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final url = Uri.parse(
        'https://shop-app-2705c-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken');
    // pathc is a way to update the existint content mergin with the data
    // we send
    await http.patch(
      url,
      body: json.encode(
        {
          'title': newProduct.title,
          'description': newProduct.description,
          'price': newProduct.price,
          'imageUrl': newProduct.imageUrl,
        },
      ),
    );
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      _items[prodIndex] = newProduct;
      notifyListeners();
    }
  }

  void deleteProduct(String id) {
    final url = Uri.parse(
        'https://shop-app-2705c-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken');
    final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    //removeAt also returns a instance of the removed item
    // we create a copy of the product just as reference in case some part
    // of application still using it
    var existingProduct = _items.removeAt(existingProductIndex);
    notifyListeners();
    // for get, post and patch when fails http pacakge raise and error but for
    // delete thats not the case, so we will implement it by our selves
    http.delete(url).then((response) {
      if (response.statusCode >= 400) {
        throw HttpException('Could not delete product.');
      }
      // this will elimited the reference from memory
      existingProduct.dispose();
    }).catchError((_) {
      // this ensures that if we fail deleting it from remote the item will
      //come back to local instance to be consistent with remote data
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
    });
    //_items.removeWhere((prod) => prod.id == id);
  }
}
