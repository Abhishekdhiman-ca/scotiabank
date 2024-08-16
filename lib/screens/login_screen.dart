import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:scotiabank_app/screens/home_screen.dart';
import 'package:scotiabank_app/screens/signup_screen.dart';
import 'package:scotiabank_app/services/api_service.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final ApiService _apiService = ApiService();
  bool _isLoading = false;
  bool _obscureText = true;
  bool _rememberMe = false;
  List<dynamic> users = [];
  late AnimationController _controller;
  late Animation<double> _animation;

  // Default User Credentials
  final String defaultUserName = "Abhishek";
  final String defaultUserEmail = "abhi1322@gmail.com";
  final String defaultUserPassword = "1322@Bie";

  // Theme toggle
  bool _isDarkTheme = false;

  @override
  void initState() {
    super.initState();
    _fetchAllUsers();

    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _fetchAllUsers() async {
    setState(() {
      _isLoading = true;
    });

    try {
      List<dynamic>? fetchedUsers = (await _apiService.getAllUsers()) as List?;
      if (fetchedUsers != null) {
        setState(() {
          users = fetchedUsers;
        });
      } else {
        print("No users found");
      }
    } catch (e) {
      print("Error: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _login() async {
    setState(() {
      _isLoading = true;
    });

    // Check if the credentials match the default user
    if (emailController.text == defaultUserEmail && passwordController.text == defaultUserPassword) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(userName: defaultUserName, isDefaultUser: true),
        ),
      );
      return;
    }

    var filter = {
      "Creator": {
        "@type": "UserAccount",
        "Identifier": emailController.text,
        "Password": passwordController.text,
      }
    };

    try {
      Response<dynamic>? response = await _apiService.readTransaction(filter);
      if (response != null && response.statusCode == 200 && response.data['Result'].isNotEmpty) {
        var userName = response.data['Result'][0]['Name'];
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(userName: userName, isDefaultUser: false),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Invalid email or password.')),
        );
      }
    } catch (e) {
      print('Error during login: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred. Please try again later.')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _isDarkTheme ? Colors.black : Colors.white,
      body: Stack(
        children: [
          // Animated Background
          AnimatedBackground(animation: _animation, isDarkTheme: _isDarkTheme),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 60),
                  Center(
                    child: FadeTransition(
                      opacity: _animation,
                      child: ColorFiltered(
                        colorFilter: ColorFilter.mode(
                          Colors.white,
                          BlendMode.srcIn,
                        ),
                        child: Image.asset(
                          'assets/images/scotiabank_icon.png',
                          width: 100,
                          height: 100,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 40),
                  Center(
                    child: Text(
                      'Welcome Back!',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: _isDarkTheme ? Colors.white : Colors.red,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.email, color: _isDarkTheme ? Colors.white : Colors.black),
                      labelText: 'Email',
                      filled: true,
                      fillColor: _isDarkTheme ? Colors.grey[800] : Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: passwordController,
                    obscureText: _obscureText,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.lock, color: _isDarkTheme ? Colors.white : Colors.black),
                      labelText: 'Password',
                      filled: true,
                      fillColor: _isDarkTheme ? Colors.grey[800] : Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide.none,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureText ? Icons.visibility : Icons.visibility_off,
                          color: _isDarkTheme ? Colors.white : Colors.black,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Checkbox(
                            value: _rememberMe,
                            onChanged: (value) {
                              setState(() {
                                _rememberMe = value!;
                              });
                            },
                          ),
                          Text('Remember Me', style: TextStyle(color: _isDarkTheme ? Colors.white : Colors.black)),
                        ],
                      ),
                      TextButton(
                        onPressed: () {
                          // Implement forgot password functionality
                        },
                        child: Text(
                          'Forgot Password?',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Center(
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _login,
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 80),
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 8,
                      ),
                      child: _isLoading
                          ? CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      )
                          : Text(
                        'Sign In',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Center(
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SignupScreen()),
                        );
                      },
                      child: RichText(
                        text: TextSpan(
                          text: "Don't have an account? ",
                          style: TextStyle(color: _isDarkTheme ? Colors.grey[400] : Colors.grey[600]),
                          children: <TextSpan>[
                            TextSpan(
                              text: 'Register Now',
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Center(
                    child: Column(
                      children: [
                        Text(
                          'Or sign in with',
                          style: TextStyle(fontSize: 16, color: _isDarkTheme ? Colors.grey[400] : Colors.grey[600]),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: Icon(Icons.facebook, color: Colors.blue, size: 40),
                              onPressed: () {
                                // Implement Facebook login
                              },
                            ),
                            SizedBox(width: 20),
                            IconButton(
                              icon: Icon(Icons.g_translate, color: Colors.red, size: 40),
                              onPressed: () {
                                // Implement Google login
                              },
                            ),
                            SizedBox(width: 20),
                            IconButton(
                              icon: Icon(Icons.fingerprint, color: Colors.green, size: 40),
                              onPressed: () {
                                // Implement biometric login (Face ID / Touch ID)
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                  _isLoading
                      ? Center(child: CircularProgressIndicator())
                      : users.isEmpty
                      ? Center(
                    child: Text(
                      'No registered users found',
                      style: TextStyle(color: _isDarkTheme ? Colors.white : Colors.black),
                    ),
                  )
                      : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Registered Users:',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: _isDarkTheme ? Colors.white : Colors.black),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: users.length,
                        itemBuilder: (context, index) {
                          var user = users[index];
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.red,
                              child: Text(
                                user['Name'][0],
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            title: Text('${user['Name']}', style: TextStyle(color: _isDarkTheme ? Colors.white : Colors.black)),
                            subtitle: Text('Email: ${user['Identifier']}', style: TextStyle(color: _isDarkTheme ? Colors.grey[400] : Colors.grey[600])),
                            trailing: Tooltip(
                              message: 'Password: ${user['Password']}',
                              child: Icon(Icons.info_outline, color: Colors.red),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 40,
            right: 16,
            child: IconButton(
              icon: Icon(_isDarkTheme ? Icons.wb_sunny : Icons.nights_stay, color: _isDarkTheme ? Colors.white : Colors.black),
              onPressed: () {
                setState(() {
                  _isDarkTheme = !_isDarkTheme;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}

class AnimatedBackground extends StatelessWidget {
  final Animation<double> animation;
  final bool isDarkTheme;

  AnimatedBackground({required this.animation, required this.isDarkTheme});

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: animation,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDarkTheme ? [Colors.black, Colors.grey[900]!] : [Colors.redAccent, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
      ),
    );
  }
}
