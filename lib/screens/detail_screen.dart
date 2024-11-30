import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:sushi_app/models/food.dart';
import 'package:sushi_app/provider/cart.dart';
import 'package:sushi_app/screens/cart_screen.dart';

class DetailScreen extends StatefulWidget {
  final Food food;
  const DetailScreen({super.key, required this.food});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  int qtyCount = 0;
  int totalPrice = 0;

  void incrementQty() {
    setState(() {
      qtyCount++;
      totalPrice = qtyCount * parsePrice(widget.food.price.toString());
    });
  }

  void decrementQty() {
    setState(() {
      if (qtyCount > 0) {
        qtyCount--;
        totalPrice = qtyCount * parsePrice(widget.food.price.toString());
      }
    });
  }

  int parsePrice(String price) {
    // Remove any non-numeric characters (like "Rp." or commas)
    String sanitizedPrice = price.replaceAll(RegExp(r'[^0-9]'), '');

    // Return the parsed integer value, assuming the string is now numeric
    return int.parse(sanitizedPrice); // Default to 0 if parsing fails
  }

  void addToCart() {
    if (qtyCount > 0) {
      final cart = context.read<Cart>(); // Corrected the syntax here
      cart.addToCart(widget.food, qtyCount); // Add food to cart
      popUpDialog(); // Show modal bottom sheet after adding to cart
    }
  }

  void popUpDialog() {
    setState(() {
      qtyCount = 0; // Reset quantity
      totalPrice = 0; // Reset total price
    });

    showModalBottomSheet(
      context: context,
      isDismissible: false, // Disable dismissing by tapping outside
      showDragHandle: true, // Show drag handle for the bottom sheet
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          width: MediaQuery.of(context)
              .size
              .width, // Corrected usage of MediaQuery
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Food was added to cart', // The message shown in the bottom sheet
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 30),
              Text(
                '${widget.food.name} was added to cart, would you like to add some food?', // The message shown in the bottom sheet
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              SizedBox(height: 30),
              Row(
                children: [
                  Expanded(
                    child: FloatingActionButton(
                      heroTag: 'goToCart',
                      backgroundColor: Color.fromARGB(109, 140, 94, 91),
                      elevation: 0,
                      onPressed: () {
                        Navigator.pop(context);
                        goToCart();
                      },
                      child: Text(
                        'View cart',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: FloatingActionButton(
                      heroTag: 'pop',
                      backgroundColor: Theme.of(context).primaryColor,
                      elevation: 0,
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Sure',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        );
      },
    );
  }

  goToCart() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CartScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      //app bar
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          Consumer<Cart>(
            builder: (context, value, child) {
              return Stack(
                children: [
                  IconButton(
                    icon: Icon(
                      CupertinoIcons.bag,
                      size: 30,
                    ),
                    onPressed: () {
                      goToCart();
                    },
                  ),
                  Positioned(
                    top: 14,
                    left: 14,
                    child: Visibility(
                      visible: value.cart.isNotEmpty ? true : false,
                      child: CircleAvatar(
                        radius: 10,
                        backgroundColor: Colors.transparent,
                        child: Center(
                          child: Text(
                            value.cart.length.toString(),
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              );
            },
          ),
        ],
      ),
      //detail body
      body: DetailBody(context),

      //Bottom
      bottomNavigationBar: GestureDetector(
        onTap: () {
          addToCart();
        },
        child: Container(
          margin: const EdgeInsets.all(8.0),
          padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: Colors.redAccent,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Add to Cart',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
              Text(
                'Rp. ' + totalPrice.toString(),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
      //bottom nav
    );
  }

  DetailBody(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Hero(
            tag: widget.food.imagePath.toString(),
            child: Container(
              height: 300,
              width: MediaQuery.sizeOf(context).width,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(widget.food.imagePath.toString()),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                        Colors.black.withOpacity(0.2), BlendMode.darken)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.food.name.toString(),
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Price',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${widget.food.price} IDR',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        Icon(CupertinoIcons.star_fill,
                            size: 14,
                            color: const Color.fromARGB(255, 104, 94, 3)),
                        SizedBox(width: 5),
                        Text(
                          widget.food.rating.toString(),
                          style: TextStyle(
                            color: const Color.fromARGB(255, 104, 94, 2),
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    )
                  ],
                ),

                //icon
                //Icon(CupertinoIcons.heart, size: 20, color: Colors.red),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        decrementQty();
                      },
                      icon: Icon(
                        CupertinoIcons.minus,
                        size: 30,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(width: 5),
                    //text
                    Text(
                      qtyCount.toString(),
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 5),
                    IconButton(
                      onPressed: () {
                        incrementQty();
                      },
                      icon: Icon(
                        CupertinoIcons.plus,
                        size: 30,
                        color: Colors.black,
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.food.description.toString(),
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
