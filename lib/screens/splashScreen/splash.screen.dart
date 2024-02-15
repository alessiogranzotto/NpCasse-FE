import 'dart:async';
// import 'package:cache_manager/cache_manager.dart';
import 'package:flutter/material.dart';
import 'package:np_casse/app/constants/assets.dart';
import 'package:np_casse/app/routes/app_routes.dart';
import 'package:np_casse/core/notifiers/authentication.notifier.dart';
// import 'package:np_casse/screens/homeScreen/home.screen.dart';
// import 'package:np_casse/screens/loginScreen/login.view.dart';
// import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:provider/provider.dart';
// import 'package:np_casse/app/constants/keys.dart';

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

    // return CacheManagerUtils.conditionalCache(
    //   key: AppKeys.onBoardDone,
    //   valueType: ValueType.StringValue,
    //   actionIfNull: () {
    //     Navigator.of(context).pushNamed(AppRouter.onBoardRoute).whenComplete(
    //         () => WriteCache.setString(
    //             key: AppKeys.onBoardDone, value: 'Boarded'));
    //   },
    //   actionIfNotNull: () {
    //     CacheManagerUtils.conditionalCache(
    //         key: AppKeys.userData,
    //         valueType: ValueType.StringValue,
    //         actionIfNull: () {
    //           Navigator.of(context).pushNamed(AppRouter.loginRoute);
    //         },
    //         actionIfNotNull: () {
    //           Navigator.of(context).pushReplacementNamed(AppRouter.homeRoute);
    //         });
    //   },
    // );

    return authenticationNotifier.isAuth
        ? Navigator.of(context).pushNamed(AppRouter.homeRoute)
        : Navigator.of(context).pushReplacementNamed(AppRouter.loginRoute);
  }

  @override
  void initState() {
    Timer(const Duration(seconds: 3), _initiateCache);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: Image(
            image: AssetImage(AppAssets.splashImage),
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
            alignment: Alignment.center));
  }
}
