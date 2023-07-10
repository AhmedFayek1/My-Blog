import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:myblog/Modules/Home_Screen/Home/home_cubit.dart';
import 'package:myblog/Modules/Users/users_screen.dart';
import 'package:myblog/Shared/App_Colors.dart';
import 'package:myblog/Shared/constants.dart';
import '../../Models/Blog.dart';
import '../../Models/User.dart';
import '../../Modules/Login_Screen/SocialLoginCubit/LoginStates.dart';
import '../../Modules/Profile/Profile_Screen.dart';
import '../../Modules/Register_Screen/Register_Cubit/Register_States.dart';

void navigate(context, widget) =>
    Navigator.push(context, MaterialPageRoute(builder: (context) => widget));

void navigateToFinish(context, widget) => Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => widget),
      (Route<dynamic> route) => false,
    );

Widget field({
  required  var controller,
  required  Function(String) validator,
  Function(String value)? onChanged,
  required  String label,
  Icon? icon,
  bool obsecureText = false,
  var type = TextInputType.text,
  Function? onFieldSubmitted,
  var suffixIcon,
  IconButton? suffix,
  double hieght = 70,
  int maxLine = 1,
  bool outLineBorder = true,
  Color color = Colors.white,
}) {
  return Container(
    height: hieght,
    padding: const EdgeInsets.only(bottom: 20),
    width: double.infinity,
    decoration: const BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(20)),
    ),
    child: TextFormField(
      keyboardType: TextInputType.multiline,
      controller: controller,
      validator: (String? value) => validator(value!),
      onChanged: onChanged,
      //keyboardType: type,
      maxLines: maxLine,
      decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(10),
          fillColor: Colors.white.withOpacity(0.6),
          filled: true,
          errorMaxLines: 2,
          hintText: label,
          prefixIcon: icon,
          suffixIcon: suffix,
          border: outLineBorder
              ? OutlineInputBorder(borderRadius: BorderRadius.circular(10))
              : InputBorder.none),
      obscureText: obsecureText,
      onFieldSubmitted: (onFieldSubmittedValue) {
        onFieldSubmitted!();
      },
    ),
  );
}

Widget myText(
    {
      context,
      required String text,
      double size = 14,
      bool bold = false,
      Color color = Colors.black,
      int lines = 99,
    }) {
return GestureDetector(
    onLongPress: () {
      Clipboard.setData(ClipboardData(text: text));
      ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Copied to Clipboard"),));
    },
    child: Text(
       text,
       style: TextStyle(
        fontSize: size,
        fontWeight: bold == true ? FontWeight.bold : FontWeight.normal,

        color: color,
        fontFamily: 'myFont'
      ),
      maxLines: lines,
      overflow: TextOverflow.ellipsis,
    ),
  );
}

Widget button({
  required  Function fun,
  required  String textButton,
  Color color = Colors.white,
  double width = double.infinity,
  double size = 20,
}) {
  return Container(
    width: width,
    height: 50,
    decoration: BoxDecoration(
      gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.redAccent.withAlpha(200), Colors.pinkAccent.withAlpha(200)]),
      border: Border.all(width: 0.2),
      borderRadius: const BorderRadius.all(Radius.circular(10)),
    ),
    child: MaterialButton(
      elevation: 0,
      onPressed: () {
        fun();
      },
      child: Center(
          child:
              myText(text: textButton, size: size, color: color, bold: true)),
    ),
  );
}

void showToast({required  String message, required  ToastStates state}) =>
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 5,
        backgroundColor: ShowColor(state),
        textColor: Colors.white,
        fontSize: 16.0);

enum ToastStates { SUCCESS, ERROR, WARNING }

Color? color;

Color ShowColor(ToastStates state) {
  switch (state) {
    case ToastStates.SUCCESS:
      color = Colors.green;
      break;
    case ToastStates.ERROR:
      color = Colors.red;
      break;
    case ToastStates.WARNING:
      color = Colors.amber;
      break;
  }
  return color!;
}

Widget errorMessage(String text) {
  return Container(
      height: 40,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.redAccent, Colors.pinkAccent]),
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: Center(
        child: myText(text: text, size: 20, bold: true, color: Colors.white),
      ));
}

Widget errorRegisterationBox(BlogAppRegisterStates state) {
  if (state is BlogAppRegisterErrorState &&
      state.error.code == 'email-already-in-use') {
    return errorMessage("User Already Exist");
  }
  if (state is BlogAppRegisterErrorState && state.error.code == 'invalid-email') {
    return errorMessage("Invalid Email Address");
  }
  if (state is BlogAppRegisterErrorState &&
      state.error.code == 'network-request-failed') {
    return errorMessage("No Internet Connection");
  } else {
    return const SizedBox(
      height: 20.00,
    );
  }
}

Widget errorLoginBox(BlogAppLoginStates state) {
  if (state is BlogAppLoginErrorState && state.error.code == 'user-not-found') {
    return errorMessage("User Not Found");
  }
  if (state is BlogAppLoginErrorState && state.error.code == 'wrong-password') {
    return errorMessage("Incorrect Password");
  }
  if (state is BlogAppLoginErrorState && state.error.code == 'invalid-email') {
    return errorMessage("Invalid Email Address");
  }
  if (state is BlogAppLoginErrorState &&
      state.error.code == 'network-request-failed') {
    return errorMessage("No Internet Connection");
  } else {
    return const SizedBox(
      height: 20.00,
    );
  }
}

Widget line() {
  return Container(
    padding: const EdgeInsets.all(10),
    height: 2,
    decoration: BoxDecoration(
      color: Colors.grey[400],
      borderRadius: const BorderRadius.all(Radius.circular(10)),
    ),
  );
}

Widget buildItemCard(Blog blog, context, index) {
  List<String> date = BlogAppCubit.get(context).splitDate(blog.date!);
  return Container(
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.6),
      // gradient: LinearGradient(
      //   colors: index % 2 ==0 ? [
      //     Colors.white.withOpacity(0.6),
      //     Colors.pinkAccent.withOpacity(0.6),
      //   ] : [
      //     Colors.pinkAccent.withOpacity(0.6),
      // Colors.white.withOpacity(0.6),
      // ],
      // ),
      borderRadius: const BorderRadius.all(Radius.circular(35)),
    ),
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(1),
            child: Row(
              children: [
                InkWell(
                  onTap: () async {
                    UserModel user = BlogAppCubit.get(context).getUser(blog.uID!)!; navigate(context, ProfileScreen(user));
                  },
                  child: circleAvatar(
                    image : blog.userImage!,
                    radius: 30,
                  )
                ),
                const SizedBox(
                  width: 10.00,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        myText(
                            text: blog.userName!, size: 20.00, bold: true),
                        const SizedBox(
                          width: 5.00,
                        ),
                      ],
                    ),  
                    Row(
                      children: [
                        myText(text: date[1], size: 15, color: Colors.grey[600]!),
                        const SizedBox(width: 5,),
                        myText(text: date[0], size: 15, color: Colors.grey[600]!),
                        const SizedBox(width: 5,),
                        myText(text: date[2], size: 15, color: Colors.grey[600]!),

                       // myText(text: blog.date!, size: 15, color: Colors.grey[600]!),
                      ],
                    ),
                    myText(
                        text: blog.category!,
                        size: 15,
                        color: Colors.grey[600]!),
                  ],
                ),
                const Spacer(),
                menu(
                    fun: (value) {
                      BlogAppCubit.get(context)
                          .blogSettings(context, value, blog);
                    },
                    list: blog.uID == uID
                        ? ['Edit', 'Delete']
                        : [
                            blog.savers!.contains(uID) ? 'Unsave' : 'Save',
                            'Report'
                          ])
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15.00),
            child: Container(
              width: double.infinity,
              height: 1.00,
              color: Colors.grey[300],
            ),
          ),
          myText(
            context: context,
            text: blog.blog!,
             size: 20.00,
          ),
          if (blog.image != null)
            SizedBox(
              height: 190.00,
              child: Stack(
                  alignment: AlignmentDirectional.bottomCenter,
                  children: [
                    Align(
                      alignment: AlignmentDirectional.topCenter,
                      child: Padding(
                          padding:
                              const EdgeInsets.symmetric(vertical: 5.00),
                          child: Stack(
                            children: [
                              Container(
                                width: double.infinity,
                                height: 150.00,
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(5.00)),
                                  image: DecorationImage(
                                      image: NetworkImage(blog.image!),
                                      fit: BoxFit.cover),
                                ),
                              ),
                            ],
                          )),
                    ),
                  ]),
            ),
          const SizedBox(
            height: 5,
          ),
          Row(
            children: [
              IconButton(
                onPressed: () {
                  BlogAppCubit.get(context).addLike(blog);
                },
                icon: const Icon(
                  Icons.favorite,
                  color: Colors.red,
                ),
              ),
              const SizedBox(
                width: 5.00,
              ),
              InkWell(
                  onTap: () {
                    List<UserModel> users =
                        BlogAppCubit.get(context).listUsers(blog.likes!);
                    navigate(context, UsersScreen(users,title: 'Likes',));
                  },
                  child: myText(text: "${blog.likes!.length}")),
            ],
          )
        ],
      ),
    ),
  );
}

Widget buildUserItem(UserModel model, context, index,{String status = 'none'}) {
  return InkWell(
    onTap: () {
      if(status == 'none') {
        navigate(context, ProfileScreen(model));
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: myText(text: 'Are you sure you want to ${status == 'block' ? 'block' : 'unblock'} ${model.name}?', size: 20, bold: true),
            actions: [
              TextButton(
                onPressed: () {
                  BlogAppCubit.get(context).blockUser(model.uID!,context);
                  Navigator.pop(context);
                },
                child: myText(text: 'Yes', size: 20, bold: true),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: myText(text: 'No', size: 20, bold: true),
              ),
            ],
          ),
        );
      }
    },
    child: Container(

      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white60,
        borderRadius: BorderRadius.all(Radius.circular(30)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(1),
              child: Row(
                children: [
                  circleAvatar(
                    image: model.image!,
                    radius: 20.00,
                  ),
                  const SizedBox(
                    width: 10.00,
                  ),
                  myText(text: model.name!, size: 20.00, bold: true),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget buildFilteredUsers(UserModel user, context, index) {
  return InkWell(
    onTap: () {
      navigate(context, ProfileScreen(user));
    },
    child: Container(
      height: 50,
      width: double.infinity,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(30)),
      ),
      child: Card(
          color: Colors.grey[200],
          clipBehavior: Clip.antiAliasWithSaveLayer,
          elevation: 10.00,
          margin: const EdgeInsets.symmetric(horizontal: 10),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                circleAvatar(
                  image: user.image!,
                  radius: 20.00,
                ),
                const SizedBox(
                  width: 10,
                ),
                myText(text: user.name!),
              ],
            ),
          )),
    ),
  );
}

// PreferredSizeWidget customAppBar({required String text,double size = 20,Color color = Colors.white,bool bold = false,List<Widget>? sentActions = []})
// {
//   return AppBar(
//     title: myTitle(text: text,size: size,bold: bold ,color: color),
//     actions: sentActions!.isNotEmpty ? sentActions : [],
//     backgroundColor: appBar,
//   );
// }

Widget screenWithImage(Widget widget) {
  return Container(
    padding: const EdgeInsets.all(10),
    width: double.infinity,
    height: double.infinity,
    decoration:  BoxDecoration(
        image: DecorationImage(
            image: Image.asset('assets/images/background.jpg').image,
        opacity: 0.7,
        fit: BoxFit.cover

        // gradient: LinearGradient(
        //   colors: [Colors.pink,Colors.white38],
        //   begin: Alignment.topCenter,
        //   end: Alignment.bottomCenter,
        // ),
    ),
        ),
    child: SafeArea(child: widget),
  );
}

Widget menu(
    {
      required  Function(String) fun,
    required  List<String> list,
      String? text
    }) {
  return PopupMenuButton(
    //color: Colors.grey[400],
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    onSelected: (String? value) => fun(value!),
    itemBuilder: (BuildContext context) {
      return list.map((String choice) {
        return PopupMenuItem(
          value: choice,
          child: Text(choice),
        );
      }).toList();
    },
    child: text != null ? myText(text: text) : const Icon(Icons.more_vert),
  );
}

Widget drobMenu({
      context,
      required  Function(String) fun,
      required  List<String> list,
      var text
    }) {
  //BlogAppCubit.get(context).first = list[0];

  return DropdownButton(
    // Initial Value
    value: text,

    // Down Arrow Icon
    icon: const Icon(Icons.keyboard_arrow_down),
    hint: myText(text: "Category"),
    // Array list of items
    items: list.map<DropdownMenuItem<String>>((String item) {
      return DropdownMenuItem(
        value: item,
        child: Text(item),
      );
    }).toList(),
    // After selecting the desired option,it will
    // change button value to selected value
    onChanged: (val) => fun(val.toString()),
  );
}


void delayNav(context, Widget widget) {
  Timer(const Duration(milliseconds: 1000), () {
    Navigator.push(context, MaterialPageRoute(builder: (_) => widget));
  });
}
Widget backArrow(context)
{
  return Center(
    child: IconButton(onPressed: ()
        {
          Navigator.pop(context);
        },
        icon: const Icon(Icons.arrow_back_ios_new,size: 30,)),
  );
}

Widget circleAvatar({required String image,required double radius})
{
  return CircleAvatar(
    backgroundImage: NetworkImage(image),
    radius: radius,
  );
}

Widget circleIconAvatar({required var child,double radius = 25,Color color = Colors.grey})
{
  return CircleAvatar(
    backgroundColor: color,
    child: child,
    radius: radius,
  );
}
