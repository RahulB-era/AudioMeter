import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:noise_meter/noise_meter.dart';
import 'package:permission_handler/permission_handler.dart';

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
  bool _isRecording = false;
  NoiseReading? _latestReading;
  StreamSubscription<NoiseReading>? _noiseSubscription;
  NoiseMeter? noiseMeter;
  double? maxDB = 0.0;
  double? meanDB = 0.0;
  int currentPageIndex = 0;

  void stop() {
    _noiseSubscription?.cancel();
    _noiseSubscription = null;
    setState(() => _isRecording = false);
  }

  void onData(NoiseReading noiseReading) {
    setState(() => _latestReading = noiseReading);
    maxDB = _latestReading?.maxDecibel;
    meanDB = _latestReading?.meanDecibel;
  }

  void onError(Object error) {
    print(error);
    stop();
  }

  /// Check if microphone permission is granted.
  Future<bool> checkPermission() async => await Permission.microphone.isGranted;

  /// Request the microphone permission.
  Future<void> requestPermission() async =>
      await Permission.microphone.request();

  /// Start noise sampling.
  Future<void> start() async {
    // Create a noise meter, if not already done.
    noiseMeter ??= NoiseMeter();

    // Check permission to use the microphone.
    if (!(await checkPermission())) await requestPermission();

    // Listen to the noise stream.
    _noiseSubscription = noiseMeter?.noise.listen(onData, onError: onError);
    setState(() => _isRecording = true);
  }

  @override
  void initState() {
    super.initState();
    start();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.settings),
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
              icon: const Icon(Icons.copy),
              color: Colors.blue,
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            SfRadialGauge(axes: <RadialAxis>[
              RadialAxis(minimum: 0, maximum: 150, ranges: <GaugeRange>[
                GaugeRange(
                    startValue: 0,
                    endValue: 50,
                    color: Colors.green,
                    startWidth: 10,
                    endWidth: 10),
                GaugeRange(
                    startValue: 50,
                    endValue: 100,
                    color: Colors.orange,
                    startWidth: 10,
                    endWidth: 10),
                GaugeRange(
                    startValue: 100,
                    endValue: 150,
                    color: Colors.red,
                    startWidth: 10,
                    endWidth: 10)
              ], pointers: <GaugePointer>[
                NeedlePointer(value: maxDB ?? 0, enableAnimation: true)
              ], annotations: <GaugeAnnotation>[
                GaugeAnnotation(
                    widget: Container(
                        child: Text('${maxDB!.toStringAsFixed(2)} dB',
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold))),
                    angle: maxDB,
                    positionFactor: 0.5)
              ])
            ]),
            const Text(
              'Danger zone',
            ),
            ElevatedButton.icon(
                onPressed: _isRecording ? stop : start,
                icon: Icon(
                  Icons.play_arrow,
                  color: Colors.blue,
                ),
                label: Text(
                  'Start/Stop',
                  style: TextStyle(color: Colors.blue),
                )),
            Text(
              _isRecording ? "Mic: ON" : "Mic: OFF",
            ),
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
