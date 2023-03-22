import 'dart:convert';
import './app/services/api.dart';
import './app/services/api_completion.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import './savedTextPairs.dart';
import './textCard.dart';

const primaryColor = Color(0xFFFFFFFF);

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '5KRs',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
      ),
      home: const MyHomePage(title: '5KRs Marketing'),
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
  String keyResultText = '';
  String objectiveText =
      'Increase Marketing Campaign Response by 5% in 90 days';
  bool _isLoadingTop = false;
  bool _isLoadingBottom = false;
  List<Map<String, String>> savedTextPairs = [];
  int _currentPageIndex = 0;

  PageController _pageController = PageController(); // Add this line

  void onPageChanged(int index) {
    setState(() {
      _currentPageIndex = index;
    });
  }

  void updateSavedTextPairs(List<Map<String, String>> updatedPairs) {
    setState(() {
      savedTextPairs = updatedPairs;
    });
  }

  List<String> keyResultTextResults =
      List<String>.filled(100, '', growable: false);
  List<String> objectiveTextResults =
      List<String>.filled(100, '', growable: false);

  Future<String> _refreshKeyResultsText(String prompt) async {
    final apiCompletion = APIService(API.sandbox());
    final keyresult = await apiCompletion.getCompletion(
        prompt, '< MARKETING KEY RESULTS MODEL >');
    return keyresult;
  }

  Future<String> _refreshObjectiveText(String prompt) async {
    final apiCompletion = APIService(API.sandbox());
    final objective = await apiCompletion.getCompletion(
        prompt, '< MARKETING OBJECTIVES MODEL >');
    return objective;
  }

  void refreshTopText(String newPrompt) async {
    setState(() => _isLoadingTop = true);
    String newText = await _refreshKeyResultsText(newPrompt);
    setState(() {
      keyResultText = newText;
      _isLoadingTop = false;
      for (int i = 0; i < keyResultTextResults.length - 1; i++) {
        keyResultTextResults[i] = keyResultTextResults[i + 1];
      }
      keyResultTextResults[keyResultTextResults.length - 1] = newText;
    });
  }

  void refreshBottomText(String newPrompt) async {
    setState(() => _isLoadingBottom = true);
    String newText = await _refreshObjectiveText(newPrompt);
    setState(() {
      objectiveText = newText;
      _isLoadingBottom = false;
      for (int i = 0; i < objectiveTextResults.length - 1; i++) {
        objectiveTextResults[i] = objectiveTextResults[i + 1];
      }
      objectiveTextResults[objectiveTextResults.length - 1] = newText;
    });
  }

  void onTapKeyResult() {
    refreshTopText(objectiveText);
  }

  void onTapObjective() {
    refreshBottomText('marketing');
  }

  Widget _buildLoadingDots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircularProgressIndicator(),
      ],
    );
  }

  void onHeartButtonClick() {
    Map<String, String> newPair = {
      'keyResult': keyResultText.trim(),
      'objective': objectiveText.trim()
    };
    if (!_isDuplicate(newPair)) {
      setState(() {
        savedTextPairs.add({
          'keyResult': keyResultText.trim(),
          'objective': objectiveText.trim(),
        });
      });
    }
  }

  Widget buildHeartButton() {
    return IconButton(
      icon: Icon(Icons.favorite, color: Colors.red),
      onPressed: onHeartButtonClick,
      iconSize: 48,
    );
  }

  bool _isDuplicate(Map<String, String> textPair) {
    for (var pair in savedTextPairs) {
      if (pair['keyResult'] == textPair['keyResult'] &&
          pair['objective'] == textPair['objective']) {
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: RichText(
          text: TextSpan(
            children: <TextSpan>[
              TextSpan(
                text: '5KRs\n',
                style:
                    TextStyle(color: Colors.black.withOpacity(1), fontSize: 22),
              ),
              TextSpan(
                text: 'Marketing OKR generator',
                style: TextStyle(color: Colors.black, fontSize: 14),
              ),
            ],
          ),
          textAlign: TextAlign.center,
        ),
        backgroundColor: primaryColor,
      ),
      body: PageView(
        controller: _pageController, // Add this line
        onPageChanged: onPageChanged,
        children: [
          Column(
            children: [
              Expanded(
                child: GestureDetector(
                  onHorizontalDragEnd: (dragDetails) {
                    if ((dragDetails.primaryVelocity ?? 0) > 0) {
                      onTapObjective();
                    }
                  },
                  child: InkWell(
                    onTap: onTapObjective,
                    child: Center(
                        child: TextCard(
                            text: objectiveText.trim(),
                            header: 'Objective',
                            isLoading: _isLoadingBottom)),
                  ),
                ),
              ),
              buildHeartButton(),
              Expanded(
                child: GestureDetector(
                  onHorizontalDragEnd: (dragDetails) {
                    if ((dragDetails.primaryVelocity ?? 0) > 0) {
                      onTapKeyResult();
                    }
                  },
                  child: InkWell(
                    onTap: onTapKeyResult,
                    child: Center(
                      child: TextCard(
                          text: keyResultText.trim(),
                          header: 'Key Result',
                          isLoading: _isLoadingTop),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SavedTextPairsPage(
            savedTextPairs: savedTextPairs,
            onUpdateSavedTextPairs: updateSavedTextPairs,
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentPageIndex,
        onTap: (int index) {
          setState(() {
            _currentPageIndex = index;
          });
          _pageController.animateToPage(
            index,
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Saved',
          ),
        ],
      ),
    );
  }
}
