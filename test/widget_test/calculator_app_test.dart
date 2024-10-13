import 'package:calculator_app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:calculator_app/main.dart';

/// File to handle all widget tests of the app
void main() {
  final buttons = Constants.buttons;

  Future<void> setup(WidgetTester tester) async {
    await tester.pumpWidget(const CalculatorApp());
  }

  /// Ensures given [button] exists, performs tap
  Future<void> tapButton(WidgetTester tester, Finder button) async {
    expect(button, findsOneWidget);
    await tester.tap(button);
    await tester.pumpAndSettle();
  }

  Future<void> testNumberButton(WidgetTester tester, String buttonKey) async {
    // Ensure button exists
    Finder button = find.byKey(Key(buttonKey));
    // Set expected result
    String formattedResult = '${buttons[buttonKey]!} ';

    // Tap button
    expect(find.text(formattedResult), findsNothing);
    await tapButton(tester, button);

    // Check that expected result exists
    expect(find.text(formattedResult), findsOneWidget);
  }

  /// Checks that expression can't start with an operand
  Future<void> testIncorrectOperandStart(WidgetTester tester, String buttonKey) async {
    // Ensure button exists, tap button
    Finder button = find.byKey(Key(buttonKey));
    await tapButton(tester, button);

    // Check that error message is shown
    expect(find.text(Constants.errorOperandStart), findsOneWidget);
  }

  /// Checks that expression can't end with an operand
  Future<void> testIncorrectOperandEnd(WidgetTester tester, String buttonKey) async {
    // Setup expected result
    String formattedResult = '${buttons[Constants.oneKey]} ';

    // Ensure result isn't shown
    expect(find.text(formattedResult), findsNothing);

    // Ensure '1' button exists, perform tap and verify result
    Finder oneButton = find.byKey(Key(Constants.oneKey));
    await tapButton(tester, oneButton);
    expect(find.text(formattedResult), findsOneWidget);

    // Ensure operand button exists, perform tap
    Finder operandButton = find.byKey(Key(buttonKey));
    await tapButton(tester, operandButton);

    // Ensure enter button exists, perform tap
    Finder enterButton = find.byKey(Key(Constants.entKey));
    await tapButton(tester, enterButton);

    // Check that error message is shown
    expect(find.text(Constants.errorOperandEnd), findsOneWidget);
  }

  // Checks that an operand can't be entered twice back-to-back
  Future<void> testIncorrectOperandTwice(WidgetTester tester, String buttonKey) async {
    // Setup expected result
    String formattedResult = '${buttons[Constants.oneKey]} ';

    // Ensure '1' button exists, perform tap and verify result
    Finder oneButton = find.byKey(Key(Constants.oneKey));
    await tapButton(tester, oneButton);
    expect(find.text(formattedResult), findsOneWidget);

    // Ensure enter button exists, perform tap twice
    Finder operandButton = find.byKey(Key(buttonKey));
    await tapButton(tester, operandButton);
    await tapButton(tester, operandButton);

    // Check that error message is shown
    expect(find.text(Constants.errorTwoOperands), findsOneWidget);
  }

  /// Tests an operation start to finish given a list of [buttonKeys] and the value
  /// to expect at the end of the operation
  Future<void> testOperation(
      WidgetTester tester, List<String> buttonKeys, String expectedValue) async {
    String formattedResult = '';

    // Ensure each button exists and perform tap, then update expected result string
    for (final buttonKey in buttonKeys) {
      Finder button = find.byKey(Key(buttonKey));
      await tapButton(tester, button);
      formattedResult += '${buttons[buttonKey]!} ';
    }

    // Ensure enter button exists, perform tap, then update expected result string
    Finder enterButton = find.byKey(Key(Constants.entKey));
    await tapButton(tester, enterButton);
    formattedResult += '${buttons[Constants.entKey]} $expectedValue';

    // Check that correct result string is shown
    expect(find.text(formattedResult), findsOneWidget);
  }

  testWidgets('All buttons visible', (WidgetTester tester) async {
    await setup(tester);
    expect(find.byType(ElevatedButton), findsNWidgets(16));
  });

  group('Number buttons', () {
    testWidgets('Button 0', (WidgetTester tester) async {
      await setup(tester);
      await testNumberButton(tester, Constants.zeroKey);
    });

    testWidgets('Button 1', (WidgetTester tester) async {
      await setup(tester);
      await testNumberButton(tester, Constants.oneKey);
    });

    testWidgets('Button 2', (WidgetTester tester) async {
      await setup(tester);
      await testNumberButton(tester, Constants.twoKey);
    });

    testWidgets('Button 3', (WidgetTester tester) async {
      await setup(tester);
      await testNumberButton(tester, Constants.threeKey);
    });

    testWidgets('Button 4', (WidgetTester tester) async {
      await setup(tester);
      await testNumberButton(tester, Constants.fourKey);
    });

    testWidgets('Button 5', (WidgetTester tester) async {
      await setup(tester);
      await testNumberButton(tester, Constants.fiveKey);
    });

    testWidgets('Button 6', (WidgetTester tester) async {
      await setup(tester);
      await testNumberButton(tester, Constants.sixKey);
    });

    testWidgets('Button 7', (WidgetTester tester) async {
      await setup(tester);
      await testNumberButton(tester, Constants.sevenKey);
    });

    testWidgets('Button 8', (WidgetTester tester) async {
      await setup(tester);
      await testNumberButton(tester, Constants.eightKey);
    });

    testWidgets('Button 9', (WidgetTester tester) async {
      await setup(tester);
      await testNumberButton(tester, Constants.nineKey);
    });

    testWidgets('Double number concatenates', (WidgetTester tester) async {
      await setup(tester);
      await testNumberButton(tester, Constants.oneKey);

      Finder button = find.byKey(Key(Constants.oneKey));
      expect(button, findsOneWidget);

      await tester.tap(button);
      await tester.pumpAndSettle();

      expect(find.text('11 '), findsOneWidget);
    });
  });

  group('Non-number buttons', () {
    testWidgets('Clear button works', (WidgetTester tester) async {
      await setup(tester);
      expect(find.text(buttons[Constants.oneKey]!), findsOneWidget);

      await testNumberButton(tester, Constants.oneKey);

      Finder button = find.byKey(Key(Constants.clrKey));
      await tester.tap(button);
      await tester.pumpAndSettle();

      expect(find.text(buttons[Constants.oneKey]!), findsOneWidget);
      expect(find.text('${buttons[Constants.oneKey]!} '), findsNothing);
    });

    group('Operand buttons incorrect', () {
      group('Addition', () {
        testWidgets('Addition button incorrect start', (WidgetTester tester) async {
          await setup(tester);
          await testIncorrectOperandStart(tester, Constants.addKey);
        });

        testWidgets('Addition button incorrect end', (WidgetTester tester) async {
          await setup(tester);
          await testIncorrectOperandEnd(tester, Constants.addKey);
        });

        testWidgets('Addition button twice', (WidgetTester tester) async {
          await setup(tester);
          await testIncorrectOperandTwice(tester, Constants.addKey);
        });
      });

      group('Subtraction', () {
        testWidgets('Subtraction button incorrect start', (WidgetTester tester) async {
          await setup(tester);
          await testIncorrectOperandStart(tester, Constants.subKey);
        });

        testWidgets('Subtraction button incorrect end', (WidgetTester tester) async {
          await setup(tester);
          await testIncorrectOperandEnd(tester, Constants.subKey);
        });

        testWidgets('Subtraction button twice', (WidgetTester tester) async {
          await setup(tester);
          await testIncorrectOperandTwice(tester, Constants.subKey);
        });
      });

      group('Multiplication', () {
        testWidgets('Multiplication button incorrect start', (WidgetTester tester) async {
          await setup(tester);
          await testIncorrectOperandStart(tester, Constants.multKey);
        });

        testWidgets('Multiplication button incorrect end', (WidgetTester tester) async {
          await setup(tester);
          await testIncorrectOperandEnd(tester, Constants.multKey);
        });

        testWidgets('Multiplication button twice', (WidgetTester tester) async {
          await setup(tester);
          await testIncorrectOperandTwice(tester, Constants.multKey);
        });
      });
      group('Division', () {
        testWidgets('Division button incorrect start', (WidgetTester tester) async {
          await setup(tester);
          await testIncorrectOperandStart(tester, Constants.divKey);
        });

        testWidgets('Division button incorrect end', (WidgetTester tester) async {
          await setup(tester);
          await testIncorrectOperandEnd(tester, Constants.divKey);
        });

        testWidgets('Division button twice', (WidgetTester tester) async {
          await setup(tester);
          await testIncorrectOperandTwice(tester, Constants.divKey);
        });
      });

      testWidgets('Enter button incorrect start', (WidgetTester tester) async {
        await setup(tester);
        await testIncorrectOperandStart(tester, Constants.entKey);
      });
    });

    group('Operand buttons work correctly', () {
      int oneInt = int.parse(Constants.buttons[Constants.oneKey]!);
      int twoInt = int.parse(Constants.buttons[Constants.twoKey]!);
      int threeInt = int.parse(Constants.buttons[Constants.threeKey]!);
      int fourInt = int.parse(Constants.buttons[Constants.fourKey]!);
      int fiveInt = int.parse(Constants.buttons[Constants.fiveKey]!);

      group('Addition', () {
        testWidgets('One-step operation', (WidgetTester tester) async {
          final operationKeys = [Constants.oneKey, Constants.addKey, Constants.twoKey];
          String expectedValue = (oneInt + twoInt).toDouble().toStringAsFixed(2);

          await setup(tester);
          await testOperation(tester, operationKeys, expectedValue);
        });

        testWidgets('Two-step operation', (WidgetTester tester) async {
          final operationKeys = [
            Constants.oneKey,
            Constants.addKey,
            Constants.twoKey,
            Constants.addKey,
            Constants.threeKey
          ];
          String expectedValue = (oneInt + twoInt + threeInt).toDouble().toStringAsFixed(2);

          await setup(tester);
          await testOperation(tester, operationKeys, expectedValue);
        });
      });

      group('Subtraction', () {
        testWidgets('One-step operation', (WidgetTester tester) async {
          final operationKeys = [Constants.oneKey, Constants.subKey, Constants.twoKey];
          String expectedValue = (oneInt - twoInt).toDouble().toStringAsFixed(2);

          await setup(tester);
          await testOperation(tester, operationKeys, expectedValue);
        });

        testWidgets('Two-step operation', (WidgetTester tester) async {
          final operationKeys = [
            Constants.oneKey,
            Constants.subKey,
            Constants.twoKey,
            Constants.subKey,
            Constants.threeKey,
          ];
          String expectedValue = (oneInt - twoInt - threeInt).toDouble().toStringAsFixed(2);

          await setup(tester);
          await testOperation(tester, operationKeys, expectedValue);
        });
      });

      group('Multiplication', () {
        testWidgets('One-step operation', (WidgetTester tester) async {
          final operationKeys = [Constants.oneKey, Constants.multKey, Constants.twoKey];
          String expectedValue = (oneInt * twoInt).toDouble().toStringAsFixed(2);

          await setup(tester);
          await testOperation(tester, operationKeys, expectedValue);
        });

        testWidgets('Two-step operation', (WidgetTester tester) async {
          final operationKeys = [
            Constants.oneKey,
            Constants.multKey,
            Constants.twoKey,
            Constants.multKey,
            Constants.threeKey,
          ];
          String expectedValue = (oneInt * twoInt * threeInt).toDouble().toStringAsFixed(2);

          await setup(tester);
          await testOperation(tester, operationKeys, expectedValue);
        });
      });

      group('Division', () {
        testWidgets('One-step operation', (WidgetTester tester) async {
          final operationKeys = [Constants.oneKey, Constants.divKey, Constants.twoKey];
          String expectedValue = (oneInt / twoInt).toDouble().toStringAsFixed(2);

          await setup(tester);
          await testOperation(tester, operationKeys, expectedValue);
        });

        testWidgets('Two-step operation', (WidgetTester tester) async {
          final operationKeys = [
            Constants.oneKey,
            Constants.divKey,
            Constants.twoKey,
            Constants.divKey,
            Constants.threeKey,
          ];
          String expectedValue = (oneInt / twoInt / threeInt).toDouble().toStringAsFixed(2);

          await setup(tester);
          await testOperation(tester, operationKeys, expectedValue);
        });
      });

      group('Multi-step operations', () {
        testWidgets('Two-stepped mixed operation', (WidgetTester tester) async {
          final operationKeys = [
            Constants.oneKey,
            Constants.addKey,
            Constants.twoKey,
            Constants.subKey,
            Constants.threeKey,
          ];
          String expectedValue = (oneInt + twoInt - threeInt).toDouble().toStringAsFixed(2);

          await setup(tester);
          await testOperation(tester, operationKeys, expectedValue);
        });

        testWidgets('Three-step mixed operation', (WidgetTester tester) async {
          final operationKeys = [
            Constants.oneKey,
            Constants.addKey,
            Constants.twoKey,
            Constants.subKey,
            Constants.threeKey,
            Constants.multKey,
            Constants.fourKey
          ];
          String expectedValue =
              (oneInt + twoInt - threeInt * fourInt).toDouble().toStringAsFixed(2);

          await setup(tester);
          await testOperation(tester, operationKeys, expectedValue);
        });

        testWidgets('Four-step mixed operation', (WidgetTester tester) async {
          final operationKeys = [
            Constants.oneKey,
            Constants.addKey,
            Constants.twoKey,
            Constants.subKey,
            Constants.threeKey,
            Constants.multKey,
            Constants.fourKey,
            Constants.divKey,
            Constants.fiveKey,
          ];
          String expectedValue =
              (oneInt + twoInt - threeInt * fourInt / fiveInt).toDouble().toStringAsFixed(2);

          await setup(tester);
          await testOperation(tester, operationKeys, expectedValue);
        });
      });
    });
  });
}
