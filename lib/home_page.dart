import 'dart:ffi';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter/material.dart';
import 'package:simplecalcflutter/screen.dart';
import 'package:sqflite/sqflite.dart';
import 'package:simplecalcflutter/database_helper.dart';

import 'main.dart';

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
  Color scaffoldBackgroundColor =
      Colors.white; // used for generating random colors

  String textView = ''; // the displaying text

  // to know the first sign of digit
  bool firstSign = true;

  double firstNum = 0; // add next number with this number

  String currentOpn =
      ''; // when entering next number operation to be performed is saved here

  //the function is to check if there is any operation to be performed on new number
  //if there is anything to perform then current number and first number will act as operands
  //and the operator will be in string currentOpn.

  String check(String number) {
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
        default:
          const snackBar = SnackBar(
            content: Text('Error'),
            duration: Duration(seconds: 2),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          break;
      }
      currentOpn =
          ''; // set to empty for stopping next number to use same operation
    }
    return number;
  }

  // this function is used to display the number on UI.
  void _setNumberOnScreen(String number) {
    if (textView != '') {
      if (double.tryParse(textView) == null) {
        textView = '';
      }
    }

    //number = check(number); //checking if any operation is to be performed on number
    //change the text in UI with new inputs
    setState(() {
      textView = textView + number;
    });
    return;
  }

  String _equalTo() {
    String number = check(textView);

    setState(() {
      textView = textView + number;
    });

    return textView;
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
      if (textView != '') {
        textView = textView.substring(
            0, textView.length - 1); // last character is ignored
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
    } else {
      if (double.parse(textView).isNaN) {
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
    scaffoldBackgroundColor = _getRandomColor();
    setState(() {});
  }

  Color _getRandomColor() {
    Random random = Random();
    return Color.fromRGBO(
        random.nextInt(255), random.nextInt(255), random.nextInt(255), 1.0);
  }

  //create new shared preference for background
  void _setSharedPrefsThemeColor() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('background1', 'white');
  }

  // change the Bg color
  void changeThemeColor() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? counter = prefs.getString('background1');

    if (counter == null) {
      _setSharedPrefsThemeColor();
    }

    if (counter == 'white') {
      prefs.setString('background1', 'black');
    } else {
      prefs.setString('background1', 'white');
    }

    setState(() {
      scaffoldBackgroundColor =
          counter == 'white' ? Colors.green : Colors.white;
    });

    // counter = null;
  }

  //This function check for previous background color and set background color on loading
  void setThemeColorOnLoading() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? counter = prefs.getString('background1');

    if (counter == null) {
      prefs.setString('background1', 'white');
      counter = prefs.getString('background1');
    }

    scaffoldBackgroundColor = counter == 'white' ? Colors.white : Colors.green;

    setState(() {});
  }

  //used for initiating checking for previous background property
  @override
  void initState() {
    // TODO: implement initState
    setThemeColorOnLoading();
    super.initState();
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
      appBar: appBar(),
      body: scaffoldBody(context),
    );
  }

  Center scaffoldBody(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            textView,
            style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          const Padding(padding: EdgeInsets.only(bottom: 20)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              clearField(),
              const Padding(padding: EdgeInsets.only(right: 10)),
              elevatedButton('%'),
              const Padding(padding: EdgeInsets.only(right: 10)),
              backField(),
              const Padding(padding: EdgeInsets.only(right: 10)),
              elevatedButton('*'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              numberButton('7'),
              const Padding(padding: EdgeInsets.only(right: 10)),
              numberButton('8'),
              const Padding(padding: EdgeInsets.only(right: 10)),
              numberButton('9'),
              const Padding(padding: EdgeInsets.only(right: 10)),
              elevatedButton('/')
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              numberButton('4'),
              const Padding(padding: EdgeInsets.only(right: 10)),
              numberButton('5'),
              const Padding(padding: EdgeInsets.only(right: 10)),
              numberButton('6'),
              const Padding(padding: EdgeInsets.only(right: 10)),
              elevatedButton('+'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              numberButton('1'),
              const Padding(padding: EdgeInsets.only(right: 10)),
              numberButton('2'),
              const Padding(padding: EdgeInsets.only(right: 10)),
              numberButton('3'),
              const Padding(padding: EdgeInsets.only(right: 10)),
              elevatedButton('-')
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              numberButton('00'),
              const Padding(padding: EdgeInsets.only(right: 10)),
              numberButton('0'),
              const Padding(padding: EdgeInsets.only(right: 10)),
              numberButton('.'),
              const Padding(padding: EdgeInsets.only(right: 10)),
              ElevatedButton(
                onPressed: () {
                  // changeBackgroundColor();
                  double? value = double.tryParse(_equalTo());
                  if(value == null) {
                    return;
                  }
                  _insert(value);
                  // someFunction();
                  Navigator.of(context).push(_createRoute());
                },
                style: ElevatedButton.styleFrom(
                    primary: Colors.black54,
                    onPrimary: Colors.white,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero)),
                child: const Text('='),
              ),
            ],
          ),
        ],
      ),
    );
  }


  //elevated button for deleting the last typed value in textView
  ElevatedButton backField() {
    return ElevatedButton(
              onPressed: () {
                _backLastTyped();
              },
              style: ElevatedButton.styleFrom(
                  primary: Colors.black54,
                  onPrimary: Colors.white,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero)),
              child: const Text('BA'),
            );
  }

  // button for deleting all the texts in textField
  ElevatedButton clearField() {
    return ElevatedButton(
              onPressed: () {
                _clearScreen();
              },
              style: ElevatedButton.styleFrom(
                  primary: Colors.black54,
                  onPrimary: Colors.white,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero)),
              child: const Text('AC'),
            );
  }

  // button function for all the numbers
  ElevatedButton numberButton(String num) {
    return ElevatedButton(
              onPressed: () {
                _setNumberOnScreen(num);
              },
              style: ElevatedButton.styleFrom(
                  primary: Colors.black54,
                  onPrimary: Colors.white,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero)),
              child: Text(num),
            );
  }

  //button function for all the operators
  ElevatedButton elevatedButton(String op) {
    return ElevatedButton(
              onPressed: () {
                _setOperations(op);
              },
              style: ElevatedButton.styleFrom(
                  primary: Colors.black54,
                  onPrimary: Colors.white,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero)),
              child: Text(op),
            );
  }

  AppBar appBar() {
    return AppBar(
      // TRY THIS: Try changing the color here to a specific color (to
      // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
      // change color while the other colors stay the same.
      backgroundColor: Colors.green,
      // Here we take the value from the MyHomePage object that was created by
      // the App.build method, and use it to set our appbar title.
      title: Text(widget.title),

      //button
      actions: [
        IconButton(
            onPressed: changeThemeColor,
            icon: const Icon(Icons.invert_colors))
      ],
    );
  }


  //created route for moving to next page
  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => Screen(),
      //transitionbuilder is optional if we need some animation(but we should write that function and return child)
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        var tween =
        Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        var offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    );
  }


  // insert function used to insert value into sqflite database
  void _insert(double value) async {
    // row to insert
    Map<String, dynamic> row = {DatabaseHelper.columnAge: value};
    final id = await dbHelper.insert(row);
    debugPrint('inserted row id: $id');
  }

  //u= query function is used to retrieve values from database as MAP
  void query() async {
    final allRows = await dbHelper.queryAllRows();
    debugPrint('query all rows:');
    for (final row in allRows) {
      print(row['sums']);
      // debugPrint(row.toString());
    }
  }


}
