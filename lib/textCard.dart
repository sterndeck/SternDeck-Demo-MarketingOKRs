import 'package:flutter/material.dart';

class TextCard extends StatelessWidget {
  final String text;
  final String header;
  final bool isLoading;

  TextCard({
    required this.text,
    required this.header,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints.expand(),
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        margin: EdgeInsets.all(16.0),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: isLoading
                ? CircularProgressIndicator()
                : RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                          text: header + '\n\n',
                          style: TextStyle(
                              color: Colors.black.withOpacity(0.7),
                              fontSize: 18),
                        ),
                        TextSpan(
                          text: text,
                          style: TextStyle(color: Colors.black, fontSize: 28),
                        ),
                      ],
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
