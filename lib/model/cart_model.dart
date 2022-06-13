class Cart {
  final int? id;
  final String? productId;
  final String? productName;
  final int? initialPrice;
  final int? productPrice;
  final int? quantity;
  final String? unitTag;
  final String? image;

  Cart(

        {
          required this.id,
          required this.productId,
          required this.productName,
          required this.initialPrice,
          required this.productPrice,
          required this.quantity,
          required this.unitTag,
          required this.image,
        }
      );


  Cart.fromMap(Map<dynamic, dynamic> res)
  : id = res['id'],
  productPrice = res['productPrice'],
  productId = res['productId'],
  productName = res['productName'],
  initialPrice = res['initialPrice'],
  quantity = res['quantity'],
  unitTag = res['unitTag'],
  image = res['image'];

  Map<String, Object?> toMap() {
    return {
      'id'  : id,
      'productPrice' : productPrice,
      'productName' : productName,
      'productId' : productId,
      'initialPrice' : initialPrice,
      'quantity' : quantity,
      'unitTag' : unitTag,
      'image' : image,
    };
  }
}