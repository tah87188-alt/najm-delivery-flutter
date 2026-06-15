import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(NajmApp());
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Color(0xFF1E3A8A),
  ));
}

class NajmApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'نجم التوصيل',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: Color(0xFF1E3A8A)),
      home: LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final codeController = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1E3A8A), Color(0xFF3B82F6)]
          )
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.local_shipping, size: 80, color: Colors.white),
                SizedBox(height: 16),
                Text('نجم التوصيل', style: TextStyle(fontSize: 32, color: Colors.white, fontWeight: FontWeight.bold)),
                SizedBox(height: 50),
                Container(
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      TextField(
                        controller: codeController,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        decoration: InputDecoration(hintText: 'أدخل كود الشحنة', border: InputBorder.none),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          if(codeController.text.trim() == 'KSA12345') {
                            Navigator.push(context, MaterialPageRoute(builder: (_) => TrackingScreen()));
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF1E3A8A),
                          minimumSize: Size(double.infinity, 55),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: Text('تتبع الآن', style: TextStyle(fontSize: 18, color: Colors.white)),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Text('كود تجريبي: KSA12345', style: TextStyle(color: Colors.white70)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TrackingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('الشحنة KSA12345'), backgroundColor: Color(0xFF1E3A8A)),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Card(child: Padding(
            padding: EdgeInsets.all(16),
            child: Text('حالة الشحنة: خرجت للتوصيل', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green)),
          )),
          SizedBox(height: 16),
          _buildStep('تم استلام الطلب', '10:30 ص', true),
          _buildStep('جاري التجهيز', '11:45 ص', true),
          _buildStep('خرج للتوصيل', '2:15 م', true),
          _buildStep('تم التوصيل', 'متوقع 4:30 م', false),
        ],
      ),
    );
  }

  Widget _buildStep(String title, String time, bool done) {
    return ListTile(
      leading: Icon(done ? Icons.check_circle : Icons.radio_button_unchecked, color: done ? Colors.green : Colors.grey),
      title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
      trailing: Text(time),
    );
  }
}
