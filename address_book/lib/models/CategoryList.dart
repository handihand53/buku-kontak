class CategoryList {
  int id;
  String name;
  int color;

  CategoryList({this.id, this.name, this.color});
  CategoryList.insert({this.name, this.color});

  CategoryList.fromMap(Map<String, dynamic> categoryList) {
    this.id = categoryList['id'];
    this.name = categoryList['name_cat'];
    this.color = categoryList['color'];
  }
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name_cat': name,
      'color': color,
    };
  }
}