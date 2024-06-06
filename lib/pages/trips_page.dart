import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TripsPage extends StatefulWidget {
  const TripsPage({Key? key}) : super(key: key);

  @override
  _TripsPageState createState() => _TripsPageState();
}

class _TripsPageState extends State<TripsPage> {
  late TextEditingController _fromController;
  late TextEditingController _toController;
  late TextEditingController _dateController;
  late TextEditingController _priceController;
  List<DocumentSnapshot> _searchResults = [];

  @override
  void initState() {
    super.initState();
    _fromController = TextEditingController();
    _toController = TextEditingController();
    _dateController = TextEditingController();
    _priceController = TextEditingController();
  }

  @override
  void dispose() {
    _fromController.dispose();
    _toController.dispose();
    _dateController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _searchTrips() async {
    final String from = _fromController.text.trim();
    final String to = _toController.text.trim();
    final String date = _dateController.text.trim();
    final String price = _priceController.text.trim();

    // Clear previous search results
    _searchResults.clear();

    // Create a reference to the "trips" collection
    final CollectionReference tripsRef =
    FirebaseFirestore.instance.collection("trips");

    // Create a query based on search criteria
    Query query = tripsRef;
    if (from.isNotEmpty) {
      query = query.where('from', isEqualTo: from);
    }
    if (to.isNotEmpty) {
      query = query.where('to', isEqualTo: to);
    }
    if (date.isNotEmpty) {
      query = query.where('date', isEqualTo: date);
    }
    if (price.isNotEmpty) {
      query = query.where('price', isEqualTo: price);
    }

    // Execute the query
    final QuerySnapshot querySnapshot = await query.get();

    // Add search results to list
    _searchResults.addAll(querySnapshot.docs);

    // Update UI
    setState(() {});
  }

  Future<void> _joinTrip(String tripId) async {
    // Get the current user
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        // Update the trip's passengers list
        await FirebaseFirestore.instance
            .collection("trips")
            .doc(tripId)
            .update({
          "passengers": FieldValue.arrayUnion([user.email])
        });

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Вы присоединились к поездке!')));
      } catch (error) {
        // Handle any errors during data updates
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Произошла ошибка при присоединении к поездке: $error')));
      }
    } else {
      // Handle the case where the user is not logged in
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Пожалуйста, войдите в систему, чтобы присоединиться к поездке.')));
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
        _dateController.text =
        "${picked.day.toString().padLeft(2, '0')}.${picked.month.toString().padLeft(2, '0')}.${picked.year}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Маршруты'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _fromController,
              style: TextStyle(color: Colors.black87), // Set text color darker
              decoration: InputDecoration(
                labelText: 'Откуда',
                labelStyle: TextStyle(
                    color: Colors.black87), // Set label text color darker
              ),
            ),
            TextField(
              controller: _toController,
              style: TextStyle(color: Colors.black87), // Set text color darker
              decoration: InputDecoration(
                labelText: 'Куда',
                labelStyle: TextStyle(
                    color: Colors.black87), // Set label text color darker
              ),
            ),
            InkWell(
              onTap: () => _selectDate(context),
              child: IgnorePointer(
                child: TextField(
                  controller: _dateController,
                  style: TextStyle(color: Colors.black87),
                  // Set text color darker
                  decoration: InputDecoration(
                    labelText: 'Дата',
                    labelStyle: TextStyle(
                        color: Colors.black87), // Set label text color darker
                  ),
                ),
              ),
            ),
            TextField(
              controller: _priceController,
              style: TextStyle(color: Colors.black87), // Set text color darker
              decoration: InputDecoration(
                labelText: 'Цена',
                labelStyle: TextStyle(
                    color: Colors.black87), // Set label text color darker
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _searchTrips,
              child: Text('Поиск поездок'),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _searchResults.length,
                itemBuilder: (context, index) {
                  final trip = _searchResults[index];
                  return ListTile(
                    title: Text(
                      'From: ${trip['from']}, To: ${trip['to']}, Date: ${trip['date']}',
                      style: TextStyle(
                          color: Colors.black87), // Set text color darker
                    ),
                    subtitle: Text(
                      'Price: ${trip['price']}',
                      style: TextStyle(
                          color: Colors
                              .black54), // Set text color slightly darker
                    ),
                    trailing: ElevatedButton(
                      onPressed: () => _joinTrip(trip.id),
                      child: Text('Поеду'),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
