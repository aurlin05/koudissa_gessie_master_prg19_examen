import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
// Import your providers
import 'package:koudissa_gessie_master_prg19_examen/providers/auth_provider.dart';
import 'package:koudissa_gessie_master_prg19_examen/providers/project_provider.dart';
import 'package:koudissa_gessie_master_prg19_examen/providers/task_provider.dart';
import 'package:koudissa_gessie_master_prg19_examen/providers/theme_provider.dart';
// Import your screens
import 'package:koudissa_gessie_master_prg19_examen/screens/splash_screen.dart';
import 'package:koudissa_gessie_master_prg19_examen/config/theme.dart';
import 'package:koudissa_gessie_master_prg19_examen/config/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ProjectProvider()),
        ChangeNotifierProvider(create: (_) => TaskProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'Project Management App',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.themeMode,
            initialRoute: AppRoutes.splash,
            routes: AppRoutes.routes,
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}