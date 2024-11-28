class CartModel {
  String? name;
  String? price;
  String? imagePath;
  String? quantity;

  CartModel({
    this.name,
    this.price,
    this.imagePath,
    this.quantity,
  });

  CartModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    price = json['price'];
    imagePath = json['imagePath'];
    quantity = json['quantity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['price'] = this.price;
    data['imagePath'] = this.imagePath;
    data['quantity'] = this.quantity;
    return data;
  }
}
