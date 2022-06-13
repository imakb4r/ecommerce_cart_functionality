import 'package:badges/badges.dart';
import 'package:ecommmerce_cart/provider/cart_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'db_helper.dart';
import 'model/cart_model.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {

  DBHelper? dbHelper = DBHelper();
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Cart"),
        centerTitle: true,
        elevation: 0,
        actions: [
          Center(
            child: Badge(
              badgeContent: Consumer<CartProvider>(
                builder: (context, value, child) {
                  return Text(
                    value.getCounter().toString(),
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  );
                } ,
              ),
              animationDuration: const Duration(milliseconds: 300),
              child: const Icon(Icons.shopping_cart_outlined),
            ),
          ),
          SizedBox(width: 20,)
        ],),
      body: Column(
        children: [
          FutureBuilder(
            future: cart.getData(),
            builder: (context, AsyncSnapshot<List<Cart>> snapshot) {
              if (snapshot.hasData) {
                return Expanded(
                  child: ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Image(
                                    height: 100,
                                    width: 100,
                                    image: NetworkImage(snapshot.data![index].image.toString()),

                                  ),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              snapshot.data![index].productName.toString(),
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            InkWell(
                                              onTap: (){
                                                dbHelper!.delete(snapshot.data![index].id!);
                                                cart.removeCounter();
                                                cart.removeTotalPrice(double.parse(snapshot.data![index].productPrice.toString()));
                                              },
                                              child: Icon(Icons.delete),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(width: 5,),
                                        Text(
                                          snapshot.data![index].unitTag.toString() + " " +r"$" + snapshot.data![index].productPrice.toString(),
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        const SizedBox(height: 5,),
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: Container(
                                            height: 35,
                                            width: 100,
                                            decoration: BoxDecoration(
                                              color: Colors.green[700],
                                              borderRadius: BorderRadius.circular(5),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(4.0),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      int quantity = snapshot.data![index].quantity!;
                                                      int price = snapshot.data![index].initialPrice!;
                                                      quantity --;
                                                      int? newPrice = price * quantity ;

                                                      if (quantity >= 1) {
                                                        dbHelper!.updateQuantity(
                                                            Cart(id: snapshot.data![index].id!,
                                                                productId: snapshot.data![index].id!.toString(),
                                                                productName: snapshot.data![index].productName!,
                                                                initialPrice: snapshot.data![index].initialPrice!,
                                                                productPrice: newPrice,
                                                                quantity: quantity,
                                                                unitTag: snapshot.data![index].unitTag.toString(),
                                                                image: snapshot.data![index].image.toString())
                                                        ).then((value) {
                                                          newPrice = 0;
                                                          quantity = 0;
                                                          cart.removeTotalPrice(double.parse(snapshot.data![index].initialPrice!.toString()));
                                                        }).onError((error, stackTrace) {
                                                          print(error);
                                                        });
                                                      }
                                                    },
                                                      child: Icon(Icons.remove,color: Colors.white)
                                                  ),
                                                  Text(
                                                    snapshot.data![index].quantity.toString(),
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  InkWell(
                                                    onTap:() {
                                                      int quantity = snapshot.data![index].quantity!;
                                                      int price = snapshot.data![index].initialPrice!;
                                                      quantity ++;
                                                      int? newPrice = price * quantity ;

                                                      dbHelper!.updateQuantity(
                                                        Cart(id: snapshot.data![index].id!,
                                                            productId: snapshot.data![index].id!.toString(),
                                                            productName: snapshot.data![index].productName!,
                                                            initialPrice: snapshot.data![index].initialPrice!,
                                                            productPrice: newPrice,
                                                            quantity: quantity,
                                                            unitTag: snapshot.data![index].unitTag.toString(),
                                                            image: snapshot.data![index].image.toString())
                                                      ).then((value) {
                                                        newPrice = 0;
                                                        quantity = 0;
                                                        cart.addTotalPrice(double.parse(snapshot.data![index].initialPrice!.toString()));
                                                      }).onError((error, stackTrace) {
                                                        print(error);
                                                      });
                                                    } ,
                                                    child: Icon(Icons.add, color:  Colors.white)
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        );
                      } ),
                );
              }else {
                return const Center(child: Text("No item in Cart."));

              }

            },
          ),
          Consumer<CartProvider>(builder: (context, value, child) {
            return Visibility(
              visible: value.getTotalPrice().toStringAsFixed(2) == '0.00' ? false : true,
              child: Column(
                children: [
                  ReuseableWidget(title: 'Sub Total', value: r'$' + value.getTotalPrice().toStringAsFixed(2),),
                  //ReuseableWidget(title: 'Sub Total', value: r'$' + value.getTotalPrice().toStringAsFixed(2),)
                ],
              ),
            );
          }),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
    primary: Colors.lightGreenAccent,
    onPrimary: Colors.amberAccent,
              minimumSize: Size(400, 50)

            ),
              onPressed: (){
              const snackBar =  SnackBar(
                content:   Text(
                  " Payment Successful",
                ),
                backgroundColor: Colors.indigo,
                elevation: 10,
                behavior: SnackBarBehavior.floating,
                margin: EdgeInsets.all(5),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
              },
            child: const Text(
                "Pay Now",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 22,
              )
            ),
          ),
        ],
      ),
    );
  }
}

class ReuseableWidget extends StatelessWidget {
  final String title, value;

  const ReuseableWidget({Key? key, required this.title, required this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.subtitle2,
          ),
          Text(
            value.toString(),
            style: Theme.of(context).textTheme.subtitle2,
          ),
        ],
      ),
    );
  }
}
