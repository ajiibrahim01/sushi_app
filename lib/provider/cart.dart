import 'package:flutter/cupertino.dart';
import 'package:sushi_app/models/cart_model.dart';
import 'package:sushi_app/models/food.dart';

class Cart extends ChangeNotifier {
  final List<CartModel> _cart = [];

  List<CartModel> get cart => _cart;

  void addToCart(Food foodItem, int qty) {
    bool isExist = false;

    for (var cartItem in _cart) {
      if (cartItem.name == foodItem.name) {
        cartItem.quantity =
            (int.parse(cartItem.quantity.toString()) + qty).toString();
        isExist = true;
        break;
      }
    }
    if (!isExist) {
      _cart.add(
        CartModel(
          name: foodItem.name,
          price: foodItem.price,
          imagePath: foodItem.imagePath,
          quantity: qty.toString(),
        ),
      );
    }

    notifyListeners();
  }

  void clearCart() {
    _cart.clear();
    notifyListeners();
  }

  void removeFromCart(CartModel item) {
    for (var cartItem in _cart) {
      if (cartItem.name == item.name) {
        if (int.parse(cartItem.quantity.toString()) > 1) {
          cartItem.quantity =
              (int.parse(cartItem.quantity.toString()) - 1).toString();
        } else {
          _cart.remove(cartItem);
          break;
        }
        break;
      }
    }
    notifyListeners();
  }
}
