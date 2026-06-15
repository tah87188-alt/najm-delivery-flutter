import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(NajmApp());
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Color(0xFF1E7B1E),
    statusBarIconBrightness: Brightness.light,
  ));
}

class NajmApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'نجم التوصيل',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xFF1E7B1E),
        fontFamily: 'Cairo',
        scaffoldBackgroundColor: Color(0xFFF5F5F5),
      ),
      home: TrackingScreen(),
    );
  }
}

class TrackingScreen extends StatefulWidget {
  @override
  _TrackingScreenState createState() => _TrackingScreenState();
}

class _TrackingScreenState extends State<TrackingScreen> {
  final codeController = TextEditingController();
  bool showResult = false;
  String enteredCode = '';

  void _searchShipment() {
    String code = codeController.text.trim().toUpperCase();
    if (code.isEmpty) {
      _showMessage('الرجاء إدخال رقم الشحنة', Colors.orange);
      return;
    }

    setState(() {
      enteredCode = code;
      showResult = true;
    });
    codeController.clear();
    FocusScope.of(context).unfocus();
  }

  void _showMessage(String msg, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg, textAlign: TextAlign.center),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // الهيدر الأخضر
            Container(
              width: double.infinity,
              margin: EdgeInsets.all(12),
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Color(0xFF1E7B1E),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Text(
                    'نجم التوصيل',
                    style: TextStyle(fontSize: 28, color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'تتبع شحنتك لحظة بلحظة داخل المملكة',
                    style: TextStyle(fontSize: 14, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Color(0xFFF4E6A7),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'مدعوم بالذكاء الاصطناعي',
                      style: TextStyle(fontSize: 12, color: Color(0xFF1E7B1E), fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),

            // المحتوى
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 12),
                children: [
                  // كرت المساعد الذكي
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 2)),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'يا هلا والله 👋',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.right,
                        ),
                        SizedBox(height: 8),
                        Text(
                          'أنا مساعدك الذكي من نجم التوصيل\nاكتب رقم الشحنة حقك عشان أشيك\nلك وينها الحين',
                          style: TextStyle(fontSize: 16, height: 1.6),
                          textAlign: TextAlign.right,
                        ),
                        if (showResult)...[
                          SizedBox(height: 20),
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Color(0xFF1E7B1E),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              enteredCode,
                              style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(height: 16),
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Color(0xFFE8F5E9),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text('تم العثور على الشحنة', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                    SizedBox(width: 8),
                                    Icon(Icons.check_box, color: Colors.green),
                                  ],
                                ),
                                SizedBox(height: 12),
                                _buildInfoRow('رقم الشحنة:', enteredCode),
                                _buildInfoRow('الحالة:', enteredCode == 'KSA12345'? 'تم التسليم بنجاح' : 'قيد التوصيل'),
                                _buildInfoRow('الموقع الحالي:', 'الرياض - حي الملز'),
                                _buildInfoRow('الوصول المتوقع:', '15 يونيو 2026'),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // حقل الإدخال والأزرار
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, -2))],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: _searchShipment,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF1E7B1E),
                          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: Text('استعلام', style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: codeController,
                          textAlign: TextAlign.right,
                          textInputAction: TextInputAction.search,
                          style: TextStyle(fontSize: 16),
                          decoration: InputDecoration(
                            hintText: 'اكتب رقم الشحنة هنا... مثال: KSA12345',
                            filled: true,
                            fillColor: Color(0xFFFFF9E6),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Color(0xFFFFC107), width: 2),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Color(0xFFFFC107), width: 2),
                            ),
                            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                          ),
                          onSubmitted: (_) => _searchShipment(),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {
                      _showMessage('قريباً', Colors.grey);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF5C6BC0),
                      minimumSize: Size(150, 45),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text('دخول الإدارة', style: TextStyle(fontSize: 14, color: Colors.white)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text(value, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600))),
          Text(label, style: TextStyle(fontSize: 15, color: Colors.grey[700])),
        ],
      ),
    );
  }
}
