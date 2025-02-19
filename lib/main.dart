import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:new_codingkart_project/CartScreenPage.dart';
import 'package:new_codingkart_project/GraphQL_Query.dart';
import 'package:provider/provider.dart';
import 'GraphQL_Client_EndPoint.dart';
import 'CartProvider.dart';

void main() async {
  runApp(
    MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => Cart_Provider())
        ],
      child:  const CodingKartData()) ,
    );
}

class CodingKartData extends StatelessWidget {
  const CodingKartData({super.key});

  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
      client: client,
      child:  MaterialApp(
        title: 'Shopify Collection',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue
        ),
        home: Homepage(),
      )
   );
  }
}

class Homepage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<Cart_Provider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Shopify Collection"),
        actions: [
          Stack(
      clipBehavior: Clip.none,
            children: [
              IconButton(
                icon: Icon(Icons.shopping_cart,color: Colors.indigo,),
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => CartScreen())
                  );
                },
              ),
              if (cartProvider.cartItemsCount > 0)
                Positioned(
                  right: 8,
                  top: 2,
                  child: Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    constraints: BoxConstraints(
                      minWidth: 5,
                      minHeight: 5,
                    ),
                    child: Text(
                      '${cartProvider.cartItemsCount}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),

            ]
          ),
        ],
      ),

          body: Query(options: QueryOptions(
          document: gql(getCollectionQuery),
          variables: {
            "id": "gid://shopify/Collection/475105526067",
            "filters":[],
            "limit" : 10,
            "identifiers":[
              {"key": "quick_apps_mobile_banner", "namespace": "custom"},
              {"key": "demo_name", "namespace": "custom"}],
            "sortKey":"TITLE",
            "reverse":true
          },
        fetchPolicy: FetchPolicy.networkOnly,
      ), builder: (QueryResult result,
          {VoidCallback ? refetch, FetchMore? fetchMore}){
        if(result.isLoading){
          return Center(
              child: CircularProgressIndicator());
        }
        print("GraphQL Response :+ ${result.data}");

        if(result.hasException){
          print(result.exception.toString());
          return Center(
              child: Text('Error: ${result.exception.toString()}'));
        }
        var collection = result.data?['collection'];
        if (collection == null)
          return Center(child: Text("No collection found"));

        var products = collection['products']?['edges'] ?? [];
        if (products.isEmpty)
          return Center(child: Text("No products available"));

        return ListView.builder(
          itemCount: products.length,
          itemBuilder: (context,index){
            if(index >= products.length){
              return SizedBox();

            }
            var product = products[index]['node'];
            String title = product['title'];
            String imageUrl = (product['images']?['edges']?.isNotEmpty ?? false)
                ? product['images']['edges'][0]['node']['src']
                : "";
            String price = product['priceRange']['minVariantPrice']['amount'] ?? "N/A";
            String currency = product['priceRange']['minVariantPrice']['currencyCode'] ?? "N/A ";

            return Card(
              color: Colors.white,
              margin: EdgeInsets.all(10),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.network(imageUrl,width: 250,height: 250,),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(title,
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10,left: 10),
                        child: Text('$currency - $price/- ',
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.bold
                          ),),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                            onPressed: (){
                              cartProvider.addToCart(
                                  {"title": title,
                                    "imageUrl": imageUrl,
                                    "price": price,
                                    "currency": currency,
                                  },
                                  context
                              );

                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.amber
                            ),
                            child: Text("Add to Cart",
                            style: TextStyle(
                              color: Colors.black
                            ),)),
                      )

                    ],
                  )

                ],
                
              )
            );
          },
        );
      },
      ),
    );
  }
  
}
