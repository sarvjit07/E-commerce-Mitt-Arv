import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'providers/cart_provider.dart';
import 'providers/product_provider.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart'; // Import the register screen

void main() async{

  WidgetsFlutterBinding.ensureInitialized();

  if(kIsWeb){
    await Firebase.initializeApp(options: FirebaseOptions(apiKey: "AIzaSyAx6h2U5JaBDD0pME3PfEWSWOEKtgs6e3E",
  authDomain: "e-com-flutter-f817c.firebaseapp.com",
  projectId: "e-com-flutter-f817c",
  storageBucket: "e-com-flutter-f817c.firebasestorage.app",
  messagingSenderId: "531008692877",
  appId: "1:531008692877:web:389df27378d0f565a178c4",
  measurementId: "G-N4CK84V46C"));
  runApp(const MyApp());
  }else{
    await Firebase.initializeApp();
  }
  
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'E-Commerce App',
            theme: ThemeData(primarySwatch: Colors.blue),
            // Conditional navigation based on authentication status
            home: authProvider.isLoggedIn
                ? const HomeScreen()
                : const LoginScreen(),
            routes: {
              '/home': (context) => const HomeScreen(),
              '/login': (context) => const LoginScreen(),
              '/register': (context) => const RegisterScreen(), // Add register route
            },
          );
        },
      ),
    );
  }
}
