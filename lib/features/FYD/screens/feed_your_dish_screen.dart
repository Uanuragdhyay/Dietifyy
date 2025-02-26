import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DietaryPlanScreen extends StatefulWidget {
  const DietaryPlanScreen({super.key});

  @override
  State<DietaryPlanScreen> createState() => _DietaryPlanScreenState();
}

class _DietaryPlanScreenState extends State<DietaryPlanScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _mealController = TextEditingController();

  void _addOrEditMeal({String? docId, String? currentMeal}) {
    _mealController.text = currentMeal ?? "";

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(docId == null ? "Add Dietary Plan" : "Edit Dietary Plan"),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: TextField(
          controller: _mealController,
          decoration: InputDecoration(
            hintText: "Enter meal or dietary plan",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              if (_mealController.text.trim().isEmpty) {
                _mealController.clear();
                Navigator.pop(context);
                return;
              }

              String userId = _auth.currentUser!.uid;

              if (docId == null) {
                // Adding new meal
                await _firestore.collection('users').doc(userId).collection('dietaryPlans').add({
                  'meal': _mealController.text.trim(),
                  'completed': false,
                  'timestamp': FieldValue.serverTimestamp(),
                });
                _mealController.clear();
                Navigator.pop(context); // ✅ Close the add/edit dialog first
                _showConfirmationDialog("Dietary Plan Added Successfully!");
              } else {
                // Editing existing meal
                await _firestore.collection('users').doc(userId).collection('dietaryPlans').doc(docId).update({
                  'meal': _mealController.text.trim(),
                });
                _mealController.clear();
                Navigator.pop(context); // ✅ Close the add/edit dialog first
                _showConfirmationDialog("Dietary Plan Updated Successfully!");
              }
            },
            child: Text(docId == null ? "Add" : "Update"),
          ),
        ],
      ),
    );
  }


  void _showConfirmationDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text("Success", style: TextStyle(fontWeight: FontWeight.bold)),
        content: Text(message, textAlign: TextAlign.center),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String userId = _auth.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(title: const Text("Dietary Plan Tracker")),
      body: Column(
        children: [
          const SizedBox(height: 16),

          // "Add Plan" Button
          Center(
            child: ElevatedButton(
              onPressed: () => _addOrEditMeal(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
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
                children: [
                  const Icon(Icons.add, color: Colors.white, size: 22),
                  const SizedBox(width: 10),
                  const Text(
                    "Add Dietary Plan",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 1.2),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          Expanded(
            child: StreamBuilder(
              stream: _firestore
                  .collection('users')
                  .doc(userId)
                  .collection('dietaryPlans')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text("No dietary plans added."));
                }

                return ListView(
                  padding: const EdgeInsets.all(16),
                  children: snapshot.data!.docs.map((doc) {
                    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
                    return Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 4,
                      child: ListTile(
                        title: Text(
                          data['meal'],
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            decoration: data['completed'] ? TextDecoration.lineThrough : null,
                          ),
                        ),
                        leading: Checkbox(
                          value: data['completed'],
                          onChanged: (value) => _toggleMealCompletion(doc.id, data['completed']),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.orangeAccent),
                              onPressed: () => _addOrEditMeal(docId: doc.id, currentMeal: data['meal']),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.redAccent),
                              onPressed: () => _deleteMeal(doc.id),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _toggleMealCompletion(String docId, bool currentStatus) async {
    String userId = _auth.currentUser!.uid;
    await _firestore.collection('users').doc(userId).collection('dietaryPlans').doc(docId).update({'completed': !currentStatus});
  }

  void _deleteMeal(String docId) async {
    String userId = _auth.currentUser!.uid;
    await _firestore.collection('users').doc(userId).collection('dietaryPlans').doc(docId).delete();
  }
}
