import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo/app/routes.dart';

import 'login.controller.dart';

class LoginPage extends GetView<LoginController> {
  LoginPage({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.always,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 40),
                          child: Image.asset(
                            'assets/images/to-do-list.png',
                            isAntiAlias: true,
                            width: 100,
                            alignment: Alignment.center,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: controller.emailController,
                          cursorColor: Colors.white,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                              labelText: 'Email',
                              fillColor: Colors.white,
                              focusColor: Colors.white,
                              hoverColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              )),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          controller: controller.passwordController,
                          obscureText: true,
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
                        const SizedBox(
                          height: 20,
                        ),
                        Obx(() => controller.loading.value
                            ? const CircularProgressIndicator()
                            : Column(
                                children: [
                                  GestureDetector(
                                    child: Container(
                                      padding: const EdgeInsets.all(16),
                                      width: 100,
                                      height: 50,
                                      decoration: const BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      child: Obx(() => Center(
                                            child: controller.loading.value
                                                ? SizedBox(
                                                    width: 20,
                                                    child:
                                                        CircularProgressIndicator(
                                                      color: Theme.of(context)
                                                          .primaryColor,
                                                      strokeWidth: 2,
                                                    ),
                                                  )
                                                : const Text(
                                                    'Entrar',
                                                    style: TextStyle(
                                                        color: Colors.black87,
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                          )),
                                    ),
                                    onTap: () {
                                      controller.login();
                                    },
                                  ),
                                  const SizedBox(height: 20),
                                  const Text('or'),
                                  const SizedBox(height: 20),
                                  Container(
                                    padding: EdgeInsets.only(
                                        left: Get.width * 0.1,
                                        right: Get.width * 0.1),
                                    child: Container(
                                      color: Colors.white,
                                      child: GestureDetector(
                                        onTap: () async {
                                          await controller.loginWithGoogle();
                                        },
                                        child: controller.loading.value
                                            ? const CircularProgressIndicator()
                                            : Container(
                                                height: 50,
                                                width: double.infinity,
                                                decoration: const BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(10),
                                                  ),
                                                ),
                                                child: Center(
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(5),
                                                        child: Image.asset(
                                                          'assets/images/google-icon.png',
                                                          isAntiAlias: true,
                                                          width: 20,
                                                          alignment:
                                                              Alignment.center,
                                                        ),
                                                      ),
                                                      const Text(
                                                        'Entre com o google',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black87),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                      ),
                                    ),
                                  ),
                                ],
                              )),
                        const SizedBox(
                          height: 20,
                        ),
                        TextButton(
                            onPressed: () => Get.toNamed(Routes.register),
                            child: const Text(
                              "registrar",
                              style: TextStyle(color: Colors.grey),
                            )),
                      ],
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
