import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:dietifyy/core/common/widgets/custom_button.dart';
import 'package:dietifyy/features/auth/views/screens/sign_in_screen.dart';
import 'package:dietifyy/features/home/screens/home_screen.dart';
import 'package:dietifyy/main_screen.dart';

class UserDetailsScreen extends StatefulWidget {
  final String userId;
  const UserDetailsScreen({super.key, required this.userId});

  @override
  State<UserDetailsScreen> createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? gender;
  DateTime? selectedDOB;
  List<String> selectedDietaryChoices = [];
  final TextEditingController allergiesController = TextEditingController();

  final List<String> dietaryOptions = ["Vegan", "Vegetarian", "Keto", "Halal"];

  Future<void> saveUserDetails() async {
    await _firestore.collection('users').doc(widget.userId).update({
      'gender': gender,
      'dob': selectedDOB != null ? Timestamp.fromDate(selectedDOB!) : null,
      'dietaryChoices': selectedDietaryChoices,
      'allergies': allergiesController.text.trim(),
    });

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) =>  SignInScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: const Text("Complete Your Profile")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Gender Selection
          const Text("Gender", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          Row(
            children: [
              Radio(
                value: "Male",
                groupValue: gender,
                onChanged: (value) => setState(() => gender = value),
              ),
              const Text("Male"),
              Radio(
                value: "Female",
                groupValue: gender,
                onChanged: (value) => setState(() => gender = value),
              ),
              const Text("Female"),
            ],
          ),
          const SizedBox(height: 16),

          // Date of Birth Selection
          const Text("Date of Birth", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () async {
              DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(1900),
                lastDate: DateTime.now(),
              );
              if (pickedDate != null) {
                setState(() => selectedDOB = pickedDate);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              foregroundColor: Colors.white,
              minimumSize: const Size(200, 50), // Ensures minimum width of 200px and height of 50px
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
              shadowColor: Colors.black54,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.calendar_today, color: Colors.white, size: 18),
                const SizedBox(width: 8),
                Text(
                  selectedDOB == null ? "Select DOB" : DateFormat.yMMMd().format(selectedDOB!),
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Dietary Preferences
          const Text("Dietary Preferences", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          Column(
            children: dietaryOptions.map((diet) {
              return CheckboxListTile(
                title: Text(diet),
                value: selectedDietaryChoices.contains(diet),
                onChanged: (bool? value) {
                  setState(() {
                    if (value == true) {
                      selectedDietaryChoices.add(diet);
                    } else {
                      selectedDietaryChoices.remove(diet);
                    }
                  });
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 16),

          // Allergies Input
          const Text("Allergies (if any)", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          TextField(
            controller: allergiesController,
            decoration: InputDecoration(
              hintText: "Enter allergies (if any)",
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              filled: true,
              fillColor: isDark ? Colors.grey[800] : Colors.grey[200],
            ),
            maxLines: 2,
          ),
          const SizedBox(height: 24),

          // Save Button
          CustomButton(
            text: "Save",
            onPressed: saveUserDetails,
          ),
        ],
      ),
    );
  }
}
