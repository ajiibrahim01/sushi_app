class Food {
  String? name;
  String? description;
  String? price;
  String? imagePath;
  String? rating;

  Food({this.name, this.description, this.price, this.imagePath, this.rating});

  Food.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    description = json['description'];
    price = json['price'];
    imagePath = json['image_path'];
    rating = json['rating'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['description'] = this.description;
    data['price'] = this.price;
    data['image_path'] = this.imagePath;
    data['rating'] = this.rating;
    return data;
  }
}
