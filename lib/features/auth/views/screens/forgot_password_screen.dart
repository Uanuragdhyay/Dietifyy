import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:dietifyy/core/common/utils/validation_utils.dart';
import 'package:dietifyy/core/common/widgets/custom_button.dart';
import 'package:dietifyy/core/config/theme/app_colors.dart';
import 'package:dietifyy/features/auth/views/widgets/custom_text_field.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController emailController = TextEditingController();
  String? emailError;
  bool isLoading = false;
  String? statusMessage;

  void validateInputs() {
    setState(() {
      emailError = ValidationUtils.validateEmail(emailController.text);
      statusMessage = null; // Reset status message on new input
    });
  }

  bool get isValid => emailError == null;

  Future<void> resetPassword() async {
    validateInputs();
    if (!isValid) return;

    setState(() {
      isLoading = true;
      statusMessage = null;
    });

    try {
      await _auth.sendPasswordResetEmail(email: emailController.text);
      setState(() {
        statusMessage = "Password reset email sent! Check your inbox.";
      });
    } on FirebaseAuthException catch (e) {
      setState(() {
        statusMessage = e.message ?? "Failed to send reset email.";
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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back_ios,
            color: isDark ? Colors.white : AppColors.textDark,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Forgot Password?',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: isDark ? Colors.white : AppColors.textDark,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),

            Text(
              'Enter your email address to reset your password',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: isDark ? Colors.grey[400] : AppColors.textLight,
              ),
            ),

            const SizedBox(height: 32),

            // Email TextField
            CustomTextField(
              label: 'Email',
              hintText: 'Enter your email',
              prefixIcon: Icons.email_outlined,
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              errortext: emailError,
              onChanged: (value) => validateInputs(),
            ),

            const SizedBox(height: 24),

            // Reset Password Button
            CustomButton(
              text: 'Reset Password',
              onPressed: resetPassword,
              isLoading: isLoading,
              isDisabled: !isValid,
            ),

            const SizedBox(height: 16),

            if (statusMessage != null)
              Text(
                statusMessage!,
                style: TextStyle(
                  color: statusMessage!.contains("sent") ? Colors.green : Colors.red,
                  fontSize: 14,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
