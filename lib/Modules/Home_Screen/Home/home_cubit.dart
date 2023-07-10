import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myblog/Models/Blog.dart';
import 'package:myblog/Models/User.dart';
import 'package:myblog/Modules/Edit_Blog/EditBlogScreen.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:myblog/Modules/Home_Screen/Home_Screen.dart';
import '../../../Shared/Components/components.dart';
import '../../../Shared/Network/local/Cache_Helper.dart';
import '../../../Shared/constants.dart';
import '../../../Shared/notifications.dart';
import '../../Login_Screen/Login_Screen.dart';
import '../../Users/users_screen.dart';
import 'home_states.dart';


class BlogAppCubit extends Cubit<BlogAppStates> {
  BlogAppCubit() : super(BlogAppInitialState());

  static BlogAppCubit get(context) => BlocProvider.of(context);

  UserModel? myData;
  var usersDB = FirebaseFirestore.instance.collection('users');
  var myBlogsDB = FirebaseFirestore.instance
      .collection('users')
      .doc(uID)
      .collection('blogs');
  List<Blog> allBlogs = [];
  List<UserModel> allUsers = [];
  List<UserModel> blockedUsers = [];
  List<String> allUsersUIDs = [];
  List<Blog> savedBlogs = [];
  File userImage = File('');
  File blogImage = File('');

  Map<String, List<Blog>> usersBlogs = {};

  Future<void> getCurrentUserData() async {
      await usersDB.doc(uID).get().then((value) {
      myData = UserModel.fromjson(value.data()!);
      emit(BlogAppGetCurrentUserDataSuccessState());
    }).catchError((e) {
      emit(BlogAppGetCurrentUserDataErrorState(e));
    });
  }

  Future<void> getAllBlogs() async {
    allUsers = [];
    blockedUsers = [];
    allUsersUIDs = [];
    allBlogs = [];
    savedBlogs = [];
    usersBlogs = {};

    await usersDB.get().then((event) {
      event.docs.forEach((user) {
        handleBlockedUsers(user);
        allUsersUIDs.add(UserModel.fromjson(user.data()).uID!);
        user.reference
            .collection('blogs')
            .orderBy('date', descending: true)
            .get()
            .then((value) {
          for (var element in value.docs) {
            setBlogs(UserModel.fromjson(user.data()), Blog.fromjson(element.data()));
          }
          emit(BlogAppGetAllBlogsSuccessState());
        });
      });
    }).catchError((error) {
      emit(BlogAppGetAllBlogsErrorState(error));
    });
  }

  void handleBlockedUsers(QueryDocumentSnapshot<Map<String, dynamic>> user) {
    if(!myData!.blocked!.contains(UserModel.fromjson(user.data()).uID!)) {
      allUsers.add(UserModel.fromjson(user.data()));
    }
    else
    {
      blockedUsers.add(UserModel.fromjson(user.data()));
    }
  }

  List<String> splitDate(String date) {
    List<String> dateList = [];
    //dateList[0] = date.substring(0, 4); //year
    dateList.add(date.substring(5, 7)); //month
    dateList.add(date.substring(8, 10)); //day
    dateList.add(date.substring(11, 16)); //hour

    return dateList;
  }

  Future<void>? uploadBlogWithImage({
    required context,
    required String blog,
    required String category,
    required String audience,
  }) {
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('blogs/${Uri.file(blogImage.path).pathSegments.last}')
        .putFile(blogImage)
        .then((p0) {
      p0.ref.getDownloadURL().then((value) {
        uploadBlog(
          context: context,
          image: value,
          blog: blog,
          category: category,
          audience: audience,
        );
        emit(BlogAppUplodeBlogImageSuccessState());
      }).catchError((e) {
        emit(BlogAppUplodeBlogImageErrorState(e));
      }).catchError((e) {
        emit(BlogAppUplodeBlogImageErrorState(e));
      });
    });
    return null;
  }

  Future<void> uploadBlog({
    required context,
    String? image,
    required String blog,
    required String category,
     required String audience,
  }) async {
    Blog newBlog = Blog(
      userName: myData!.name,
      userImage: myData!.image,
      blog: blog,
      image: image,
      uID: uID,
      date: DateTime.now().toString(),
      category: category,
      likes: [],
      savers: [],
      audience: audience,
    );
    myBlogsDB.add(newBlog.toMap()).then((value) {
      value.update({'id': value.id}).then((value) {
        getAllBlogs();
      });
      // usersBlogs[uID]!.add(newBlog);
      MyNotifications(context: context).sendPushNotification(myData!.followers!, "Blog Update", "${myData!.name} Add a new blog tab to view");
      MyNotifications(context: context).pushNotification(myData!.token!, "Blog Update" ,"Your blog has been added successfully");
      emit(BlogAppUploadBlogSuccessState());
    }).catchError((e) {
      emit(BlogAppUploadBlogErrorState(e));
    });
  }

  Future<void> updateBlogDataWithImage(
      {required Blog blogg, required String blog, required String category, required String audience}) async {
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('blogs/${Uri.file(blogImage.path).pathSegments.last}')
        .putFile(blogImage)
        .then((p0) {
      p0.ref.getDownloadURL().then((value) {
        updateBlogData(
            blogg: blogg,
            blog: blog,
            category: category,
            audience: audience,
            image: value);
      });
    });
  }

  void updateBlogData(
      {
        required  Blog blogg,
      required  String blog,
      required  String category,
      required  String audience,
        String? image}) {
    myBlogsDB.doc(blogg.id).update({
      'blog': blog,
      'audience': audience,
      'category': category,
      if (image != null) 'image': image
    }).then((value) {
      getAllBlogs();
      //getUserBlogs(uID);
      emit(BlogAppUpdateBlogSuccessState());
    }).catchError((e) {
      emit(BlogAppUpdateBlogErrorState(e));
    });
  }

  void deleteBlog(Blog blog) {
    myBlogsDB.doc(blog.id).delete().then((value) {
      usersBlogs[uID]!.remove(blog);
      allBlogs.remove(blog);
      //getAllBlogs();
      emit(BlogAppDeleteBlogSuccessState());
    }).catchError((e) {
      emit(BlogAppDeleteBlogErrorState(e));
    });
  }

  void blogSettings(context, String value, Blog blog) {
    if (value == 'Edit')
      navigate(context, EditBlogScreen(blog));
    else if (value == "Delete")
      deleteBlog(blog);
    else if (value == "Save" || value == "Unsave") saveBlog(blog);
    //else if (value == "Report") deleteBlog(blog);
  }

  void userSettings(context, String value, UserModel user) {
    if (value == 'Block' || value == 'Unblock') {
      blockUser(user.uID!,context);
    } else if (value == "Lock") {
      lockProfile();
    } else if (value == "Unlock") {
      lockProfile();
    }
    else if (value == "Blocked Users") {
      navigate(context, UsersScreen(blockedUsers,status: 'b',title: 'Blocked Users',));
    }
  }




  void setAudienceBlog(UserModel user, Blog blog, List<dynamic> list) {
    if (blog.audience == "Public" || blog.uID == uID)
      list.add(blog);
    else if (blog.audience == "Followers" &&
        user.followers!.contains(myData!.uID)) list.add(blog);
  }

  void addLike(Blog blog) {
    if (!blog.likes!.contains(myData!.uID)) {
      blog.likes!.add(myData!.uID);
      usersDB
          .doc(blog.uID)
          .collection('blogs')
          .doc(blog.id)
          .update({'likes': blog.likes}).then((value) {
        //getAllBlogs();
        emit(BlogAppAddLikeSuccessState());
      }).catchError((e) {
        emit(BlogAppAddLikeErrorState(e));
      });
    } else {
      blog.likes!.remove(myData!.uID);
      usersDB
          .doc(blog.uID)
          .collection('blogs')
          .doc(blog.id)
          .update({'likes': blog.likes}).then((value) {
        //getAllBlogs();
        emit(BlogAppRemoveLikeSuccessState());
      }).catchError((e) {
        emit(BlogAppRemoveLikeErrorState(e));
      });
    }
  }

  void follow(UserModel user, {required context}) {
    if (!user.followers!.contains(myData!.uID)) {
      user.followers!.add(myData!.uID);
      myData!.following!.add(user.uID);

      usersDB.doc(user.uID).update({'followers': user.followers}).then((value) {
        usersDB.doc(uID).update({'following': myData!.following}).then((value) {
          MyNotifications(context: context).pushNotification(myData!.token!, "Hello ${myData!.name}", "you started following ${user.name}");
          MyNotifications(context: context).pushNotification(user.token!, "Hello ${user.name}", "${myData!.name} started following you");
          //getAllBlogs();
          emit(BlogAppSendFollowSuccessState());
        }).catchError((e) {

          emit(BlogAppSendFollowErrorState(e));
        });
      });
    } else {
      user.followers!.remove(myData!.uID);
      myData!.following!.remove(user.uID);

      usersDB.doc(user.uID).update({'followers': user.followers}).then((value) {
        usersDB.doc(uID).update({'following': myData!.following}).then((value) {
          //getAllBlogs();
          emit(BlogAppRemoveFollowSuccessState());
        }).catchError((e) {
          print(e.toString());
          emit(BlogAppRemoveFollowErrorState(e));
        });
      });
    }
    // getAllBlogs();
  }

  Future<void> getUserImage() async {
    final pickedFile =
        await ImagePicker.platform.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      userImage = File(pickedFile.path);
      emit(BlogAppUploadUserImageSuccessState());
    } else {
      emit(BlogAppUploadUserImageErrorState());
    }
  }


  Future<void> getBlogImage() async {
    final pickedFile =
    await ImagePicker.platform.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      blogImage = File(pickedFile.path);
      emit(BlogAppUploadBlogImageSuccessState());
    } else {
      emit(BlogAppUploadBlogImageErrorState());
    }
  }

  void updateUserData({
    required  String name,
    required  int age,
    required  String phone,
    required  String country,
    required  String about,
  }) {
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(userImage.path).pathSegments.last}')
        .putFile(userImage)
        .then((p0) {
      p0.ref.getDownloadURL().then((value) {
        update(
          name: name,
          age: age,
          phone: phone,
          image: value,
          country: country,
          about: about,
        );
        emit(BlogAppUplodeCoverImageSuccessState());
      }).catchError((e) {
        emit(BlogAppUplodeCoverImageErrorState(e));
      }).catchError((e) {
        emit(BlogAppUplodeCoverImageErrorState(e));
      });
    });
  }

  void updateUserBlogs(String name, String image) {
    myBlogsDB.get().then((value) {
      value.docs.forEach((element) {
        element.reference.update({'userName': name, 'userImage': image});
      });
    });
    emit(BlogAppUpdateBlogUserDataSuccessState());
  }

  Future<void> update({
    required String name,
    required int age,
    required String phone,
    String? image,
    required String country,
    required String about,
  }) async {
    if (image == null) image = myData!.image!;
    usersDB.doc(uID).update({
      'name': name,
      'age': age,
      'phone': phone,
      'image': image,
      'country': country,
      'about': about
    }).then((value) {
      updateUserBlogs(name, image!);
      getCurrentUserData();
      getAllBlogs();
      emit(BlogAppUpdateUserDataSuccessState());
    }).catchError((e) {
      emit(BlogAppUpdateUserDataErrorState(e));
    });
  }

  List<UserModel> listUsers(List<dynamic> list) {
    List<UserModel> users = [];
    for (var element in allUsers) {
      for (var element2 in list) {
        if (element.uID == element2) users.add(element);
      }
    }
    return users;
  }

  void setBlogs(UserModel user, Blog blog) {
    if(!usersBlogs.containsKey(user.uID)) {
      usersBlogs[user.uID!] = [];
    }

        setAudienceBlog(user, blog, usersBlogs[user.uID]!);
        setAudienceBlog(user, blog, allBlogs);

      if (blog.savers!.contains(uID)) {
        savedBlogs.add(blog);
      }
  }

  void saveBlog(Blog blog) {
    List<dynamic> savers = blog.savers!;
    if (!savers.contains(myData!.uID)) {
      savers.add(uID);
      savedBlogs.add(blog);
    } else {
      savers.remove(uID);
      savedBlogs.remove(blog);
    }

    usersDB
        .doc(blog.uID)
        .collection('blogs')
        .doc(blog.id)
        .update({'savers': savers}).then((value) {
      //getAllBlogs();
      emit(BlogAppSaveBlogSuccessState());
    }).catchError((e) {
      emit(BlogAppSaveBlogErrorState(e));
    });
  }

  List<String> categories = ['News', 'Science', 'Cinema', 'Technology'];
  List<String> audience = ['Public', 'Followers', 'Only me'];

  String category = 'News';
  String aud = 'Public';

  void setCategories(String newvalue) {
    category = newvalue;
    emit(ChangeDrobDownMenuItemState());
  }

  void setAudience(String newvalue) {
    aud = newvalue;
    emit(ChangeDrobDownMenuItemState());
  }

  void RemovePostImage() {
    blogImage.delete();
    emit(BlogAppRemovePostImageSuccessState());
  }

  UserModel? getUser(String id)  {
     for (var element in allUsers) {
      if (element.uID! == id) {
        return element;
      }
    }
  }

  List<UserModel> filteredList = [];
  void filterItems(String query) {
    if (query.isNotEmpty) {
      filteredList = allUsers
          .where(
              (item) => item.name!.toLowerCase().contains(query.toLowerCase()))
          .toList();
      emit(BlogAppFilterDataState());
    } else {
      filteredList.clear();
      emit(BlogAppFilterDataState());
    }
  }

  void blockUser(String id,context)
  {
    List<dynamic> blocked = myData!.blocked!;
    blocked.contains(id) ? blocked.remove(id) : blocked.add(id);
    usersDB.doc(uID).update({'blocked': blocked}).then((value) {
      getCurrentUserData();
      getAllBlogs();
      navigateToFinish(context, HomeScreen());
      emit(BlogAppBlockUserSuccessState());
    }).catchError((e) {
      emit(BlogAppBlockUserErrorState(e));
    });
  }

  void lockProfile()
  {
    bool myProfile = !myData!.locked!;
    usersDB.doc(uID).update({'locked': myProfile}).then((value) {
      getCurrentUserData();
      emit(BlogAppLockProfileSuccessState());
    }).catchError((e) {
      emit(BlogAppLockProfileErrorState(e));
    });
  }
}
