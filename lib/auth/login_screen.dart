import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:poputchik/auth/signup_screen.dart';
import 'package:poputchik/methods/common_methods.dart';
import 'package:poputchik/pages/dashboard.dart';
import 'package:poputchik/pages/home_page.dart';
import 'package:poputchik/widgets/loading_dialog.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  CommonMethods cMethods = CommonMethods();

  checkIfNetworkIsAvailable(){
    cMethods.checkConnectivity(context);

    signInFormValidation();
  }

  signInFormValidation() {
    if (!emailTextEditingController.text.trim().contains("@")) {
      cMethods.displaySnackBar("Введите правильный email", context);
    }
    else if (passwordTextEditingController.text
        .trim()
        .length < 5) {
      cMethods.displaySnackBar("Пароль должен превышать 6 символов", context);
    }
    else {
      signInUser();
    }
  }

  signInUser() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => LoadingDialog(messageText: "Заходим в аккаунт. . ."),
    );
    final User? userFirebase = (
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailTextEditingController.text.trim(),
          password: passwordTextEditingController.text.trim(),
        ).catchError((errorMsg)
        {
          Navigator.pop(context);
          cMethods.displaySnackBar(errorMsg.toString(), context);
        })
    ).user;

    if(!context.mounted) return;
    Navigator.pop(context);

    if(userFirebase != null){
      DatabaseReference usersRef = FirebaseDatabase.instance.ref().child("users").child(userFirebase.uid);
      await usersRef.once().then((snap){
          if(snap.snapshot.value != null){
            if((snap.snapshot.value as Map)["blockStatus"] == "no"){
                Navigator.push(context, MaterialPageRoute(builder: (c) => Dashboard()));
            }
            else{
              FirebaseAuth.instance.signOut();

              cMethods.displaySnackBar("Вы аккаунт заблокирован. Для уточнения обратитесь в службу поддержки", context);
            }
          }
          else{
            FirebaseAuth.instance.signOut();
            cMethods.displaySnackBar("Такого пользователя не найдено.", context);
          }
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  Image.asset(
                      "assets/images/logo.png"
                  ),

                  Text(
                    "Авторизоваться",
                    style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.black
                    ),
                  ),

                  //text fields + button
                  Padding(
                    padding: const EdgeInsets.all(22),
                    child: Column(
                      children: [

                        TextField(
                          controller: emailTextEditingController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            labelText: "Ваша почта",
                            labelStyle: TextStyle(
                              fontSize: 14,
                              color: Colors.black38,
                            ),
                          ),
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 15,
                          ),
                        ),

                        const SizedBox(height: 22,),

                        TextField(
                          controller: passwordTextEditingController,
                          obscureText: true,
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                            labelText: "Пароль",
                            labelStyle: TextStyle(
                              fontSize: 14,
                              color: Colors.black38,
                            ),
                          ),
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 15,
                          ),
                        ),

                        const SizedBox(height: 32,),

                        ElevatedButton(
                          onPressed: ()
                          {
                            checkIfNetworkIsAvailable();
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.lightGreenAccent,
                              padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 20 )

                          ),
                          child:  const Text(
                              "Войти",
                              style: TextStyle(
                                color: Colors.black45,
                                fontWeight: FontWeight.w600,

                              )
                          ),


                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12,),

                  //textbutton
                  TextButton(
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (c)=> SignUpScreen()));
                    },
                    child: const Text(
                      "Нет аккаунта? Зарегестрируйтесь здесь",
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  )
                ],
              )
          ),
        )
    );
  }
}
