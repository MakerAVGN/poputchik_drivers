import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchDestinationPage extends StatefulWidget {
  const SearchDestinationPage({Key? key}) : super(key: key);

  @override
  State<SearchDestinationPage> createState() => _SearchDestinationPageState();
}

class _SearchDestinationPageState extends State<SearchDestinationPage> {
  TextEditingController pickUpTextEditingController = TextEditingController();
  TextEditingController destinationTextEditingController = TextEditingController();
  TextEditingController dateTextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white70, // Новый цвет фона для всего экрана
      body: SingleChildScrollView(
        child: Column(
          children: [
            Card(
              elevation: 10,
              child: Container(
                height: 300,
                decoration: const BoxDecoration(
                  color: Colors.teal,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 5.0,
                      spreadRadius: 0.5,
                      offset: Offset(0.7, 0.7),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      const SizedBox(height: 6),
                      Stack(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: const Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                            ),
                          ),
                          Center(
                            child: Text(
                              "Поиск попутки",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      _buildInputField(
                        hintText: 'Откуда едете?',
                        controller: pickUpTextEditingController,
                        iconPath: "assets/images/initial.png",
                      ),
                      const SizedBox(height: 11),
                      _buildInputField(
                        hintText: 'Куда едете?',
                        controller: destinationTextEditingController,
                        iconPath: "assets/images/final.png",
                      ),
                      const SizedBox(height: 11),
                      _buildDateInputField(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildInputField({
    required String hintText,
    required TextEditingController controller,
    required String iconPath,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0),
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hintText,
            fillColor: Colors.teal[300],
            filled: true,
            border: InputBorder.none,
            isDense: true,
            contentPadding: const EdgeInsets.only(left: 11, top: 9, bottom: 9),
            prefixIcon: Padding(
              padding: const EdgeInsets.only(left: 8, right: 8),
              child: Image.asset(
                iconPath,
                height: 16,
                width: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }


  Widget _buildDateInputField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.teal[300],
        borderRadius: BorderRadius.circular(5),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: GestureDetector(
          onTap: () async {
            final DateTime? picked = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime.now(),
              lastDate: DateTime(2101),
            );
            if (picked != null) {
              setState(() {
                dateTextEditingController.text = picked.toString();
              });
            }
          },
          child: Row(
            children: [
              Icon(Icons.calendar_today),
              const SizedBox(width: 6),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(6, 9, 0, 9),
                  child: Text(
                    dateTextEditingController.text.isNotEmpty
                        ? dateTextEditingController.text
                        : 'Select Date',
                    style: const TextStyle(color: Colors.black),
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
