import 'package:snapid/main.dart';

class UtilsFunc {
  static const double dpi = 300.0;

  static double pixelsToInches(double pixels) {
    return pixels / dpi;
  }

  static double pixelsToCm(double pixels) {
    final inches = pixelsToInches(pixels);
    return inches * 2.54;
  }

  static double convertUnits(double pixels) {
    var selectedUnit = appStorage.read("unit") ?? "cm"; 
    if (selectedUnit == "in" || selectedUnit == "inch" || selectedUnit == "inches") {
      return pixelsToInches(pixels);
    } else {
      return pixelsToCm(pixels);
    }
  }
}
