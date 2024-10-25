import 'package:flutter/material.dart';

import 'main.dart';
void main() => runApp(AzkarScreen());

class AzkarScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: _AzkarScreen(),
    );
  }
}

class _AzkarScreen extends StatelessWidget {
  final List<String> azkarItems = [
    'أذكار الصباح',
    'أذكار المساء',
    'أذكار النوم',
    'سورة الملك',
    'سورة الكهف',
    'دعاء الرزق',
    'دعاء الشفاء من المرض',
    'دعاء ليلة القدر',
    'سورة يس',
    'دعاء الميت',
    'دعاء ختم القران الكريم',
    'دعاء السفر',
    'استغفار',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:Color(0xFF0C223E),
        title: Text(
          'أذكار',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: Colors.white),
        ),
        centerTitle: true,

        actions: [
          IconButton(
            icon: Icon(Icons.arrow_right_alt, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => QuranApp()),
              );
            },
          ),],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: azkarItems.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF0C223E),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 20),
                    ),
                    onPressed: () {

                    },
                    child: Text(
                      azkarItems[index],
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                );
              },
            ),
          ),

        ],
      ),
      bottomNavigationBar:BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Color(0xFF0C223E),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book, color: Colors.white),
            label: 'أذكار',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.mosque, color: Colors.white),
            label: 'مسجد',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book, color: Colors.white),
            label: 'القرآن الكريم',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.access_time, color: Colors.white),
            label: 'الصلاة',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on, color: Colors.white),
            label: 'القبلة',
          ),
        ],
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white,
      ),
    );
  }
}