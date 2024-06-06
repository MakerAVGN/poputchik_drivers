import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:poputchik/auth/login_screen.dart';
import 'package:poputchik/methods/common_methods.dart';
import 'package:poputchik/pages/dashboard.dart';
import 'package:poputchik/pages/home_page.dart';
import 'package:poputchik/widgets/loading_dialog.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

  TextEditingController userNameTextEditingController = TextEditingController();
  TextEditingController userPhoneTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  CommonMethods cMethods = CommonMethods();

  checkIfNetworkIsAvailable(){
  cMethods.checkConnectivity(context);

  signUpFormValidation();
  }

  signUpFormValidation(){
    if(userNameTextEditingController.text.trim().length < 2){
        cMethods.displaySnackBar("Ваше имя должно певышать 3 символа.", context);
    }
    else if(userPhoneTextEditingController.text.trim().length <7){
      cMethods.displaySnackBar("Номер телефона не может быть меньше 7 символов", context);
    }
    else if(!emailTextEditingController.text.trim().contains("@")){
      cMethods.displaySnackBar("Введите правильный email", context);
    }
    else if(passwordTextEditingController.text.trim().length < 5){
      cMethods.displaySnackBar("Пароль должен превышать 6 символов", context);
    }
    else{
      registerNewUser();
    }
 }

 registerNewUser() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => LoadingDialog(messageText: "Регистрация прошла успешно!"),
    );

    final User? userFirebase = (
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
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
    
    DatabaseReference usersRef = FirebaseDatabase.instance.ref().child("users").child(userFirebase!.uid);
    Map userDataMap = {
      "name": userNameTextEditingController.text.trim(),
      "email": emailTextEditingController.text.trim(),
      "phone": userPhoneTextEditingController.text.trim(),
      "id": userFirebase.uid,
      "blockStatus": "no",
    };

    usersRef.set(userDataMap);

  Navigator.push(context, MaterialPageRoute(builder: (c) => Dashboard()));
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
                    "Создать аккаунт",
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
                        controller: userNameTextEditingController,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          labelText: "Ваше имя",
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
                        controller: userPhoneTextEditingController,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          labelText: "Ваше номер телефона",
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
                          backgroundColor: Colors.cyanAccent[400],
                          padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 20 )

                        ),
                        child:  const Text(
                          "Зарегестрироваться",
                           style: TextStyle(
                           color: Colors.black45,
                             fontWeight: FontWeight.w600,

                        )
                        ),


                      ),
                    ],
                  ),
              ),



              //textbutton
              TextButton(
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (c)=> LoginScreen()));
                },
                child: const Text(
                  "Уже есть аккаунт? Авторизуйтесь здесь",
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