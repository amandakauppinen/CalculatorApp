import 'package:calculator_app/utils/calc_data.dart';
import 'package:calculator_app/utils/constants.dart';
import 'package:calculator_app/utils/functions.dart';
import 'package:flutter/material.dart';

/// This is a simple Flutter calculator app
///
/// User can choose to interact with buttons as they would on a simple calculator
/// Calculator follows correct order of operations and can be cleared
/// This was written to practice writing automated tests for flutter
void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Constants.appName,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Map<String, CalcData> buttons =
      Constants.buttons.map((key, value) => MapEntry(key, CalcData(value)));
  List<CalcData> calculatorInput = [];
  String? errorMessage;
  String? resultString;

  @override
  Widget build(BuildContext context) {
    // Format calculation string that appears above the buttons
    String calcString = '';
    for (CalcData calcButton in calculatorInput) {
      calcString += '${calcButton.value} ';
    }
    if (resultString != null) {
      calcString += '= $resultString';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(Constants.appName),
      ),
      body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        if (calculatorInput.isNotEmpty) Text(calcString),
        Padding(padding: EdgeInsets.symmetric(vertical: Constants.padding)),
        // Layout calculator buttons  buttons
        // [7][8][9][+]
        // [4][5][6][-]
        // [1][2][3][/]
        // [C][0][=][*]
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _getCalcButton(Constants.sevenKey),
            _getCalcButton(Constants.eightKey),
            _getCalcButton(Constants.nineKey),
            _getCalcButton(Constants.addKey),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _getCalcButton(Constants.fourKey),
            _getCalcButton(Constants.fiveKey),
            _getCalcButton(Constants.sixKey),
            _getCalcButton(Constants.subKey),
          ],
        ),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          _getCalcButton(Constants.oneKey),
          _getCalcButton(Constants.twoKey),
          _getCalcButton(Constants.threeKey),
          _getCalcButton(Constants.divKey),
        ]),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _getCalcButton(Constants.clrKey),
            _getCalcButton(Constants.zeroKey),
            _getCalcButton(Constants.entKey),
            _getCalcButton(Constants.multKey),
          ],
        ),
        if (errorMessage != null)
          Text(
            errorMessage!,
            style: const TextStyle(color: Colors.red),
          ),
      ]),
    );
  }

  /// Returns a formatted calculator button based on the given [key]
  Widget _getCalcButton(String key) {
    CalcData button = buttons[key]!;
    return Padding(
        padding: EdgeInsets.all(Constants.padding),
        child: ElevatedButton(
            key: Key(key),
            style: ButtonStyle(
              backgroundColor: MaterialStatePropertyAll<Color>(
                  button.value.isEmpty ? Colors.grey : Colors.green),
            ),
            // Don't do anything if the evaluation has been made and user pushes anything but clear
            onPressed: resultString != null && button.buttonType != EnumButtonType.clear
                ? () {}
                : () {
                    // Set error if user tries to start with an operand
                    if ((button.buttonType == EnumButtonType.operand ||
                            button.buttonType == EnumButtonType.enter) &&
                        calculatorInput.isEmpty) {
                      setState(() => errorMessage = Constants.errorOperandStart);
                    }
                    // Set error if user tries to end with an operand
                    else if (button.buttonType == EnumButtonType.operand &&
                        calculatorInput.isNotEmpty &&
                        button.buttonType == calculatorInput.last.buttonType) {
                      setState(() => errorMessage = Constants.errorTwoOperands);
                    }
                    // All non-error cases
                    else {
                      errorMessage = null;
                      // Concatenate numbers if entered back-to-back
                      if (button.buttonType == EnumButtonType.number &&
                          calculatorInput.isNotEmpty &&
                          button.buttonType == calculatorInput.last.buttonType) {
                        setState(() {
                          calculatorInput.last.value = calculatorInput.last.value + button.value;
                        });
                      }
                      // Clear input
                      else if (button.buttonType == EnumButtonType.clear) {
                        setState(() {
                          calculatorInput.clear();
                          resultString = null;
                        });
                      }
                      // Perform evaluation on entered values
                      else if (button.buttonType == EnumButtonType.enter) {
                        if (calculatorInput.last.buttonType == EnumButtonType.operand) {
                          setState(() => errorMessage = Constants.errorOperandEnd);
                        } else {
                          Functions.evaluateExperession(List.from(calculatorInput),
                              (result) => setState(() => resultString = result));
                        }
                      }
                      // Add user input to calculatorInput list
                      else {
                        setState(() => calculatorInput.add(button));
                      }
                    }
                  },
            child: Text(button.value)));
  }
}
