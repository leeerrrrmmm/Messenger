import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:message/Screens/auth/services/auth_services.dart';


import '../../components/my_button.dart';
import '../../components/my_text_field.dart';

class LoginPage extends StatefulWidget {

  void Function()? onTap;

   LoginPage({
    super.key,
    required this.onTap,
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {

    TextEditingController _emailController = TextEditingController();
    TextEditingController _passwordController = TextEditingController();

    void login() async{
      final authService = AuthServices();
      try{
        await authService.signInWithEmailPassword(
            _emailController.text.trim(),
            _passwordController.text.trim()
        );
      }catch(e){
        showDialog(context: context, builder: (context) => AlertDialog(
          title: Text(e.toString()),
        ));
      }
    }

  return Scaffold(

    appBar:AppBar(
            title:Text('L O G I N',
                style:TextStyle(
                    color:Theme.of(context).colorScheme.primary
                )),
            centerTitle:true
        ),
        body:Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment:MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.message_rounded,
                  size:60,
                  color: Theme.of(context).colorScheme.primary,),
                Text('Welcome back',
                    style:TextStyle(
                      color:Theme.of(context).colorScheme.primary,
                      fontSize:16,
                    )),
                const SizedBox(height: 20,),
                MyTextField(
                  labelText: 'Email',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  obscureText: false,
                  focusNode: null,
                ),
                const SizedBox(height: 20,),
                MyTextField(
                  labelText: 'Password',
                  controller: _passwordController,
                  keyboardType: TextInputType.name,
                  obscureText: true,
                  focusNode: null,
                ),
                const SizedBox(height: 20,),
                MyButton(
                  text: 'Login',
                  onTap:login,),
                const SizedBox(height: 20,),
                Row(
                  mainAxisAlignment:MainAxisAlignment.center,
                  children: [
                    Text('Have not an account?',
                        style:TextStyle(
                            color:Theme.of(context).colorScheme.primary
                        )),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: Text('\t\tRegister now',
                          style:TextStyle(
                              fontWeight:FontWeight.bold,
                              color:Theme.of(context).colorScheme.inversePrimary
                          )),
                    ),
                  ],
                ),
                
                //google btn
                ElevatedButton(
                    onPressed: AuthServices().googleSignIn,
                    child: const Text('sign with google'))
              ],
            ),
          ),
        ),
    );
  }
}
