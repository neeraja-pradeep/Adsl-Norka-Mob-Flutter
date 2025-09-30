import 'package:norkacare_app/provider/auth_provider.dart';
import 'package:norkacare_app/provider/norka_provider.dart';
import 'package:norkacare_app/provider/verification_provider.dart';
import 'package:norkacare_app/provider/hospital_provider.dart';
import 'package:norkacare_app/provider/otp_verification_provider.dart';
import 'package:norkacare_app/screen/auth/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'services/razorpay_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Razorpay
  RazorpayService.initialize();

  final isDarkMode = await getThemeMode();
  runApp(MyApp(isDarkMode: isDarkMode));
}

Future<bool?> getThemeMode() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool('isDarkMode');
}

Future<void> saveThemeMode(bool? isDarkMode) async {
  final prefs = await SharedPreferences.getInstance();
  if (isDarkMode == null) {
    await prefs.remove('isDarkMode');
  } else {
    await prefs.setBool('isDarkMode', isDarkMode);
  }
}

class MyApp extends StatefulWidget {
  final bool? isDarkMode;

  const MyApp({super.key, required this.isDarkMode});

  static final ValueNotifier<bool?> themeNotifier = ValueNotifier(null);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    MyApp.themeNotifier.value = widget.isDarkMode;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool?>(
      valueListenable: MyApp.themeNotifier,
      builder: (context, isDark, child) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => AuthProvider()),
            ChangeNotifierProvider(create: (_) => NorkaProvider()),
            ChangeNotifierProvider(create: (_) => VerificationProvider()),
            ChangeNotifierProvider(create: (_) => HospitalProvider()),
            ChangeNotifierProvider(create: (_) => OtpVerificationProvider()),
          ],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData.light(),
            darkTheme: ThemeData.dark(),
            themeMode: isDark == null
                ? ThemeMode.system
                : (isDark ? ThemeMode.dark : ThemeMode.light),
            home: const SplashScreen(),
          ),
        );
      },
    );
  }
}
