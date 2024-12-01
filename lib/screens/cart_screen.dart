import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sushi_app/provider/cart.dart';
import 'package:sushi_app/screens/dashboard.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool loader = true;
  @override
  void initState() {
    Future.delayed(Duration(seconds: 2)).then((value) {
      setState(() {
        loader = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int parsePrice(String price) {
      // Remove any non-numeric characters (like "Rp." or commas)
      String sanitizedPrice = price.replaceAll(RegExp(r'[^0-9]'), '');

      // Return the parsed integer value, assuming the string is now numeric
      return int.parse(sanitizedPrice); // Default to 0 if parsing fails
    }

    return Consumer<Cart>(
      builder: (context, value, child) {
        double price = 0;
        double totalPrice = 0;
        double taxAndService = 0;
        double totalPayment = 0;
        for (var cartModel in value.cart) {
          price = int.parse(cartModel.quantity.toString()) *
              parsePrice(cartModel.price.toString()).toDouble();
          totalPrice += price;
        }
        taxAndService = (totalPrice * 0.11).toDouble();
        totalPayment = (totalPrice + taxAndService).toDouble();
        return loader
            ? Center(
                child: SizedBox(
                  width: 200,
                  height: 100,
                  child: Shimmer.fromColors(
                      child: Text(
                        'Loading',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 40.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      baseColor: Colors.grey,
                      highlightColor: Colors.white),
                ),
              )
            : Scaffold(
                appBar: AppBar(
                  title: Text('Cart'),
                  actions: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: IconButton(
                        icon: Row(
                          children: [
                            Text('Clear cart'),
                            SizedBox(width: 10),
                            Icon(CupertinoIcons.trash_circle),
                          ],
                        ),
                        onPressed: () {
                          Provider.of<Cart>(context, listen: false).clearCart();
                          setState(() {
                            price = 0;
                            totalPrice = 0;
                            taxAndService = 0;
                            totalPayment = 0;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                body: value.cart.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Your cart is empty.',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: 10),
                            CupertinoButton(
                              color: Theme.of(context).primaryColor,
                              child: Text('Add Some Food'),
                              onPressed: () {
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Dashboard()),
                                  (route) => false,
                                );
                              },
                            )
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: value.cart.length,
                        itemBuilder: (context, index) {
                          final food = value.cart[index];
                          return ListTile(
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: Container(
                                width: 50,
                                height: 50,
                                child: Image.asset(
                                  food.imagePath.toString(),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            title: Text(food.name.toString()),
                            subtitle: Row(
                              children: [
                                Text('IDR ${food.price} x ${food.quantity}'),
                              ],
                            ),
                            trailing: IconButton(
                                onPressed: () {
                                  value.removeFromCart(food);
                                  if (value.cart.isEmpty) {
                                    price = 0;
                                    totalPrice = 0;
                                    taxAndService = 0;
                                    totalPayment = 0;
                                  } else {
                                    context.read<Cart>();
                                  }
                                },
                                icon: Icon(CupertinoIcons.minus)),
                          );
                        }),
                bottomNavigationBar: price == 0
                    ? null
                    : Container(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: Colors.black,
                                  width: 1,
                                ),
                              ),
                              padding: EdgeInsets.all(16),
                              margin: EdgeInsets.all(16),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Price'),
                                      Text('IDR ${totalPrice}'),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Tax and Service'),
                                      Text('IDR ${taxAndService}'),
                                    ],
                                  ),
                                  Divider(),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Tax and Service'),
                                      Text('IDR ${totalPayment}'),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.fromLTRB(20, 0, 20, 20),
                              width: MediaQuery.of(context).size.width,
                              child: CupertinoButton(
                                color: Theme.of(context).primaryColor,
                                child: Row(
                                  children: [
                                    Text('Pay Now'),
                                    SizedBox(width: 10),
                                    Icon(CupertinoIcons.arrow_right),
                                  ],
                                ),
                                onPressed: () {},
                              ),
                            )
                          ],
                        ),
                      ),
              );
      },
    );
  }
}
