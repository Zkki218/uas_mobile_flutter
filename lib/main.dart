import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controllers/login_controller.dart';
import 'controllers/dashboard_controller.dart';
import 'controllers/cashier_controller.dart';
import 'views/login_view.dart';
import 'views/dashboard_view.dart';
import 'views/cashier_view.dart';

void main() {
  Get.put(DashboardController(), permanent: true);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'POS Aplikasi',
      initialRoute: '/login',
      getPages: [
        GetPage(
          name: '/login', 
          page: () => const LoginView(),
          binding: BindingsBuilder(() {
            Get.lazyPut<LoginController>(() => LoginController());
          }),
        ),
        GetPage(
          name: '/dashboard', 
          page: () => const DashboardView(),
          binding: BindingsBuilder(() {
            Get.lazyPut<DashboardController>(() => DashboardController());
          }),
        ),
        GetPage(
          name: '/cashier', 
          page: () => const CashierView(),
          binding: BindingsBuilder(() {
            Get.lazyPut<CashierController>(() => CashierController());
          }),
        ),
      ],
    );
  }
}