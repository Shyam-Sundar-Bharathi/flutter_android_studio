import 'dart:math';

String area (String userInput, String dropDownValue, int precision) {
  if(dropDownValue == "SQUARE"){
    var side = double.parse(userInput);
    return (side*side).toStringAsPrecision(precision);
  }
  else if(dropDownValue == "CIRCLE"){
    return (3.141592653589793238*double.parse(userInput)*double.parse(userInput)).toStringAsPrecision(precision);
  }
  else if (dropDownValue == "RECTANGLE"){
    var arr = userInput.split(",");
    return (double.parse(arr[0])*double.parse(arr[1])).toStringAsPrecision(precision);
  }
  else if (dropDownValue == "TRIANGLE"){
    var arr = userInput.split(",");
    if (arr.length == 2){
      return (0.5 * double.parse(arr[0]) * double.parse(arr[1])).toStringAsPrecision(precision);
    }
    else if(arr.length == 3){
      var a = double.parse(arr[0]);
      var b = double.parse(arr[1]);
      var c = double.parse(arr[2]);
      var s = (a+b+c)/2;
      return pow(s*(s-a)*(s-b)*(s-c),0.5).toStringAsPrecision(precision);
    }
  }

  else if(dropDownValue == "PARALLELOGRAM"){
    var arr = userInput.split(",");
    return (double.parse(arr[0]) * double.parse(arr[1])).toStringAsPrecision(precision);
  }

  else if(dropDownValue == "RHOMBUS"){
    var arr = userInput.split(",");
    return (0.5 * double.parse(arr[0]) * double.parse(arr[1])).toStringAsPrecision(precision);
  }
}