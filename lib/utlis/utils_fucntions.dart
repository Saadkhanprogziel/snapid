class UtilsFunc {

  static double converUnit(double value, String unit) {
    if (unit.toLowerCase() == 'metric') {
      return value; 
    } else if (unit.toLowerCase() == 'imperial') {
      return value * 0.393701;
    } else {
      throw ArgumentError('Unsupported unit: $unit. Use "cm" or "inch".');
    }
  }
}
