import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:dream_calc/services/drawer.dart';
import 'package:dream_calc/services/buttons.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:math_expressions/math_expressions.dart';

extension Ex on double {
  String toStringAsFixedNoZero(int n) =>
      double.parse(this.toStringAsFixed(n)).toString();
}

class genCalc extends StatefulWidget {
  @override
  _genCalcState createState() => _genCalcState();
}

class _genCalcState extends State<genCalc> {

  Map data = {
    'precision' : 4,
    'colourTheme' : "BLUE",
  };
  TextEditingController userInput = new TextEditingController();
  var cursorPos;
  var answer = '';
  final List<String> buttons = [
    'MENU',
    '( )',
    '^',
    'DEL/CLR',
    '7',
    '8',
    '9',
    '/',
    '4',
    '5',
    '6',
    'x',
    '1',
    '2',
    '3',
    '-',
    '0',
    '.',
    '=',
    '+',
  ];
  int tappedIndex = -1;
  void tapped(int index) async {
    setState(() => tappedIndex = index);
    await Future.delayed(Duration(milliseconds: 200));
    setState(() => tappedIndex = -1);
  }

  bool isOperator(String x) {
    if (x == '/' || x == 'x' || x == '-' || x == '+' || x == '=' || x == '^' ) {
      return true;
    }
    return false;
  }

  void insertText(String myText) {
    cursorPos = userInput.selection.base.offset;
    if(cursorPos < 0)
      userInput.text += myText;
    else
      {
        final text = userInput.text;
        final textSelection = userInput.selection;
        final newText = text.replaceRange(
          textSelection.start,
          textSelection.end,
          myText,
        );
        final myTextLength = myText.length;
        userInput.text = newText;
        userInput.selection = textSelection.copyWith(
          baseOffset: textSelection.start + myTextLength,
          extentOffset: textSelection.start + myTextLength,
        );
      }
    isOperator(myText)? null : evaluate(userInput.text);
  }

  void insertOperator(String operator) {
    if(userInput.text.length == 0)
      if(operator=='-')
        userInput.text+=operator;
      else
        return;

    //
    else if(isOperator(userInput.text[userInput.text.length-1]))
      if(operator=='-')
        userInput.text+= '(-' ;
      else
        if(userInput.text[userInput.text.length-2]=='(')
          return;
        else
          setState(() {
            userInput.text = userInput.text.substring(0,userInput.text.length-1) + operator;
          });

    else if(userInput.text[userInput.text.length-1]=='(')
      if(operator == '-')
        userInput.text += '-';
      else
        return;

    else
      insertText(operator);
  }

  void parenthesis() {
    int open = '('.allMatches(userInput.text).length;
    int close = ')'.allMatches(userInput.text).length;
    if(open==0){
      userInput.text+='(';
      return;
    }
    if(open>close){
      if(isOperator(userInput.text[userInput.text.length - 1]) || userInput.text[userInput.text.length - 1]=='('){
        userInput.text+='(';
      }
      else
        userInput.text+=')';
    }
    else if(open==close){
      if(isOperator(userInput.text[userInput.text.length - 1])){
        userInput.text+='(';
      }
      else
        userInput.text+="x(";
    }

  }

  void backSpace() {
    if(userInput.text.length == 0)
      return;
    cursorPos = userInput.selection.base.offset;
    if(cursorPos < 0)
      userInput.text = userInput.text.substring(0, userInput.text.length - 1);
    else
      {
        final text = userInput.text;
        final textSelection = userInput.selection;
        final selectionLength = textSelection.end - textSelection.start;
        // There is a selection.
        if (selectionLength > 0) {
          final newText = text.replaceRange(
            textSelection.start,
            textSelection.end,
            '',
          );
          userInput.text = newText;
          userInput.selection = textSelection.copyWith(
            baseOffset: textSelection.start,
            extentOffset: textSelection.start,
          );
        }
        else
          {

            final offset = 1;
            final newStart = textSelection.start - offset;
            final newEnd = textSelection.start;
            final newText = text.replaceRange(
              newStart,
              newEnd,
              '',
            );
            userInput.text = newText;
            userInput.selection = textSelection.copyWith(
              baseOffset: newStart,
              extentOffset: newStart,
            );
          }
      }
    if(userInput.text.length == 0)
      setState(() {
        answer="";
      });
    else if (isOperator(userInput.text[userInput.text.length - 1]))
      evaluate(userInput.text.substring(0,userInput.text.length-1));
    else
      evaluate(userInput.text);
  }

  void evaluate(String input) {
    String finaluserinput = input.replaceAll('x', '*');
    Parser p = Parser();
    try{
      Expression exp = p.parse(finaluserinput);
      ContextModel cm = ContextModel();
      double eval = exp.evaluate(EvaluationType.REAL, cm);
      setState(() {
        answer = eval.toStringAsFixedNoZero(precision);
      });
      //print("END TRY");
    }
    on FormatException {
      try{
        int open = '('.allMatches(userInput.text).length;
        int close = ')'.allMatches(userInput.text).length;
        if(open == close + 1)
          finaluserinput += ')';
        else{
          finaluserinput = finaluserinput.replaceAll('(', '');
          finaluserinput = finaluserinput.replaceAll(')', '');
        }
        if(finaluserinput.length == 0){
          setState(() {
            answer='';
          });
          return;
        }
        Expression exp = p.parse(finaluserinput);
        ContextModel cm = ContextModel();
        double eval = exp.evaluate(EvaluationType.REAL, cm);
        setState(() {
          answer = eval.toStringAsFixedNoZero(precision);
        });
      }
      on Exception{
        setState(() {
          answer == 'The expression is incorrect';
        });
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    data = data.isNotEmpty ? data : ModalRoute.of(context).settings.arguments;
    precision = data['precision'];
    SystemChrome.setEnabledSystemUIOverlays([]);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white70,
      appBar: AppBar(
        title: Text(
          "General Caculator",
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.black,
      ),
      drawer: myDrawer(),
      body: Column(
          children: [
            Expanded(
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      padding: EdgeInsets.all(20),
                      alignment: Alignment.centerRight,
                      child: TextField(
                        readOnly: true,
                        showCursor: true,
                        textAlign: TextAlign.right,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                        ),
                        controller: userInput,
                        style: TextStyle(
                          fontSize: 25,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(15),
                      alignment: Alignment.centerRight,
                      child: Text(
                        answer,
                        overflow: TextOverflow.clip,
                        softWrap: false,
                        style: TextStyle(
                          fontSize: 30,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              flex:3,
              child: Container(
                color: Colors.black87,
                child: GridView.builder(
                  itemCount: buttons.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                  ),
                  itemBuilder: (BuildContext context, int index){
                    if(index == 0){
                      return MyButton(
                        buttontapped: (){
                          print('tapped');
                          tapped(index);
                        },
                        color: tappedIndex == index? Colors.green[700] : Colors.green[300],
                        textColor: Colors.black,
                        buttonText: buttons[index],
                      );
                    }
                    //parenthesis
                    if(index == 1){
                      return MyButton(
                        buttontapped: (){
                          tapped(index);
                          parenthesis();
                          evaluate(userInput.text);
                        },

                        color: tappedIndex == index? Colors.blue : Colors.blueAccent,
                        textColor: Colors.black,
                        buttonText: buttons[index],
                      );
                    }
                    //DELCLRBUTTON
                     if(index == 3){
                      return MyButton(
                        buttontapped: (){
                          tapped(index);
                          backSpace();
                          },
                        buttonlongpressed: (){
                          tapped(index);
                          setState(() {
                            userInput.text='';
                            answer='';
                          });
                        },
                        buttonText: buttons[index],
                        color: tappedIndex == index ? Colors.red[500] : Colors.red[300],
                        textColor: Colors.black,
                        fontSize: 20.0,
                      );
                    }
                    // Equal button
                    else if (index == 18) {
                      return MyButton(
                        buttontapped: () {
                          tapped(index);
                          if((answer == '' || answer == '0') && userInput.text != '')
                            setState(() {
                              answer = "The expression is incorrect";
                            });
                          else if (answer == 'The expression is incorrect')
                            null;
                          else
                            setState(() {
                              userInput.text = answer;
                              answer="";
                            });
                        },
                        buttonText: buttons[index],
                        color: tappedIndex == index? Colors.green : Colors.greenAccent[400],
                        textColor: Colors.white,
                      );
                    }
                    //other buttons
                    else{
                      return MyButton(
                        buttontapped: () {
                          tapped(index);
                          if(isOperator(buttons[index]))
                            insertOperator(buttons[index]);
                          else
                            setState(() {
                              insertText(buttons[index]);
                            });
                          //isOperator(buttons[index]) ? null : evaluate(userInput.text);
                        },
                        buttonText: buttons[index],
                        color: isOperator(buttons[index])
                            ? tappedIndex == index? Colors.blue : Colors.blueAccent
                            : tappedIndex == index? Colors.grey[400] : Colors.grey[200],
                        textColor: isOperator(buttons[index])
                            ? Colors.white
                            : Colors.black,
                      );
                    }
                  },
                ),
              ),
            ),
          ],
        ),
    );
  }
}

