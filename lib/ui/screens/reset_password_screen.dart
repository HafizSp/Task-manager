import 'package:flutter/material.dart';
import 'package:task_manager/data/network/network_caller.dart';
import 'package:task_manager/data/network/network_response.dart';
import 'package:task_manager/data/utility/urls.dart';
import 'package:task_manager/ui/widgets/body_background.dart';
import 'package:task_manager/ui/widgets/snack_message.dart';

import 'login_screen.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen(
      {super.key, required this.email, required this.pin});

  final String email;
  final String pin;

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController _newPasswordTEController =
      TextEditingController();
  final TextEditingController _confirmPasswordTEController =
      TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool resetPasswordInProgress = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          BodyBackground(
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 80),
                        Text(
                          'Reset Password',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Minimum password length should be 8 letters',
                          style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 24),
                        TextFormField(
                          controller: _newPasswordTEController,
                          obscureText: true,
                          decoration: const InputDecoration(
                            hintText: 'New Password',
                          ),
                          validator: (String? value) {
                            if (value?.isEmpty ?? true) {
                              return "Enter a valid password";
                            }
                            if (value!.length < 6) {
                              return "Password length must be more than 6 character";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _confirmPasswordTEController,
                          obscureText: true,
                          decoration: const InputDecoration(
                            hintText: 'Confirm Password',
                          ),
                          validator: (String? value) {
                            if (value?.isEmpty ?? true) {
                              return "Enter a valid password";
                            }
                            if (value!.length < 6) {
                              return "Password length must be more than 6 character";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: Visibility(
                            visible: resetPasswordInProgress == false,
                            replacement: const Center(
                              child: CircularProgressIndicator(),
                            ),
                            child: Visibility(
                              visible: resetPasswordInProgress == false,
                              replacement: const Center(
                                child: CircularProgressIndicator(),
                              ),
                              child: ElevatedButton(
                                onPressed: resetPassword,
                                child: const Text('Confirm'),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 48),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Have an account?",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w600),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const LoginScreen(),
                                  ),
                                );
                              },
                              child: const Text(
                                'Sign In',
                                style: TextStyle(fontSize: 16),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> resetPassword() async {
    if (_formKey.currentState!.validate() &&
        _newPasswordTEController.text == _confirmPasswordTEController.text) {
      resetPasswordInProgress = true;
      if (mounted) {
        setState(() {});
      }
      Map<String, dynamic> item = {
        "email": widget.email,
        "OTP": widget.pin,
        "password": _confirmPasswordTEController.text,
      };

      final NetworkResponse response =
          await NetworkCaller().postRequest(Urls.resetPassword, body: item);

      resetPasswordInProgress = false;
      if (mounted) {
        setState(() {});
      }

      if (response.isSuccess && response.jsonResponse["status"] == "success") {
        if (mounted) {
          showSnackMessage(context, "Successfully password reset!");

          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const LoginScreen(),
              ),
              (route) => false);
        }
      } else {
        if (response.statusCode == 401) {
          if (mounted) {
            showSnackMessage(context, "Please check password");
          }
        } else {
          if (mounted) {
            showSnackMessage(context, "Password reset failed");
          }
        }
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _newPasswordTEController.dispose();
    _confirmPasswordTEController.dispose();
  }
}
