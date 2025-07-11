import 'package:flutter/material.dart';
import 'login.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// void main() {
//   runApp(
//       SmartFruitApp(),
//   );
// }
void main() {
  runApp(
    ScreenUtilInit(
      designSize: Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) => SmartFruitApp(),
    ),
  );
}


class SmartFruitApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart Fruit',
      theme: ThemeData(
        fontFamily: 'MontserratMedium',
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
        inputDecorationTheme: InputDecorationTheme(
          floatingLabelStyle: TextStyle(color: Colors.green),
          filled: true,
          fillColor: Colors.green[50],
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.green.shade200),
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.green, width: 2),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      home: LoginPage(),
    );
  }
}