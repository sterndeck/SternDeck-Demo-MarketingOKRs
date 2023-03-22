import 'package:flutter/material.dart';

class SavedTextPairsPage extends StatefulWidget {
  SavedTextPairsPage({
    Key? key,
    required this.savedTextPairs,
    required this.onUpdateSavedTextPairs,
  }) : super(key: key);

  final List<Map<String, String>> savedTextPairs;
  final Function(List<Map<String, String>>) onUpdateSavedTextPairs;

  @override
  _SavedTextPairsPageState createState() => _SavedTextPairsPageState();
}

class _SavedTextPairsPageState extends State<SavedTextPairsPage> {
  List<Map<String, String>> _editableTextPairs = [];
  int _currentPageIndex = 1;
  @override
  void initState() {
    super.initState();
    _editableTextPairs = List.from(widget.savedTextPairs);
  }

  void removePair(int index) {
    setState(() {
      _editableTextPairs.removeAt(index);
    });
    widget.onUpdateSavedTextPairs(_editableTextPairs);
  }

  Widget buildEditableTextPair(BuildContext context, int index) {
    String keyResult = _editableTextPairs[index]['keyResult'] ?? '';
    String objective = _editableTextPairs[index]['objective'] ?? '';

    return Card(
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Objective:',
              style: TextStyle(fontSize: 18, color: Colors.blueGrey[600]),
            ),
            Text(
              objective,
              style: TextStyle(),
            ),
            SizedBox(height: 8),
            Text(
              'Key Result:',
              style: TextStyle(fontSize: 18, color: Colors.blueGrey[600]),
            ),
            Text(keyResult),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => removePair(index),
                  child: Text('Remove'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: _editableTextPairs.length,
        itemBuilder: (BuildContext context, int index) {
          return buildEditableTextPair(context, index);
        },
        padding: EdgeInsets.all(8.0),
      ),
    );
  }
}
