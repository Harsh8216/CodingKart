String getCollectionQuery = """
query(\$id : ID!, \$cursor : String, \$limit : Int, \$sortKey : ProductCollectionSortKeys, \$reverse: Boolean, \$filters: [ProductFilter!], \$identifiers:[HasMetafieldsIdentifier!]!) @inContext(language:BS){
  collection(id: \$id) {
    title
     metafields(
      identifiers: \$identifiers
    ) {
      key
      value
      reference {
        ... on MediaImage {
          id
          image {
            src
          }
        }
      }
    }
    products(first: \$limit, sortKey: \$sortKey, after: \$cursor, reverse: \$reverse, filters: \$filters) {
    edges {
      node {
        id
        title
        images(first: 1) {
          edges {
            node {
              altText
              src
            }
          }
        }
        priceRange {
          maxVariantPrice {
            amount
            currencyCode
          }
          minVariantPrice {
            amount
            currencyCode
          }
        }
        productType
        availableForSale
        collections(first: 10) {
          edges {
            node {
              id
              title
              handle
            }
          }
        }
        metafields(
          identifiers: [{key: "rating", namespace: "reviews"}, {key: "rating_count", namespace: "reviews"}]
        ) {
          key
          value
        }
        description
        variants(first: 250) {
          edges {
            node {
              id
               storeAvailability(first: 250, near: {latitude: 1.5, longitude: 1.5}) {
                  nodes {
                    available
                    location {
                      address {
                        address1
                        address2
                        city
                        country
                        countryCode
                        formatted
                        latitude
                        longitude
                        phone
                        province
                        provinceCode
                        zip
                      }
                      id
                      name
                    }
                    pickUpTime
                    quantityAvailable
                  }
                }
            }
          }
        }
      }
      
      cursor
    }
     filters {
        id
        label
        type
        values {
          count
          id
          input
          label
           swatch {
            color
            image {
              image {
                src
                id
              }
            }
          }
        }
      }
    pageInfo {
      endCursor
      hasNextPage
      startCursor
      hasPreviousPage
    }
  }
  }
}

""";
