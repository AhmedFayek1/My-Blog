import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myblog/Shared/App_Colors.dart';
import '../../Shared/Components/components.dart';
import '../Home_Screen/Home/home_cubit.dart';
import '../Home_Screen/Home/home_states.dart';

class SearchScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    var searchController = TextEditingController();
    return BlocConsumer<BlogAppCubit, BlogAppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = BlogAppCubit.get(context);
          return Scaffold(
            // appBar: AppBar(
            //   backgroundColor: appBar,
            // ),
            body: screenWithImage(
              Column(
                children: [
                  Row(
                    children: [
                      backArrow(context),
                    ],
                  ),
                  SizedBox(height: 10,),
                  field(
                      controller: searchController,
                      validator: (String) {},
                      label: 'Enter User Name',
                      onChanged: (String value) {
                        cubit.filterItems(value);
                      }),
                  const SizedBox(height: 10,),
                  ConditionalBuilder(
                    condition: cubit.filteredList.isNotEmpty,
                    builder: (context) => ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) => buildFilteredUsers(
                            cubit.filteredList[index], context, index),
                        separatorBuilder: (context, index) => const SizedBox(height: 5,),
                        itemCount: cubit.filteredList.length
                    ),
                    fallback: (context) => Container(),
                  )
                ],
              ),
            ),
          );
        });
  }
}
