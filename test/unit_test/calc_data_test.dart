import 'package:calculator_app/utils/calc_data.dart';
import 'package:calculator_app/utils/constants.dart';
import 'package:flutter_test/flutter_test.dart';

/// File to hanlde testing CalcData class constructor
void main() {
  test('Constructor correctly identifies numbers', () {
    int numAmount = 5;

    // Setup list to iterate through with non number values
    List<CalcData> dataList = [
      CalcData('String value'),
      CalcData('C'),
      CalcData('='),
      CalcData('+')
    ];

    // Add numbers to list
    for (int i = 0; i < numAmount; i++) {
      dataList.add(CalcData(i.toString()));
    }

    // Expect that there are the same amount of CalcButtonData objects in the list as filled with the for loop
    expect(
        dataList.where((element) => element.buttonType == EnumButtonType.number).length, numAmount);
  });

  test('Constructor correctly sets button types', () {
    CalcData operand = CalcData('+');
    expect(operand.buttonType == EnumButtonType.operand, true);

    CalcData number = CalcData('2');
    expect(number.buttonType == EnumButtonType.number, true);

    CalcData submit = CalcData('=');
    expect(submit.buttonType == EnumButtonType.enter, true);

    CalcData clear = CalcData('C');
    expect(clear.buttonType == EnumButtonType.clear, true);
  });
}
