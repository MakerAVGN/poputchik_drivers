import 'package:flutter/material.dart';
import 'package:poputchik_drivers/methods/common_methods.dart';
import 'package:flutter/cupertino.dart';
import 'package:poputchik_drivers/widgets/loading_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TripsPage extends StatefulWidget {
  const TripsPage({Key? key});

  @override
  State<TripsPage> createState() => _TripsPageState();
}

class _TripsPageState extends State<TripsPage> {
  final TextEditingController _fromController = TextEditingController();
  final TextEditingController _toController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  CommonMethods cMethods = CommonMethods();

  checkIfNetworkIsAvailable() {
    cMethods.checkConnectivity(context);
  }

  Future<void> addTripToDatabase() async {
    User? user = FirebaseAuth.instance.currentUser;
    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => LoadingDialog(messageText: "Adding trip..."),
    );

    try {
      // Generate a unique ID for the trip
      String tripId = FirebaseFirestore.instance.collection("trips").doc().id;

      // Add a new trip to Cloud Firestore with the generated ID
      CollectionReference tripsRef = FirebaseFirestore.instance.collection("trips");
      await tripsRef.doc(tripId).set({
        "id": tripId,
        "email": user?.email,
        "from": _fromController.text,
        "to": _toController.text,
        "date": _dateController.text,
        "price": _priceController.text,
        "passengers": [], // Пустой список попутчиков
      });

      // Hide loading dialog
      Navigator.pop(context);

      // Show success message
      cMethods.displaySnackBar("Поездка успешно добавлена!", context);

      // Clear input fields after adding trip
      _fromController.clear();
      _toController.clear();
      _dateController.clear();
      _priceController.clear();
    } catch (error) {
      // Hide loading dialog in case of error
      Navigator.pop(context);

      // Display error message
      cMethods.displaySnackBar("Произошла ошибка при добавлении поездки: $error", context);
    }
  }


  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != DateTime.now()) {
      setState(() {
        _dateController.text = "${picked.day.toString().padLeft(2, '0')}.${picked.month.toString().padLeft(2, '0')}.${picked.year}";
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Маршруты'),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Откуда', style: TextStyle(fontSize: 18, color: Colors.black)),
            TextField(
              controller: _fromController,
              style: TextStyle(color: Colors.black87), // Set input text color darker
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Введите место отправления',
                hintStyle: TextStyle(color: Colors.black.withOpacity(0.5)), // Set hint text color slightly darker
              ),
            ),
            SizedBox(height: 20),
            Text('Куда', style: TextStyle(fontSize: 18, color: Colors.black)),
            TextField(
              controller: _toController,
              style: TextStyle(color: Colors.black87), // Set input text color darker
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Введите место назначения',
                hintStyle: TextStyle(color: Colors.black.withOpacity(0.5)), // Set hint text color slightly darker
              ),
            ),
            SizedBox(height: 20),
            Text('Дата', style: TextStyle(fontSize: 18, color: Colors.black)),
            TextFormField(
              controller: _dateController,
              readOnly: true,
              style: TextStyle(color: Colors.black87), // Set input text color darker
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Выберите дату поездки',
                hintStyle: TextStyle(color: Colors.black.withOpacity(0.5)), // Set hint text color slightly darker
                suffixIcon: IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: () => _selectDate(context),
                ),
              ),
            ),
            SizedBox(height: 20),
            Text('Цена', style: TextStyle(fontSize: 18, color: Colors.black)),
            TextField(
              controller: _priceController,
              style: TextStyle(color: Colors.black87), // Set input text color darker
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Введите цену поездки',
                hintStyle: TextStyle(color: Colors.black.withOpacity(0.5)), // Set hint text color slightly darker
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: addTripToDatabase,
              child: Text('Добавить поездку'),
            ),
          ],
        ),
      ),
    );
  }
}
