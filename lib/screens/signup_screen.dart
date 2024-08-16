import 'package:flutter/material.dart';
import 'package:scotiabank_app/services/api_service.dart';
import 'package:flutter_pw_validator/flutter_pw_validator.dart';
import 'package:country_picker/country_picker.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> with SingleTickerProviderStateMixin {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController securityAnswerController = TextEditingController();
  final ApiService _apiService = ApiService();

  bool isPasswordValid = false;
  bool _isLoading = false;
  bool _acceptTerms = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  String? _selectedSecurityQuestion;
  bool _isDarkTheme = false;
  String? _selectedCountry;
  late AnimationController _controller;
  late Animation<double> _animation;

  final List<String> _securityQuestions = [
    "What is your mother's maiden name?",
    "What was the name of your first pet?",
    "What was your first car?",
    "What elementary school did you attend?",
    "What is the name of the town where you were born?"
  ];

  @override
  void initState() {
    super.initState();
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

  void _signup() async {
    if (passwordController.text != confirmPasswordController.text) {
      _showInlineError('Passwords do not match');
      return;
    }

    if (!isPasswordValid) {
      _showInlineError('Please enter a strong password');
      return;
    }

    if (!_acceptTerms) {
      _showInlineError('You must accept the terms and conditions to proceed');
      return;
    }

    if (_selectedSecurityQuestion == null || securityAnswerController.text.isEmpty) {
      _showInlineError('Please select a security question and provide an answer');
      return;
    }

    if (_selectedCountry == null) {
      _showInlineError('Please select your country');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    var data = {
      "Name": "${firstNameController.text} ${lastNameController.text}",
      "Country": _selectedCountry,
      "Creator": {
        "@type": "UserAccount",
        "Identifier": emailController.text,
        "Password": passwordController.text,
        "SecurityQuestion": _selectedSecurityQuestion,
        "SecurityAnswer": securityAnswerController.text
      }
    };

    try {
      var response = await _apiService.createTransaction(data);
      if (response != null && response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Account created successfully')),
        );
        Navigator.pop(context);
      } else {
        _showInlineError('Failed to create account');
      }
    } catch (e) {
      print('Error during signup: $e');
      _showInlineError('An error occurred. Please try again later.');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showInlineError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _selectCountry() {
    showCountryPicker(
      context: context,
      showPhoneCode: false,
      onSelect: (Country country) {
        setState(() {
          _selectedCountry = country.name;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _isDarkTheme ? Colors.black : Colors.white,
      body: Stack(
        children: [
          AnimatedBackground(animation: _animation, isDarkTheme: _isDarkTheme),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 60),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back, color: _isDarkTheme ? Colors.white : Colors.black),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      Expanded(
                        child: Center(
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
                      ),
                    ],
                  ),
                  SizedBox(height: 40),
                  Center(
                    child: Text(
                      'Create Account',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: _isDarkTheme ? Colors.white : Colors.red,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.red,
                      child: Text(
                        '${firstNameController.text.isNotEmpty ? firstNameController.text[0] : '?'}${lastNameController.text.isNotEmpty ? lastNameController.text[0] : ''}',
                        style: TextStyle(color: Colors.white, fontSize: 40),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: firstNameController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.person, color: _isDarkTheme ? Colors.white : Colors.black),
                      labelText: 'First Name',
                      filled: true,
                      fillColor: _isDarkTheme ? Colors.grey[800] : Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onChanged: (text) {
                      setState(() {});
                    },
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: lastNameController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.person, color: _isDarkTheme ? Colors.white : Colors.black),
                      labelText: 'Last Name',
                      filled: true,
                      fillColor: _isDarkTheme ? Colors.grey[800] : Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onChanged: (text) {
                      setState(() {});
                    },
                  ),
                  SizedBox(height: 16),
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
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: passwordController,
                    obscureText: _obscurePassword,
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
                          _obscurePassword ? Icons.visibility : Icons.visibility_off,
                          color: _isDarkTheme ? Colors.white : Colors.black,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  FlutterPwValidator(
                    controller: passwordController,
                    minLength: 8,
                    uppercaseCharCount: 1,
                    numericCharCount: 1,
                    specialCharCount: 1,
                    width: 400,
                    height: 150,
                    onSuccess: () {
                      setState(() {
                        isPasswordValid = true;
                      });
                    },
                    onFail: () {
                      setState(() {
                        isPasswordValid = false;
                      });
                    },
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: confirmPasswordController,
                    obscureText: _obscureConfirmPassword,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.lock, color: _isDarkTheme ? Colors.white : Colors.black),
                      labelText: 'Confirm Password',
                      filled: true,
                      fillColor: _isDarkTheme ? Colors.grey[800] : Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide.none,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureConfirmPassword ? Icons.visibility : Icons.visibility_off,
                          color: _isDarkTheme ? Colors.white : Colors.black,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureConfirmPassword = !_obscureConfirmPassword;
                          });
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _selectedSecurityQuestion,
                    decoration: InputDecoration(
                      labelText: 'Security Question',
                      prefixIcon: Icon(Icons.security, color: _isDarkTheme ? Colors.white : Colors.black),
                      filled: true,
                      fillColor: _isDarkTheme ? Colors.grey[800] : Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    items: _securityQuestions.map((String question) {
                      return DropdownMenuItem<String>(
                        value: question,
                        child: Text(question, style: TextStyle(color: _isDarkTheme ? Colors.white : Colors.black)),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedSecurityQuestion = newValue;
                      });
                    },
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: securityAnswerController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.question_answer, color: _isDarkTheme ? Colors.white : Colors.black),
                      labelText: 'Answer',
                      filled: true,
                      fillColor: _isDarkTheme ? Colors.grey[800] : Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  GestureDetector(
                    onTap: _selectCountry,
                    child: AbsorbPointer(
                      child: TextField(
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.flag, color: _isDarkTheme ? Colors.white : Colors.black),
                          labelText: _selectedCountry ?? 'Select Country',
                          filled: true,
                          fillColor: _isDarkTheme ? Colors.grey[800] : Colors.grey[200],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Checkbox(
                        value: _acceptTerms,
                        onChanged: (value) {
                          setState(() {
                            _acceptTerms = value ?? false;
                          });
                        },
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            _showTermsAndConditions();
                          },
                          child: Text('I accept the terms and conditions', style: TextStyle(color: _isDarkTheme ? Colors.grey[400] : Colors.grey[600])),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Center(
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _signup,
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 80), backgroundColor: Colors.red,
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
                        'Create Account',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
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

  void _showTermsAndConditions() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Terms and Conditions'),
          content: SingleChildScrollView(
            child: Text('Detailed terms and conditions go here...'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Accept'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Decline'),
            ),
          ],
        );
      },
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
