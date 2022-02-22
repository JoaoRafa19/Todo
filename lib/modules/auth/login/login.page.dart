import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo/app/routes.dart';

import 'login.controller.dart';

class LoginPage extends GetView<LoginController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Form(
                  autovalidateMode: AutovalidateMode.always,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        TextFormField(
                          controller: controller.emailController,
                          cursorColor: Colors.white,
                          style: TextStyle(color: Colors.white),
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
                        GestureDetector(
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            width: 100,
                            height: 50,
                            decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            child: Obx(() => Center(
                                  child: controller.loading.value
                                      ? SizedBox(
                                          width: 20,
                                          child: CircularProgressIndicator(
                                            color:
                                                Theme.of(context).primaryColor,
                                            strokeWidth: 2,
                                          ),
                                        )
                                      : const Text(
                                          'Entrar',
                                          style: TextStyle(
                                              color: Colors.black87,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                )),
                          ),
                          onTap: () {
                            controller.login();
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextButton(
                            onPressed: () => Get.toNamed('/home'),
                            child: Text("registrar")),
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