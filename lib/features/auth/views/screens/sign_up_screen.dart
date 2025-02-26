import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:dietifyy/core/common/utils/validation_utils.dart';
import 'package:dietifyy/core/common/widgets/custom_button.dart';
import 'package:dietifyy/core/config/theme/app_colors.dart';
import 'package:dietifyy/features/auth/views/screens/sign_in_screen.dart';
import 'package:dietifyy/features/auth/views/screens/user_details_screen.dart';
import 'package:dietifyy/features/auth/views/widgets/custom_text_field.dart';
import 'package:dietifyy/features/auth/views/widgets/social_button.dart';
import 'package:dietifyy/main_screen.dart';

class SignUpScreen extends StatefulWidget {
const SignUpScreen({super.key});

@override
State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
final FirebaseAuth _auth = FirebaseAuth.instance;
final FirebaseFirestore _firestore = FirebaseFirestore.instance;


final TextEditingController nameController = TextEditingController();
final TextEditingController emailController = TextEditingController();
final TextEditingController passwordController = TextEditingController();
final TextEditingController confirmPasswordController = TextEditingController();

bool isLoading = false;
String? emailError;
String? passwordError;
String? confirmPasswordError;
String? authError;

void validateInputs() {
setState(() {
emailError = ValidationUtils.validateEmail(emailController.text);
passwordError = ValidationUtils.validatePassword(passwordController.text);
confirmPasswordError = ValidationUtils.validateConfirmPassword(
passwordController.text,
confirmPasswordController.text
);
authError = null; // Reset authentication errors on new input
});
}

Future<void> signInWithGoogle() async {
  setState(() {
    isLoading = true;
  });

  try {
    // Ensure user is signed out before logging in (forces account selection)
    await GoogleSignIn().signOut();

    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) {
      setState(() {
        isLoading = false;
      });
      return; // User canceled sign-in
    }

    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final OAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Sign in to Firebase with Google credentials
    UserCredential userCredential = await _auth.signInWithCredential(credential);
    User? user = userCredential.user;

    if (user != null) {
      // Reference to Firestore users collection
      final userDoc = FirebaseFirestore.instance.collection('users').doc(user.uid);

      // Check if user already exists in Firestore
      final docSnapshot = await userDoc.get();

      if (!docSnapshot.exists) {
        // If user does not exist, create user entry
        await userDoc.set({
          'uid': user.uid,
          'name': user.displayName ?? "",
          'email': user.email ?? "",
          'createdAt': FieldValue.serverTimestamp(),
        });

        // Navigate to User Details Screen if first-time login
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => UserDetailsScreen(userId: user.uid),
          ),
        );
      } else {
        // Navigate directly to MainScreen if user exists
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainScreen()),
        );
      }
    }
  } on FirebaseAuthException catch (e) {
    setState(() {
      authError = e.message;
    });
  } finally {
    setState(() {
      isLoading = false;
    });
  }
}

bool get isValid => emailError == null && passwordError == null && confirmPasswordError == null;

Future<void> signUp() async {
validateInputs();
if (!isValid) return;

setState(() {
isLoading = true;
});

try {
UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
email: emailController.text,
password: passwordController.text,
);

User? user = userCredential.user;
if (user != null) {
await _firestore.collection('users').doc(user.uid).set({
'uid': user.uid,
'name': nameController.text,
'email': emailController.text,
'createdAt': FieldValue.serverTimestamp(),
});

Get.snackbar(
"Success",
"Account created successfully. Please log in.",
backgroundColor: Colors.green,
colorText: Colors.white,
);

Navigator.pushReplacement(
context,
MaterialPageRoute(builder: (context) => UserDetailsScreen(userId: user.uid)),
);
}
} on FirebaseAuthException catch (e) {
setState(() {
authError = e.message;
});
} finally {
setState(() {
isLoading = false;
});
}
}
@override
Widget build(BuildContext context) {
final isDark = Theme.of(context).brightness == Brightness.dark;

return Scaffold(
backgroundColor: Theme.of(context).scaffoldBackgroundColor,
body: SafeArea(
child: SingleChildScrollView(
padding: const EdgeInsets.all(24),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
IconButton(
onPressed: () => Navigator.pop(context),
icon: Icon(
Icons.arrow_back_ios,
color: isDark ? Colors.white : AppColors.textDark,
),
padding: EdgeInsets.zero,
),
const SizedBox(height: 20),
Text(
'Create Account',
style: Theme.of(context).textTheme.headlineMedium?.copyWith(
color: isDark ? Colors.white : AppColors.textDark,
fontWeight: FontWeight.bold,
),
),
const SizedBox(height: 8),
Text(
'Sign Up to get started!',
style: Theme.of(context).textTheme.bodyLarge?.copyWith(
color: isDark ? Colors.grey[500] : AppColors.textLight,
),
),
const SizedBox(height: 32),

if (authError != null)
Padding(
padding: const EdgeInsets.only(bottom: 12),
child: Text(
authError!,
style: const TextStyle(color: Colors.red, fontSize: 14),
),
),

// Name Text Field
CustomTextField(
label: 'Full Name',
hintText: 'Enter your full name',
prefixIcon: Icons.person_2_outlined,
controller: nameController,
),

const SizedBox(height: 16),

// Email Text Field
CustomTextField(
label: 'Email',
hintText: 'Enter your email',
prefixIcon: Icons.email_outlined,
controller: emailController,
keyboardType: TextInputType.emailAddress,
errortext: emailError,
onFieldSubmitted: (_) => validateInputs(),
onChanged: (value) => validateInputs(),
),

const SizedBox(height: 16),

// Password Text Field
CustomTextField(
label: 'Password',
hintText: 'Enter password',
prefixIcon: Icons.lock_outline_rounded,
controller: passwordController,
isPassword: true,
errortext: passwordError,
onChanged: (value) => validateInputs(),
),

const SizedBox(height: 16),

// Confirm Password Text Field
CustomTextField(
label: 'Confirm Password',
hintText: 'Confirm password',
prefixIcon: Icons.lock_outline_rounded,
controller: confirmPasswordController,
isPassword: true,
errortext: confirmPasswordError,
onChanged: (value) => validateInputs(),
),

const SizedBox(height: 24),

// Sign Up Button
CustomButton(
text: 'Sign Up',
onPressed: signUp,
isLoading: isLoading,
// isDisabled: !isValid,
),

const SizedBox(height: 24),

// OR Divider
Row(
children: [
Expanded(
child: Divider(
color: isDark ? Colors.white38 : Colors.grey[400],
),
),
Padding(
padding: const EdgeInsets.symmetric(horizontal: 16),
child: Text(
'OR',
style: TextStyle(
color: isDark ? Colors.white70 : Colors.grey[600],
),
),
),
Expanded(
child: Divider(
color: isDark ? Colors.white38 : Colors.grey[400],
),
),
],
),

const SizedBox(height: 24),

// Social Sign Up Buttons
Row(
children: [
Expanded(
child: SocialButton(
icon: 'assets/images/google.jpg',
label: 'Google',
onPressed:signInWithGoogle,
),
),
const SizedBox(width: 15),
Expanded(
child: SocialButton(
icon: 'assets/images/fb.jpg',
label: 'Facebook',
onPressed:signInWithGoogle,
),
),
],
),

const SizedBox(height: 24),

// Sign In Redirect
Row(
mainAxisAlignment: MainAxisAlignment.center,
children: [
Text(
"Already have an account?",
style: TextStyle(
color: isDark ? Colors.white : AppColors.textDark,
),
),
TextButton(
onPressed: () {
Navigator.push(
context,
MaterialPageRoute(
builder: (context) => const SignInScreen(),
),
);
},
child: Text(
'Sign In',
style: TextStyle(
color: isDark ? Colors.white : AppColors.primary,
fontWeight: FontWeight.bold,
),
),
),
],
),
],
),
),
),
);
}
}