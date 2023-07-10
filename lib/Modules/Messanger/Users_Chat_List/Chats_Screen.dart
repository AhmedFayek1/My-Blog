import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myblog/Models/User.dart';
import 'package:myblog/Shared/Components/components.dart';
import '../../Home_Screen/Home/home_cubit.dart';
import '../Messanger_cubit.dart';
import '../Messanger_states.dart';
import '../User_Chat/user_chat.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MessengerAppCubit, MessengerAppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var model = BlogAppCubit.get(context).myData;
        List<String> chats = MessengerAppCubit.get(context).usersUIDs;
        print("CHATS" + chats.toString());
        return Scaffold(
          body: screenWithImage(Column(
            children: [
              Row(
                children: [
                  backArrow(context),
                  SizedBox(
                    width: 20,
                  ),
                  myText(
                    text: "Messenger",
                    bold: true,
                    size: 25,
                  )
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Expanded(
                child: ListView.separated(
                    itemBuilder: (context, index) =>
                        buildChatItem(chats[index], context),
                    separatorBuilder: (context, index) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5.00),
                          child: Container(
                            width: double.infinity,
                            height: 1.00,
                            color: Colors.grey[300],
                          ),
                        ),
                    itemCount: chats.length),
              )
            ],
          )),
        );
      },
    );
  }

  Widget buildChatItem(String id, context) {
    UserModel? model = BlogAppCubit.get(context).getUser(id);

    return InkWell(
      onTap: () {
        MessengerAppCubit.get(context).getMessages(receiverID: id);
        navigate(context, ChatDetails(userModel: model!));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
        child: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(model!.image!),
              radius: 25.00,
            ),
            const SizedBox(
              width: 15.00,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                myText(
                  text: model.name!,
                  bold: true,
                  size: 25.00,
                ),
                SizedBox(
                  height: 5.00,
                ),
                if (MessengerAppCubit.get(context).usersChat.containsKey(id) &&
                    MessengerAppCubit.get(context).usersChat[id]!.isNotEmpty)
                  myText(
                      text: MessengerAppCubit.get(context)
                          .usersChat[id]!
                          .last
                          .text
                          .toString(),
                      bold: true,
                      color: Colors.grey[700]!)
              ],
            ),
            Spacer(),
            if (MessengerAppCubit.get(context).usersChat.containsKey(id) &&
                MessengerAppCubit.get(context).usersChat[id]!.isNotEmpty)
              myText(
                text: BlogAppCubit.get(context).splitDate(
                    MessengerAppCubit.get(context)
                        .usersChat[id]!
                        .last
                        .datetime!)[2],
                color: Colors.black,
              )
          ],
        ),
      ),
    );
  }
}
