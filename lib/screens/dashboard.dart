import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sushi_app/models/food.dart';
import 'package:sushi_app/provider/cart.dart';
import 'package:sushi_app/screens/cart_screen.dart';
import 'package:sushi_app/screens/detail_screen.dart';
import 'package:sushi_app/screens/search_screen.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  List<Food> foods = [];

  Future<void> getFoods() async {
    String jsonString =
        await rootBundle.loadString('assets/assets/json/food.json');

    List<dynamic> jsonMap = json.decode(jsonString);

    setState(() {
      foods = jsonMap.map((e) => Food.fromJson(e)).toList();
    });

    if (foods.isNotEmpty) {
      debugPrint(foods[0].name); // Safely print the name of the first food
    } else {
      debugPrint('No foods available in the JSON');
    }
  }

  void detailFood(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailScreen(
          food: foods[index],
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getFoods();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            const Text(
              'Sushiman',
              style: TextStyle(
                fontSize: 30,
                color: Colors.black,
              ),
            ),
            Row(
              children: [
                Icon(
                  CupertinoIcons.location,
                  size: 14,
                ),
                SizedBox(width: 5),
                Text(
                  'Jakarta, Indonesia',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ],
            )
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SearchScreen()));
            },
            icon: Icon(
              CupertinoIcons.search,
              size: 30,
            ),
          ),
          Consumer<Cart>(
            builder: (context, value, child) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Stack(
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
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // banner
          BannerPromoWidget(),

          // best seller
          SizedBox(height: 20),

          BestSellerWidget(context),
          SizedBox(height: 20),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Popular Food',
              style: TextStyle(
                color: Colors.black,
                fontSize: 34,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemCount: foods.length,
              padding: const EdgeInsets.all(10),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    detailFood(index);
                  },
                  child: Container(
                    color: Colors.transparent,
                    margin: EdgeInsets.only(right: 16),
                    height: 140,
                    width: 140,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Hero(
                          tag: foods[index].imagePath.toString(),
                          child: Container(
                            height: 100,
                            width: 140,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              image: DecorationImage(
                                  image: AssetImage(
                                      foods[index].imagePath.toString()),
                                  fit: BoxFit.cover,
                                  colorFilter: ColorFilter.mode(
                                      Colors.black.withOpacity(0.2),
                                      BlendMode.darken)),
                            ),
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          foods[index].name.toString(),
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          foods[index].price.toString() + ' IDR',
                          style: TextStyle(
                            color: const Color.fromARGB(255, 85, 17, 12),
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          children: [
                            Icon(CupertinoIcons.star_fill,
                                size: 12,
                                color: const Color.fromARGB(255, 104, 94, 3)),
                            SizedBox(width: 5),
                            Text(
                              foods[index].rating.toString(),
                              style: TextStyle(
                                color: const Color.fromARGB(255, 104, 94, 2),
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
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

  Column BestSellerWidget(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Best Seller',
          style: TextStyle(
            color: Colors.black,
            fontSize: 34,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          height: 120,
          margin: EdgeInsets.all(10),
          width: MediaQuery.sizeOf(context).width,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(foods[2].imagePath.toString()),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.2), BlendMode.darken)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ListTile(
                title: Text(
                  foods[2].name.toString(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  '${foods[2].price} IDR',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}

class BannerPromoWidget extends StatelessWidget {
  const BannerPromoWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      margin: EdgeInsets.all(10),
      width: MediaQuery.sizeOf(context).width,
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/assets/images/sushi_nigiri.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.3), BlendMode.darken)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ListTile(
            title: Text(
              'Get 78% off ',
              style: TextStyle(
                color: Colors.white,
                fontSize: 34,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              'for Sushi Nigiri',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
            trailing: Icon(
              CupertinoIcons.arrow_right,
              color: Colors.white,
            ),
          )
        ],
      ),
    );
  }
}
