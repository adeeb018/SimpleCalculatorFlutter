import 'dart:ffi';
import 'dart:math';

import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  Color scaffoldBackgroundColor = Colors.white; // used for generating random colors

  String textView = ''; // the displaying text

  // to know the first sign of digit
  bool firstSign = true;

  double firstNum = 0; // add next number with this number

  String currentOpn = ''; // when entering next number operation to be performed is saved here

  //the function is to check if there is any operation to be performed on new number
  //if there is anything to perform then current number and first number will act as operands
  //and the operator will be in string currentOpn.
  String check(String number){
    if (currentOpn.isNotEmpty) {
      textView = '';
      switch (currentOpn) {
        case '+':
          number = (firstNum + double.parse(number))
              .toString(); // adding current and previous and convert to string
          firstNum = double.parse(number);
          break;
        case '-':
          number = (firstNum - double.parse(number))
              .toString(); // subtracting current and previous and convert to string
          firstNum = double.parse(number);
          break;
        case '/':
          number = (firstNum / double.parse(number))
              .toString(); // dividing current and previous and convert to string
          firstNum = double.parse(number);
          break;
        case '*':
          number = (firstNum * double.parse(number))
              .toString(); // multiplying current and previous and convert to string
          firstNum = double.parse(number);
          break;
        case '%':
          number = (firstNum % double.parse(number))
              .toString(); // taking modulus current and previous and convert to string
          firstNum = double.parse(number);
          break;
        default :
          const snackBar = SnackBar(
            content: Text('Error'), duration: Duration(seconds: 2),);
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          break;
      }
      currentOpn = ''; // set to empty for stopping next number to use same operation
    }
    return number;
  }


  // this function is used to display the number on UI.
  int _setNumberOnScreen(String number) {

    number = check(number); //checking if any operation is to be performed on number

    //change the text in UI with new inputs
    setState(() {
      textView = textView + number;
    });
    return 0;
  }

  // this function will clear the screen and set all the values to initial point.
  void _clearScreen() {
    firstSign = true;
    firstNum = 0;
    currentOpn = '';

    //clear the text field
    setState(() {
      textView = '';
    });
  }

  // this function is used to clear the last entered data
  void _backLastTyped() {
    setState(() {
      if(textView != '') {
        textView = textView.substring(0, textView.length - 1); // last character is ignored
      }
    });
  }


  // this function is checking some conditions
  // 1.if an operation come before entering number. example if input come as -2+3,here -2 should evaluated
  // for that we use firstSign , a variable which will be true if + or - come as first, no other operator should came first.

  void _setOperations(String opn) {
    if (textView.isEmpty) {
      if (opn == '-' || opn == '+') {
        if (opn == '-') {
          _setNumberOnScreen('-'); // adding - to the first of screen
        } else {
          _setNumberOnScreen('+'); // adding + to the first of screen
        }
        firstSign = false; // so that we know the first digit is negative
      }
      return;
    }
    // here if the operator came after some value in textview then we have to check whether
    // the previous number has some sign on it.
    if (firstSign == false) {
      firstNum = double.parse(textView);
    }
    else {
      if (double
          .parse(textView)
          .isNaN) {
        _clearScreen();
        return;
      }
      firstNum = double.parse(textView);
    }
    currentOpn = opn;

    //changing the UI with by adding operator with it.
    setState(() {
      textView = textView + opn;
    });
  }

  void changeBackgroundColor() {
    scaffoldBackgroundColor = getRandomColor();
    setState(() {

    });
  }

  Color getRandomColor() {
    Random random = Random();
    return Color.fromRGBO(
        random.nextInt(255), random.nextInt(255), random.nextInt(255), 1.0);
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      backgroundColor: scaffoldBackgroundColor,
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Colors.green,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              textView,
              style: const TextStyle(
                  fontSize: 30, fontWeight: FontWeight.bold),),
            const Padding(padding: EdgeInsets.only(bottom: 20)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _clearScreen();
                  },
                  style: ElevatedButton.styleFrom(
                      primary: Colors.black54,
                      onPrimary: Colors.white,
                      shape:
                      const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero
                      )
                  ),
                  child: const Text('AC'),
                ),
                const Padding(padding: EdgeInsets.only(right: 10)),
                ElevatedButton(
                  onPressed: () {
                    _setOperations('%');
                  },
                  style: ElevatedButton.styleFrom(
                      primary: Colors.black54,
                      onPrimary: Colors.white,
                      shape:
                      const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero
                      )
                  ),
                  child: const Text('%'),
                ),
                const Padding(padding: EdgeInsets.only(right: 10)),
                ElevatedButton(
                  onPressed: () {
                    _backLastTyped();
                  },
                  style: ElevatedButton.styleFrom(
                      primary: Colors.black54,
                      onPrimary: Colors.white,
                      shape:
                      const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero
                      )
                  ),
                  child: const Text('BA'),
                ),
                const Padding(padding: EdgeInsets.only(right: 10)),
                ElevatedButton(
                  onPressed: () {
                    _setOperations('*');
                  },
                  style: ElevatedButton.styleFrom(
                      primary: Colors.black54,
                      onPrimary: Colors.white,
                      shape:
                      const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero
                      )
                  ),
                  child: const Text('*'),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _setNumberOnScreen('7');
                  },
                  style: ElevatedButton.styleFrom(
                      primary: Colors.black54,
                      onPrimary: Colors.white,
                      shape:
                      const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero
                      )
                  ),
                  child: const Text('7'),
                ),
                const Padding(padding: EdgeInsets.only(right: 10)),
                ElevatedButton(
                  onPressed: () {
                    _setNumberOnScreen('8');
                  },
                  style: ElevatedButton.styleFrom(
                      primary: Colors.black54,
                      onPrimary: Colors.white,
                      shape:
                      const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero
                      )
                  ),
                  child: const Text('8'),
                ),
                const Padding(padding: EdgeInsets.only(right: 10)),
                ElevatedButton(
                  onPressed: () {
                    _setNumberOnScreen('9');
                  },
                  style: ElevatedButton.styleFrom(
                      primary: Colors.black54,
                      onPrimary: Colors.white,
                      shape:
                      const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero
                      )
                  ),
                  child: const Text('9'),
                ),
                const Padding(padding: EdgeInsets.only(right: 10)),
                ElevatedButton(
                  onPressed: () {
                    _setOperations('/');
                  },
                  style: ElevatedButton.styleFrom(
                      primary: Colors.black54,
                      onPrimary: Colors.white,
                      shape:
                      const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero
                      )
                  ),
                  child: const Text('/'),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _setNumberOnScreen('4');
                  },
                  style: ElevatedButton.styleFrom(
                      primary: Colors.black54,
                      onPrimary: Colors.white,
                      shape:
                      const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero
                      )
                  ),
                  child: const Text('4'),
                ),
                const Padding(padding: EdgeInsets.only(right: 10)),
                ElevatedButton(
                  onPressed: () {
                    _setNumberOnScreen('5');
                  },
                  style: ElevatedButton.styleFrom(
                      primary: Colors.black54,
                      onPrimary: Colors.white,
                      shape:
                      const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero
                      )
                  ),
                  child: const Text('5'),
                ),
                const Padding(padding: EdgeInsets.only(right: 10)),
                ElevatedButton(
                  onPressed: () {
                    _setNumberOnScreen('6');
                  },
                  style: ElevatedButton.styleFrom(
                      primary: Colors.black54,
                      onPrimary: Colors.white,
                      shape:
                      const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero
                      )
                  ),
                  child: const Text('6'),
                ),
                const Padding(padding: EdgeInsets.only(right: 10)),
                ElevatedButton(
                  onPressed: () {
                    _setOperations('+');
                  },
                  style: ElevatedButton.styleFrom(
                      primary: Colors.black54,
                      onPrimary: Colors.white,
                      shape:
                      const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero
                      )
                  ),
                  child: const Text('+'),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _setNumberOnScreen('1');
                  },
                  style: ElevatedButton.styleFrom(
                      primary: Colors.black54,
                      onPrimary: Colors.white,
                      shape:
                      const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero
                      )
                  ),
                  child: const Text('1'),
                ),
                const Padding(padding: EdgeInsets.only(right: 10)),
                ElevatedButton(
                  onPressed: () {
                    _setNumberOnScreen('2');
                  },
                  style: ElevatedButton.styleFrom(
                      primary: Colors.black54,
                      onPrimary: Colors.white,
                      shape:
                      const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero
                      )
                  ),
                  child: const Text('2'),
                ),
                const Padding(padding: EdgeInsets.only(right: 10)),
                ElevatedButton(
                  onPressed: () {
                    _setNumberOnScreen('3');
                  },
                  style: ElevatedButton.styleFrom(
                      primary: Colors.black54,
                      onPrimary: Colors.white,
                      shape:
                      const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero
                      )
                  ),
                  child: const Text('3'),
                ),
                const Padding(padding: EdgeInsets.only(right: 10)),
                ElevatedButton(
                  onPressed: () {
                    _setOperations('-');
                  },
                  style: ElevatedButton.styleFrom(
                      primary: Colors.black54,
                      onPrimary: Colors.white,
                      shape:
                      const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero
                      )
                  ),
                  child: const Text('-'),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _setNumberOnScreen('00');
                  },
                  style: ElevatedButton.styleFrom(
                      primary: Colors.black54,
                      onPrimary: Colors.white,
                      shape:
                      const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero
                      )
                  ),
                  child: const Text('00'),
                ),
                const Padding(padding: EdgeInsets.only(right: 10)),
                ElevatedButton(
                  onPressed: () {
                    _setNumberOnScreen('0');
                  },
                  style: ElevatedButton.styleFrom(
                      primary: Colors.black54,
                      onPrimary: Colors.white,
                      shape:
                      const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero
                      )
                  ),
                  child: const Text('0'),
                ),
                const Padding(padding: EdgeInsets.only(right: 10)),
                ElevatedButton(
                  onPressed: () {
                    _setNumberOnScreen('.');
                  },
                  style: ElevatedButton.styleFrom(
                      primary: Colors.black54,
                      onPrimary: Colors.white,
                      shape:
                      const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero
                      )
                  ),
                  child: const Text('.'),
                ),
                const Padding(padding: EdgeInsets.only(right: 10)),
                ElevatedButton(
                  onPressed: () {
                  changeBackgroundColor();
                  },
                  style: ElevatedButton.styleFrom(
                      primary: Colors.black54,
                      onPrimary: Colors.white,
                      shape:
                      const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero
                      )
                  ),
                  child: const Text(''),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
