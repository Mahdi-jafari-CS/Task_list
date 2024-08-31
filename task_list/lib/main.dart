
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:task_list/data/data.dart';
import 'package:task_list/data/repo/repository.dart';
import 'package:task_list/data/source/hive_task_source.dart';
import 'package:task_list/screens/home/home.dart';

const taskBoxName = 'task';
void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(TaskAdapter());
  Hive.registerAdapter(PriorityAdapter());
  await Hive.openBox<TaskEntity>(taskBoxName);
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: primaryVariantColor));
  runApp(ChangeNotifierProvider<Repository<TaskEntity>>(
    create: (context) => Repository(HiveTaskDataSource(Hive.box(taskBoxName))),
    child: const MyApp()));
}

const Color primaryColor = Color(0xff794cff);
const Color primaryVariantColor = Color(0xff5C0AFF);
const secondaryTextColor = Color(0xffAFBED0);
const normalPriority = Color(0xffF09819);
const highPriority = primaryColor;
const lowPriority = Color(0xff3BE1F1);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    const primaryTextColor = Color(0x0ff1d28c);
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          textTheme: GoogleFonts.poppinsTextTheme(const TextTheme(
              headlineSmall: TextStyle(fontWeight: FontWeight.bold))),
          inputDecorationTheme: const InputDecorationTheme(
              floatingLabelBehavior: FloatingLabelBehavior.never,
              labelStyle: TextStyle(color: secondaryTextColor),
              iconColor: secondaryTextColor,
              border: InputBorder.none),
          // This is the theme of your application.
          //
          // TRY THIS: Try running your application with "flutter run". You'll see
          // the application has a purple toolbar. Then, without quitting the app,
          // try changing the seedColor in the colorScheme below to Colors.green
          // and then invoke "hot reload" (save your changes or press the "hot
          // reload" button in a Flutter-supported IDE, or press "r" if you used
          // the command line to start the app).
          //
          // Notice that the counter didn't reset back to zero; the application
          // state is not lost during the reload. To reset the state, use hot
          // restart instead.
          //
          // This works for code too, not just values: Most code changes can be
          // tested with just a hot reload.
          colorScheme: const ColorScheme.light(
            primary: primaryColor,
            primaryContainer: primaryVariantColor,
            surface: Color(0xffF3F5F8),
            onSurface: primaryTextColor,
            secondary: primaryColor,
            onSecondary: Colors.white,
          ),
          useMaterial3: false,
        ),
        home: HomeScreen());
  }
}
