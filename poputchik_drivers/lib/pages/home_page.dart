import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final User? user = FirebaseAuth.instance.currentUser;

  // Function to delete a trip from the database
  Future<void> _deleteTrip(String tripId) async {
    try {
      await FirebaseFirestore.instance.collection('trips').doc(tripId).delete();
    } catch (error) {
      print('Error deleting trip: $error');
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ваши поездки'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('trips')
            .where('email', isEqualTo: user!.email)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Произошла ошибка при загрузке данных'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('У вас пока нет поездок'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final trip = snapshot.data!.docs[index];
              final tripData = trip.data() as Map<String, dynamic>;
              final tripId = trip.id;

              return Card(
                margin: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        'Откуда: ${tripData['from']}\nКуда: ${tripData['to']}\nДата: ${tripData['date']}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    ListTile(
                      title: Text('Цена: \$${tripData['price']}'),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => _deleteTrip(tripId),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
