import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
  Map<String, dynamic>? shipmentData;
  bool isLoading = false;

  Future<void> _searchShipment() async {
    String code = codeController.text.trim().toUpperCase();
    if (code.isEmpty) {
      _showMessage('الرجاء إدخال رقم الشحنة', Colors.orange);
      return;
    }

    setState(() => isLoading = true);

    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('shipments')
        .doc(code)
        .get();

      setState(() {
        if (doc.exists) {
          shipmentData = doc.data() as Map<String, dynamic>;
          showResult = true;
        } else {
          showResult = false;
          _showMessage('لم يتم العثور على الشحنة', Colors.red);
        }
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      _showMessage('خطأ في الاتصال', Colors.red);
    }

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
                        if (isLoading)...[
                          SizedBox(height: 20),
                          Center(child: CircularProgressIndicator(color: Color(0xFF1E7B1E))),
                        ],
                        if (showResult && shipmentData!= null)...[
                          SizedBox(height: 20),
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Color(0xFF1E7B1E),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              shipmentData!['id']?? '',
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
                                _buildInfoRow('رقم الشحنة:', shipmentData!['id']?? ''),
                                _buildInfoRow('الحالة:', shipmentData!['status']?? ''),
                                _buildInfoRow('الموقع الحالي:', shipmentData!['location']?? ''),
                                _buildInfoRow('الوصول المتوقع:', shipmentData!['date']?? ''),
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
                        onPressed: isLoading? null : _searchShipment,
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
                      Navigator.push(context, MaterialPageRoute(builder: (_) => LoginScreen()));
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

// صفحة تسجيل الدخول
class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passController = TextEditingController();
  bool isLoading = false;

  Future<void> _login() async {
    setState(() => isLoading = true);
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passController.text.trim(),
      );
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => AdminScreen()));
    } on FirebaseAuthException catch (e) {
      String msg = 'خطأ في تسجيل الدخول';
      if (e.code == 'user-not-found') msg = 'الإيميل غير موجود';
      if (e.code == 'wrong-password') msg = 'كلمة المرور خطأ';
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg), backgroundColor: Colors.red));
    }
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('تسجيل دخول الإدارة'), backgroundColor: Color(0xFF1E7B1E)),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              textAlign: TextAlign.right,
              decoration: InputDecoration(labelText: 'الإيميل', border: OutlineInputBorder()),
            ),
            SizedBox(height: 16),
            TextField(
              controller: passController,
              textAlign: TextAlign.right,
              obscureText: true,
              decoration: InputDecoration(labelText: 'كلمة المرور', border: OutlineInputBorder()),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: isLoading? null : _login,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF1E7B1E),
                minimumSize: Size(double.infinity, 50),
              ),
              child: isLoading
                ? CircularProgressIndicator(color: Colors.white)
                  : Text('دخول', style: TextStyle(fontSize: 18, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}

// صفحة الإدارة
class AdminScreen extends StatefulWidget {
  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  final idController = TextEditingController();
  final statusController = TextEditingController();
  final locationController = TextEditingController();
  final dateController = TextEditingController();

  Future<void> _addShipment() async {
    if (idController.text.isEmpty) return;
    await FirebaseFirestore.instance.collection('shipments').doc(idController.text.toUpperCase()).set({
      'id': idController.text.toUpperCase(),
      'status': statusController.text,
      'location': locationController.text,
      'date': dateController.text,
    });
    _clearFields();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('تمت الإضافة بنجاح'), backgroundColor: Colors.green));
  }

  void _clearFields() {
    idController.clear();
    statusController.clear();
    locationController.clear();
    dateController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('لوحة الإدارة'),
        backgroundColor: Color(0xFF1E7B1E),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => TrackingScreen()), (r) => false);
            },
          )
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Text('إضافة / تعديل شحنة', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          SizedBox(height: 16),
          TextField(controller: idController, textAlign: TextAlign.right, decoration: InputDecoration(labelText: 'رقم الشحنة KSA...', border: OutlineInputBorder())),
          SizedBox(height: 12),
          TextField(controller: statusController, textAlign: TextAlign.right, decoration: InputDecoration(labelText: 'الحالة', border: OutlineInputBorder())),
          SizedBox(height: 12),
          TextField(controller: locationController, textAlign: TextAlign.right, decoration: InputDecoration(labelText: 'الموقع الحالي', border: OutlineInputBorder())),
          SizedBox(height: 12),
          TextField(controller: dateController, textAlign: TextAlign.right, decoration: InputDecoration(labelText: 'الوصول المتوقع', border: OutlineInputBorder())),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: _addShipment,
            style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF1E7B1E), minimumSize: Size(double.infinity, 50)),
            child: Text('حفظ الشحنة', style: TextStyle(fontSize: 16, color: Colors.white)),
          ),
          SizedBox(height: 30),
          Text('كل الشحنات', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          SizedBox(height: 12),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('shipments').snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
              return Column(
                children: snapshot.data!.docs.map((doc) {
                  Map data = doc.data() as Map;
                  return Card(
                    child: ListTile(
                      title: Text(data['id'], textAlign: TextAlign.right),
                      subtitle: Text('${data['status']} - ${data['location']}', textAlign: TextAlign.right),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () => doc.reference.delete(),
                      ),
                      onTap: () {
                        idController.text = data['id'];
                        statusController.text = data['status'];
                        locationController.text = data['location'];
                        dateController.text = data['date'];
                      },
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}
