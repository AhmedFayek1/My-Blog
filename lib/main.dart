import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myblog/Modules/Home_Screen/Home/home_cubit.dart';
import 'package:myblog/Modules/Login_Screen/SocialLoginCubit/LoginCubit.dart';
import 'package:myblog/Modules/Messanger/Messanger_cubit.dart';
import 'package:myblog/Modules/Welcome/welcome_screen.dart';
import '../../Shared/Network/local/Cache_Helper.dart';
import 'Modules/Home_Screen/Home_Screen.dart';
import 'Shared/Bloc_Observer.dart';
import 'Shared/constants.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  //print("backGround ${message.messageId}");
}
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
 FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  Bloc.observer = MyBlocObserver();
  await Firebase.initializeApp();

  await CacheHelper.init();
  Widget widget;
  uID = CacheHelper.GetData(key: 'uID');


  if(uID != null) widget = HomeScreen();
  else widget = WelcomeScreen();

  runApp(MyApp(startwidget: widget,));
}

class MyApp extends StatelessWidget {
  final Widget startwidget;
  MyApp({required this.startwidget});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider (
      providers: [
            BlocProvider(create: (BuildContext context) => BlogAppCubit()..getCurrentUserData()..getAllBlogs()),
             BlocProvider(create: (BuildContext context) => MessengerAppCubit(),),
             BlocProvider(create: (BuildContext context) => BlogAppLoginCubit(),),
      ],
    child: MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: startwidget,
    )
    );
  }
}