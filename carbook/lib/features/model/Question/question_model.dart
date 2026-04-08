class QuestionModel {
  int questionId;
  int userId;
  String userName;
  String userLastName;
  int categoryId;
  String categoryName;
  int brandId;
  String brandName;
  String subBrandCategory;
  String title;
  String content;

  QuestionModel({
    required this.userName,
    required this.userLastName,
    required this.categoryName,
    required this.brandName,
    required this.questionId,
    required this.userId,
    required this.categoryId,
    required this.brandId,
    required this.subBrandCategory,
    required this.title,
    required this.content,
  });
  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      userName: json['userName'] ?? '',
      userLastName: json['userLastName'] ?? '',
      categoryName: json['categoryName'] ?? '',
      brandName: json['brandName'] ?? '',
      questionId: json['questionId'],
      userId: json['userId'],
      categoryId: json['categoryId'],
      brandId: json['brandId'],
      subBrandCategory: json['subBrandCategory'] ?? '',
      title: json['title'] ?? '',
      content: json['content'] ?? '',
    );
  }
}
