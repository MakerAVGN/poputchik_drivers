import 'dart:convert';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:poputchik_drivers/auth/login_screen.dart';
import 'package:poputchik_drivers/methods/common_methods.dart';
import 'package:poputchik_drivers/pages/dashboard.dart';
import 'package:poputchik_drivers/widgets/loading_dialog.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController userNameTextEditingController = TextEditingController();
  TextEditingController userPhoneTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  TextEditingController vehicleModelTextEditingController = TextEditingController();
  TextEditingController vehicleColorEditingController = TextEditingController();
  TextEditingController vehicleNumberEditingController = TextEditingController();

  CommonMethods cMethods = CommonMethods();
  XFile? imageFile;

  void checkIfNetworkIsAvailable() {
    cMethods.checkConnectivity(context);

    if (imageFile != null) {
      signUpFormValidation();
    } else {
      cMethods.displaySnackBar("Пожалуйста, загрузите фото.", context);
    }
  }

  void signUpFormValidation() {
    if (userNameTextEditingController.text.trim().length < 2) {
      cMethods.displaySnackBar("Ваше имя должно быть не менее 2 символов.", context);
    } else if (userPhoneTextEditingController.text.trim().length < 7) {
      cMethods.displaySnackBar("Номер телефона не может быть меньше 7 символов.", context);
    } else if (!emailTextEditingController.text.trim().contains("@")) {
      cMethods.displaySnackBar("Введите корректный email.", context);
    } else if (passwordTextEditingController.text.trim().length < 6) {
      cMethods.displaySnackBar("Пароль должен быть не менее 6 символов.", context);
    } else if (vehicleModelTextEditingController.text.trim().isEmpty) {
      cMethods.displaySnackBar("Введите модель вашего автомобиля.", context);
    } else if (vehicleColorEditingController.text.trim().isEmpty) {
      cMethods.displaySnackBar("Введите цвет вашего автомобиля.", context);
    } else if (vehicleNumberEditingController.text.trim().isEmpty) {
      cMethods.displaySnackBar("Введите номер вашего автомобиля.", context);
    } else {
      uploadImageAndRegister();
    }
  }

  Future<void> uploadImageAndRegister() async {
    String base64Image = base64Encode(File(imageFile!.path).readAsBytesSync());

    registerNewDriver(base64Image);
  }

  void registerNewDriver(String base64Image) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => LoadingDialog(messageText: "Регистрация..."),
    );

    try {
      final UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailTextEditingController.text.trim(),
        password: passwordTextEditingController.text.trim(),
      );

      DatabaseReference usersRef = FirebaseDatabase.instance.ref().child("drivers").child(userCredential.user!.uid);

      Map<String, dynamic> driverDataMap = {
        "photo": base64Image,
        "car_details": {
          "carColor": vehicleColorEditingController.text.trim(),
          "carNumber": vehicleNumberEditingController.text.trim(),
          "carModel": vehicleModelTextEditingController.text.trim(),
        },
        "name": userNameTextEditingController.text.trim(),
        "email": emailTextEditingController.text.trim(),
        "phone": userPhoneTextEditingController.text.trim(),
        "id": userCredential.user!.uid,
        "blockStatus": "no",
      };

      await usersRef.set(driverDataMap);

      Navigator.pop(context); // закрываем диалог загрузки
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (c) => Dashboard()));
    } catch (e) {
      Navigator.pop(context); // закрываем диалог загрузки
      cMethods.displaySnackBar("Ошибка регистрации: ${e.toString()}", context);
    }
  }

  void chooseImageFromGallery() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        imageFile = pickedFile;
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
              const SizedBox(height: 40),
              imageFile == null
                  ? CircleAvatar(
                radius: 106,
                backgroundImage: AssetImage("assets/images/avatarman.png"),
              )
                  : Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey,
                  image: DecorationImage(
                    fit: BoxFit.fitHeight,
                    image: FileImage(File(imageFile!.path)),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: chooseImageFromGallery,
                child: Text(
                  "Выберите фото",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 22),
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
                    const SizedBox(height: 22),
                    TextField(
                      controller: userPhoneTextEditingController,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        labelText: "Ваш номер телефона",
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
                    const SizedBox(height: 22),
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
                    const SizedBox(height: 22),
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
                    const SizedBox(height: 22),
                    TextField(
                      controller: vehicleModelTextEditingController,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        labelText: "Модель вашего автомобиля",
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
                    const SizedBox(height: 32),
                    TextField(
                      controller: vehicleColorEditingController,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        labelText: "Цвет вашего автомобиля",
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
                    const SizedBox(height: 32),
                    TextField(
                      controller: vehicleNumberEditingController,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        labelText: "Номер вашего автомобиля",
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
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: checkIfNetworkIsAvailable,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.cyanAccent[400],
                        padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 20),
                      ),
                      child: const Text(
                        "Зарегистрироваться",
                        style: TextStyle(
                          color: Colors.black45,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (c) => LoginScreen()));
                },
                child: const Text(
                  "Уже есть аккаунт? Авторизуйтесь здесь",
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
