import 'dart:math';

String mean (String userInput, int precision) {
  var sArray = userInput.split(",");
  var iArray = [];
  var length = sArray.length;
  var iter = 0;
  for(iter=0; iter<length; iter++)
    iArray.add(double.parse(sArray[iter]));
  var sum = iArray.fold(0, (a, b) => a + b);
  var mean = sum/length;
  return mean.toStringAsPrecision(precision);
}

String median (String userInput, int precision) {
  var sArray = userInput.split(",");
  var iArray = [];
  var length = sArray.length;
  var iter = 0;
  for(iter=0; iter<length; iter++)
    iArray.add(double.parse(sArray[iter]));
  iArray.sort();
  var median = 0.0;
  if(length % 2 == 1)
    {
      median = iArray[((length-1)/2).truncate()];
      return median.toString();
    }
  median = (((iArray[((length-1)/2).floor()] + iArray[((length-1)/2).ceil()]))/2);
  return median.toStringAsPrecision(precision);
}

String mode (String userInput, int precision) {
  var sArray = userInput.split(",");
  var iArray = [];
  var length = sArray.length;
  var iter = 0;
  var mode = 0.0;
  for(iter=0; iter<length; iter++)
    iArray.add(double.parse(sArray[iter]));
  var popular = Map();

  iArray.forEach((number) {
    if(!popular.containsKey(number)) {
      popular[number] = 1;
    } else {
      popular[number] +=1;
    }
  });
  var values = [];
  popular.forEach((key, value) {
    values.add(value);
  });
  values.sort();
  var modalValue = values[values.length - 1];
  popular.forEach((key, value) {
    if(value == modalValue)
      mode=key;
  });
  return mode.toStringAsPrecision(precision);
}

String range (String userInput, int precision) {
  var sArray = userInput.split(",");
  var iArray = [];
  var length = sArray.length;
  var iter = 0;
  for(iter=0; iter<length; iter++)
    iArray.add(double.parse(sArray[iter]));
  iArray.sort();
  return (iArray[length-1] - iArray[0]).toStringAsPrecicion(precision);

}

String variance (String userInput, int precision){
  var sArray = userInput.split(",");
  //var iArray = [];
  var length = sArray.length;
  var iter = 0;
  var result = 0.0;
  var avg = double.parse(mean(userInput, precision));
  // for(iter=0; iter<length; iter++)
  //   iArray.add(double.parse(sArray[iter]));
  for(iter=0; iter<length; iter++)
    result += pow(avg - double.parse(sArray[iter]), 2);
  result /= length;
  return result.toStringAsPrecision(precision);

}

String stddev (String userInput, int precision){
  return (pow(double.parse(variance(userInput, 10)),0.5)).toStringAsPrecision(precision);

}

String cv (String userInput, int precision){
  return (double.parse(stddev(userInput, 10))/double.parse(mean(userInput, 10))).toStringAsPrecision(precision);
}