import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myblog/Modules/Home_Screen/Home/home_states.dart';
import 'package:myblog/Modules/Posts/Post_Screen.dart';
import 'package:myblog/Shared/Components/components.dart';
import '../../../Shared/App_Colors.dart';
import '../Home_Screen/Home/home_cubit.dart';

class SavedBlogsScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    var cubit = BlogAppCubit.get(context);
    return BlocConsumer<BlogAppCubit,BlogAppStates>(
      listener: (context,state) {},
      builder: (context,state) {
        return Scaffold(
            body: screenWithImage(
              Column(
                children: [
                  Row(
                    children: [
                      backArrow(context),
                      SizedBox(width: 10,),
                      myText(text: "Saved",size: 30,bold: true),
                    ],
                  ),
                  SizedBox(height: 20,),
                  SingleChildScrollView(
                    physics: BouncingScrollPhysics(
                        decelerationRate: ScrollDecelerationRate.fast
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(height: 20.00,),
                        ConditionalBuilder(
                          condition: cubit.savedBlogs.length > 0 && cubit.myData != null,
                          builder: (context) => SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            child: Column(
                              children: [
                                ListView.separated(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (context,index) => buildItemCard(cubit.savedBlogs[index],context,index),
                                  separatorBuilder: (context,index) => const SizedBox(height: 10.00,),
                                  itemCount: cubit.savedBlogs.length,
                                )
                              ],
                            ),
                          ),
                          fallback: (context) => Center(child: Text("No Blogs Yet")),
                        )],
                    ),
                  ),
                ],
              ),
            )
        );
      },
    );
  }

}