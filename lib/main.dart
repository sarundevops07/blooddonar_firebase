import 'package:blooddonar_firebase/application/home/blood_donar_bloc.dart';
import 'package:blooddonar_firebase/domain/dependency_injection/injectable.dart';
import 'package:blooddonar_firebase/presentation/add_edit/add_edit.dart';
import 'package:blooddonar_firebase/presentation/home/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureInjection();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<BloodDonarBloc>(),
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
            useMaterial3: true,
          ),
          home: HomePage(),
          routes: {
            "HomePage": (ctx) => HomePage(),
            //  "AddEditDonar": (ctx) => AddEditDonar(),
          }),
    );
  }
}
