import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Cart_Provider with ChangeNotifier{
  final List<Map<String,dynamic>> _cartItems = [];
  List<Map<String,dynamic>> get cartItems => _cartItems;
  int get cartItemsCount => _cartItems.length;

  bool isProductInCart(String title){
    return _cartItems.any((items) => items['title'] == title);
  }

  void addToCart(Map<String,dynamic> product,BuildContext context){
    if(isProductInCart(product["title"])){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('You have already added this item.')));
      return;
    }
    _cartItems.add(product);
    notifyListeners();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("${product['title']} added to cart")),
    );
  }

  void removeFromCart(int index) {
    _cartItems.removeAt(index);
    notifyListeners();
  }

  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }
}