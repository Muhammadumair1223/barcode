import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/auth_controller.dart';
import '../utils/dimensions.dart';
import '../utils/gradient_color_helper.dart';
import '../utils/styles.dart';
import '../widgets/custom_button_widget.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<AuthController>(context);

    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top),
        decoration: BoxDecoration(
          gradient: GradientColorHelper.gradientColor(),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Text(
                    "DailyStop",
                    style: fontSizeBlack.copyWith(
                      fontSize: Dimensions.fontSizeOverOverLarge,
                    ),
                  ),
                  const SizedBox(height: 50),
                  Form(
                    key: controller.formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          onChanged: (value) {},
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Enter Username";
                            } else {
                              return null;
                            }
                          },
                          keyboardType: TextInputType.text,
                          controller: controller.userNameController,
                          decoration: const InputDecoration(
                            hintText: 'Enter UserName',
                            suffixIcon: Icon(
                              Icons.people_outlined,
                              color: Colors.deepPurple,
                            ),
                            prefixIcon: Icon(
                              Icons.person,
                              color: Colors.deepPurple,
                            ),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 20, horizontal: 20),
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.deepPurple, width: 1),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.deepPurple, width: 2),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          onChanged: (value) {},
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Enter Password";
                            } else {
                              return null;
                            }
                          },
                          keyboardType: TextInputType.text,
                          obscureText: true,
                          controller: controller.passwordController,
                          decoration: const InputDecoration(
                            hintText: 'Enter your password',
                            suffixIcon: Icon(
                              Icons.remove_red_eye_sharp,
                              color: Colors.deepPurple,
                            ),
                            prefixIcon: Icon(
                              Icons.lock_open_outlined,
                              color: Colors.deepPurple,
                            ),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 20, horizontal: 20),
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.deepPurple, width: 1),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.deepPurple, width: 2),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        CustomButtonWidget(
                          isLoading: false,
                          buttonText: "Sign In",
                          onPressed: () => controller.login(context),
                        ),
                        const SizedBox(height: 10),
                        if (controller.isLoading)
                          const CircularProgressIndicator()
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
