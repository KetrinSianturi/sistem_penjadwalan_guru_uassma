import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/jadwal_bloc.dart';
import 'bloc/jadwal_event.dart';
import 'ui/post_index_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => JadwalBloc()..add(LoadJadwalEvent()),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Sisfor Jadwal Guru SMA',
        theme: ThemeData(
          primarySwatch: Colors.purple,
          scaffoldBackgroundColor: const Color(0xFFF5F5F5),
        ),
        home: const PostIndexPage(),
      ),
    );
  }
}
