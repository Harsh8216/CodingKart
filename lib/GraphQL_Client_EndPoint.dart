
import 'package:flutter/cupertino.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

final HttpLink httpLink = HttpLink(
  'https://vikas-test-bean.myshopify.com/api/2024-10/graphql.json',
  defaultHeaders: {
    "X-Shopify-Storefront-Access-Token" : "01f9402f3dab4f9cbb7908cf2c48a812",
    "Content-Type": "application/json",
    "Accept": "application/json",
    "Access-Control-Allow-Origin": "*"
  }

);

ValueNotifier<GraphQLClient> client = ValueNotifier(
  GraphQLClient(
    link: httpLink as Link,
    cache: GraphQLCache(
    ),
  )
);