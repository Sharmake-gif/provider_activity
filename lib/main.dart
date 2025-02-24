import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:window_size/window_size.dart';

void main() {
  setupWindow();
  runApp(
    ChangeNotifierProvider(
      create: (context) => Counter(),
      child: const MyApp(),
    ),
  );
}

// Constants for window size
const double windowWidth = 360;
const double windowHeight = 640;

// Setup window size for desktop platforms
void setupWindow() {
  if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
    WidgetsFlutterBinding.ensureInitialized();
    setWindowTitle('Provider Counter');
    setWindowMinSize(const Size(windowWidth, windowHeight));
    setWindowMaxSize(const Size(windowWidth, windowHeight));
    getCurrentScreen().then((screen) {
      setWindowFrame(Rect.fromCenter(
        center: screen!.frame.center,
        width: windowWidth,
        height: windowHeight,
      ));
    });
  }
}

// Counter model using ChangeNotifier
class Counter with ChangeNotifier {
  int value = 0;

  void setValue(double newValue) {
    value = newValue.toInt();
    notifyListeners();
  }

  void increase() {
    if (value < 99) {
      value++;
      notifyListeners();
    }
  }

  void decrease() {
    if (value > 0) {
      value--;
      notifyListeners();
    }
  }
}

// Root of the Flutter app
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

// Home Page
class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Age Milestones')),
      body: const CounterDisplay(),
    );
  }
}

// Counter Display Widget
class CounterDisplay extends StatelessWidget {
  const CounterDisplay({super.key});

  Color getBackgroundColor(int age) {
    if (age <= 12) return Colors.blue.shade100;
    if (age <= 19) return Colors.green.shade100;
    if (age <= 30) return Colors.orange.shade100;
    if (age <= 50) return Colors.purple.shade100;
    return Colors.grey.shade300;
  }

  String getMilestoneMessage(int age) {
    if (age <= 12) return "Childhood - Enjoy your early years!";
    if (age <= 19) return "Teenage - Embrace the energy of youth!";
    if (age <= 30) return "Young Adult - Chase your dreams!";
    if (age <= 50) return "Middle Age - Balance and wisdom.";
    return "Senior - Enjoy life with experience!";
  }

  Color getProgressColor(int age) {
    if (age <= 33) return Colors.green;
    if (age <= 67) return Colors.yellow;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    int age = context.watch<Counter>().value;
    return Container(
      color: getBackgroundColor(age),
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            getMilestoneMessage(age),
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Text('Age: $age', style: Theme.of(context).textTheme.headlineMedium),
          Slider(
            value: age.toDouble(),
            min: 0,
            max: 99,
            divisions: 99,
            label: '$age',
            onChanged: (newValue) {
              context.read<Counter>().setValue(newValue);
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: LinearProgressIndicator(
              value: age / 99,
              color: getProgressColor(age),
              backgroundColor: Colors.grey.shade300,
              minHeight: 10,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => context.read<Counter>().decrease(),
                child: const Text('Decrease age'),
              ),
              const SizedBox(width: 20),
              ElevatedButton(
                onPressed: () => context.read<Counter>().increase(),
                child: const Text('Increase age'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
