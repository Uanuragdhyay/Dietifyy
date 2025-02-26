import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:dietifyy/core/common/utils/validation_utils.dart';
import 'package:dietifyy/core/common/widgets/custom_button.dart';
import 'package:dietifyy/core/config/theme/app_colors.dart';
import 'package:dietifyy/features/auth/views/screens/user_details_screen.dart';
import 'package:dietifyy/features/auth/views/widgets/custom_text_field.dart';
import 'package:dietifyy/features/auth/views/screens/forgot_password_screen.dart';
import 'package:dietifyy/features/auth/views/screens/sign_up_screen.dart';
import 'package:dietifyy/features/auth/views/widgets/social_button.dart';
import 'package:dietifyy/main_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  String? emailError;
  String? passwordError;
  String? authError;

  void validateInputs() {
    setState(() {
      emailError = ValidationUtils.validateEmail(emailController.text);
      passwordError = ValidationUtils.validatePassword(passwordController.text);
      authError = null; // Reset auth error on input change
    });
  }

  bool get isValid => emailError == null && passwordError == null;

  Future<void> signIn() async {
    validateInputs();
    if (!isValid) return;

    setState(() {
      isLoading = true;
    });

    try {
      await _auth.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainScreen()),
      );
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

  // Google Sign-In Method
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
              const SizedBox(height: 50),
              Text(
                'Welcome Back!',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: isDark ? Colors.white : AppColors.textDark,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Sign in to continue',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: isDark ? Colors.white70 : AppColors.textLight,
                ),
              ),
              const SizedBox(height: 40),

              if (authError != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(
                    authError!,
                    style: const TextStyle(color: Colors.red, fontSize: 14),
                  ),
                ),

              // Email TextField
              CustomTextField(
                label: 'Email',
                hintText: 'Enter your email',
                prefixIcon: Icons.email_outlined,
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                errortext: emailError,
                onFieldSubmitted: (_) => validateInputs(),
              ),

              const SizedBox(height: 16),

              // Password TextField
              CustomTextField(
                label: 'Password',
                hintText: 'Enter your password',
                prefixIcon: Icons.lock_outlined,
                controller: passwordController,
                isPassword: true,
                errortext: passwordError,
                onFieldSubmitted: (_) => validateInputs(),
              ),

              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ForgotPasswordScreen(),
                      ),
                    );
                  },
                  child: Text(
                    'Forgot Password?',
                    style: TextStyle(
                      color: isDark ? Colors.white : AppColors.primary,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Sign In Button
              CustomButton(
                text: 'Sign In',
                onPressed: signIn,
                isLoading: isLoading,
              ),

              const SizedBox(height: 24),

              // Social Sign-In Buttons
              Row(
                children: [
                  Expanded(
                    child: SocialButton(
                      icon: 'assets/images/google.jpg',
                      label: 'Google',
                      onPressed: signInWithGoogle,
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: SocialButton(
                      icon: 'assets/images/fb.jpg',
                      label: 'Facebook',
                      onPressed: signInWithGoogle, // You can implement Facebook Login here
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Sign Up Redirect
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account?",
                    style: TextStyle(
                      color: isDark ? Colors.white : AppColors.textDark,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignUpScreen(),
                        ),
                      );
                    },
                    child: Text(
                      'Sign Up',
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
