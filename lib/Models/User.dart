class UserModel
{
  String? name;
  String? email;
  String? phone;
  int? age;
  String? about;
  String? country;
  String? uID;
  String? image = "https://imgv3.fotor.com/images/blog-richtext-image/part-blurry-image.jpg";
  bool? isEmailVerified;
  List<dynamic>? followers;
  List<dynamic>? following;
  String? token;
  List<dynamic>? blocked;
  bool? locked ;

  UserModel({this.name,  this.image, this.email,  this.phone,  this.uID, this.age, this.about, this.country,  this.isEmailVerified, this.followers, this.following,required this.token,required this.blocked,required this.locked});

  UserModel.fromjson(Map<String,dynamic> json)
  {
      name = json['name'];
      image = json['image'];
      email = json['email'];
      phone = json['phone'];
      age = json['age'];
      about = json['about'];
      country = json['country'];
      uID = json['uID'];
      isEmailVerified = json['isEmailVerified'];
      followers = json['followers'];
      following = json['following'];
      token = json['token'];
      blocked = json['blocked'];
      locked = json['locked'];
  }

  Map<String,dynamic> toMap() {
    return {
      'name' : name,
      'image' : image,
      'email' : email,
      'phone' : phone,
      'age' : age,
      'about' : about,
      'country' : country,
      'uID' : uID,
      'isEmailVerified' : isEmailVerified,
      'followers' : followers,
      'following' : following,
      'token' : token,
      'blocked' : blocked,
      'locked' : locked,
    };
  }

}