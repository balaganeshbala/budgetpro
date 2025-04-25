import 'package:budgetpro/components/app_theme_button.dart';
import 'package:budgetpro/pages/forgot_password/bloc/forgot_password_bloc.dart';
import 'package:budgetpro/pages/forgot_password/bloc/forgot_password_event.dart';
import 'package:budgetpro/pages/forgot_password/bloc/forgot_password_state.dart';
import 'package:budgetpro/utits/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  final _emailFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ForgotPasswordBloc>(
      create: (context) => ForgotPasswordBloc(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text(
            'Forgot Password',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: "Sora",
              color: Colors.white,
            ),
          ),
          backgroundColor: AppColors.primaryColor,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: BlocConsumer<ForgotPasswordBloc, ForgotPasswordState>(
          listener: (context, state) {
            if (state is ForgotPasswordSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.green,
                  behavior: SnackBarBehavior.floating,
                ),
              );
              // Navigate back to sign in screen after success
              Future.delayed(const Duration(seconds: 2), () {
                Navigator.of(context).pop();
              });
            } else if (state is ForgotPasswordFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.error),
                  backgroundColor: Colors.redAccent,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is ForgotPasswordLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  color: AppColors.accentColor,
                ),
              );
            }

            bool isInputValid = state is ForgotPasswordInputChangedState
                ? state.isInputValid
                : false;

            return SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 24),
                      const Text(
                        "Reset Your Password",
                        style: TextStyle(
                          fontFamily: "Sora",
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryColor,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        "Enter your email and we'll send you a link to reset your password.",
                        style: TextStyle(
                          fontFamily: "Sora",
                          fontSize: 16,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 32),
                      EmailField(
                        emailTextEditingController: _emailController,
                        focusNode: _emailFocusNode,
                        forgotPasswordBloc: context.read<ForgotPasswordBloc>(),
                      ),
                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: AppThemeButton(
                          onPressed: isInputValid
                              ? () {
                                  context
                                      .read<ForgotPasswordBloc>()
                                      .add(const ForgotPasswordSubmitted());
                                }
                              : null,
                          text: 'Send Reset Link',
                        ),
                      ),
                      const SizedBox(height: 24),
                      Center(
                        child: TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text(
                            'Back to Sign In',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: "Sora",
                              color: AppColors.accentColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class EmailField extends StatelessWidget {
  const EmailField({
    Key? key,
    required TextEditingController emailTextEditingController,
    required FocusNode focusNode,
    required ForgotPasswordBloc forgotPasswordBloc,
  })  : _emailTextEditingController = emailTextEditingController,
        _focusNode = focusNode,
        _forgotPasswordBloc = forgotPasswordBloc,
        super(key: key);

  final TextEditingController _emailTextEditingController;
  final FocusNode _focusNode;
  final ForgotPasswordBloc _forgotPasswordBloc;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: const TextStyle(
        fontFamily: "Sora",
        fontWeight: FontWeight.w500,
      ),
      focusNode: _focusNode,
      controller: _emailTextEditingController,
      keyboardType: TextInputType.emailAddress,
      autocorrect: false,
      decoration: InputDecoration(
        labelText: 'Email',
        hintText: 'Enter your email',
        prefixIcon: const Icon(Icons.email_outlined, color: Colors.black54),
        labelStyle: const TextStyle(
          fontFamily: "Sora",
          fontWeight: FontWeight.w400,
          color: Colors.black54,
        ),
        hintStyle: const TextStyle(
          fontFamily: "Sora",
          fontWeight: FontWeight.w300,
          color: Colors.black38,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.primaryColor, width: 2),
        ),
        floatingLabelStyle: const TextStyle(
          fontFamily: "Sora",
          fontWeight: FontWeight.w500,
          color: AppColors.primaryColor,
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      ),
      onChanged: (value) {
        _forgotPasswordBloc.add(ForgotPasswordEmailChanged(email: value));
      },
    );
  }
}
