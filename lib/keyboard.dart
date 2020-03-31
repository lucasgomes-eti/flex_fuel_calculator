import 'package:flutter/material.dart';

class Keyboard extends StatelessWidget {
  const Keyboard({this.onKeyboardTapped, this.onErase, this.onEraseAll, this.onConfig});
  final KeyboardCallback onKeyboardTapped;
  final onErase, onEraseAll, onConfig;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      childAspectRatio: 1.1,
      crossAxisCount: 4,
      children: <Widget>[
        InkWell(
          onTap: () => onKeyboardTapped('7'),
          child: Container(
            child: Center(
              child: Text(
                '7',
                style: TextStyle(fontSize: 36),
              ),
            ),
          ),
        ),
        InkWell(
          onTap: () => onKeyboardTapped('8'),
          child: Container(
            child: Center(
              child: Text(
                '8',
                style: TextStyle(fontSize: 36),
              ),
            ),
          ),
        ),
        InkWell(
          onTap: () => onKeyboardTapped('9'),
          child: Container(
            child: Center(
              child: Text(
                '9',
                style: TextStyle(fontSize: 36),
              ),
            ),
          ),
        ),
        InkWell(
          onTap: onConfig,
          child: Container(
            child: Center(
              child: Icon(Icons.settings),
            ),
          ),
        ),
        InkWell(
          onTap: () => onKeyboardTapped('4'),
          child: Container(
            child: Center(
              child: Text(
                '4',
                style: TextStyle(fontSize: 36),
              ),
            ),
          ),
        ),
        InkWell(
          onTap: () => onKeyboardTapped('5'),
          child: Container(
            child: Center(
              child: Text(
                '5',
                style: TextStyle(fontSize: 36),
              ),
            ),
          ),
        ),
        InkWell(
          onTap: () => onKeyboardTapped('6'),
          child: Container(
            child: Center(
              child: Text(
                '6',
                style: TextStyle(fontSize: 36),
              ),
            ),
          ),
        ),
        SizedBox(),
        InkWell(
          onTap: () => onKeyboardTapped('1'),
          child: Container(
            child: Center(
              child: Text(
                '1',
                style: TextStyle(fontSize: 36),
              ),
            ),
          ),
        ),
        InkWell(
          onTap: () => onKeyboardTapped('2'),
          child: Container(
            child: Center(
              child: Text(
                '2',
                style: TextStyle(fontSize: 36),
              ),
            ),
          ),
        ),
        InkWell(
          onTap: () => onKeyboardTapped('3'),
          child: Container(
            child: Center(
              child: Text(
                '3',
                style: TextStyle(fontSize: 36),
              ),
            ),
          ),
        ),
        InkWell(
          onTap: onEraseAll,
          child: Container(
            child: Center(
              child: Text(
                'AC',
                style: TextStyle(fontSize: 36),
              ),
            ),
          ),
        ),
        SizedBox(),
        InkWell(
          onTap: () => onKeyboardTapped('0'),
          child: Container(
            child: Center(
              child: Text(
                '0',
                style: TextStyle(fontSize: 36),
              ),
            ),
          ),
        ),
        SizedBox(),
        InkWell(
          onTap: onErase,
          child: Container(
            child: Center(
              child: Icon(Icons.arrow_back),
            ),
          ),
        )
      ],
    );
  }
}

typedef KeyboardCallback = void Function(String value);
