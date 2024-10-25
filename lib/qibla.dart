import 'main.dart';
import 'package:flutter/material.dart';
void main() {
  runApp(Qibla());
}

class Qibla extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: QiblaScreen(),
    );
  }
}

class QiblaScreen extends StatelessWidget {


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF0C223E),
        title: Text(
          'اتجاه القبلة',
          style: TextStyle(fontSize: 24, color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              Icons.arrow_right_alt,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => QuranApp()),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Container(
          margin: EdgeInsets.all(16),
          width: 300,
          height: 300,
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Color(0xFF0C223E),
              width: 8,
            ),
            image: DecorationImage(
              image: AssetImage('assets/qibla.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child:Stack(
            alignment: Alignment.center,
            children: [

              Positioned(
                child: Icon(
                  Icons.navigation,
                  size: 64,
                  color: Colors.red,
                ),
              ),
            ],
          ),




        ),
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