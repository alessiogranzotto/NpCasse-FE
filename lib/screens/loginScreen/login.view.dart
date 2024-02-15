import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:np_casse/app/constants/assets.dart';
import 'package:np_casse/app/constants/keys.dart';
import 'package:np_casse/componenents/text.form.field.dart';
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
      authNotifier.userAuthenticate(
          context: context,
          email: emailController.text,
          password: passwordController.text,
          appName: AppKeys.appName);
    }
  }

  @override
  Widget build(BuildContext context) {
    AuthenticationNotifier authenticationNotifier =
        Provider.of<AuthenticationNotifier>(context);
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth >= 1200) {
            return Row(
              children: [
                const Expanded(
                    child: Image(
                        image: AssetImage(AppAssets.leftHomeImage),
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
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  AGTextFormField(
                                    controller: emailController,
                                    labelText: AppStrings.email,
                                    keyboardType: TextInputType.emailAddress,
                                    textInputAction: TextInputAction.next,
                                    onChanged: (_) =>
                                        _formKey.currentState?.validate(),
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
                                        padding: const EdgeInsets.only(top: 20),
                                        child: AGTextFormField(
                                          obscureText: passwordObscure,
                                          controller: passwordController,
                                          labelText: AppStrings.password,
                                          textInputAction: TextInputAction.done,
                                          keyboardType:
                                              TextInputType.visiblePassword,
                                          onChanged: (_) =>
                                              _formKey.currentState?.validate(),
                                          validator: (value) {
                                            return value!.isEmpty
                                                ? AppStrings.pleaseEnterPassword
                                                : AppConstants.passwordRegex
                                                        .hasMatch(value)
                                                    ? null
                                                    : AppStrings
                                                        .invalidPassword;
                                          },
                                          suffixIcon: IconButton(
                                            onPressed: () => passwordNotifier
                                                .value = !passwordObscure,
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
                                  Row(
                                    children: [
                                      Expanded(
                                        child: TextButton(
                                          onPressed: () {},
                                          child: const Text(
                                            AppStrings.forgotPassword,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 8),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 20),
                                      Expanded(
                                        child: ValueListenableBuilder(
                                          valueListenable: fieldValidNotifier,
                                          builder: (_, isValid, __) {
                                            return FilledButton(
                                              onPressed: isValid
                                                  ? () {
                                                      authenticateAccount();
                                                      emailController.clear();
                                                      passwordController
                                                          .clear();
                                                    }
                                                  : null,
                                              child:
                                                  const Text(AppStrings.login),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  Row(
                                    children: [
                                      Expanded(
                                          child: Divider(
                                              color: Colors.grey.shade200)),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20),
                                        child: Text(AppStrings.orLoginWith,
                                            style: Theme.of(context)
                                                .textTheme
                                                .headlineSmall
                                                ?.copyWith(
                                                    color: Colors.blueGrey)),
                                      ),
                                      Expanded(
                                          child: Divider(
                                              color: Colors.grey.shade200)),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: OutlinedButton.icon(
                                          onPressed: () {},
                                          icon: SvgPicture.asset(Vectors.google,
                                              width: 14),
                                          label: const Text(
                                            AppStrings.google,
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 20),
                                      Expanded(
                                        child: OutlinedButton.icon(
                                          onPressed: () {},
                                          icon: SvgPicture.asset(
                                              Vectors.facebook,
                                              width: 14),
                                          label: const Text(
                                            AppStrings.facebook,
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                AppStrings.doNotHaveAnAccount,
                                style:
                                    Theme.of(context).textTheme.headlineLarge,
                              ),
                              const SizedBox(width: 4),
                              TextButton(
                                onPressed: () => {},
                                child: const Text(AppStrings.register),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          } else if (constraints.maxWidth >= 800 &&
              constraints.maxWidth < 1200) {
            return Row(
              children: [
                const Expanded(
                    child: Image(
                        image: AssetImage(AppAssets.leftHomeImage),
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
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  AGTextFormField(
                                    controller: emailController,
                                    labelText: AppStrings.email,
                                    keyboardType: TextInputType.emailAddress,
                                    textInputAction: TextInputAction.next,
                                    onChanged: (_) =>
                                        _formKey.currentState?.validate(),
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
                                      return AGTextFormField(
                                        obscureText: passwordObscure,
                                        controller: passwordController,
                                        labelText: AppStrings.password,
                                        textInputAction: TextInputAction.done,
                                        keyboardType:
                                            TextInputType.visiblePassword,
                                        onChanged: (_) =>
                                            _formKey.currentState?.validate(),
                                        validator: (value) {
                                          return value!.isEmpty
                                              ? AppStrings.pleaseEnterPassword
                                              : AppConstants.passwordRegex
                                                      .hasMatch(value)
                                                  ? null
                                                  : AppStrings.invalidPassword;
                                        },
                                        suffixIcon: IconButton(
                                          onPressed: () => passwordNotifier
                                              .value = !passwordObscure,
                                          style: IconButton.styleFrom(
                                            minimumSize: const Size.square(48),
                                          ),
                                          icon: Icon(
                                            passwordObscure
                                                ? Icons.visibility_off_outlined
                                                : Icons.visibility_outlined,
                                            size: 20,
                                            color: Colors.black,
                                          ),
                                        ),
                                      );
                                    },
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
                                  Row(
                                    children: [
                                      Expanded(
                                        child: TextButton(
                                          onPressed: () {},
                                          child: const Text(
                                            AppStrings.forgotPassword,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 8),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 20),
                                      Expanded(
                                        child: ValueListenableBuilder(
                                          valueListenable: fieldValidNotifier,
                                          builder: (_, isValid, __) {
                                            return FilledButton(
                                              onPressed: isValid
                                                  ? () {
                                                      SnackbarHelper
                                                          .showSnackBar(
                                                        AppStrings.loggedIn,
                                                      );
                                                      authenticateAccount();
                                                      emailController.clear();
                                                      passwordController
                                                          .clear();
                                                    }
                                                  : null,
                                              child:
                                                  const Text(AppStrings.login),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  Row(
                                    children: [
                                      Expanded(
                                          child: Divider(
                                              color: Colors.grey.shade200)),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20),
                                        child: Text(AppStrings.orLoginWith,
                                            style: Theme.of(context)
                                                .textTheme
                                                .headlineSmall
                                                ?.copyWith(
                                                    color: Colors.blueGrey)),
                                      ),
                                      Expanded(
                                          child: Divider(
                                              color: Colors.grey.shade200)),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: OutlinedButton.icon(
                                          onPressed: () {},
                                          icon: SvgPicture.asset(Vectors.google,
                                              width: 14),
                                          label: const Text(
                                            AppStrings.google,
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 20),
                                      Expanded(
                                        child: OutlinedButton.icon(
                                          onPressed: () {},
                                          icon: SvgPicture.asset(
                                              Vectors.facebook,
                                              width: 14),
                                          label: const Text(
                                            AppStrings.facebook,
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                AppStrings.doNotHaveAnAccount,
                                style:
                                    Theme.of(context).textTheme.headlineLarge,
                              ),
                              const SizedBox(width: 4),
                              TextButton(
                                onPressed: () => {},
                                child: const Text(AppStrings.register),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          } else {
            return Row(
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
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  AGTextFormField(
                                    controller: emailController,
                                    labelText: AppStrings.email,
                                    keyboardType: TextInputType.emailAddress,
                                    textInputAction: TextInputAction.next,
                                    onChanged: (_) =>
                                        _formKey.currentState?.validate(),
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
                                      return AGTextFormField(
                                        obscureText: passwordObscure,
                                        controller: passwordController,
                                        labelText: AppStrings.password,
                                        textInputAction: TextInputAction.done,
                                        keyboardType:
                                            TextInputType.visiblePassword,
                                        onChanged: (_) =>
                                            _formKey.currentState?.validate(),
                                        validator: (value) {
                                          return value!.isEmpty
                                              ? AppStrings.pleaseEnterPassword
                                              : AppConstants.passwordRegex
                                                      .hasMatch(value)
                                                  ? null
                                                  : AppStrings.invalidPassword;
                                        },
                                        suffixIcon: IconButton(
                                          onPressed: () => passwordNotifier
                                              .value = !passwordObscure,
                                          style: IconButton.styleFrom(
                                            minimumSize: const Size.square(48),
                                          ),
                                          icon: Icon(
                                            passwordObscure
                                                ? Icons.visibility_off_outlined
                                                : Icons.visibility_outlined,
                                            size: 20,
                                            color: Colors.black,
                                          ),
                                        ),
                                      );
                                    },
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
                                  Row(
                                    children: [
                                      Expanded(
                                        child: TextButton(
                                          onPressed: () {},
                                          child: const Text(
                                            AppStrings.forgotPassword,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 8),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 20),
                                      Expanded(
                                        child: ValueListenableBuilder(
                                          valueListenable: fieldValidNotifier,
                                          builder: (_, isValid, __) {
                                            return FilledButton(
                                              onPressed: isValid
                                                  ? () {
                                                      SnackbarHelper
                                                          .showSnackBar(
                                                        AppStrings.loggedIn,
                                                      );
                                                      authenticateAccount();
                                                      emailController.clear();
                                                      passwordController
                                                          .clear();
                                                    }
                                                  : null,
                                              child:
                                                  const Text(AppStrings.login),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  Row(
                                    children: [
                                      Expanded(
                                          child: Divider(
                                              color: Colors.grey.shade200)),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20),
                                        child: Text(AppStrings.orLoginWith,
                                            style: Theme.of(context)
                                                .textTheme
                                                .headlineSmall
                                                ?.copyWith(
                                                    color: Colors.blueGrey)),
                                      ),
                                      Expanded(
                                          child: Divider(
                                              color: Colors.grey.shade200)),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: OutlinedButton.icon(
                                          onPressed: () {},
                                          icon: SvgPicture.asset(Vectors.google,
                                              width: 14),
                                          label: const Text(
                                            AppStrings.google,
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 20),
                                      Expanded(
                                        child: OutlinedButton.icon(
                                          onPressed: () {},
                                          icon: SvgPicture.asset(
                                              Vectors.facebook,
                                              width: 14),
                                          label: const Text(
                                            AppStrings.facebook,
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                AppStrings.doNotHaveAnAccount,
                                style:
                                    Theme.of(context).textTheme.headlineLarge,
                              ),
                              const SizedBox(width: 4),
                              TextButton(
                                onPressed: () => {},
                                child: const Text(AppStrings.register),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}

// return Scaffold(
//   resizeToAvoidBottomInset: true,
//   backgroundColor: Theme.of(context).colorScheme.background,
//   body: SafeArea(
//     child: Center(
//       child: Container(
//         alignment: Alignment.topCenter,
//         width:
//             //width * 0.5
//             (switch (width) {
//           <= 500 => width * 0.75,
//           <= 1000 => width * 0.5,
//           > 1000 => width * 0.3,
//           _ => 400
//         }),
//         child: Padding(
//           padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
//           child: SingleChildScrollView(
//             child: Column(
//               children: [
//                 const SizedBox(height: 20),
//                 // welcomeTextLogin(themeFlag: themeFlag),

//                 Builder(
//                   builder: (BuildContext context) {
//                     switch (authenticationNotifier.getactualState) {
//                       case 'LoadingState':
//                         return const Column(
//                           children: [
//                             Row(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   //logo
//                                   Icon(
//                                     Icons.lock,
//                                     size: 100,
//                                     color: Colors.red,
//                                   )
//                                   //welcome back
//                                 ]),
//                             SizedBox(height: 50),
//                             Center(
//                                 child: CircularProgressIndicator(
//                               color: Colors.red,
//                               strokeWidth: 5,
//                             )),
//                             SizedBox(height: 20),
//                           ],
//                         );

//                       case 'LoadedState':
//                         return const Column(
//                           children: [
//                             //  const Row(
//                             //       mainAxisAlignment: MainAxisAlignment.center,
//                             //       children: [
//                             //         //logo
//                             //         Icon(
//                             //           Icons.lock_open,
//                             //            size: 100,
//                             //         )
//                             //welcome back
//                             //       ]),
//                             SizedBox(height: 50),
//                             //     Center(
//                             //       child: Text(
//                             //         'Bentornato! ',
//                             //         style: const TextStyle(
//                             //            color: Colors.black,
//                             //            fontSize: 18,
//                             //            fontWeight: FontWeight.bold),
//                             //      ),
//                             //     ),
//                           ],
//                         );
//                       case 'ErrorState':
//                         return Column(
//                           children: [
//                             const Row(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   //logo
//                                   Icon(
//                                     Icons.lock,
//                                     size: 100,
//                                     color: Colors.red,
//                                   )
//                                   //welcome back
//                                 ]),
//                             const SizedBox(height: 50),
//                             Text(
//                               'Inserisci le credenziali per accedere',
//                               style: Theme.of(context)
//                                   .textTheme
//                                   .titleMedium!
//                                   .copyWith(color: Colors.red),
//                             ),
//                             const SizedBox(height: 25),
//                           ],
//                         );
//                       case 'LogoutState':
//                         return Column(
//                           children: [
//                             const Row(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   //logo
//                                   Icon(
//                                     Icons.logout,
//                                     size: 100,
//                                   )
//                                   //welcome back
//                                 ]),
//                             const SizedBox(height: 50),
//                             Center(
//                               child: Text(
//                                 'Ciao, a presto! ',
//                                 style:
//                                     Theme.of(context).textTheme.titleMedium,
//                               ),
//                             ),
//                             const SizedBox(height: 20),
//                           ],
//                         );
//                       default:
//                         return Column(
//                           children: [
//                             const Row(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   //logo
//                                   Icon(
//                                     Icons.lock,
//                                     size: 100,
//                                   )
//                                   //welcome back
//                                 ]),
//                             const SizedBox(height: 50),
//                             Text(
//                               'Inserisci le credenziali per accedere',
//                               style:
//                                   Theme.of(context).textTheme.titleMedium,
//                             ),
//                             const SizedBox(height: 25),
//                           ],
//                         );
//                     }
//                   },
//                 ),
//                 Column(
//                   children: [
//                     Container(
//                       decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(8),
//                           color: Theme.of(context).colorScheme.primary,
//                           boxShadow: [
//                             BoxShadow(
//                               color: Theme.of(context).shadowColor,
//                               offset: const Offset(0.0, 1.0), //(x,y)

//                               blurRadius: 8.0,
//                             )
//                           ]),
//                       child: Column(
//                         children: [
//                           Form(
//                             key: _formKey,
//                             child: Column(children: [
//                               const SizedBox(height: 20),
//                               Padding(
//                                 padding: const EdgeInsets.symmetric(
//                                     horizontal: 25.0),
//                                 child:
//                                     LoginTextFormField.loginTextFormField(
//                                         // themeFlag: themeFlag,
//                                         textEditingController:
//                                             userEmailController,
//                                         obscureText: false,
//                                         hintText: 'email',
//                                         prefixIcon: const Icon(Icons.email),
//                                         validator: (val) => val!.isEmpty
//                                             ? 'Inserire una email valida'
//                                             : null,
//                                         themeData: Theme.of(context)),
//                               ),
//                               const SizedBox(height: 10),
//                               Padding(
//                                 padding: const EdgeInsets.symmetric(
//                                     horizontal: 25.0),
//                                 child:
//                                     LoginTextFormField.loginTextFormField(
//                                         // themeFlag: themeFlag,
//                                         textEditingController:
//                                             userPasswordController,
//                                         obscureText: true,
//                                         hintText: 'password',
//                                         prefixIcon:
//                                             const Icon(Icons.vpn_key),
//                                         validator: (val) => val!.isEmpty
//                                             ? 'Inserire una password valida'
//                                             : null,
//                                         themeData: Theme.of(context)),
//                               ),
//                               const SizedBox(height: 10),
//                             ]),
//                           ),
//                           const SizedBox(height: 10),
//                           Padding(
//                             padding: const EdgeInsets.symmetric(
//                                 horizontal: 25.0),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.end,
//                               children: [
//                                 GestureDetector(
//                                   child: Text(
//                                     'Password dimenticata?',
//                                     style: TextStyle(
//                                         color: Theme.of(context).hintColor,
//                                         decoration:
//                                             TextDecoration.underline),
//                                   ),
//                                 )
//                               ],
//                             ),
//                           ),
//                           const SizedBox(height: 20),
//                           GestureDetector(
//                             onTap: () async {
//                               authenticateAccount();
//                             },
//                             child: Container(
//                               padding: const EdgeInsets.all(25),
//                               margin: const EdgeInsets.symmetric(
//                                   horizontal: 25),
//                               decoration: BoxDecoration(
//                                   color: Theme.of(context)
//                                       .colorScheme
//                                       .primaryContainer,
//                                   borderRadius: BorderRadius.circular(8),
//                                   boxShadow: [
//                                     BoxShadow(
//                                       color: Theme.of(context)
//                                           .colorScheme
//                                           .shadow,
//                                       offset:
//                                           const Offset(0.0, 1.0), //(x,y)
//                                       blurRadius: 1.0,
//                                     )
//                                   ]),
//                               child: Center(
//                                 child: Text(
//                                   "Accedi",
//                                   style: Theme.of(context)
//                                       .textTheme
//                                       .titleSmall,
//                                 ),
//                               ),
//                             ),
//                           ),
//                           const SizedBox(height: 20),
//                           GestureDetector(
//                             onTap: () => Navigator.of(context)
//                                 .pushNamed(AppRouter.registerRoute),
//                             child: Container(
//                               padding: const EdgeInsets.all(25),
//                               margin: const EdgeInsets.symmetric(
//                                   horizontal: 25),
//                               decoration: BoxDecoration(
//                                   color: Theme.of(context)
//                                       .colorScheme
//                                       .secondaryContainer,
//                                   borderRadius: BorderRadius.circular(8),
//                                   boxShadow: [
//                                     BoxShadow(
//                                       color: Theme.of(context)
//                                           .colorScheme
//                                           .shadow,
//                                       offset:
//                                           const Offset(0.0, 1.0), //(x,y)
//                                       blurRadius: 1.0,
//                                     )
//                                   ]),
//                               child: Center(
//                                 child: Text(
//                                   "Nuovo utente",
//                                   style: Theme.of(context)
//                                       .textTheme
//                                       .titleSmall,
//                                 ),
//                               ),
//                             ),
//                           ),
//                           const SizedBox(height: 20),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     ),
//   ),
// );

// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:login_register_app/utils/helpers/snackbar_helper.dart';
// import 'package:login_register_app/values/app_regex.dart';
// import 'package:np_casse/app/constants/regex.dart';

// import '../components/app_text_form_field.dart';
// import '../resources/resources.dart';
// import '../utils/common_widgets/gradient_background.dart';
// import '../utils/helpers/navigation_helper.dart';
// import '../values/app_constants.dart';
// import '../values/app_routes.dart';
// import '../values/app_strings.dart';
// import '../values/app_theme.dart';

// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});

//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   final _formKey = GlobalKey<FormState>();

//   final ValueNotifier<bool> passwordNotifier = ValueNotifier(true);
//   final ValueNotifier<bool> fieldValidNotifier = ValueNotifier(false);

//   late final TextEditingController emailController;
//   late final TextEditingController passwordController;

//   void initializeControllers() {
//     emailController = TextEditingController()..addListener(controllerListener);
//     passwordController = TextEditingController()
//       ..addListener(controllerListener);
//   }

//   void disposeControllers() {
//     emailController.dispose();
//     passwordController.dispose();
//   }

//   void controllerListener() {
//     final email = emailController.text;
//     final password = passwordController.text;

//     if (email.isEmpty && password.isEmpty) return;

//     if (AppRegex.emailRegex.hasMatch(email) &&
//         AppRegex.passwordRegex.hasMatch(password)) {
//       fieldValidNotifier.value = true;
//     } else {
//       fieldValidNotifier.value = false;
//     }
//   }

//   @override
//   void initState() {
//     initializeControllers();
//     super.initState();
//   }

//   @override
//   void dispose() {
//     disposeControllers();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: ListView(
//         padding: EdgeInsets.zero,
//         children: [
//           const GradientBackground(
//             children: [
//               Text(
//                 AppStrings.signInToYourNAccount,
//                 style: AppTheme.titleLarge,
//               ),
//               SizedBox(height: 6),
//               Text(AppStrings.signInToYourAccount, style: AppTheme.bodySmall),
//             ],
//           ),
//           Form(
//             key: _formKey,
//             child: Padding(
//               padding: const EdgeInsets.all(20),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 crossAxisAlignment: CrossAxisAlignment.end,
//                 children: [
//                   AppTextFormField(
//                     controller: emailController,
//                     labelText: AppStrings.email,
//                     keyboardType: TextInputType.emailAddress,
//                     textInputAction: TextInputAction.next,
//                     onChanged: (_) => _formKey.currentState?.validate(),
//                     validator: (value) {
//                       return value!.isEmpty
//                           ? AppStrings.pleaseEnterEmailAddress
//                           : AppConstants.emailRegex.hasMatch(value)
//                               ? null
//                               : AppStrings.invalidEmailAddress;
//                     },
//                   ),
//                   ValueListenableBuilder(
//                     valueListenable: passwordNotifier,
//                     builder: (_, passwordObscure, __) {
//                       return AppTextFormField(
//                         obscureText: passwordObscure,
//                         controller: passwordController,
//                         labelText: AppStrings.password,
//                         textInputAction: TextInputAction.done,
//                         keyboardType: TextInputType.visiblePassword,
//                         onChanged: (_) => _formKey.currentState?.validate(),
//                         validator: (value) {
//                           return value!.isEmpty
//                               ? AppStrings.pleaseEnterPassword
//                               : AppConstants.passwordRegex.hasMatch(value)
//                                   ? null
//                                   : AppStrings.invalidPassword;
//                         },
//                         suffixIcon: IconButton(
//                           onPressed: () =>
//                               passwordNotifier.value = !passwordObscure,
//                           style: IconButton.styleFrom(
//                             minimumSize: const Size.square(48),
//                           ),
//                           icon: Icon(
//                             passwordObscure
//                                 ? Icons.visibility_off_outlined
//                                 : Icons.visibility_outlined,
//                             size: 20,
//                             color: Colors.black,
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                   TextButton(
//                     onPressed: () {},
//                     child: const Text(AppStrings.forgotPassword),
//                   ),
//                   const SizedBox(height: 20),
//                   ValueListenableBuilder(
//                     valueListenable: fieldValidNotifier,
//                     builder: (_, isValid, __) {
//                       return FilledButton(
//                         onPressed: isValid
//                             ? () {
//                                 SnackbarHelper.showSnackBar(
//                                   AppStrings.loggedIn,
//                                 );
//                                 emailController.clear();
//                                 passwordController.clear();
//                               }
//                             : null,
//                         child: const Text(AppStrings.login),
//                       );
//                     },
//                   ),
//                   const SizedBox(height: 20),
//                   Row(
//                     children: [
//                       Expanded(child: Divider(color: Colors.grey.shade200)),
//                       Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 20),
//                         child: Text(
//                           AppStrings.orLoginWith,
//                           style: AppTheme.bodySmall.copyWith(
//                             color: Colors.black,
//                           ),
//                         ),
//                       ),
//                       Expanded(child: Divider(color: Colors.grey.shade200)),
//                     ],
//                   ),
//                   const SizedBox(height: 20),
//                   Row(
//                     children: [
//                       Expanded(
//                         child: OutlinedButton.icon(
//                           onPressed: () {},
//                           icon: SvgPicture.asset(Vectors.google, width: 14),
//                           label: const Text(
//                             AppStrings.google,
//                             style: TextStyle(color: Colors.black),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(width: 20),
//                       Expanded(
//                         child: OutlinedButton.icon(
//                           onPressed: () {},
//                           icon: SvgPicture.asset(Vectors.facebook, width: 14),
//                           label: const Text(
//                             AppStrings.facebook,
//                             style: TextStyle(color: Colors.black),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text(
//                 AppStrings.doNotHaveAnAccount,
//                 style: AppTheme.bodySmall.copyWith(color: Colors.black),
//               ),
//               const SizedBox(width: 4),
//               TextButton(
//                 onPressed: () => NavigationHelper.pushReplacementNamed(
//                   AppRoutes.register,
//                 ),
//                 child: const Text(AppStrings.register),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
