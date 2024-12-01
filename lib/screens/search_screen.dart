import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sushi_app/models/food.dart';
import 'package:sushi_app/screens/detail_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<Food> foods = [];
  List<Food> _foundedFoods = [];

  Future<void> getFoods() async {
    String foodData =
        await rootBundle.loadString('assets/assets/json/food.json');

    List<dynamic> jsonMap = json.decode(foodData);

    setState(() {
      foods = jsonMap.map((e) => Food.fromJson(e)).toList();
      _foundedFoods = foods;
    });
  }

  onSearchFood(String query) {
    setState(() {
      _foundedFoods = foods
          .where((element) =>
              element.name!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  void initState() {
    super.initState();
    getFoods();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Food'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                  //labelText: 'Search Food',
                  hintText: 'Search Food',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  prefixIcon: Icon(CupertinoIcons.search),
                  contentPadding: EdgeInsets.fromLTRB(18, 0, 18, 0)),
              onChanged: (value) {
                setState(() {
                  onSearchFood(value.toString());
                });
              },
            ),
          ),
          ListView.builder(
              shrinkWrap: true,
              itemCount: _foundedFoods.length,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailScreen(
                            food: _foundedFoods[index],
                          ),
                        ));
                  },
                  leading: SizedBox(
                    width: 50,
                    height: 50,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Image.asset(
                        _foundedFoods[index].imagePath.toString(),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  title: Text(
                    _foundedFoods[index].name.toString(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Text('IDR ${_foundedFoods[index].price}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        CupertinoIcons.star_fill,
                        size: 15,
                        color: Colors.green,
                      ),
                      Text(
                        _foundedFoods[index].rating.toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                );
              }),
        ],
      ),
    );
  }
}
