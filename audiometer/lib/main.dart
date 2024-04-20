import 'package:flutter/material.dart';
// import 'package:gauge_indicator/gauge_indicator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dynamic_color/dynamic_color.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Audio Meter',
          theme: ThemeData(
            useMaterial3: true,
            textTheme: GoogleFonts.poppinsTextTheme(),
            primarySwatch: Colors.blue,
            scaffoldBackgroundColor: Colors.white,
            // scaffoldBackgroundColor: lightDynamic?.background ?? Colors.white,
            // primaryColor: darkDynamic?.onPrimaryContainer ?? Colors.white,
          ),
          home: const MyHomePage(title: 'Audio Meter'),
        );
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int currentPageIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.settings),
              color: Colors.blue,
            ),
            Text(
              widget.title,
              style: GoogleFonts.poppins(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 0, 140, 255),
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.copy),
              color: Colors.blue,
            ),


          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            
            const Text(
              'graph and gauge',
            ),
            ElevatedButton.icon(
                onPressed: () {},
                icon: Icon(
                  Icons.play_arrow,
                  color: Colors.blue,
                ),
                label: Text(
                  'play',
                  style: TextStyle(color: Colors.blue),
                ))
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: Colors.blue,
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(
              Icons.multitrack_audio_rounded,
              color: Colors.white,
            ),
            icon: Icon(Icons.multitrack_audio_rounded, color: Colors.grey),
            label: 'Decibel Meter',
          ),
          NavigationDestination(
            selectedIcon: Icon(
              Icons.help_outline,
              color: Colors.white,
            ),
            icon: Badge(child: Icon(Icons.help_outline, color: Colors.grey)),
            label: 'help',
          ),
        ],
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
      ),
    );
  }
}
