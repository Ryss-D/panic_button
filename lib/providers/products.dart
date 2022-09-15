// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

// import '../models/http_exception.dart';

// class Products with ChangeNotifier {

//   Future<void> fetchAndSetProducts([bool filterByUser = false]) async {
//     //TODO: create env files
//     final url = Uri.parse(filterByUser
//         ? 'https://shop-app-2705c-default-rtdb.firebaseio.com/products.json?auth=$authToken&orderBy="creatorId"&equalTo="$userId"'
//         : 'https://shop-app-2705c-default-rtdb.firebaseio.com/products.json?auth=$authToken');
//     try {
//       final response = await http.get(url);
//       final extractedData = json.decode(response.body);
//       final favoriteResponse = await http.get(
//         Uri.parse(
//             'https://shop-app-2705c-default-rtdb.firebaseio.com/userFavorites/$userId.json?auth=$authToken'),
//       );
//       final favoriteData = json.decode(favoriteResponse.body);
//       final List<Product> loadedProducts = [];
//       if (extractedData != null) {
//         extractedData.forEach(
//           (prodId, prodData) {
//             loadedProducts.add(
//               Product(
//                 id: prodId,
//                 title: prodData['title'],
//                 description: prodData['description'],
//                 price: prodData['price'],
//                 isFavorite: favoriteData != null
//                     ? favoriteData[prodId] ?? false
//                     : false,
//                 imageUrl: prodData['imageUrl'],
//               ),
//             );
//           },
//         );
//       }
//       _items = loadedProducts;
//       notifyListeners();
//     } catch (error) {
//       throw error;
//     }
//   }

//   Future<void> addProduct(Product product) async {
//     // we will add some http interaction to our products list
//     final url = Uri.parse(
//         'https://shop-app-2705c-default-rtdb.firebaseio.com/products.json?auth=$authToken');

//     try {
//       final response = await http.post(
//         url,
//         body: json.encode(
//           {
//             'title': product.title,
//             'description': product.description,
//             'imageUrl': product.imageUrl,
//             'price': product.price,
//             'creatorId': userId,
//           },
//         ),
//       );
//       final newProduct = Product(
//         //if we managed it from here now we can acces to response data
//         // in this particular case json.decode(response.body) will raturn a
//         // with the name (id) of the created object on firebase (Database)
//         title: product.title,
//         description: product.description,
//         price: product.price,
//         imageUrl: product.imageUrl,
//         //id: DateTime.now().toString(),
//         //now we can use firebase id as id on product
//         id: json.decode(response.body)['name'],
//       );
//       _items.add(newProduct);
//       //this will be usefull if we want to insert it on specifir condition, with
//       //zero it will be added at start
//       //items.insert(0,newProduct);
//       //_items.add(value);
//       // this methos allowus to tell te Listeners when are new info avaliable to
//       // rebuild
//       notifyListeners();
//     } catch (error) {
//       throw error;
//     }
//     ;

//   }

//   Future<void> updateProduct(String id, Product newProduct) async {
//     final url = Uri.parse(
//         'https://shop-app-2705c-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken');
//     // pathc is a way to update the existint content mergin with the data
//     // we send
//     await http.patch(
//       url,
//       body: json.encode(
//         {
//           'title': newProduct.title,
//           'description': newProduct.description,
//           'price': newProduct.price,
//           'imageUrl': newProduct.imageUrl,
//         },
//       ),
//     );
//     final prodIndex = _items.indexWhere((prod) => prod.id == id);
//     if (prodIndex >= 0) {
//       _items[prodIndex] = newProduct;
//       notifyListeners();
//     }
//   }

// }
