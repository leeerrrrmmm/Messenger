import 'package:flutter/material.dart';
import 'package:message/Screens/auth/services/auth_services.dart';

import '../Screens/Settings.dart';

class MyDrower extends StatelessWidget {
  const MyDrower({super.key});

  void logout () async {
    final _auth = AuthServices();
    _auth.signOut();
  }

  @override
  Widget build(BuildContext context) {



    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              DrawerHeader(
                  child: Center(
                    child: Icon(
                        Icons.messenger_outline_rounded,
                        size: 60,
                        color:Theme.of(context).colorScheme.inversePrimary
                    ),
                  )),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: IconButton(
                  onPressed:() {
                    Navigator.pop(context);
                  },
                  icon:Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        SizedBox(width: MediaQuery.of(context).size.width * 0.01),
                        Icon(Icons.home_rounded,
                            color:Theme.of(context).colorScheme.primary,
                            size:30),
                        SizedBox(width: MediaQuery.of(context).size.width * 0.1),
                        Text(' H O M E ',
                            style:TextStyle(
                                color:Theme.of(context).colorScheme.primary,
                                fontSize:20
                            ))
                      ]
                  )
                            ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: IconButton(
                    onPressed:() {
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (context) => Settings()));
                    },
                    icon:Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          SizedBox(width: MediaQuery.of(context).size.width * 0.01),
                          Icon(Icons.settings_rounded,
                              color:Theme.of(context).colorScheme.primary,
                              size:30),
                          SizedBox(width: MediaQuery.of(context).size.width * 0.1),
                          Text(' S E T T I N G S ',
                              style:TextStyle(
                                  color:Theme.of(context).colorScheme.primary,
                                  fontSize:20
                              ))
                        ]
                    )
                ),
              )
            ],
          ),
          IconButton(
              onPressed:logout,
              icon:Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SizedBox(width: MediaQuery.of(context).size.width * 0.01),
                    Icon(Icons.exit_to_app_rounded,
                        color:Theme.of(context).colorScheme.primary,
                        size:30),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.1),
                    Text(' L O G O U T ',
                        style:TextStyle(
                            color:Theme.of(context).colorScheme.primary,
                            fontSize:20
                        ))
                  ]
              )
          )
        ],
      ),
    );
  }
}
