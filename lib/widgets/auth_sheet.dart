import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../constants/app_colors.dart';

export 'auth_sheet.dart';

class AuthSheet extends StatefulWidget {
  final bool isSignUp;
  
  const AuthSheet({
    super.key,
    this.isSignUp = false,
  });

  @override
  State<AuthSheet> createState() => _AuthSheetState();
}

class _AuthSheetState extends State<AuthSheet> {
  bool _isLoading = false;
  
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  DateTime? _dateOfBirth;
  String? _selectedCountry;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  // Add form key
  final _formKey = GlobalKey<FormState>();
  
  // Add validation states
  bool _emailTouched = false;
  bool _passwordTouched = false;
  bool _confirmPasswordTouched = false;

  int _calculateAge(DateTime birthDate) {
    final today = DateTime.now();
    int age = today.year - birthDate.year;
    if (today.month < birthDate.month || 
        (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  String? _validatePassword(String password) {
    if (password.length < 8) {
      return 'Password must be at least 8 characters';
    }
    if (!password.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain at least one uppercase letter';
    }
    if (!password.contains(RegExp(r'[a-z]'))) {
      return 'Password must contain at least one lowercase letter';
    }
    if (!password.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain at least one number';
    }
    if (!password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return 'Password must contain at least one special character';
    }
    return null;
  }

  // Email validation
  String? _validateEmail(String? value) {
    if (!_emailTouched) return null;
    
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    if (!value.contains('@') || !value.contains('.')) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  // Password validation with immediate feedback
  String? _validatePasswordField(String? value) {
    if (!_passwordTouched) return null;
    
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    return _validatePassword(value);
  }

  // Confirm password validation
  String? _validateConfirmPassword(String? value) {
    if (!_confirmPasswordTouched) return null;
    
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  // Name validation
  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    if (value.length < 2) {
      return 'Name must be at least 2 characters';
    }
    return null;
  }

  Future<void> _submitSignUp() async {
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }

    final passwordError = _validatePassword(_passwordController.text);
    if (passwordError != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(passwordError)),
      );
      return;
    }

    if (_emailController.text.isEmpty || 
        _firstNameController.text.isEmpty || 
        _lastNameController.text.isEmpty || 
        _dateOfBirth == null || 
        _selectedCountry == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    final age = _calculateAge(_dateOfBirth!);
    if (age < 13) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You must be at least 13 years old to sign up')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      await userCredential.user!.sendEmailVerification();

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
            'uid': userCredential.user!.uid,
            'firstName': _firstNameController.text.trim(),
            'lastName': _lastNameController.text.trim(),
            'email': _emailController.text.trim(),
            'dateOfBirth': _dateOfBirth,
            'age': age,
            'country': _selectedCountry,
            'createdAt': FieldValue.serverTimestamp(),
            'updatedAt': FieldValue.serverTimestamp(),
            'isActive': true,
            'emailVerified': false,
          });

      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: const Text('Verify Your Email'),
          content: Text(
            'A verification email has been sent to ${_emailController.text}.\n\n'
            'Please check your inbox and click the verification link to complete your registration.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        String message = 'An error occurred';
        
        switch (e.code) {
          case 'email-already-in-use':
            message = 'This email is already registered';
            break;
          case 'invalid-email':
            message = 'Invalid email address';
            break;
          case 'weak-password':
            message = 'Password is too weak';
            break;
          default:
            message = e.message ?? 'An error occurred';
        }
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Create your account',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 24),
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                        helperText: 'Enter your email address',
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: _validateEmail,
                      onChanged: (value) {
                        if (!_emailTouched) {
                          setState(() => _emailTouched = true);
                        }
                        _formKey.currentState?.validate();
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        border: const OutlineInputBorder(),
                        helperText: 
                            'Must contain at least 8 characters, uppercase, lowercase, number and special character',
                        helperMaxLines: 2,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword ? Icons.visibility : Icons.visibility_off,
                          ),
                          onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                        ),
                      ),
                      obscureText: _obscurePassword,
                      validator: _validatePasswordField,
                      onChanged: (value) {
                        if (!_passwordTouched) {
                          setState(() => _passwordTouched = true);
                        }
                        _formKey.currentState?.validate();
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _confirmPasswordController,
                      decoration: InputDecoration(
                        labelText: 'Confirm Password',
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureConfirmPassword ? Icons.visibility : Icons.visibility_off,
                          ),
                          onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                        ),
                      ),
                      obscureText: _obscureConfirmPassword,
                      validator: _validateConfirmPassword,
                      onChanged: (value) {
                        if (!_confirmPasswordTouched) {
                          setState(() => _confirmPasswordTouched = true);
                        }
                        _formKey.currentState?.validate();
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _firstNameController,
                      decoration: const InputDecoration(
                        labelText: 'First Name',
                        border: OutlineInputBorder(),
                      ),
                      textCapitalization: TextCapitalization.words,
                      validator: _validateName,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _lastNameController,
                      decoration: const InputDecoration(
                        labelText: 'Last Name',
                        border: OutlineInputBorder(),
                      ),
                      textCapitalization: TextCapitalization.words,
                      validator: _validateName,
                    ),
                    const SizedBox(height: 16),
                    OutlinedButton(
                      onPressed: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: DateTime(2000),
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now(),
                        );
                        if (date != null) {
                          setState(() => _dateOfBirth = date);
                        }
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Text(
                        _dateOfBirth == null
                            ? 'Select Date of Birth'
                            : 'Date of Birth: ${_dateOfBirth!.day}/${_dateOfBirth!.month}/${_dateOfBirth!.year}',
                      ),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: _selectedCountry,
                      decoration: const InputDecoration(
                        labelText: 'Country',
                        border: OutlineInputBorder(),
                      ),
                      items: ['Jamaica', 'United States', 'Canada', 'United Kingdom', 'Other']
                          .map((country) => DropdownMenuItem(
                                value: country,
                                child: Text(country),
                              ))
                          .toList(),
                      onChanged: (value) => setState(() => _selectedCountry = value),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _isLoading 
                          ? null 
                          : () {
                              if (_formKey.currentState?.validate() ?? false) {
                                _submitSignUp();
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(50),
                        backgroundColor: AppColors.primary,
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Text('Sign Up'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }
} 