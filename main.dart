import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(AttendanceApp());
}

class AttendanceApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Virtual Attendance System',
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}

// -------------------- LOGIN SCREEN --------------------
class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  String _errorMessage = '';

  void _login() {
    String username = _usernameController.text.trim();
    String password = _passwordController.text;

    if (username == 'admin' && password == 'admin123') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AdminDashboard()),
      );
    } else if (username.isNotEmpty && password.isNotEmpty) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => AttendanceHome(username: username)),
      );
    } else {
      setState(() {
        _errorMessage = 'Invalid username or password';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login'), backgroundColor: Colors.deepPurple),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Password'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              child: Text('Login'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
            ),
            if (_errorMessage.isNotEmpty)
              Padding(
                padding: EdgeInsets.only(top: 10),
                child: Text(_errorMessage, style: TextStyle(color: Colors.red)),
              )
          ],
        ),
      ),
    );
  }
}

// -------------------- MAIN USER SCREEN --------------------
class AttendanceHome extends StatefulWidget {
  final String username;
  AttendanceHome({required this.username});

  @override
  _AttendanceHomeState createState() => _AttendanceHomeState();
}

class _AttendanceHomeState extends State<AttendanceHome> {
  List<Map<String, String>> attendanceLog = [];

  void markAttendance() {
    final now = DateTime.now();
    final formatter = DateFormat('yyyy-MM-dd HH:mm');
    final timeString = formatter.format(now);

    setState(() {
      attendanceLog.add({
        'user': widget.username,
        'time': timeString,
        'location': 'GPS: 12.9716, 77.5946' // Simulated location
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome, ${widget.username}'),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
              icon: Icon(Icons.logout),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              })
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: markAttendance,
              child: Text('Mark Attendance'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            ),
            SizedBox(height: 20),
            Text('Attendance Log:', style: TextStyle(fontSize: 18)),
            Expanded(
              child: ListView.builder(
                itemCount: attendanceLog.length,
                itemBuilder: (context, index) {
                  final entry = attendanceLog[index];
                  return ListTile(
                    title: Text(entry['time']!),
                    subtitle: Text(entry['location']!),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

// -------------------- ADMIN DASHBOARD --------------------
class AdminDashboard extends StatelessWidget {
  final List<Map<String, String>> dummyLogs = List.generate(
    10,
    (index) => {
      'user': 'user${index + 1}',
      'time': DateFormat('yyyy-MM-dd HH:mm')
          .format(DateTime.now().subtract(Duration(days: index))),
      'location': 'GPS: 12.9716, 77.5946'
    },
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Dashboard'),
        backgroundColor: Colors.redAccent,
        actions: [
          IconButton(
              icon: Icon(Icons.logout),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              })
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text('Monthly Attendance Summary',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: dummyLogs.length,
                itemBuilder: (context, index) {
                  final log = dummyLogs[index];
                  return Card(
                    child: ListTile(
                      title: Text('${log['user']}'),
                      subtitle: Text('${log['time']} • ${log['location']}'),
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
