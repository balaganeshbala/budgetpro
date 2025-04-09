import 'package:budgetpro/pages/sign_in/bloc/sign_in_bloc.dart';
import 'package:budgetpro/pages/sign_in/bloc/sign_in_event.dart';
import 'package:budgetpro/pages/sign_in/bloc/sign_in_state.dart';
import 'package:budgetpro/utits/colors.dart';
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

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SignInBloc>(
      create: (context) => SignInBloc(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Sign In')),
        body: BlocConsumer<SignInBloc, SignInState>(
          listener: (context, state) {
            if (state is SignInSuccess) {
              Navigator.pushReplacementNamed(context, '/home');
            } else if (state is SignInFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error)),
              );
            }
          },
          builder: (context, state) {
            if (state is SignInLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            bool isInputValid =
                state is SignInInputChangedState ? state.isInputValid : false;

            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
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
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: isInputValid
                            ? () {
                                context
                                    .read<SignInBloc>()
                                    .add(SignInSubmitted());
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isInputValid
                              ? AppColors.accentColor
                              : Colors.grey,
                          padding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 20),
                        ),
                        child: const Text(
                          'Sign In',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontFamily: "Sora",
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextButton(
                      style: const ButtonStyle(
                          backgroundColor:
                              WidgetStatePropertyAll<Color>(Colors.white)),
                      onPressed: () {
                        Navigator.pushNamed(context, '/register');
                      },
                      child: const Text(
                        'Create a new account',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.accentColor,
                            fontFamily: "Sora"),
                      ),
                    ),
                  ],
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
    return TextField(
      style: const TextStyle(fontFamily: "Sora", fontWeight: FontWeight.w600),
      focusNode: _focusNode,
      controller: _emailTextEditingController,
      keyboardType: TextInputType.emailAddress,
      decoration: const InputDecoration(
        labelText: 'Email',
        labelStyle: TextStyle(fontFamily: "Sora", fontWeight: FontWeight.w300),
        border: OutlineInputBorder(),
        floatingLabelStyle: TextStyle(fontFamily: "Sora"),
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
  })  : _passwordTextEditingController = passwordTextEditingController,
        _focusNode = focusNode,
        _signInBloc = signInBloc;

  final TextEditingController _passwordTextEditingController;
  final FocusNode _focusNode;
  final SignInBloc _signInBloc;

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: const TextStyle(fontFamily: "Sora", fontWeight: FontWeight.w600),
      focusNode: _focusNode,
      controller: _passwordTextEditingController,
      obscureText: true,
      decoration: const InputDecoration(
        labelText: 'Password',
        labelStyle: TextStyle(fontFamily: "Sora", fontWeight: FontWeight.w300),
        border: OutlineInputBorder(),
        floatingLabelStyle: TextStyle(fontFamily: "Sora"),
      ),
      onChanged: (value) {
        _signInBloc.add(SignInPasswordChanged(password: value));
      },
    );
  }
}
