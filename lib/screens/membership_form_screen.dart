import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/membership.dart';
import '../repositories/membership_repository.dart';
import '../constants/app_colors.dart';

class MembershipFormScreen extends StatefulWidget {
  const MembershipFormScreen({super.key});

  @override
  State<MembershipFormScreen> createState() => _MembershipFormScreenState();
}

class _MembershipFormScreenState extends State<MembershipFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _repository = MembershipRepository();
  bool _isLoading = false;
  
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  DateTime? _dateOfBirth;
  String _selectedMembershipType = 'standard';
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Only check existing application after email is entered
  }

  Future<void> _checkExistingApplication(String email) async {
    final hasPending = await _repository.hasPendingApplication(email);
    if (hasPending && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('An application with this email already exists'),
        ),
      );
      return;
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate() && _dateOfBirth != null) {
      await _checkExistingApplication(_emailController.text);
      
      setState(() => _isLoading = true);
      
      try {
        print('Starting form submission...');
        
        // Create Auth account
        print('Creating Firebase Auth account...');
        final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );
        print('Auth account created successfully: ${userCredential.user?.uid}');

        // Create membership
        print('Creating membership document...');
        final membership = Membership(
          id: '',
          userId: userCredential.user!.uid,
          fullName: _fullNameController.text,
          email: _emailController.text,
          phone: _phoneController.text,
          dateOfBirth: _dateOfBirth!,
          address: _addressController.text,
          createdAt: DateTime.now(),
          membershipType: _selectedMembershipType,
          membershipCode: Membership.generateMembershipCode(),
        );

        print('Membership data: ${membership.toMap()}');
        await _repository.submitMembershipForm(membership);
        print('Membership document created successfully');

        // Update user profile
        if (userCredential.user != null) {
          await FirebaseAuth.instance.currentUser?.updateDisplayName(_fullNameController.text);
        }

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Application submitted successfully. Your membership code is: ${membership.membershipCode}'),
              duration: const Duration(seconds: 6),
            ),
          );
          Navigator.pop(context);
        }
      } catch (e, stackTrace) {
        print('Error during form submission:');
        print('Error: $e');
        print('Stack trace: $stackTrace');
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error submitting form: $e')),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Join MyDBN'),
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
            child: Column(
                children: [
                  // Header Section
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                    ),
                    child: const Column(
              children: [
                        Text(
                          'Become a Member',
                  style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                        SizedBox(height: 8),
                        Text(
                          'Join our family and get exclusive benefits',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Form Section
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _buildInputField(
                            controller: _fullNameController,
                            label: 'Full Name',
                            icon: Icons.person_outline,
                            validator: (value) =>
                                value?.isEmpty ?? true ? 'Please enter your name' : null,
                          ),
                          const SizedBox(height: 20),
                          _buildInputField(
                            controller: _emailController,
                            label: 'Email',
                            icon: Icons.email_outlined,
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) =>
                                value?.isEmpty ?? true ? 'Please enter your email' : null,
                          ),
                          const SizedBox(height: 20),
                          _buildInputField(
                            controller: _passwordController,
                            label: 'Password',
                            icon: Icons.lock_outline,
                            obscureText: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a password';
                              }
                              if (value.length < 6) {
                                return 'Password must be at least 6 characters';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          _buildInputField(
                            controller: _confirmPasswordController,
                            label: 'Confirm Password',
                            icon: Icons.lock_outline,
                            obscureText: true,
                            validator: (value) {
                              if (value != _passwordController.text) {
                                return 'Passwords do not match';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          _buildInputField(
                            controller: _phoneController,
                            label: 'Phone',
                            icon: Icons.phone_outlined,
                            keyboardType: TextInputType.phone,
                            validator: (value) =>
                                value?.isEmpty ?? true ? 'Please enter your phone' : null,
                          ),
                          const SizedBox(height: 20),
                          _buildDatePicker(),
                          const SizedBox(height: 20),
                          _buildInputField(
                            controller: _addressController,
                            label: 'Address',
                            icon: Icons.location_on_outlined,
                  maxLines: 3,
                            validator: (value) =>
                                value?.isEmpty ?? true ? 'Please enter your address' : null,
                          ),
                          const SizedBox(height: 20),
                          _buildMembershipTypeSelector(),
                          const SizedBox(height: 32),
                          ElevatedButton(
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                    ),
                    child: const Text(
                              'Submit Application',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                    ),
                  ),
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

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    bool obscureText = false,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppColors.primary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary),
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
      validator: validator,
    );
  }

  Widget _buildDatePicker() {
    return InkWell(
      onTap: () async {
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
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
          color: Colors.grey.shade50,
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_today_outlined, color: AppColors.primary),
            const SizedBox(width: 12),
            Text(
              _dateOfBirth == null
                  ? 'Select Date of Birth'
                  : 'DoB: ${_dateOfBirth!.day}/${_dateOfBirth!.month}/${_dateOfBirth!.year}',
              style: TextStyle(
                color: _dateOfBirth == null ? Colors.grey.shade600 : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMembershipTypeSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey.shade50,
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButtonFormField<String>(
          value: _selectedMembershipType,
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.card_membership, color: AppColors.primary),
            border: InputBorder.none,
          ),
          items: const [
            DropdownMenuItem(
              value: 'standard',
              child: Text('Standard Membership'),
            ),
            DropdownMenuItem(
              value: 'premium',
              child: Text('Premium Membership'),
            ),
          ],
          onChanged: (value) {
            if (value != null) {
              setState(() => _selectedMembershipType = value);
            }
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
} 