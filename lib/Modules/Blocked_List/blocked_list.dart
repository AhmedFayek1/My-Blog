import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myblog/Modules/Home_Screen/Home/home_states.dart';
import 'package:myblog/Shared/Components/components.dart';
import '../../Models/User.dart';
import '../Home_Screen/Home/home_cubit.dart';

class BlockedList extends StatelessWidget {

  final List<UserModel> users;
  BlockedList(this.users);

  @override
  Widget build(BuildContext context) {
    var cubit = BlogAppCubit.get(context);
    return BlocConsumer<BlogAppCubit,BlogAppStates>(
      listener: (context,state) {},
      builder: (context,state) {
        return Scaffold(
          // backgroundColor: Colors.grey[300],
          // appBar: AppBar(
          //   title: ,
          //   backgroundColor: appBar,
          // ),
            body: screenWithImage(
              Column(
                children: [
                  Row(children: [
                    backArrow(context),
                    //Expanded(child: Center(child: myText(text: "Users",size: 30,bold: true)))
                  ]),
                  SingleChildScrollView(
                    child: ConditionalBuilder(
                      condition: users.length > 0,
                      builder: (context) => SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          children: [
                            ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context,index) => buildUserItem(users[index],context,index),
                              separatorBuilder: (context,index) => const SizedBox(height: 10.00,),
                              itemCount: users.length,
                            )
                          ],
                        ),
                      ),
                      fallback: (context) => Center(child: Text("No Blogs Yet")),
                    ),
                  )],
              ),
            )
        );
      },
    );
  }

}
