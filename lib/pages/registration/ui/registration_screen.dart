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

  @override
  Widget build(BuildContext context) {
    return BlocProvider<RegistrationBloc>(
      create: (context) => RegistrationBloc(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Register')),
        body: BlocConsumer<RegistrationBloc, RegistrationState>(
          listener: (context, state) {
            if (state is RegistrationSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
              Navigator.pushReplacementNamed(context, '/sign-in');
            } else if (state is RegistrationFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error)),
              );
            }
          },
          builder: (context, state) {
            if (state is RegistrationLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            bool isInputValid = state is RegistrationInputChangedState
                ? state.isInputValid
                : false;

            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    NameField(
                      nameTextEditingController: _nameController,
                      focusNode: _nameFocusNode,
                      registrationBloc: context.read<RegistrationBloc>(),
                    ),
                    const SizedBox(height: 20),
                    EmailField(
                      emailTextEditingController: _emailController,
                      focusNode: _emailFocusNode,
                      registrationBloc: context.read<RegistrationBloc>(),
                    ),
                    const SizedBox(height: 20),
                    PasswordField(
                      passwordTextEditingController: _passwordController,
                      focusNode: _passwordFocusNode,
                      registrationBloc: context.read<RegistrationBloc>(),
                      labelText: 'Password',
                    ),
                    const SizedBox(height: 20),
                    PasswordField(
                      passwordTextEditingController: _confirmPasswordController,
                      focusNode: _confirmPasswordFocusNode,
                      registrationBloc: context.read<RegistrationBloc>(),
                      labelText: 'Confirm Password',
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: isInputValid
                            ? () {
                                context
                                    .read<RegistrationBloc>()
                                    .add(const RegistrationSubmitted());
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
                          'Register',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontFamily: "Sora",
                          ),
                        ),
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
    return TextField(
      style: const TextStyle(fontFamily: "Sora", fontWeight: FontWeight.w600),
      focusNode: _focusNode,
      controller: _nameTextEditingController,
      decoration: const InputDecoration(
        labelText: 'Name',
        labelStyle: TextStyle(fontFamily: "Sora", fontWeight: FontWeight.w300),
        border: OutlineInputBorder(),
        floatingLabelStyle: TextStyle(fontFamily: "Sora"),
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
  })  : _passwordTextEditingController = passwordTextEditingController,
        _focusNode = focusNode,
        _registrationBloc = registrationBloc;

  final TextEditingController _passwordTextEditingController;
  final FocusNode _focusNode;
  final RegistrationBloc _registrationBloc;
  final String labelText;

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: const TextStyle(fontFamily: "Sora", fontWeight: FontWeight.w600),
      focusNode: _focusNode,
      controller: _passwordTextEditingController,
      obscureText: true,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle:
            const TextStyle(fontFamily: "Sora", fontWeight: FontWeight.w300),
        border: const OutlineInputBorder(),
        floatingLabelStyle: const TextStyle(fontFamily: "Sora"),
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
