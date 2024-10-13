import 'package:calculator_app/utils/calc_data.dart';
import 'package:calculator_app/utils/constants.dart';

/// Class to hold non-UI functions
class Functions {
  /// Performs evaluation of full calculator input given a list of the [calcData]
  /// and a callback function when a result is prepared
  static void evaluateExperession(List<CalcData> calcData, Function(String) onCalculate) {
    // Retrieve number of operands
    int opCount = getOpCount(calcData);
    String result = Constants.errorCalculating;

    // Ensure that there is an operand in the string and there are more than 3 provided values
    if (opCount != 0 && calcData.length >= 3) {
      // Continue performing calculations while operands still exist in the data
      while (opCount != 0) {
        // Get index of first multiplication or division operand to evaluate first
        int opIndex =
            calcData.indexWhere((element) => element.value == '*' || element.value == '/');

        // If no multiplication or division operands, get first addition or subtractions
        if (opIndex == -1) {
          opIndex = calcData.indexWhere((element) => element.buttonType == EnumButtonType.operand);
        }

        // If an operand is still somehow not found, set opCount to 0 and exit loop
        if (opIndex == -1) {
          opCount = 0;
        } else {
          // Perform calculation on the number before the operand and the number after the operand
          String result = calculate(
              [calcData[opIndex - 1].value, calcData[opIndex].value, calcData[opIndex + 1].value]);
          // If error calculating, set opCount to 0 and exit loop
          if (result == '') {
            opCount = 0;
          } else {
            // Replace the calculation range with the updated value received from the calculate function
            calcData.replaceRange(opIndex - 1, opIndex + 2, [
              CalcData(calculate([
                calcData[opIndex - 1].value,
                calcData[opIndex].value,
                calcData[opIndex + 1].value
              ]))
            ]);
            // Update opCount
            opCount = getOpCount(calcData);
          }
        }
      }

      // Ensure that only one value is left, apply double precision and prepare string representation
      if (calcData.length == 1) {
        result = (double.tryParse(calcData[0].value) ?? 0).toStringAsFixed(2);
      }
    }

    // Callback function call with either error message or result
    onCalculate(result.toString());
  }

  /// Returns string representation of a 3-step operation based on the provided [set]
  /// i.e. providing set -> ['3', '+', '2'] will return '5'
  /// returns an empty string on failure
  static String calculate(List<String> set) {
    // Return empty if set is too long
    if (set.length != 3) return '';

    // Parse number values and get operand
    double? value0 = double.tryParse(set[0]);
    double? value1 = double.tryParse(set[2]);
    String operand = set[1];

    // If failure to parse numbers, return empty
    if (value0 == null || value1 == null) return '';

    // Perform operation, return string representation
    if (operand == '+') {
      return (value0 + value1).toString();
    } else if (operand == '-') {
      return (value0 - value1).toString();
    } else if (operand == '/') {
      return (value0 / value1).toString();
    } else {
      return (value0 * value1).toString();
    }
  }

  /// Returns an integer count of the number of operands in a given CalcData [list]
  static int getOpCount(List<CalcData> list) {
    return list.where((element) => element.buttonType == EnumButtonType.operand).length;
  }
}
