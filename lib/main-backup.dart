import './app/services/api.dart';
import './app/services/api_service.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '5KRs',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
      ),
      home: const MyHomePage(title: '5KRs Sandbox'),
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
  String _keyresult = '';
  String _prompt = '';
  bool _isLoading = false;

  void _updateKeyResult(objective) async {
    setState(() => _isLoading = true);
    final apiService = APIService(API.sandbox());
    final keyresult = await apiService.getKeyResult(objective);
    setState(() => _keyresult = keyresult);
    setState(() => _prompt = objective);
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController textController = TextEditingController();
    textController.text = _prompt;
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 10),
              Expanded(
                flex: 3,
                child: Align(
                  child: !_isLoading
                      ? Text(
                          '${_keyresult}',
                          style: Theme.of(context).textTheme.headlineMedium,
                        )
                      : SizedBox(
                          child: CircularProgressIndicator(),
                          height: 100.0,
                          width: 100.0,
                        ),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: textController,
                maxLines: 5,
                cursorColor: Colors.red,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Grow product adoption amongst senior citizens.',
                  hintStyle:
                      TextStyle(fontSize: 20.0, color: Colors.orangeAccent),
                  filled: true,
                  fillColor: Colors.redAccent,
                  border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                  onPressed: () => _updateKeyResult(textController.text),
                  child: Text("Next KR")),
            ],
          ),
        ),
      ),
    );
  }
}
