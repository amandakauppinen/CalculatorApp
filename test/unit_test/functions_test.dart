// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:calculator_app/utils/calc_data.dart';
import 'package:calculator_app/utils/functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:calculator_app/utils/constants.dart';

/// File to handle all tests related to the various functions in utils/functions.dart
void main() {
  // Set constant integers and operands
  int one = int.parse(Constants.buttons[Constants.oneKey]!);
  int two = int.parse(Constants.buttons[Constants.twoKey]!);
  int three = int.parse(Constants.buttons[Constants.threeKey]!);
  int four = int.parse(Constants.buttons[Constants.fourKey]!);
  int five = int.parse(Constants.buttons[Constants.fiveKey]!);

  String addition = Constants.buttons[Constants.addKey]!;
  String subtraction = Constants.buttons[Constants.subKey]!;
  String multiplication = Constants.buttons[Constants.multKey]!;
  String division = Constants.buttons[Constants.divKey]!;

  test('getOpCount() correctly calculates number of operands', () {
    // 1 + 2
    String operation = '$one' + addition + '$two';
    // Create list of calc data and check operand count
    List<CalcData> list = operation.characters.map((char) => CalcData(char)).toList();
    expect(Functions.getOpCount(list), one);

    // 1 + 2 - 3
    operation += subtraction + '$three';
    // Create list of calc data and check operand count
    list = operation.characters.map((char) => CalcData(char)).toList();
    expect(Functions.getOpCount(list), two);

    // 1 + 2 - 3 * 4
    operation += multiplication + '$four';
    // Create list of calc data and check operand count
    list = operation.characters.map((char) => CalcData(char)).toList();
    expect(Functions.getOpCount(list), three);

    // 1 + 2 - 3 * 4 / 5
    operation += division + '$five';
    // Create list of calc data and check operand count
    list = operation.characters.map((char) => CalcData(char)).toList();
    expect(Functions.getOpCount(list), four);
  });

  group('evaluate()', () {
    group('evaluate() returns error with invalid operations', () {
      test('One number', () {
        // 1
        List<CalcData> data = [CalcData('$one')];
        Functions.evaluateExperession(data, (result) {
          expect(result, Constants.errorCalculating);
        });
      });
      test('One operand', () {
        // +
        List<CalcData> data = [CalcData(addition)];
        Functions.evaluateExperession(data, (result) {
          expect(result, Constants.errorCalculating);
        });
      });
      test('Only numbers', () {
        // 1 2
        List<CalcData> data = [CalcData('$one'), CalcData('$two')];
        Functions.evaluateExperession(data, (result) {
          expect(result, Constants.errorCalculating);
        });
      });

      test('Only operands', () {
        // + -
        List<CalcData> data = [CalcData(addition), CalcData(subtraction)];
        Functions.evaluateExperession(data, (result) {
          expect(result, Constants.errorCalculating);
        });
      });
      test('Invalid input', () {
        // 1 + - 2
        List<CalcData> data = [
          CalcData('$one'),
          CalcData(addition),
          CalcData(subtraction),
          CalcData('$three')
        ];
        Functions.evaluateExperession(data, (result) {
          expect(result, Constants.errorCalculating);
        });
      });
    });

    group('evaluate() correctly calculates a simple operation', () {
      test('Simple addition', () {
        // 1 + 2
        List<CalcData> data = [CalcData('$one'), CalcData(addition), CalcData('$two')];
        Functions.evaluateExperession(data, (result) {
          expect(result, (one + two).toDouble().toStringAsFixed(2));
        });
      });
      test('Simple subtraction', () {
        // 1 - 2
        List<CalcData> data = [CalcData('$one'), CalcData(subtraction), CalcData('$two')];
        Functions.evaluateExperession(data, (result) {
          expect(result, (one - two).toDouble().toStringAsFixed(2));
        });
      });

      test('Simple multiplication', () {
        // 1 * 2
        List<CalcData> data = [CalcData('$one'), CalcData(multiplication), CalcData('$two')];
        Functions.evaluateExperession(data, (result) {
          expect(result, (one * two).toDouble().toStringAsFixed(2));
        });
      });

      test('Simple division', () {
        // 1 / 2
        List<CalcData> data = [CalcData('$one'), CalcData(division), CalcData('$two')];
        Functions.evaluateExperession(data, (result) {
          expect(result, (one / two).toDouble().toStringAsFixed(2));
        });
      });
    });

    group('evaluate() correctly calculates a 2-step simple operation', () {
      test('2-step addition', () {
        // 1 + 2 + 3
        List<CalcData> data = [
          CalcData('$one'),
          CalcData(addition),
          CalcData('$two'),
          CalcData(addition),
          CalcData('$three')
        ];
        Functions.evaluateExperession(data, (result) {
          expect(result, (one + two + three).toDouble().toStringAsFixed(2));
        });
      });

      test('2-step subtraction', () {
        // 1 - 2 - 3
        List<CalcData> data = [
          CalcData('$one'),
          CalcData(subtraction),
          CalcData('$two'),
          CalcData(subtraction),
          CalcData('$three')
        ];
        Functions.evaluateExperession(data, (result) {
          expect(result, (one - two - three).toDouble().toStringAsFixed(2));
        });
      });

      test('2-step multiplication', () {
        // 1 * 2 * 3
        List<CalcData> data = [
          CalcData('$one'),
          CalcData(multiplication),
          CalcData('$two'),
          CalcData(multiplication),
          CalcData('$three')
        ];
        Functions.evaluateExperession(data, (result) {
          expect(result, (one * two * three).toDouble().toStringAsFixed(2));
        });
      });

      test('2-step division', () {
        // 1 / 2 / 3
        List<CalcData> data = [
          CalcData('$one'),
          CalcData(division),
          CalcData('$two'),
          CalcData(division),
          CalcData('$three')
        ];
        Functions.evaluateExperession(data, (result) {
          expect(result, (one / two / three).toDouble().toStringAsFixed(2));
        });
      });

      group('evaluate() correctly calculates a multi-step simple operation', () {
        test('Multi-step addition', () {
          // 1 + 2 + 3 + 4
          List<CalcData> data = [
            CalcData('$one'),
            CalcData(addition),
            CalcData('$two'),
            CalcData(addition),
            CalcData('$three'),
            CalcData(addition),
            CalcData('$four')
          ];
          Functions.evaluateExperession(data, (result) {
            expect(result, (one + two + three + four).toDouble().toStringAsFixed(2));
          });
        });

        test('Multi-step subtraction', () {
          // 1 - 2 - 3 - 4
          List<CalcData> data = [
            CalcData('$one'),
            CalcData(subtraction),
            CalcData('$two'),
            CalcData(subtraction),
            CalcData('$three'),
            CalcData(subtraction),
            CalcData('$four')
          ];
          Functions.evaluateExperession(data, (result) {
            expect(result, (one - two - three - four).toDouble().toStringAsFixed(2));
          });
        });

        test('Multi-step multipliaction', () {
          // 1 * 2 * 3 * 4
          List<CalcData> data = [
            CalcData('$one'),
            CalcData(multiplication),
            CalcData('$two'),
            CalcData(multiplication),
            CalcData('$three'),
            CalcData(multiplication),
            CalcData('$four')
          ];
          Functions.evaluateExperession(data, (result) {
            expect(result, (one * two * three * four).toDouble().toStringAsFixed(2));
          });
        });

        test('Multi-step division', () {
          // 1 / 2 / 3 / 4
          List<CalcData> data = [
            CalcData('$one'),
            CalcData(division),
            CalcData('$two'),
            CalcData(division),
            CalcData('$three'),
            CalcData(division),
            CalcData('$four')
          ];
          Functions.evaluateExperession(data, (result) {
            expect(result, (one / two / three / four).toDouble().toStringAsFixed(2));
          });
        });

        test('Multi-step mixed', () {
          // 1 + 2 - 3 * 4 / 5
          List<CalcData> data = [
            CalcData('$one'),
            CalcData(addition),
            CalcData('$two'),
            CalcData(subtraction),
            CalcData('$three'),
            CalcData(multiplication),
            CalcData('$four'),
            CalcData(division),
            CalcData('$five')
          ];
          Functions.evaluateExperession(data, (result) {
            expect(result, (one + two - three * four / five).toDouble().toStringAsFixed(2));
          });
        });
      });
    });
  });
}
