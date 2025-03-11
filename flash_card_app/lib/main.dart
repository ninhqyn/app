import 'package:flash_card_app/config/routes.dart';
import 'package:flash_card_app/config/routes_name.dart';
import 'package:flash_card_app/features/home/bloc/home_bloc.dart';
import 'package:flash_card_app/features/new_flash_card/bloc/new_flash_card/new_flash_card_bloc.dart';
import 'package:flash_card_app/features/video_play/bloc/video_play_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
void main() {

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => NewFlashCardBloc(),
        ),
        BlocProvider(
          create: (context) => VideoPlayBloc(),
        ),
        BlocProvider(
          create: (context) => HomeBloc(),
        ),

      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
            fontFamily: 'Itim'
        ),
        initialRoute: RoutesName.myHomePage,
        onGenerateRoute: Routes.generateRoute,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

