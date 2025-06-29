import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import '../../common/page_not_found.dart';

class AppGetMaterial extends StatelessWidget {
  final String title;
  final String initialRoute;
  final List<GetPage> getPages;
  final Bindings? initialBinding;
  final List<NavigatorObserver> navigatorObservers;

  const AppGetMaterial(
      {super.key,
        required this.title,
        required this.initialRoute,
        required this.getPages,
        this.initialBinding,
        this.navigatorObservers = const <NavigatorObserver>[]});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      unknownRoute: GetPage(name: '/notfound', page: () => PageNotfound()),
      onUnknownRoute: (settings) => MaterialPageRoute(
        builder: (context) => PageNotfound(),
      ),
      title: title,
      navigatorObservers: navigatorObservers,
      defaultTransition: Transition.size,
      fallbackLocale: const Locale('en', 'US'),
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('mr', 'IN'),
      ],
      initialBinding: initialBinding,
      getPages: getPages,
      initialRoute: initialRoute,
      debugShowCheckedModeBanner: false,
    );
  }
}