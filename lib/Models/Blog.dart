class Blog {
  String? userName;
  String? userImage;
  String? blog;
  String? image;
  String? uID;
  String? date;
  String? category;
  String? id;
  List<dynamic>? likes;
  List<dynamic>? savers;
  String? audience;

  Blog({required this.userName,required this.userImage,required this.blog,required this.image, required this.uID, required this.date, required this.category, this.id,required this.likes,required this.savers,required this.audience});


  Blog.fromjson(Map<String,dynamic> json)
  {
    userName = json['userName'];
    userImage = json['userImage'];
    blog = json['blog'];
    image = json['image'];
    uID = json['uID'];
    date = json['date'];
    category = json['category'];
    id = json['id'];
    likes = json['likes'];
    savers = json['savers'];
    audience = json['audience'];
  }

  Map<String,dynamic> toMap() {
    return {
      'userName' : userName,
      'userImage' : userImage,
      'blog' : blog,
      'image' : image,
      'uID' : uID,
      'date' : date,
      'category' : category,
      'likes' : likes,
      'savers' : savers,
      'audience' : audience,
    };
  }

}