import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:new_codingkart_project/CartProvider.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<Cart_Provider>(context);
    return Scaffold(
      appBar: AppBar(title: Text("Shopping Cart")),
      body: cartProvider.cartItems.isEmpty ?
      Center(
        child: Text("Your cart is empty"),
      ) : ListView.builder(
        itemCount: cartProvider.cartItems.length,
          itemBuilder: (context,index){
        var item = cartProvider.cartItems[index];
        return Card(
          margin: EdgeInsets.all(10),
          child: ListTile(
            leading: Image.network(item['imageUrl'], width: 50, height: 50, fit: BoxFit.cover),
            trailing: IconButton(onPressed: (){
              cartProvider.removeFromCart(index);
            },
                icon: Icon(Icons.delete, color: Colors.red)),
            title: Text(item['title']),
            subtitle: Text('${item['price']} ${item['currency']}'),
          ),
        );
      })
    );
  }

}