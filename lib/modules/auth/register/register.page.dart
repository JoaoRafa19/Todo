import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'register.controller.dart';

class RegisterPage extends GetView<RegisterController> {
  RegisterPage({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(title: const Text('RegisterPage')),
        body: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, bottom: 40),
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(top: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 40),
                  child: Image.asset(
                    'assets/images/account.png',
                    isAntiAlias: true,
                    width: 100,
                    alignment: Alignment.center,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 20),
                Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                          controller: controller.emailController,
                          obscureText: false,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter email';
                            }

                            if (!value.contains('@') || !value.contains('.')) {
                              return 'Please enter valid email';
                            }

                            return null;
                          },
                          decoration: const InputDecoration(
                              labelText: 'Email',
                              hoverColor: Colors.white,
                              focusColor: Colors.white,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              )),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: controller.passwordController,
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter password';
                            }
                            if (value.contains(' ')) {
                              return 'Password should not contain spaces';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                              labelText: 'Senha',
                              hoverColor: Colors.white,
                              focusColor: Colors.white,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              )),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: controller.confirmPasswordController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter password';
                            }
                            if (value.contains(' ')) {
                              return 'Password should not contain spaces';
                            }
                            if (value != controller.passwordController.text) {
                              return 'Password does not match';
                            }
                            return null;
                          },
                          obscureText: true,
                          decoration: const InputDecoration(
                              labelText: 'Confirme a senha',
                              hoverColor: Colors.white,
                              focusColor: Colors.white,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              )),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: controller.emailController,
                          obscureText: false,
                          decoration: const InputDecoration(
                              labelText: 'Nome',
                              hoverColor: Colors.white,
                              focusColor: Colors.white,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              )),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          padding: EdgeInsets.only(
                              left: Get.width * 0.1, right: Get.width * 0.1),
                          child: GestureDetector(
                            onTap: () {
                              if (_formKey.currentState!.validate()) {
                                controller.register();
                              }
                            },
                            child: Container(
                              height: 50,
                              width: double.infinity,
                              decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              child: const Center(
                                child: Text(
                                  'Cadastrar',
                                  style: TextStyle(color: Colors.black87),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ))
              ],
            ),
          ),
        ));
  }
}
