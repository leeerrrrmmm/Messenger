import 'package:flutter/material.dart';
import 'package:message/Screens/auth/services/auth_services.dart';
import '../../components/my_button.dart';
import '../../components/my_text_field.dart';

class RegisterPage extends StatefulWidget {

  void Function()? onTap;

  RegisterPage({
    super.key,
    required this.onTap,
  });

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override

  Widget build(BuildContext context) {


    TextEditingController _emailController = TextEditingController();
    TextEditingController _passwordController = TextEditingController();
    TextEditingController _ConfirmPasswordController = TextEditingController();

    void register() async {
      final _authService = AuthServices();
      if(_passwordController.text == _ConfirmPasswordController.text){
        try{
          _authService.signUpWithEmailPassword(
              _emailController.text,
              _passwordController.text,

          );
        }catch(e){
          showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text(e.toString()),
              ));
        }
      }else{
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Password does not match!'),
            ));
      }
    }

    return Scaffold(
        appBar:AppBar(
            title:Text('R E G I S T E R',
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
                MyTextField(
                  labelText: 'Confirm password',
                  controller: _ConfirmPasswordController,
                  keyboardType: TextInputType.name,
                  obscureText: true,
                  focusNode: null,
                ),
                const SizedBox(height: 20,),
                MyButton(
                  text: 'Register',
                  onTap:register,),
                const SizedBox(height: 20,),
                Row(
                  mainAxisAlignment:MainAxisAlignment.center,
                  children: [
                    Text('Already have an accont?',
                        style:TextStyle(
                            color:Theme.of(context).colorScheme.primary
                        )),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: Text('\t\tLogin now',
                          style:TextStyle(
                              fontWeight:FontWeight.bold,
                              color:Theme.of(context).colorScheme.inversePrimary
                          )),
                    ),
                  ],
                )
              ],
            ),
          ),
        )

    );
  }
}
