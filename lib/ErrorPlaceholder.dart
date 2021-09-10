import 'package:flutter/material.dart';

class ErrorPlaceholder extends StatelessWidget {
  final String textMessage;
  final GestureTapCallback onPressed;

  const ErrorPlaceholder({Key key, this.textMessage, this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text(textMessage),
        Padding(
          padding: EdgeInsets.all(15.0),
          child: FloatingActionButton(
            onPressed: onPressed,
            tooltip: 'Обновить',
            child: Icon(Icons.refresh),
          ),
        )
      ]),
    ));
  }
}
