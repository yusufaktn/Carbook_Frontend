class Categorymodel {
  int CategoryId;
  String CategoryName;
  String? imageUrl; // Opsiyonel alan

  Categorymodel({
    required this.CategoryId,
    required this.CategoryName,
    this.imageUrl,
  });

  factory Categorymodel.fromJson(Map<String, dynamic> json) {
    return Categorymodel(
      CategoryId: json['categoryId'],
      CategoryName: json['name'],
      imageUrl: json['imageUrl'],
    );
  }
}
