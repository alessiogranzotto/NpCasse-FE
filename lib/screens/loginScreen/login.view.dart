import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:np_casse/app/constants/assets.dart';
import 'package:np_casse/app/constants/keys.dart';
import 'package:np_casse/componenents/custom.text.form.field.dart';
import 'package:np_casse/core/notifiers/authentication.notifier.dart';
import 'package:np_casse/core/notifiers/download.app.notifier.dart';
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
  bool isDownloadingApk = false;

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

    if (AppConstants.emailRegex.hasMatch(email) &&
        AppConstants.passwordRegex.hasMatch(password)) {
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

  downloadAndroidApp() {
    setState(() {
      isDownloadingApk = true;
    });
    DownloadAppNotifier downloadAppNotifier =
        Provider.of<DownloadAppNotifier>(context, listen: false);
    downloadAppNotifier.downloadAndroidApp(context: context).then((value) {
      setState(() {
        isDownloadingApk = false;
      });
    });
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
          Widget formSection = Container(
            constraints: const BoxConstraints(maxWidth: 500),
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image(
                      image: AssetImage(AppAssets.logoGivePro),
                      fit: BoxFit.fill,
                      width: 100,
                      alignment: Alignment.center,
                    ),
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
                                        keyboardType: TextInputType.emailAddress,
                                        textInputAction: TextInputAction.next,
                                        onChanged: (_) =>
                                            _formKey.currentState?.validate(),
                                        validator: (value) {
                                          return value!.isEmpty
                                              ? AppStrings.pleaseEnterEmailAddress
                                              : AppConstants.emailRegex
                                                      .hasMatch(value)
                                                  ? null
                                                  : AppStrings.invalidEmailAddress;
                                        },
                                      ),
                                      ValueListenableBuilder(
                                        valueListenable: passwordNotifier,
                                        builder: (_, passwordObscure, __) {
                                          return Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 20),
                                            child: CustomTextFormField(
                                              obscureText: passwordObscure,
                                              controller: passwordController,
                                              labelText: AppStrings.password,
                                              textInputAction:
                                                  TextInputAction.done,
                                              keyboardType:
                                                  TextInputType.visiblePassword,
                                              onChanged: (_) => _formKey
                                                  .currentState
                                                  ?.validate(),
                                              validator: (value) {
                                                return value!.isEmpty
                                                    ? AppStrings
                                                        .pleaseEnterPassword
                                                    : AppConstants.passwordRegex
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
                                                      : Icons.visibility_outlined,
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
                                              style: ElevatedButton.styleFrom(
                                                side:
                                                    const BorderSide(width: 1.0),
                                              ),
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
                                                      ? authenticateAccount
                                                      : null,
                                                  style: ElevatedButton.styleFrom(
                                                    side: const BorderSide(
                                                        width: 1.0),
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
                                    ],
                                  )
                                : Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 30.0),                                        child: OtpTextField(
                                          enabledBorderColor: Colors.blueGrey,
                                          showCursor: true,
                                          fieldHeight: 60,
                                          fieldWidth: 60,
                                          textStyle: const TextStyle(
                                              fontSize: 20,
                                              color: Colors.blueAccent),
                                          keyboardType: TextInputType.number,
                                          numberOfFields: 5,
                                          borderColor:
                                              const Color(0xFF512DA8),
                                          showFieldAsBox: true,
                                          onCodeChanged: (value) {},
                                          onSubmit: (value) {
                                            otpCode = value.length > 5
                                                ? value.substring(0, 5)
                                                : value;
                                            checkOtp();
                                          },
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            width: 300,
                                            child: ElevatedButton(
                                              onPressed: () {
                                                authenticationNotifier
                                                    .backFromOtp();
                                              },
                                              style: ElevatedButton.styleFrom(
                                                side:
                                                    const BorderSide(width: 1.0),
                                              ),
                                              child: const Text(
                                                AppStrings.back,
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
                            if (authenticationNotifier.isLoading)
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: LinearProgressIndicator(
                                  backgroundColor: Colors.transparent,
                                  valueColor:
                                      AlwaysStoppedAnimation(Colors.blue),
                                  minHeight: 5,
                                ),
                              )
                            else
                              const SizedBox(height: 5),
                          ],
                        ),
                      ),
                    ),
                    if (authenticationNotifier.stepLoading == "user")
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          side: const BorderSide(width: 1.0),
                        ),
                        onPressed: isDownloadingApk ? null : downloadAndroidApp,
                        child: const Wrap(
                          children: [
                            Icon(Icons.android, color: Colors.green),
                            SizedBox(width: 10),
                            Text(
                              'Scarica l\'app',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );

          return Center(child: formSection);
        },
      ),
    );
  }
}