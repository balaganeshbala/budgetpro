import 'package:budgetpro/components/app_name_brand.dart';
import 'package:budgetpro/components/app_theme_button.dart';
import 'package:budgetpro/pages/sign_in/bloc/sign_in_bloc.dart';
import 'package:budgetpro/pages/sign_in/bloc/sign_in_event.dart';
import 'package:budgetpro/pages/sign_in/bloc/sign_in_state.dart';
import 'package:budgetpro/utits/colors.dart';
import 'package:budgetpro/utits/constants.dart';
import 'package:budgetpro/utits/ui_utils.dart';
import 'package:budgetpro/utits/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SignInBloc>(
      create: (context) => SignInBloc(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: BlocConsumer<SignInBloc, SignInState>(
          listener: (context, state) {
            if (state is SignInSuccess) {
              Navigator.pushReplacementNamed(context, '/home');
            } else if (state is SignInFailure) {
              UIUtils.showSnackbar(context, state.error,
                  type: SnackbarType.error);
            }
          },
          builder: (context, state) {
            if (state is SignInLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  color: AppColors.accentColor,
                ),
              );
            }

            bool isInputValid =
                state is SignInInputChangedState ? state.isInputValid : false;

            return SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 24),
                      AppNameBrand(),
                      const SizedBox(height: 24),
                      const Text(
                        "Sign in to continue",
                        style: TextStyle(
                          fontFamily: "Sora",
                          fontSize: 16,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 30),
                      EmailField(
                        emailTextEditingController: _emailController,
                        focusNode: _emailFocusNode,
                        signInBloc: context.read<SignInBloc>(),
                      ),
                      const SizedBox(height: 20),
                      PasswordField(
                        passwordTextEditingController: _passwordController,
                        focusNode: _passwordFocusNode,
                        signInBloc: context.read<SignInBloc>(),
                        obscurePassword: _obscurePassword,
                        toggleObscurePassword: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            Utils.launchURL(fogotPasswordEndPoint);
                          },
                          child: const Text(
                            'Forgot Password?',
                            style: TextStyle(
                              fontFamily: "Sora",
                              color: AppColors.accentColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: AppThemeButton(
                          onPressed: isInputValid
                              ? () {
                                  context
                                      .read<SignInBloc>()
                                      .add(SignInSubmitted());
                                }
                              : null,
                          text: 'Sign In',
                        ),
                      ),
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Don't have an account?",
                            style: TextStyle(
                              fontFamily: "Sora",
                              color: Colors.black54,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/register');
                            },
                            child: const Text(
                              'Sign Up',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.accentColor,
                                fontFamily: "Sora",
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
          },
        ),
      ),
    );
  }
}

class EmailField extends StatelessWidget {
  const EmailField({
    super.key,
    required TextEditingController emailTextEditingController,
    required FocusNode focusNode,
    required SignInBloc signInBloc,
  })  : _emailTextEditingController = emailTextEditingController,
        _focusNode = focusNode,
        _signInBloc = signInBloc;

  final TextEditingController _emailTextEditingController;
  final FocusNode _focusNode;
  final SignInBloc _signInBloc;

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
        floatingLabelStyle: TextStyle(
          fontFamily: "Sora",
          fontWeight: FontWeight.w500,
          color: AppColors.primaryColor,
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      ),
      onChanged: (value) {
        _signInBloc.add(SignInEmailChanged(email: value));
      },
    );
  }
}

class PasswordField extends StatelessWidget {
  const PasswordField({
    super.key,
    required TextEditingController passwordTextEditingController,
    required FocusNode focusNode,
    required SignInBloc signInBloc,
    required bool obscurePassword,
    required VoidCallback toggleObscurePassword,
  })  : _passwordTextEditingController = passwordTextEditingController,
        _focusNode = focusNode,
        _signInBloc = signInBloc,
        _obscurePassword = obscurePassword,
        _toggleObscurePassword = toggleObscurePassword;

  final TextEditingController _passwordTextEditingController;
  final FocusNode _focusNode;
  final SignInBloc _signInBloc;
  final bool _obscurePassword;
  final VoidCallback _toggleObscurePassword;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: const TextStyle(
        fontFamily: "Sora",
        fontWeight: FontWeight.w500,
      ),
      focusNode: _focusNode,
      controller: _passwordTextEditingController,
      obscureText: _obscurePassword,
      decoration: InputDecoration(
        labelText: 'Password',
        hintText: 'Enter your password',
        prefixIcon: const Icon(Icons.lock_outline, color: Colors.black54),
        suffixIcon: IconButton(
          icon: Icon(
            _obscurePassword ? Icons.visibility_off : Icons.visibility,
            color: Colors.black54,
          ),
          onPressed: _toggleObscurePassword,
        ),
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
        floatingLabelStyle: TextStyle(
          fontFamily: "Sora",
          fontWeight: FontWeight.w500,
          color: AppColors.primaryColor,
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      ),
      onChanged: (value) {
        _signInBloc.add(SignInPasswordChanged(password: value));
      },
    );
  }
}
