import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sushi_app/models/food.dart';

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

    debugPrint(foods[0].name);
  }

  @override
  void initState() {
    getFoods(); // TODO: implement initState
    super.initState();
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Stack(
              children: [
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    CupertinoIcons.bag,
                    size: 30,
                  ),
                ),
                Visibility(
                  visible: false,
                  child: Positioned(
                    top: 12,
                    right: 14,
                    child: CircleAvatar(
                      radius: 9,
                      backgroundColor: Colors.red,
                      child: Text(
                        '10',
                        style: TextStyle(color: Colors.white, fontSize: 10),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
      body: Column(children: [
        // banner
        Container(
          height: 200,
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
        )
      ]),
    );
  }
}
