import 'package:flutter/cupertino.dart';
import 'package:sushi_app/models/cart_model.dart';
import 'package:sushi_app/models/food.dart';

class Cart extends ChangeNotifier {
  final List<CartModel> _cart = [];

  List<CartModel> get cart => _cart;

  void addToCart(Food foodItem, int qty) {
    _cart.add(
      CartModel(
        name: foodItem.name,
        price: foodItem.price,
        imagePath: foodItem.imagePath,
        quantity: qty.toString(),
      ),
    );
    notifyListeners();
  }

  void clearCart() {
    _cart.clear();
    notifyListeners();
  }

  void removeFromCart(CartModel item) {
    _cart.remove(item);
    notifyListeners();
  }
}
