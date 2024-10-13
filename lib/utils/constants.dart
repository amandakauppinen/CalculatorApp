// Indicates calculator button type, used in [CalcData] constructor
enum EnumButtonType { number, operand, enter, clear }

/// Constant values used throughout app
class Constants {
  static String appName = 'Calculator';
  static double padding = 8;

  // Button keys
  static String zeroKey = 'zeroKey';
  static String oneKey = 'oneKey';
  static String twoKey = 'twoKey';
  static String threeKey = 'threeKey';
  static String fourKey = 'fourKey';
  static String fiveKey = 'fiveKey';
  static String sixKey = 'sixKey';
  static String sevenKey = 'sevenKey';
  static String eightKey = 'eightKey';
  static String nineKey = 'nineKey';
  static String addKey = 'addKey';
  static String subKey = 'subKey';
  static String multKey = 'multKey';
  static String divKey = 'divKey';
  static String clrKey = 'clrKey';
  static String entKey = 'entKey';

  // Error strings
  static String errorOperandStart = 'Cannot start formula with operand';
  static String errorTwoOperands = 'Cannot enter two operands';
  static String errorOperandEnd = 'Cannot end on operand';
  static String errorCalculating = 'Error calculating';

  // Button map
  static Map<String, String> buttons = {
    oneKey: '1',
    twoKey: '2',
    threeKey: '3',
    fourKey: '4',
    fiveKey: '5',
    sixKey: '6',
    sevenKey: '7',
    eightKey: '8',
    nineKey: '9',
    addKey: '+',
    subKey: '-',
    multKey: '*',
    divKey: '/',
    clrKey: 'C',
    zeroKey: '0',
    entKey: '=',
  };
}
