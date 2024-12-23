// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// import '../constants/colors.dart';
// import '../providers/auth_provider.dart';
// import 'sign_up_screen.dart';

// class LoginScreen extends ConsumerStatefulWidget {
//   const LoginScreen({super.key});

//   @override
//   LoginScreenState createState() => LoginScreenState();
// }

// class LoginScreenState extends ConsumerState<LoginScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();

//   @override
//   void dispose() {
//     _emailController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }

//   void _login() async {
//     if (_formKey.currentState!.validate()) {
//       try {
//         await ref.read(authProvider.notifier).signIn(
//           _emailController.text.trim(),
//           _passwordController.text.trim(),
//         );
//         if (mounted) {
//           Navigator.of(context).pop(); // Return to settings screen after login
//         }
//       } catch (e) {
//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text('Failed to log in: ${e.toString()}')),
//           );
//         }
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.close, color: Colors.black),
//           onPressed: () => Navigator.of(context).pop(),
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               const SizedBox(height: 100), // Reduced from 150
//               Image.asset('assets/images/dunbeholden.png', height: 200),
//               Form(
//                 key: _formKey,
//                 child: Column(
//                   children: [
//                     TextFormField(
//                       controller: _emailController,
//                       decoration: const InputDecoration(
//                         labelText: 'Email ',
//                       ),
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Please enter your email';
//                         }
//                         return null;
//                       },
//                     ),
//                     const SizedBox(height: 32),
//                     TextFormField(
//                       controller: _passwordController,
//                       decoration: InputDecoration(
//                         labelText: 'Password',
//                         suffixIcon: TextButton(
//                           onPressed: () {
//                             // Add forgot password functionality here
//                           },
//                           child: const Text('Forgot?'),
//                         ),
//                       ),
//                       obscureText: true,
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Please enter your password';
//                         }
//                         return null;
//                       },
//                     ),
//                     const SizedBox(height: 72),
//                     ElevatedButton(
//                       onPressed: _login,
//                       style: ElevatedButton.styleFrom(
//                         minimumSize: const Size(double.infinity, 50),
//                         backgroundColor: AppColors.primaryBlue,
//                         foregroundColor: AppColors.pureWhite,
//                       ),
//                       child: const Text('Login'),
//                     ),
//                     const SizedBox(height: 16),
//                     const Text('Or, login with...'),
//                     const SizedBox(height: 16),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         IconButton(
//                           icon: Image.asset('assets/icons/google.png',
//                               width: 30, height: 30),
//                           iconSize: 50,
//                           onPressed: () {
//                             // Add Google login functionality here
//                           },
//                         ),
//                         const SizedBox(width: 16),
//                         IconButton(
//                           icon: Image.asset('assets/icons/facebook.png',
//                               width: 30, height: 30),
//                           iconSize: 50,
//                           onPressed: () {
//                             // Add Facebook login functionality here
//                           },
//                         ),
//                         const SizedBox(width: 16),
//                         IconButton(
//                           icon: Image.asset('assets/icons/apple.png',
//                               width: 30, height: 30),
//                           iconSize: 50,
//                           onPressed: () {
//                             // Add Apple login functionality here
//                           },
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 16),
//                     TextButton(
//                       onPressed: () {
//                         Navigator.of(context).push(
//                           MaterialPageRoute(
//                               builder: (_) => const SignupScreen()),
//                         );
//                       },
//                       child: const Text('Don\'t have an account? Register'),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
