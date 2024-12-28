import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MembershipFormScreen extends StatefulWidget {
  const MembershipFormScreen({super.key});

  @override
  State<MembershipFormScreen> createState() => _MembershipFormScreenState();
}

class _MembershipFormScreenState extends State<MembershipFormScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Form fields
  String? name;
  String? email;
  String? phone;
  String? parish;
  String? age;
  String? gender;
  bool isSeasonTicketHolder = false;
  int matchesAttended = 0;
  List<String> selectedMerchandise = [];
  String? merchandiseSuggestion;
  String? generalFeedback;

  final List<String> parishes = [
    'Kingston', 'St. Andrew', 'St. Catherine', 'Clarendon', 'Manchester',
    'St. Elizabeth', 'Westmoreland', 'Hanover', 'St. James', 'Trelawny',
    'St. Ann', 'St. Mary', 'Portland', 'St. Thomas'
  ];

  final List<String> ageRanges = [
    'Under 18', '18-24', '25-34', '35-44', '45-54', '55+'
  ];

  final List<String> merchandiseOptions = [
    'Home Jersey', 'Away Jersey', 'Training Kit', 'Caps/Hats',
    'Scarves', 'Bags', 'Water Bottles', 'Other'
  ];

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      
      try {
        await FirebaseFirestore.instance.collection('membership_applications').add({
          'name': name,
          'email': email,
          'phone': phone,
          'parish': parish,
          'age': age,
          'gender': gender,
          'isSeasonTicketHolder': isSeasonTicketHolder,
          'matchesAttended': matchesAttended,
          'interestedMerchandise': selectedMerchandise,
          'merchandiseSuggestion': merchandiseSuggestion,
          'generalFeedback': generalFeedback,
          'submittedAt': FieldValue.serverTimestamp(),
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Thank you for your feedback!'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Error submitting form. Please try again.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Membership Form'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Help us improve your Dunbeholden FC experience!',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                
                // Personal Information Section
                _buildSectionTitle('Personal Information'),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Full Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
                  onSaved: (value) => name = value,
                ),
                const SizedBox(height: 16),
                
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value?.isEmpty ?? true) return 'Required';
                    if (!value!.contains('@')) return 'Invalid email';
                    return null;
                  },
                  onSaved: (value) => email = value,
                ),
                const SizedBox(height: 16),

                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Phone Number',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.phone,
                  onSaved: (value) => phone = value,
                ),
                const SizedBox(height: 16),

                // Demographics Section
                _buildSectionTitle('Demographics'),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Parish',
                    border: OutlineInputBorder(),
                  ),
                  items: parishes.map((String parish) {
                    return DropdownMenuItem(
                      value: parish,
                      child: Text(parish),
                    );
                  }).toList(),
                  onChanged: (value) => setState(() => parish = value),
                  validator: (value) => value == null ? 'Required' : null,
                ),
                const SizedBox(height: 16),

                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Age Range',
                    border: OutlineInputBorder(),
                  ),
                  items: ageRanges.map((String ageRange) {
                    return DropdownMenuItem(
                      value: ageRange,
                      child: Text(ageRange),
                    );
                  }).toList(),
                  onChanged: (value) => setState(() => age = value),
                  validator: (value) => value == null ? 'Required' : null,
                ),
                const SizedBox(height: 16),

                // Fan Experience Section
                _buildSectionTitle('Fan Experience'),
                SwitchListTile(
                  title: const Text('Are you a season ticket holder?'),
                  value: isSeasonTicketHolder,
                  onChanged: (bool value) {
                    setState(() => isSeasonTicketHolder = value);
                  },
                ),
                const SizedBox(height: 16),

                const Text('How many matches have you attended this season?'),
                Slider(
                  value: matchesAttended.toDouble(),
                  min: 0,
                  max: 20,
                  divisions: 20,
                  label: matchesAttended.toString(),
                  onChanged: (double value) {
                    setState(() => matchesAttended = value.round());
                  },
                ),
                const SizedBox(height: 16),

                // Merchandise Section
                _buildSectionTitle('Merchandise Interest'),
                Wrap(
                  spacing: 8.0,
                  children: merchandiseOptions.map((String merchandise) {
                    return FilterChip(
                      label: Text(merchandise),
                      selected: selectedMerchandise.contains(merchandise),
                      onSelected: (bool selected) {
                        setState(() {
                          if (selected) {
                            selectedMerchandise.add(merchandise);
                          } else {
                            selectedMerchandise.remove(merchandise);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),

                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Merchandise Suggestions',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 2,
                  onSaved: (value) => merchandiseSuggestion = value,
                ),
                const SizedBox(height: 16),

                // General Feedback
                _buildSectionTitle('General Feedback'),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Any other comments or suggestions?',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                  onSaved: (value) => generalFeedback = value,
                ),
                const SizedBox(height: 24),

                // Submit Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                    child: const Text(
                      'Submit Survey',
                      style: TextStyle(fontSize: 18),
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

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
} 