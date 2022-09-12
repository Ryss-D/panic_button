// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// import '../screens/cart_screen.dart';
// import '../widgets/products_grid.dart';
// import '../widgets/app_drawer.dart';
// import '../widgets/badge.dart';
// import '../providers/cart.dart';
// import '../providers/products.dart';

// enum FilterOptions {
//   Favorites,
//   All,
// }

// class ProductOverviewScreen extends StatefulWidget {
//   @override
//   State<ProductOverviewScreen> createState() => _ProductOverviewScreenState();
// }

// class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
//   var _showOnlyFavorites = false;
//   // we add this helper to ensure that specific code in didChangeDepndencies
// // run just one time
//   var _isInit = true;
//   var _isLoading = false;

//   @override
//   void initState() {
//     //Provider.of<Products>(context).fetchAndSetProducts(); wont will work if
//     // we set listen:false on the provider setting up
//     // this is a possible solution
//     //Future.delayed(Duration.zero)
//     //    .then((){Provider.of<Products>(context).fetchAndSetProducts();});
//     super.initState();
//   }

//   //This runs after widget is fullyinitialized, remember it run multiple times
//   void didChangeDependencies() {
//     if (_isInit) {
//       setState(() {
//         _isLoading = true;
//       });
//       Provider.of<Products>(context).fetchAndSetProducts().then((context) {
//         setState(() {
//           _isLoading = false;
//         });
//       });
//     }
//     _isInit = false;
//     super.didChangeDependencies;
//   }

//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Shop Overview'),
//         actions: <Widget>[
//           PopupMenuButton(
//             onSelected: (FilterOptions selectedValue) {
//               setState(
//                 () {
//                   if (selectedValue == FilterOptions.Favorites) {
//                     _showOnlyFavorites = true;
//                   } else {
//                     _showOnlyFavorites = false;
//                   }
//                 },
//               );
//             },
//             icon: Icon(
//               Icons.more_vert,
//             ),
//             itemBuilder: (context) => [
//               PopupMenuItem(
//                   child: Text('Only favorites'),
//                   value: FilterOptions.Favorites),
//               PopupMenuItem(
//                 child: Text('Show all'),
//                 value: FilterOptions.All,
//               ),
//             ],
//           ),
//           Consumer<Cart>(
//             builder: (context, cartData, child) => Badge(
//               child: child!,
//               value: cartData.itemCount.toString(),
//             ),
//             child: IconButton(
//               icon: Icon(
//                 Icons.shopping_cart,
//               ),
//               onPressed: () {
//                 Navigator.of(context).pushNamed(CartScreen.routeName);
//               },
//             ),
//           ),
//         ],
//       ),
//       drawer: AppDrawer(),
//       body: _isLoading
//           ? Center(child: CircularProgressIndicator())
//           : ProductsGrid(_showOnlyFavorites),
//     );
//   }
// }
