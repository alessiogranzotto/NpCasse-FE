import 'package:flutter/material.dart';
import 'package:np_casse/core/notifiers/authentication.notifier.dart';
import 'package:np_casse/screens/loginScreen/widget/login.TextFormField.dart';
import 'package:provider/provider.dart';
import 'package:np_casse/app/routes/app_routes.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({Key? key}) : super(key: key);
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    AuthenticationNotifier authNotifier(bool renderUI) =>
        Provider.of<AuthenticationNotifier>(context, listen: renderUI);

    registerAccount() {
      if (_formKey.currentState!.validate()) {
        // authNotifier(false).userRegister(
        //     context: context,
        //     email: emailController.text,
        //     password: passwordController.text);
      }
    }

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            // welcomeTextLogin(themeFlag: themeFlag),
            const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              //logo
              Icon(
                Icons.person,
                size: 100,
              )
              //welcome back
            ]),
            const SizedBox(height: 50),
            Form(
              key: _formKey,
              child: Column(children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: LoginTextFormField.loginTextFormField(
                      // themeFlag: themeFlag,
                      textEditingController: emailController,
                      obscureText: false,
                      hintText: 'email',
                      prefixIcon: const Icon(Icons.email),
                      validator: (val) =>
                          val!.isEmpty ? 'Inserire una email valida' : null,
                      themeData: Theme.of(context)),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: LoginTextFormField.loginTextFormField(
                      // themeFlag: themeFlag,
                      textEditingController: passwordController,
                      obscureText: true,
                      hintText: 'password',
                      prefixIcon: const Icon(Icons.vpn_key),
                      validator: (val) =>
                          val!.isEmpty ? 'Inserire una password valida' : null,
                      onChanged: (val) {
                        authNotifier(false).getPasswordStrength(password: val);
                      },
                      themeData: Theme.of(context)),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: LinearProgressIndicator(
                    value: authNotifier(true).passwordStrength!,
                    backgroundColor: Colors.grey[300],
                    color: authNotifier(true).passwordStrength! == 0
                        ? Colors.red
                        : authNotifier(true).passwordStrength! == 1
                            ? Colors.yellow
                            : authNotifier(true).passwordStrength! == 2
                                ? Colors.blue
                                : Colors.green,
                    minHeight: 15,
                  ),
                ),
              ]),
            ),
            //username textField
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () =>
                        Navigator.of(context).pushNamed(AppRouter.loginRoute),
                    child: Text(
                      'Hai un utente?',
                      style: TextStyle(
                          color: Theme.of(context).hintColor,
                          decoration: TextDecoration.underline),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () async {
                registerAccount();
              },
              child: Container(
                padding: const EdgeInsets.all(25),
                margin: const EdgeInsets.symmetric(horizontal: 25),
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(8)),
                child: Center(
                  child: Text(
                    "Registrati",
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
