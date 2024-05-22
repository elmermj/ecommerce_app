import 'package:ecommerce_app/dependency_injector/app_initialization.dart';
import 'package:ecommerce_app/services/account_service.dart';
import 'package:ecommerce_app/theme.dart';
import 'package:ecommerce_app/utils/enums/app_state_enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'presentation/entry/entry_screen.dart';
import 'presentation/home/home_screen.dart';

Rx<AppState> appState = AppState.idle.obs;

Future<void> main() async {
  
  WidgetsFlutterBinding.ensureInitialized();

  await DependencyInjection.init();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  AccountService accountService = Get.find<AccountService>();

  runApp(ECommerceApp(isLogin: accountService.isLogin.value, isAdmin: accountService.isAdmin));
  
}

class ECommerceApp extends StatelessWidget {
  final bool isLogin;
  final bool isAdmin;
  const ECommerceApp({required this.isLogin, super.key, required this.isAdmin});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: MaterialTheme(
        TextTheme(
          displayLarge: GoogleFonts.poppins(
            fontSize: 72,
            fontWeight: FontWeight.w300,
          ),
          displayMedium: GoogleFonts.poppins(
            fontSize: 48,
            fontWeight: FontWeight.w300,
          ),
          displaySmall: GoogleFonts.poppins(
            fontSize: 42,
            fontWeight: FontWeight.w400
          ),
          headlineMedium: GoogleFonts.poppins(
            fontSize: 30,
            fontWeight: FontWeight.w400,
          ),
          headlineSmall: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.w400
          ),
          titleLarge: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
          titleMedium: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
          titleSmall: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
          bodyLarge: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
          bodyMedium: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
          labelLarge: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
          bodySmall: GoogleFonts.poppins(
            fontSize: 10,
            fontWeight: FontWeight.w400,
          ),
          labelSmall: GoogleFonts.poppins(
            fontSize: 8,
            fontWeight: FontWeight.w400,
          ),
        )
      ).light(),
      darkTheme: MaterialTheme(
        TextTheme(
          displayLarge: GoogleFonts.poppins(
            fontSize: 72,
            fontWeight: FontWeight.w300,
          ),
          displayMedium: GoogleFonts.poppins(
            fontSize: 48,
            fontWeight: FontWeight.w300,
          ),
          displaySmall: GoogleFonts.poppins(
            fontSize: 42,
            fontWeight: FontWeight.w400
          ),
          headlineMedium: GoogleFonts.poppins(
            fontSize: 30,
            fontWeight: FontWeight.w400,
          ),
          headlineSmall: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.w400
          ),
          titleLarge: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
          titleMedium: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
          titleSmall: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
          bodyLarge: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
          bodyMedium: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
          labelLarge: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
          bodySmall: GoogleFonts.poppins(
            fontSize: 10,
            fontWeight: FontWeight.w400,
          ),
          labelSmall: GoogleFonts.poppins(
            fontSize: 8,
            fontWeight: FontWeight.w400,
          ),
        )
      ).dark(),
      initialRoute: '/',
      home: isLogin? HomeScreen(isAdmin: isAdmin,) : EntryScreen(),
    );
  }
}