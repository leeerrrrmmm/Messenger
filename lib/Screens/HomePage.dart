import 'package:flutter/material.dart';
import 'package:message/Screens/auth/services/auth_services.dart';
import 'package:message/components/user_tile.dart';
import 'package:message/services/chat/chat_services.dart';
import '../components/my_drower.dart';
import 'ChatPape/chat.dart';


class HomePage extends StatelessWidget {
 HomePage({super.key});

  final ChatService chatService = ChatService();
  final AuthServices authService = AuthServices();

  @override
  Widget build(BuildContext context) {

    void logout () async {
      final _auth = AuthServices();
      _auth.signOut();
    }



    return Scaffold(
        appBar:AppBar(
            backgroundColor: Theme.of(context).colorScheme.primary,
            title:Text('M E S S A N G E R',
            style:TextStyle(
              color:Theme.of(context).colorScheme.inversePrimary
            )),
            centerTitle:true,
          actions: [
            IconButton(
                onPressed:logout,
                icon: Icon(Icons.exit_to_app_rounded),
            color:Theme.of(context).colorScheme.inversePrimary)
          ]
        ),
        drawer: const  MyDrower(),
        body: _buildUserList(),

    );
  }
      //build a list of users expect for the cur logged in user
      Widget _buildUserList() {
          return StreamBuilder(
              stream: chatService.getUsersStreamExcludingBlocked(),
              builder: (context, snap) {
                //error
                if(snap.hasError){
                  return Center(child:const Text('Error'));
                }
                /// loading..
                if(snap.connectionState == ConnectionState.waiting){
                 return Center(child:CircularProgressIndicator());
                }

                return ListView(
                  children: snap.data!.map<Widget>((userData) => _buildUserListItem(userData, context)).toList(),
                );

            }
          );
      }

   Widget _buildUserListItem(Map<String, dynamic> userData, BuildContext context) {
      //display all current users
    if(userData['email'] != authService.getCurUser()!.email) {
      return UserTile(
          text:('${userData['email']}'),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder:(context) =>
                Chat(
                  receiveEmail: userData['email'],
                  receiverId: userData['uid'],
                )));
          });
     }else{
     return Container();
    }
   }


}
