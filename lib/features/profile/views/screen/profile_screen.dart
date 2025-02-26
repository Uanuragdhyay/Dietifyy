import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:dietifyy/features/auth/views/screens/sign_in_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool isLoading = true;
  Map<String, dynamic>? userData;
  final List<String> dietaryOptions = ["Vegan", "Vegetarian", "Keto", "Halal"];

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }
  void _showEditDialog(String field, String currentValue) {
    TextEditingController controller = TextEditingController(text: currentValue);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 16, right: 16, top: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Edit $field", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              decoration: InputDecoration(
                labelText: "Enter new $field",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                await _firestore.collection('users').doc(_auth.currentUser!.uid).update({field.toLowerCase(): controller.text.trim()});
                setState(() {
                  userData![field.toLowerCase()] = controller.text.trim();
                });
                Navigator.pop(context);
              },
              child: Text("Save"),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
  Future<void> _fetchUserData() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(user.uid).get();
      if (userDoc.exists) {
        setState(() {
          userData = userDoc.data() as Map<String, dynamic>?;
          isLoading = false;
        });
      }
    }
  }

  void _logout(BuildContext context) async {
    await _auth.signOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const SignInScreen()),
          (route) => false,
    );
  }

  void _editDOB() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      await _firestore.collection('users').doc(_auth.currentUser!.uid).update({'dob': Timestamp.fromDate(pickedDate)});
      setState(() {
        userData!['dob'] = Timestamp.fromDate(pickedDate);
      });
    }
  }

  void _editPreferences() {
    List<String> selectedPreferences = List<String>.from(userData?['dietaryChoices'] ?? []);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setStateModal) => Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 16, right: 16, top: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Select Dietary Preferences", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Column(
                children: dietaryOptions.map((diet) {
                  return CheckboxListTile(
                    title: Text(diet),
                    value: selectedPreferences.contains(diet),
                    onChanged: (bool? value) {
                      setStateModal(() {
                        if (value == true) {
                          selectedPreferences.add(diet);
                        } else {
                          selectedPreferences.remove(diet);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  await _firestore.collection('users').doc(_auth.currentUser!.uid).update({'dietaryChoices': selectedPreferences});
                  setState(() {
                    userData!['dietaryChoices'] = selectedPreferences;
                  });
                  Navigator.pop(context);
                },
                child: const Text("Save"),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context),
            tooltip: 'Logout',
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : userData == null
          ? const Center(child: Text("No user data found"))
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              const Icon(Icons.account_circle, size: 100, color: Colors.grey),
              const SizedBox(height: 20),

              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoRow("Name", userData!['name'] ?? 'No Name', () => _showEditDialog("Name", userData!['name'] ?? '')),
                      _buildInfoRow("Email", userData!['email'] ?? 'No Email', null),
                      _buildInfoRow("Gender", userData!['gender'] ?? 'Not Set', () => _showEditDialog("Gender", userData!['gender'] ?? '')),
                      _buildInfoRow(
                        "DOB",
                        userData!['dob'] != null ? DateFormat.yMMMd().format((userData!['dob'] as Timestamp).toDate()) : "Not Set",
                        _editDOB,
                      ),
                      _buildInfoRow(
                        "Preferences",
                        (userData!['dietaryChoices'] as List<dynamic>?)?.join(", ") ?? "Not Set",
                        _editPreferences,
                      ),
                      _buildInfoRow("Allergies", userData!['allergies'] ?? "Not Set", () => _showEditDialog("Allergies", userData!['allergies'] ?? '')),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: () => _logout(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                    side: const BorderSide(color: Colors.white, width: 2),
                  ),
                  elevation: 5,
                  shadowColor: Colors.black.withOpacity(0.3),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.exit_to_app, color: Colors.white, size: 22),
                    const SizedBox(width: 10),
                    const Text(
                      "Logout",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 1.2),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String title, String value, VoidCallback? onEdit) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.grey[600])),
              const SizedBox(height: 4),
              Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
            ],
          ),
          if (onEdit != null)
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blueAccent),
              onPressed: onEdit,
            ),
        ],
      ),
    );
  }
}
