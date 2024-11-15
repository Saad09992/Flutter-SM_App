// ignore_for_file: use_build_context_synchronously, avoid_types_as_parameter_names, non_constant_identifier_names

import 'package:sm_app/components/drawer.dart';
import 'package:sm_app/components/round_button.dart';
import 'package:sm_app/controller/auth_controller.dart';
import 'package:sm_app/utils/routes/routes_name.dart';
import 'package:sm_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
        title: const Text("Login Page"),
      ),
      drawer: const CustomDrawer(),
      body: Center(
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 10,
              ),
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
              const SizedBox(
                height: 10,
              ),
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
              const SizedBox(
                height: 30,
              ),
              RoundButton(
                title: "Signup",
                loading: authController.isLoading,
                onPress: () {
                  if (emailController.text.isEmpty) {
                    Utils.errorMessage("Please enter your email", context);
                  } else if (passwordController.text.isEmpty) {
                    Utils.errorMessage("Please enter your password", context);
                  } else if (passwordController.text.length < 6) {
                    Utils.errorMessage(
                        "Password must contain 6 letter at least", context);
                  } else {
                    Map data = {
                      'email': emailController.text,
                      'password': passwordController.text
                    };
                    authController.loginApi(data, context).then((value) {
                      // Navigate only if loginApi completes successfully
                      Future.delayed(const Duration(seconds: 3), () {
                        Navigator.pushReplacementNamed(
                            context, RoutesName.home);
                      });
                    }).catchError((error) {
                      // Handle the error here, e.g., by showing a dialog or toast
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text('Login failed: ${error.toString()}')),
                      );
                    });
                  }
                },
              ),
              const SizedBox(
                height: 30,
              ),
              InkWell(
                onTap: () {
                  Navigator.pushReplacementNamed(context, RoutesName.signup);
                },
                child: const Text("Don't have an account? Click here"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
