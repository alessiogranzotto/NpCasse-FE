import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:flutter_svg/svg.dart';
import 'package:np_casse/app/constants/assets.dart';
import 'package:np_casse/app/constants/keys.dart';
import 'package:np_casse/componenents/custom.text.form.field.dart';
import 'package:np_casse/core/notifiers/authentication.notifier.dart';
import 'package:np_casse/helpers/snackbar.helper.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final ValueNotifier<bool> passwordNotifier = ValueNotifier(true);
  final ValueNotifier<bool> fieldValidNotifier = ValueNotifier(false);

  late final TextEditingController emailController;
  late final TextEditingController passwordController;
  // late final String email, password;
  String otpCode = "";

  void initializeControllers() {
    emailController = TextEditingController()..addListener(controllerListener);
    passwordController = TextEditingController()
      ..addListener(controllerListener);
  }

  void disposeControllers() {
    emailController.dispose();
    passwordController.dispose();
  }

  void controllerListener() {
    final email = emailController.text;
    final password = passwordController.text;

    if (email.isEmpty && password.isEmpty) return;

    if (AppRegex.emailRegex.hasMatch(email) &&
        AppRegex.passwordRegex.hasMatch(password)) {
      fieldValidNotifier.value = true;
    } else {
      fieldValidNotifier.value = false;
    }
  }

  @override
  void initState() {
    initializeControllers();
    super.initState();
  }

  @override
  void dispose() {
    disposeControllers();
    super.dispose();
  }

  authenticateAccount() {
    if (_formKey.currentState!.validate()) {
      var authNotifier =
          Provider.of<AuthenticationNotifier>(context, listen: false);
      authNotifier.authenticateAccount(
          context: context,
          email: emailController.text,
          password: passwordController.text,
          appName: AppKeys.appName);
    }
  }

  checkOtp() {
    var authNotifier =
        Provider.of<AuthenticationNotifier>(context, listen: false);
    authNotifier
        .checkOtp(
            context: context, email: emailController.text, otpCode: otpCode)
        .then((value) {
      if (value) {
        initAccount();
      } else {}
    });
  }

  initAccount() {
    var authNotifier =
        Provider.of<AuthenticationNotifier>(context, listen: false);
    authNotifier.initAccount(
        context: context,
        email: emailController.text,
        password: passwordController.text,
        appName: AppKeys.appName);
  }

  @override
  Widget build(BuildContext context) {
    AuthenticationNotifier authenticationNotifier =
        Provider.of<AuthenticationNotifier>(context);
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth <= 510; // Check if width is <= 510
          if (constraints.maxWidth >= 800) {
            return Row(
              children: [
                const Expanded(
                    child: Image(
                        image: AssetImage(AppAssets.home2),
                        fit: BoxFit.cover,
                        height: double.infinity,
                        width: double.infinity,
                        alignment: Alignment.center)),
                Expanded(
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 21),
                    padding: const EdgeInsets.symmetric(horizontal: 50),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Form(
                            key: _formKey,
                            child: Padding(
                              padding: const EdgeInsets.all(30),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  authenticationNotifier.stepLoading == "user"
                                      ? Column(
                                          children: [
                                            CustomTextFormField(
                                              controller: emailController,
                                              labelText: AppStrings.email,
                                              keyboardType:
                                                  TextInputType.emailAddress,
                                              textInputAction:
                                                  TextInputAction.next,
                                              onChanged: (_) => _formKey
                                                  .currentState
                                                  ?.validate(),
                                              validator: (value) {
                                                return value!.isEmpty
                                                    ? AppStrings
                                                        .pleaseEnterEmailAddress
                                                    : AppConstants.emailRegex
                                                            .hasMatch(value)
                                                        ? null
                                                        : AppStrings
                                                            .invalidEmailAddress;
                                              },
                                            ),
                                            ValueListenableBuilder(
                                              valueListenable: passwordNotifier,
                                              builder:
                                                  (_, passwordObscure, __) {
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 20, bottom: 20),
                                                  child: CustomTextFormField(
                                                    obscureText:
                                                        passwordObscure,
                                                    controller:
                                                        passwordController,
                                                    labelText:
                                                        AppStrings.password,
                                                    textInputAction:
                                                        TextInputAction.done,
                                                    keyboardType: TextInputType
                                                        .visiblePassword,
                                                    onChanged: (_) => _formKey
                                                        .currentState
                                                        ?.validate(),
                                                    validator: (value) {
                                                      return value!.isEmpty
                                                          ? AppStrings
                                                              .pleaseEnterPassword
                                                          : AppConstants
                                                                  .passwordRegex
                                                                  .hasMatch(
                                                                      value)
                                                              ? null
                                                              : AppStrings
                                                                  .invalidPassword;
                                                    },
                                                    suffixIcon: IconButton(
                                                      onPressed: () =>
                                                          passwordNotifier
                                                                  .value =
                                                              !passwordObscure,
                                                      style:
                                                          IconButton.styleFrom(
                                                        minimumSize:
                                                            const Size.square(
                                                                48),
                                                      ),
                                                      icon: Icon(
                                                        passwordObscure
                                                            ? Icons
                                                                .visibility_off_outlined
                                                            : Icons
                                                                .visibility_outlined,
                                                        size: 20,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: ElevatedButton(
                                                    onPressed: () {},
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                            side: BorderSide(
                                                      width: 1.0,
                                                      // color: Colors.grey,
                                                    )),
                                                    child: const Text(
                                                      AppStrings.forgotPassword,
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 14),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 20),
                                                Expanded(
                                                  child: ValueListenableBuilder(
                                                    valueListenable:
                                                        fieldValidNotifier,
                                                    builder: (_, isValid, __) {
                                                      return ElevatedButton(
                                                        onPressed: isValid
                                                            ? () {
                                                                authenticateAccount();
                                                                // email =
                                                                //     emailController
                                                                //         .text;
                                                                // emailController
                                                                //     .clear();
                                                                // password =
                                                                //     passwordController
                                                                //         .text;
                                                                // passwordController
                                                                //     .clear();
                                                              }
                                                            : null,
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          side: BorderSide(
                                                            width: 1.0,
                                                            // color: Colors.grey,
                                                          ),
                                                        ),
                                                        child: const Text(
                                                          AppStrings.login,
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 14),
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        )
                                      : Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(30.0),
                                              child: OtpTextField(
                                                showCursor: true,
                                                fieldHeight: 60,
                                                fieldWidth: 60,
                                                textStyle: TextStyle(
                                                    fontSize: 20,
                                                    color: Colors.blueAccent),
                                                keyboardType:
                                                    TextInputType.number,
                                                numberOfFields: 5,
                                                borderColor: Color(0xFF512DA8),
                                                //set to true to show as box or false to show as dash
                                                showFieldAsBox: true,
                                                //runs when a code is typed in
                                                onCodeChanged: (String value) {
                                                  print(value);
                                                  print(otpCode);
                                                },
                                                //runs when every textfield is filled
                                                onSubmit: (String value) {
                                                  otpCode = value.length > 5
                                                      ? value.substring(0, 5)
                                                      : value;
                                                  checkOtp();
                                                }, // end onSubmit
                                              ),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                SizedBox(
                                                  width: 360,
                                                  child: ElevatedButton(
                                                    onPressed: () {
                                                      authenticationNotifier
                                                          .backFromOtp();
                                                    },
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                            side: BorderSide(
                                                      width: 1.0,
                                                      // color: Colors.grey,
                                                    )),
                                                    child: const Text(
                                                      AppStrings.back,
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 14),
                                                    ),
                                                  ),
                                                ),
                                                // const SizedBox(width: 20),
                                                // Expanded(
                                                //   child: ElevatedButton(
                                                //     onPressed: () {
                                                //       checkOtp();
                                                //     },
                                                //     style: ElevatedButton
                                                //         .styleFrom(
                                                //             side: BorderSide(
                                                //       width: 1.0,
                                                //       // color: Colors.grey,
                                                //     )),
                                                //     child: const Text(
                                                //       AppStrings.confirmOtp,
                                                //       style: TextStyle(
                                                //           color: Colors.black,
                                                //           fontSize: 14),
                                                //     ),
                                                //   ),
                                                // ),
                                              ],
                                            ),
                                          ],
                                        ),
                                  authenticationNotifier.isLoading
                                      ? const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: LinearProgressIndicator(
                                            backgroundColor: Colors.transparent,
                                            valueColor: AlwaysStoppedAnimation(
                                                Colors.blue),
                                            minHeight: 5,
                                          ),
                                        )
                                      : const SizedBox(height: 5),
                                  // Row(
                                  //   mainAxisAlignment: MainAxisAlignment.center,
                                  //   children: [
                                  //     Text(
                                  //       AppStrings.doNotHaveAnAccount,
                                  //       style: Theme.of(context)
                                  //           .textTheme
                                  //           .headlineLarge,
                                  //     ),
                                  //     const SizedBox(width: 4),
                                  //     TextButton(
                                  //       onPressed: () => {},
                                  //       child: const Text(AppStrings.register),
                                  //     ),
                                  //   ],
                                  // ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          } else {
            return Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(AppAssets.home2),
                  fit: BoxFit.cover,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      constraints: const BoxConstraints(maxWidth: 21),
                      padding: const EdgeInsets.symmetric(horizontal: 50),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Form(
                              key: _formKey,
                              child: Padding(
                                padding: const EdgeInsets.all(30),
                                child: authenticationNotifier.stepLoading ==
                                        "user"
                                    ? Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          CustomTextFormField(
                                            controller: emailController,
                                            labelText: AppStrings.email,
                                            keyboardType:
                                                TextInputType.emailAddress,
                                            textInputAction:
                                                TextInputAction.next,
                                            onChanged: (_) => _formKey
                                                .currentState
                                                ?.validate(),
                                            validator: (value) {
                                              return value!.isEmpty
                                                  ? "AppStrings.pleaseEnterEmailAddress"
                                                  : AppConstants.emailRegex
                                                          .hasMatch(value)
                                                      ? null
                                                      : "AppStrings.invalidEmailAddress";
                                            },
                                          ),
                                          ValueListenableBuilder(
                                            valueListenable: passwordNotifier,
                                            builder: (_, passwordObscure, __) {
                                              return Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 20, bottom: 20),
                                                child: CustomTextFormField(
                                                  obscureText: passwordObscure,
                                                  controller:
                                                      passwordController,
                                                  labelText:
                                                      AppStrings.password,
                                                  textInputAction:
                                                      TextInputAction.done,
                                                  keyboardType: TextInputType
                                                      .visiblePassword,
                                                  onChanged: (_) => _formKey
                                                      .currentState
                                                      ?.validate(),
                                                  validator: (value) {
                                                    return value!.isEmpty
                                                        ? AppStrings
                                                            .pleaseEnterPassword
                                                        : AppConstants
                                                                .passwordRegex
                                                                .hasMatch(value)
                                                            ? null
                                                            : AppStrings
                                                                .invalidPassword;
                                                  },
                                                  suffixIcon: IconButton(
                                                    onPressed: () =>
                                                        passwordNotifier.value =
                                                            !passwordObscure,
                                                    style: IconButton.styleFrom(
                                                      minimumSize:
                                                          const Size.square(48),
                                                    ),
                                                    icon: Icon(
                                                      passwordObscure
                                                          ? Icons
                                                              .visibility_off_outlined
                                                          : Icons
                                                              .visibility_outlined,
                                                      size: 20,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                          authenticationNotifier.isLoading
                                              ? const Padding(
                                                  padding: EdgeInsets.all(8.0),
                                                  child:
                                                      LinearProgressIndicator(
                                                    backgroundColor:
                                                        Colors.transparent,
                                                    valueColor:
                                                        AlwaysStoppedAnimation(
                                                            Colors.blue),
                                                    minHeight: 5,
                                                  ),
                                                )
                                              : const SizedBox(height: 5),
                                       isMobile
                                        ? Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              // Login button (appears first on mobile)
                                              Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 30), // Add horizontal margin
                                                child: ValueListenableBuilder(
                                                  valueListenable: fieldValidNotifier,
                                                  builder: (_, isValid, __) {
                                                    return SizedBox(
                                                      width: 250, // Set the same width for both buttons
                                                      child: ElevatedButton(
                                                        onPressed: isValid
                                                            ? () {
                                                                authenticateAccount();
                                                              }
                                                            : null,
                                                        style: ElevatedButton.styleFrom(
                                                          side: BorderSide(width: 1.0),
                                                        ),
                                                        child: const Text(
                                                          AppStrings.login,
                                                          style: TextStyle(color: Colors.black, fontSize: 14),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                              const SizedBox(height: 10), // Space between buttons
                                              // Forgot Password button (appears second on mobile)
                                              Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 30), // Add horizontal margin
                                                child: SizedBox(
                                                  width: 250, // Set the same width for both buttons
                                                  child: ElevatedButton(
                                                    onPressed: () {},
                                                    style: ElevatedButton.styleFrom(
                                                      side: BorderSide(width: 1.0),
                                                    ),
                                                    child: const Text(
                                                      AppStrings.forgotPassword,
                                                      style: TextStyle(color: Colors.black, fontSize: 14),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )
                                          : Row(
                                            children: [
                                              Expanded(
                                                child: ElevatedButton(
                                                  onPressed: () {},
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                          side: BorderSide(
                                                    width: 1.0,
                                                    // color: Colors.grey,
                                                  )),
                                                  child: const Text(
                                                    AppStrings.forgotPassword,
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 14),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 20),
                                              Expanded(
                                                child: ValueListenableBuilder(
                                                  valueListenable:
                                                      fieldValidNotifier,
                                                  builder: (_, isValid, __) {
                                                    return ElevatedButton(
                                                      onPressed: isValid
                                                          ? () {
                                                              authenticateAccount();
                                                              // email =
                                                              //     emailController
                                                              //         .text;
                                                              // emailController
                                                              //     .clear();
                                                              // password =
                                                              //     passwordController
                                                              //         .text;
                                                              // passwordController
                                                              //     .clear();
                                                            }
                                                          : null,
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        side: BorderSide(
                                                          width: 1.0,
                                                          // color: Colors.grey,
                                                        ),
                                                      ),
                                                      child: const Text(
                                                        AppStrings.login,
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 14),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 20),
                                          // Row(
                                          //   children: [
                                          //     Expanded(
                                          //         child: Divider(
                                          //             color: Colors.grey.shade200)),
                                          //     Padding(
                                          //       padding: const EdgeInsets.symmetric(
                                          //           horizontal: 20),
                                          //       child: Text(AppStrings.orLoginWith,
                                          //           style: Theme.of(context)
                                          //               .textTheme
                                          //               .headlineSmall
                                          //               ?.copyWith(
                                          //                   color: Colors.blueGrey)),
                                          //     ),
                                          //     Expanded(
                                          //         child: Divider(
                                          //             color: Colors.grey.shade200)),
                                          //   ],
                                          // ),
                                          // const SizedBox(height: 20),
                                          // Row(
                                          //   children: [
                                          //     Expanded(
                                          //       child: OutlinedButton.icon(
                                          //         onPressed: () {},
                                          //         icon: SvgPicture.asset(
                                          //             Vectors.google,
                                          //             width: 14),
                                          //         label: const Text(
                                          //           AppStrings.google,
                                          //           style: TextStyle(
                                          //               color: Colors.black),
                                          //         ),
                                          //       ),
                                          //     ),
                                          //     const SizedBox(width: 20),
                                          //     Expanded(
                                          //       child: OutlinedButton.icon(
                                          //         onPressed: () {},
                                          //         icon: SvgPicture.asset(
                                          //             Vectors.facebook,
                                          //             width: 14),
                                          //         label: const Text(
                                          //           AppStrings.facebook,
                                          //           style: TextStyle(
                                          //               color: Colors.black),
                                          //         ),
                                          //       ),
                                          //     ),
                                          //   ],
                                          // ),
                                        ],
                                      )
                                    : Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(30.0),
                                            child: OtpTextField(
                                              showCursor: true,
                                              fieldHeight: 60,
                                              fieldWidth: 60,
                                              textStyle: TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.blueAccent),
                                              keyboardType:
                                                  TextInputType.number,
                                              numberOfFields: 5,
                                              borderColor: Color(0xFF512DA8),
                                              //set to true to show as box or false to show as dash
                                              showFieldAsBox: true,
                                              //runs when a code is typed in
                                              onCodeChanged: (String value) {
                                                print(value);
                                                print(otpCode);
                                              },
                                              //runs when every textfield is filled
                                              onSubmit: (String value) {
                                                otpCode = value;
                                                checkOtp();
                                              }, // end onSubmit
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              SizedBox(
                                                width: 360,
                                                child: Expanded(
                                                  child: ElevatedButton(
                                                    onPressed: () {
                                                      authenticationNotifier
                                                          .backFromOtp();
                                                    },
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                            side: BorderSide(
                                                      width: 1.0,
                                                      // color: Colors.grey,
                                                    )),
                                                    child: const Text(
                                                      AppStrings.back,
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 14),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 20),
                                              Expanded(
                                                child: ElevatedButton(
                                                  onPressed: () {
                                                    checkOtp();
                                                  },
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                          side: BorderSide(
                                                    width: 1.0,
                                                    // color: Colors.grey,
                                                  )),
                                                  child: const Text(
                                                    AppStrings.confirmOtp,
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 14),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                              ),
                            ),
                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.center,
                            //   children: [
                            //     Text(
                            //       AppStrings.doNotHaveAnAccount,
                            //       style:
                            //           Theme.of(context).textTheme.headlineLarge,
                            //     ),
                            //     const SizedBox(width: 4),
                            //     TextButton(
                            //       onPressed: () => {},
                            //       child: const Text(AppStrings.register),
                            //     ),
                            //   ],
                            // ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

//const SizedBox(height: 20),
// Row(
//   children: [
//     Expanded(
//         child: Divider(
//             color: Colors.grey.shade200)),
//     Padding(
//       padding: const EdgeInsets.symmetric(
//           horizontal: 20),
//       child: Text(AppStrings.orLoginWith,
//           style: Theme.of(context)
//               .textTheme
//               .headlineSmall
//               ?.copyWith(
//                   color: Colors.blueGrey)),
//     ),
//     Expanded(
//         child: Divider(
//             color: Colors.grey.shade200)),
//   ],
// ),
// const SizedBox(height: 20),
// Row(
//   children: [
//     Expanded(
//       child: OutlinedButton.icon(
//         onPressed: () {},
//         icon: SvgPicture.asset(Vectors.google,
//             width: 14),
//         label: const Text(
//           AppStrings.google,
//           style:
//               TextStyle(color: Colors.black),
//         ),
//       ),
//     ),
//     const SizedBox(width: 20),
//     Expanded(
//       child: OutlinedButton.icon(
//         onPressed: () {},
//         icon: SvgPicture.asset(
//             Vectors.facebook,
//             width: 14),
//         label: const Text(
//           AppStrings.facebook,
//           style:
//               TextStyle(color: Colors.black),
//         ),
//       ),
//     ),
//   ],
// ),
                               