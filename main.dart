import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ecommerce_app/blocs/order_provider.dart';
import 'package:flutter_ecommerce_app/blocs/princiapale_provider.dart';
import 'package:flutter_ecommerce_app/blocs/search_bloc.dart';
import 'package:flutter_ecommerce_app/screens/home_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_ecommerce_app/screens/login_screens/phone_signup.dart';
import 'package:flutter_ecommerce_app/screens/main_page.dart';
import 'package:flutter_ecommerce_app/screens/profil_screen.dart';
import 'package:provider/provider.dart';

void main () async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => HomePageBloc(),
          ),
          ChangeNotifierProvider(
            create: (_) => SearchBloc(),
          ),
          ChangeNotifierProvider(
            create: (_) => CartPageProvider(),
          ),
        ],
        child: MyApp(),
      )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Principal(),
    );
  }
}

class Principal extends StatefulWidget {
  @override
  _PrincipalState createState() => _PrincipalState();
}

class _PrincipalState extends State<Principal> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if(snapshot.data!=null){
            return MainPage();
          }else{
            return PhoneSignIn();
          }
        },
      ),
    );
  }
}



