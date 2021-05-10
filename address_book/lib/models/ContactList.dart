class ContactList {
  int id;
  String name;
  String phoneNumber;
  int catId;
  String imgUrl;

  ContactList({this.id, this.name, this.phoneNumber, this.catId, this.imgUrl});
  ContactList.insert({this.name, this.phoneNumber, this.catId, this.imgUrl});

  ContactList.fromMap(Map<String, dynamic> contactList) {
    this.id = contactList['id'];
    this.name = contactList['name'];
    this.phoneNumber = contactList['phone_number'];
    this.catId = contactList['cat_id'];
    this.imgUrl = contactList['img_url'];
  }
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone_number': phoneNumber,
      'cat_id': catId,
      'img_url': imgUrl,
    };
  }
}