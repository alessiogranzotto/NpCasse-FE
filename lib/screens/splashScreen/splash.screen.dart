import 'dart:async';
import 'package:flutter/material.dart';
import 'package:np_casse/app/constants/assets.dart';
import 'package:np_casse/app/routes/app_routes.dart';
import 'package:np_casse/app/versionService/version.service.dart';
import 'package:np_casse/core/notifiers/authentication.notifier.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future _initiateCache() async {
    AuthenticationNotifier authenticationNotifier =
        context.read<AuthenticationNotifier>();
    await authenticationNotifier.init();

    VersionService versionService = context.read<VersionService>();
    if (mounted) {
      await versionService.showUpdateDialogIfNeeded(context);
    }

    if (!mounted) return;

    if (authenticationNotifier.isAuth) {
      Navigator.of(context).pushReplacementNamed(AppRouter.homeRoute);
    } else {
      Navigator.of(context).pushReplacementNamed(AppRouter.loginRoute);
    }
  }

  @override
  void initState() {
    Timer(const Duration(seconds: 3), _initiateCache);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: Center(
      child: Image(
          image: AssetImage(AppAssets.logoGivePro),
          fit: BoxFit.contain,
          height: double.infinity,
          width: double.infinity,
          alignment: Alignment.center),
    ));
  }
}
