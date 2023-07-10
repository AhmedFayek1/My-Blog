class ChatModel
{
  String? senderID;
  String? receiverID;
  String? text;
  String? datetime;
  String? image;


  ChatModel({this.senderID,this.receiverID,this.text,this.datetime,this.image});

  ChatModel.fromjson(Map<String,dynamic> json)
  {
    senderID = json['senderID'];
    receiverID = json['receiverID'];
    text = json['text'];
    datetime = json['datetime'];
    image = json['image'];
  }

  Map<String,dynamic> toMap() {
    return {
      'senderID' : senderID,
      'receiverID' : receiverID,
      'text' : text,
      'datetime' : datetime,
      'image': image,
    };
  }

}