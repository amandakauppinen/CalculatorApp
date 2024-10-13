import 'package:calculator_app/utils/constants.dart';

/// Contains data pertaining to calculator input
/// Given a [value] sets [buttonType]
class CalcData {
  String value;
  late final EnumButtonType buttonType;

  CalcData(this.value) {
    // Check if value is a number
    if (double.tryParse(value) != null) {
      buttonType = EnumButtonType.number;
    }
    // Otherwise evaluate if it is the enter, clear, or an operand key
    else {
      if (value == Constants.buttons[Constants.entKey]) {
        buttonType = EnumButtonType.enter;
      } else if (value == Constants.buttons[Constants.clrKey]) {
        buttonType = EnumButtonType.clear;
      } else {
        buttonType = EnumButtonType.operand;
      }
    }
  }
}
