// ignore_for_file: body_might_complete_normally_nullable, use_build_context_synchronously, avoid_types_as_parameter_names, non_constant_identifier_names

import 'package:sm_app/components/drawer.dart';
import 'package:sm_app/components/round_button.dart';
import 'package:sm_app/controller/auth_controller.dart';
import 'package:sm_app/utils/routes/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utils/utils.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});
  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  AuthController authController = Get.find();

  TextEditingController emailController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  FocusNode emailFocusNode = FocusNode();
  FocusNode usernameFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();
  ValueNotifier<bool> hidePassword = ValueNotifier<bool>(true);

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    usernameFocusNode.dispose();
    hidePassword.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("SignUp Page"),
      ),
      drawer: const CustomDrawer(),
      body: Center(
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Username',
                  labelText: 'Username',
                  prefixIcon: Icon(Icons.person),
                ),
                focusNode: usernameFocusNode,
                controller: usernameController,
                onFieldSubmitted: (val) {
                  Utils.fieldFocusChange(
                      context, usernameFocusNode, emailFocusNode);
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Email',
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email),
                ),
                focusNode: emailFocusNode,
                keyboardType: TextInputType.emailAddress,
                controller: emailController,
                onFieldSubmitted: (val) {
                  Utils.fieldFocusChange(
                      context, emailFocusNode, passwordFocusNode);
                },
              ),
              const SizedBox(height: 10),
              ValueListenableBuilder(
                  valueListenable: hidePassword,
                  builder: (context, value, child) {
                    return TextFormField(
                      decoration: InputDecoration(
                          hintText: 'Password',
                          labelText: 'Password',
                          prefixIcon: const Icon(Icons.lock_open),
                          suffixIcon: InkWell(
                              onTap: () {
                                hidePassword.value = !hidePassword.value;
                              },
                              child: hidePassword.value
                                  ? const Icon(Icons.visibility_off_outlined)
                                  : const Icon(Icons.visibility))),
                      obscuringCharacter: "*",
                      focusNode: passwordFocusNode,
                      keyboardType: TextInputType.visiblePassword,
                      controller: passwordController,
                      obscureText: hidePassword.value,
                    );
                  }),
              const SizedBox(height: 30),
              RoundButton(
                title: "Signup",
                loading: authController.isLoading,
                onPress: () {
                  if (usernameController.text.isEmpty) {
                    Utils.errorMessage("Please enter your username", context);
                  } else if (emailController.text.isEmpty) {
                    Utils.errorMessage("Please enter your email", context);
                  } else if (passwordController.text.isEmpty) {
                    Utils.errorMessage("Please enter your password", context);
                  } else if (passwordController.text.length < 6) {
                    Utils.errorMessage(
                        "Password must contain 6 letter at least", context);
                  } else {
                    Map data = {
                      'username': usernameController.text,
                      'email': emailController.text,
                      'password': passwordController.text
                    };
                    authController.signUpApi(data, context).then((value) {
                      Future.delayed(const Duration(seconds: 3), () {
                        Navigator.pushReplacementNamed(
                            context, RoutesName.login);
                      });
                    });
                  }
                },
              ),
              const SizedBox(height: 30),
              InkWell(
                onTap: () {
                  Navigator.pushReplacementNamed(context, RoutesName.login)
                      .then((value) {
                    Utils.successMessage(value.toString(), context);
                  }).onError((error, StackTrace) {
                    Utils.errorMessage(error.toString(), context);
                  });
                },
                child: const Text("Already have an account? Click here"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
