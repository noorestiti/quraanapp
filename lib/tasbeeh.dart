import 'package:flutter/material.dart';
import 'main.dart';

void main() => runApp(Tasbeeh());

class Tasbeeh extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TasbeehScreen(),
    );
  }
}

class TasbeehScreen extends StatefulWidget {
  @override
  _TasbeehScreenState createState() => _TasbeehScreenState();
}

class _TasbeehScreenState extends State<TasbeehScreen> {
  int _tasbeehCount = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF0C223E),
        leading: Icon(Icons.volume_up, color: Colors.white),
        title: Text(
          'تسبيح',
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
          ),

        ],
      ),
      body: Column(

        children: [
          SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,

            children: [
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor:Color(0xFF0C223E),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  setState(() {
                    _tasbeehCount = 0;
                  });
                },
                icon: Icon(Icons.message, color: Colors.white),
                label: Text(
                  'ابدأ',
                  style: TextStyle(fontSize: 16,color: Colors.white),
                ),
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF0C223E),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  // Toggle sound functionality
                },
                icon: Icon(Icons.volume_up, color: Colors.white),
                label: Text(
                  'صوت',
                  style: TextStyle(fontSize: 16,color: Colors.white),
                ),
              ),
            ],
          ),
          SizedBox(height: 40),
          // Circular counter
          GestureDetector(
            onTap: () {
              setState(() {
                _tasbeehCount++;
              });
            },
            child: Container(
              margin: EdgeInsets.only(top: 200),
              height: 300,
              width: 300,
              decoration: BoxDecoration(

                shape: BoxShape.circle,
                color: Colors.white,
                border: Border.all(color: Colors.blue, width: 4),
              ),
              child: Center(
                child: Text(
                  '$_tasbeehCount',
                  style: TextStyle(
                    fontSize: 60,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ),
            ),
          ),

        ],
      ),
    );
  }
}