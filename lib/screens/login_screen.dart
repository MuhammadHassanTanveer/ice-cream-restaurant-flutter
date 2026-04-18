import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_flutter_app/common/widgets/custom_asset_image_widget.dart';
import 'package:restaurant_flutter_app/common/widgets/custom_button_widget.dart';
import 'package:restaurant_flutter_app/common/widgets/custom_text_field_widget.dart';
import 'package:restaurant_flutter_app/providers/auth_provider.dart';
import 'package:restaurant_flutter_app/util/styles.dart';

import '../common/widgets/validate_check.dart';
import '../util/dimensions.dart';

class LoginScreen extends StatefulWidget {

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraLarge),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: constraints.maxHeight * 0.1),
                  CustomAssetImageWidget("assets/images/logo.png",
                    height: 100,
                  ),
                  SizedBox(height: constraints.maxHeight * 0.1),
                  Text(
                    "Sign In",
                    style: robotoBold(context).copyWith(fontSize: Dimensions.fontSizeExtraLarge(context),),
                  ),
                  SizedBox(height: constraints.maxHeight * 0.05),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        CustomTextFieldWidget(
                          controller: emailController,
                          labelText: 'Email',
                          hintText: 'Enter your email',
                          inputType: TextInputType.emailAddress,
                          prefixIcon: CupertinoIcons.mail_solid,
                          required: true,
                          validator: (value) => ValidateCheck.validateEmptyText(value, "Customer name field is required"),
                        ),
                        const SizedBox(height: Dimensions.paddingSizeDefault,),
                        CustomTextFieldWidget(
                          labelText: 'Password',
                          controller: passwordController,
                          required: true,
                          prefixIcon: Icons.lock,
                          hintText: 'Enter your password',
                          inputType: TextInputType.visiblePassword,
                          capitalization: TextCapitalization.none,
                          isPassword: true,
                          isRequired: true,
                          validator: (value) =>
                              ValidateCheck.validatePassword(
                                  value, 'Enter your password'),
                        ),
                        const SizedBox(
                          height: Dimensions.paddingSizeExtraOverLarge,
                        ),
                        CustomButtonWidget(
                          buttonText: "Sign in",
                            isLoading: context.watch<AuthProvider>().isLoading,
                          onPressed: ()async{
                            if (_formKey.currentState!.validate()) {
                              try {
                                context.read<AuthProvider>().loadingApi(true);
                                await context.read<AuthProvider>().loginUser(
                                    context,
                                    emailController.text,
                                    passwordController.text
                                );
                              } catch (e) {
                                debugPrint('Login error: $e');
                                // Show error to user
                              } finally {
                                if (mounted) {
                                  context.read<AuthProvider>().loadingApi(false);
                                }
                              }
                            }
                          },
                        ),

                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
