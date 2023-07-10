import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myblog/Models/User.dart';
import 'package:myblog/Modules/Home_Screen/Home/home_cubit.dart';
import '../../Models/Chat_Model/Chat_Model.dart';
import '../../Shared/constants.dart';
import 'Messanger_states.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;


class MessengerAppCubit extends Cubit<MessengerAppStates> {
  MessengerAppCubit() : super(MessengerAppInitialState());

  static MessengerAppCubit get(context) => BlocProvider.of(context);

  void sendChat({
    required String receiverID,
    required String text,
    required String datetime,
    String? image,
  }) {
    ChatModel chatModel = ChatModel(
      senderID: uID,
      receiverID: receiverID,
      text: text,
      datetime: datetime,
      image: image ?? null,
    );
    FirebaseFirestore.
    instance.
    collection('users').
    doc(uID).
    collection('chats').
    doc(receiverID).
    collection('messages').
    add(chatModel.toMap()).
    then((value) {
      emit(SocialSendMessagesSuccessState());
    }).catchError((onError) {
      emit(SocialSendMessagesErrorState());
    });
    FirebaseFirestore.
    instance.
    collection('users').
    doc(receiverID).
    collection('chats').
    doc(uID).
    collection('messages').
    add(chatModel.toMap()).
    then((value) {
      emit(SocialSendMessagesSuccessState());
    }).catchError((onError) {
      emit(SocialSendMessagesErrorState());
    });
  }

  List<ChatModel> messages = [];

  void getMessages({required String receiverID}) {
    FirebaseFirestore.
    instance.
    collection('users').
    doc(uID).
    collection('chats').
    doc(receiverID).
    collection('messages').
    orderBy('datetime').
    snapshots().
    listen((event) {
      messages = [];
      event.docs.forEach((element) {
        messages.add(ChatModel.fromjson(element.data()));
      });
      emit(SocialGetMessagesSuccessState());
    });
  }


  File messageImage = File('');

  Future<void> getMessageImage() async
  {
    final pickedFile = await ImagePicker.platform.getImage(
        source: ImageSource.gallery);
    if (pickedFile != null) {
      messageImage = File(pickedFile.path);
      emit(SocialUpdatePostImageSuccessState());
    }
    else {
      emit(SocialUpdatePostImageErrorState());
    }
  }

  void sendImageMessage({
    required String receiverID,
    required String text,
    required String datetime,
  }) {
    firebase_storage.FirebaseStorage.
    instance.
    ref().
    child('messages/${Uri
        .file(messageImage.path)
        .pathSegments
        .last}').
    putFile(messageImage).
    then((value) {
      value.ref.getDownloadURL().then((value) {
        sendChat(
          receiverID: receiverID,
          text: text,
          datetime: datetime,
          image: value,
        );
        emit(SocialSendImageMessageSuccessState());
      });
    }).catchError((onError) {
      emit(SocialSendMessagesErrorState());
    });
  }

  Map<String, List<ChatModel>> usersChat = {};
  List<String> usersUIDs = [];
  Future<void> getUsersChats(context) async
  {
    List<dynamic> users = BlogAppCubit.get(context).allUsersUIDs;
    usersChat = {};
    usersUIDs = [];
      for (var user in users
     ) {
        usersChat[user] = [];
      FirebaseFirestore.
      instance.
      collection('users').
      doc(uID).
      collection('chats').
      doc(user).
      collection('messages').
      orderBy('datetime').
      snapshots().
      listen((event) {
        event.docs.forEach((element) {
          usersChat[user]!.add(ChatModel.fromjson(element.data()));
        });
        if(usersChat[user]!.isNotEmpty ) {
          if(!usersUIDs.contains(user)) {
            usersUIDs.add(user);
          }
        }
      });
  }
    emit(SocialGetMessagesSuccessState());
}
}