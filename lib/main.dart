import 'dart:convert';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:works/crud.dart';
import 'package:works/linkapi.dart';

import 'admin.dart';
import 'NotificationHelper.dart';
import 'create_account_1.dart';
import 'landing_page.dart';
import 'start.dart'; // MazadcoApp

// Global session to store user ID
class Session {
  static int? userId;
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Awesome Notifications with just the 'chat_channel'
  await AwesomeNotifications().initialize(null, [
    NotificationChannel(
      channelKey: 'chat_channel',
      channelName: 'Chat Notifications',
      channelDescription: 'Notifications for chat messages',
      defaultColor: Color(0xFF9D50DD),
      ledColor: Colors.white,
      importance: NotificationImportance.High,
    ),
  ], debug: true);

  // Optional: Ask for notification permission
  bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
  if (!isAllowed) {
    AwesomeNotifications().requestPermissionToSendNotifications();
  }

  runApp(const MazadcoLoginApp());
}

class MazadcoLoginApp extends StatelessWidget {
  const MazadcoLoginApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mazadco Login',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.transparent,
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 20,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Color(0xff0077b6), width: 2),
          ),
        ),
      ),
      home: const LoginPage(),
    );
  }
}

// ordin
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool obscurePassword = true;
  String errorMessage = '';
  bool isLoading = false;
  bool isInputValid = true;

  final String linkLogIn =
      'http://localhost/works/user_profile/login.php'; // Replace this with your actual API

  void _handleLogin() async {
    String username = usernameController.text.trim();
    String password = passwordController.text.trim();

    setState(() {
      errorMessage = '';
    });

    if (username.isEmpty || password.isEmpty) {
      setState(() {
        errorMessage = 'Please enter both username and password';
      });
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse(linkLogIn),
        body: {'username': username, 'password': password},
      );

      print('Response body: ${response.body}');
      final data = json.decode(response.body);

      setState(() {
        isLoading = false;
      });

      if (data['status'] == 'success') {
        int userId = int.tryParse(data['id'].toString()) ?? 0;
        Session.userId = userId;
        NotificationHelper.sendChatNotification('Login successful');

        if (username.toLowerCase() == 'admin') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => AdminDashboardApp()),
          );
        } else {
          await evaluateRisk(Session.userId!);

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => MazadcoApp(ipAddress: Session.userId!),
            ),
          );
        }

        if (Session.userId != 0) {
          // Perform risk evaluation after login
          // await evaluateRisk(Session.userId!);

          // Navigate to the landing page
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => MazadcoApp(ipAddress: Session.userId!),
            ),
          );
        } else {
          setState(() {
            errorMessage = 'Invalid user ID';
            isInputValid = false;
          });
        }
      } else {
        setState(() {
          errorMessage = data['message'] ?? 'Login failed';
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'An error occurred. Please try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 164, 217, 202),
      body: Container(
        constraints: BoxConstraints(maxWidth: 500),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                Container(
                  height: 130,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(100),
                      topRight: Radius.circular(100),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.account_circle, size: 50, color: Colors.teal),
                      SizedBox(height: 8),
                      Text(
                        "Login",
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 6),
                      Text(
                        "login to continue",
                        style: TextStyle(color: Colors.black54, fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),

                // Login Card
                Card(
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(30),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),

                        TextField(
                          controller: usernameController,
                          decoration: const InputDecoration(
                            labelText: 'Username',
                            prefixIcon: Icon(
                              Icons.person_outline,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        TextField(
                          controller: passwordController,
                          obscureText: obscurePassword,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            prefixIcon: const Icon(
                              Icons.lock_outline,
                              color: Colors.grey,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                obscurePassword
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.grey,
                              ),
                              onPressed: () {
                                setState(() {
                                  obscurePassword = !obscurePassword;
                                });
                              },
                            ),
                          ),
                        ),

                        if (errorMessage.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Text(
                              errorMessage,
                              style: const TextStyle(color: Colors.red),
                            ),
                          ),

                        const SizedBox(height: 20),

                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: isLoading ? null : _handleLogin,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              elevation: 5,
                            ),
                            child:
                                isLoading
                                    ? const CircularProgressIndicator(
                                      color: Colors.white,
                                    )
                                    : const Text(
                                      'LOGIN',
                                      style: TextStyle(color: Colors.teal),
                                    ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => UserRegistrationForm(),
                                  ),
                                );
                              },
                              child: const Text(
                                'Create Account',
                                style: TextStyle(color: Color(0xff0077b6)),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => MazadcoApp(
                                          ipAddress: Session.userId!,
                                        ),
                                  ),
                                );
                              },
                              child: const Text(
                                'Loading Data',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> evaluateRisk(int userId) async {
    Crud crud = Crud();

    var result = await crud.getRequest("$linkRiskEvaluator?user_id=$userId");
    print("Risk API response************: $result");

    if (result != null && result is Map && result.isNotEmpty) {
      setState(() {
        // Update risk-related data
        var riskStatus = result['risk_status'] ?? 'Unknown';
        var riskData = {
          'account_authenticity': result['account_authenticity'] ?? 0.0,
          'bidding_score': result['bidding_score'] ?? 0.0,
          'transaction_score': result['transaction_score'] ?? 0.0,
          'delivery_score': result['delivery_score'] ?? 0.0,
          'fraud_score': result['fraud_score'] ?? 0.0,
          'risk_level': result['risk_status'] ?? 'Unknown',
        };
        var riskImagePath = _getImageForRisk(riskStatus);
      });
    }
  }

  String _getImageForRisk(String riskStatus) {
    // Example mapping; you can update this logic as per the risk levels
    if (riskStatus == 'High') {
      return 'assets/high_risk.png';
    } else if (riskStatus == 'Low') {
      return 'assets/low_risk.png';
    }
    return 'assets/unknown_risk.png';
  }
}
