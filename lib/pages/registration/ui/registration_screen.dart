import 'package:budgetpro/components/app_theme_button.dart';
import 'package:budgetpro/pages/registration/bloc/registration_bloc.dart';
import 'package:budgetpro/pages/registration/bloc/registration_event.dart';
import 'package:budgetpro/pages/registration/bloc/registration_state.dart';
import 'package:budgetpro/utits/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final _nameFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _confirmPasswordFocusNode = FocusNode();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<RegistrationBloc>(
      create: (context) => RegistrationBloc(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.black87),
        ),
        body: BlocConsumer<RegistrationBloc, RegistrationState>(
          listener: (context, state) {
            if (state is RegistrationSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.green,
                  behavior: SnackBarBehavior.floating,
                ),
              );
              Navigator.pushReplacementNamed(context, '/sign-in');
            } else if (state is RegistrationFailure) {
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
            if (state is RegistrationLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  color: AppColors.accentColor,
                ),
              );
            }

            bool isInputValid = state is RegistrationInputChangedState
                ? state.isInputValid
                : false;

            return SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 24),
                      const Text(
                        "Get Started",
                        style: TextStyle(
                          fontFamily: "Sora",
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Create an account to continue",
                        style: TextStyle(
                          fontFamily: "Sora",
                          fontSize: 16,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 30),
                      NameField(
                        nameTextEditingController: _nameController,
                        focusNode: _nameFocusNode,
                        registrationBloc: context.read<RegistrationBloc>(),
                      ),
                      const SizedBox(height: 16),
                      EmailField(
                        emailTextEditingController: _emailController,
                        focusNode: _emailFocusNode,
                        registrationBloc: context.read<RegistrationBloc>(),
                      ),
                      const SizedBox(height: 16),
                      PasswordField(
                        passwordTextEditingController: _passwordController,
                        focusNode: _passwordFocusNode,
                        registrationBloc: context.read<RegistrationBloc>(),
                        labelText: 'Password',
                        obscurePassword: _obscurePassword,
                        toggleObscurePassword: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      PasswordField(
                        passwordTextEditingController:
                            _confirmPasswordController,
                        focusNode: _confirmPasswordFocusNode,
                        registrationBloc: context.read<RegistrationBloc>(),
                        labelText: 'Confirm Password',
                        obscurePassword: _obscureConfirmPassword,
                        toggleObscurePassword: () {
                          setState(() {
                            _obscureConfirmPassword = !_obscureConfirmPassword;
                          });
                        },
                      ),
                      const SizedBox(height: 30),
                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: AppThemeButton(
                            onPressed: isInputValid
                                ? () {
                                    context
                                        .read<RegistrationBloc>()
                                        .add(const RegistrationSubmitted());
                                  }
                                : null,
                            text: 'Create Account'),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Already have an account?",
                            style: TextStyle(
                              fontFamily: "Sora",
                              color: Colors.black54,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text(
                              'Sign In',
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

class NameField extends StatelessWidget {
  const NameField({
    super.key,
    required TextEditingController nameTextEditingController,
    required FocusNode focusNode,
    required RegistrationBloc registrationBloc,
  })  : _nameTextEditingController = nameTextEditingController,
        _focusNode = focusNode,
        _registrationBloc = registrationBloc;

  final TextEditingController _nameTextEditingController;
  final FocusNode _focusNode;
  final RegistrationBloc _registrationBloc;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: const TextStyle(
        fontFamily: "Sora",
        fontWeight: FontWeight.w500,
      ),
      textCapitalization: TextCapitalization.words,
      focusNode: _focusNode,
      controller: _nameTextEditingController,
      decoration: InputDecoration(
        labelText: 'Full Name',
        hintText: 'Enter your full name',
        prefixIcon: const Icon(Icons.person_outline, color: Colors.black54),
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
        _registrationBloc.add(RegistrationNameChanged(name: value));
      },
    );
  }
}

class EmailField extends StatelessWidget {
  const EmailField({
    super.key,
    required TextEditingController emailTextEditingController,
    required FocusNode focusNode,
    required RegistrationBloc registrationBloc,
  })  : _emailTextEditingController = emailTextEditingController,
        _focusNode = focusNode,
        _registrationBloc = registrationBloc;

  final TextEditingController _emailTextEditingController;
  final FocusNode _focusNode;
  final RegistrationBloc _registrationBloc;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: const TextStyle(
        fontFamily: "Sora",
        fontWeight: FontWeight.w500,
      ),
      autocorrect: false,
      focusNode: _focusNode,
      controller: _emailTextEditingController,
      keyboardType: TextInputType.emailAddress,
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
          borderSide: const BorderSide(color: AppColors.primaryColor, width: 2),
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
        _registrationBloc.add(RegistrationEmailChanged(email: value));
      },
    );
  }
}

class PasswordField extends StatelessWidget {
  const PasswordField({
    super.key,
    required TextEditingController passwordTextEditingController,
    required FocusNode focusNode,
    required RegistrationBloc registrationBloc,
    required this.labelText,
    required this.obscurePassword,
    required this.toggleObscurePassword,
  })  : _passwordTextEditingController = passwordTextEditingController,
        _focusNode = focusNode,
        _registrationBloc = registrationBloc;

  final TextEditingController _passwordTextEditingController;
  final FocusNode _focusNode;
  final RegistrationBloc _registrationBloc;
  final String labelText;
  final bool obscurePassword;
  final VoidCallback toggleObscurePassword;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: const TextStyle(
        fontFamily: "Sora",
        fontWeight: FontWeight.w500,
      ),
      focusNode: _focusNode,
      controller: _passwordTextEditingController,
      obscureText: obscurePassword,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: labelText == 'Password'
            ? 'Create a password'
            : 'Re-enter your password',
        prefixIcon: const Icon(Icons.lock_outline, color: Colors.black54),
        suffixIcon: IconButton(
          icon: Icon(
            obscurePassword ? Icons.visibility_off : Icons.visibility,
            color: Colors.black54,
          ),
          onPressed: toggleObscurePassword,
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
        floatingLabelStyle: const TextStyle(
          fontFamily: "Sora",
          fontWeight: FontWeight.w500,
          color: AppColors.primaryColor,
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      ),
      onChanged: (value) {
        if (labelText == 'Password') {
          _registrationBloc.add(RegistrationPasswordChanged(password: value));
        } else {
          _registrationBloc
              .add(RegistrationConfirmPasswordChanged(confirmPassword: value));
        }
      },
    );
  }
}
