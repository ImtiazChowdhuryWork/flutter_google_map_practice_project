import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum RulerLineType { centimeter, halfCentimeter, millimeter }

class LineProperties {
  final double percentage;
  final double width;
  final Color color;

  LineProperties(this.percentage, this.width, this.color);
}

class RulerController extends GetxController {
  // Configurable parameters
  static const double maxValue = 500.0;
  static const double marksPerUnit = 10.0;
  static const String unitLabel = "cm";

  // Reactive state variables
  RxDouble selectedValue = RxDouble(0.0);
  RxInt selectedFeetValue = RxInt(0);
  RxInt selectedInchesValue = RxInt(0);
  Rx<RulerLineType?> selectedLineType = Rx<RulerLineType?>(null);
  RxInt selectedIndex = RxInt(0);

  // Scroll controller
  final ScrollController scrollController = ScrollController();

  // Item height for calculations
  double itemHeight = 13.0;

  @override
  void onInit() {
    super.onInit();
    // Initialize with default values
    selectedValue.value = 0.0;
    selectedFeetValue.value = 0;
    selectedInchesValue.value = 0;
    selectedIndex.value = 0;

    // Setup scroll listener
    scrollController.addListener(onScroll);
  }

  @override
  void onClose() {
    scrollController.removeListener(onScroll);
    scrollController.dispose();
    super.onClose();
  }

  void onScroll() {
    calculateCenterValue();
  }

  void calculateCenterValue() {
    if (scrollController.hasClients) {
      final viewportHeight = scrollController.position.viewportDimension;
      final scrollOffset = scrollController.offset;

      final centerPosition = scrollOffset + (viewportHeight / 2);

      if (itemHeight > 0) {
        final centerIndex = (centerPosition / itemHeight).floor();

        if (centerIndex >= 0 && centerIndex <= (maxValue * marksPerUnit)) {
          // Update selected value
          final newValue = centerIndex / marksPerUnit;
          selectedValue.value = newValue;

          // Convert cm to total inches (1 inch = 2.54 cm)
          final totalInches = newValue / 2.54;

          // Calculate feet and remaining inches
          selectedFeetValue.value = (totalInches / 12).floor();
          selectedInchesValue.value = (totalInches % 12).round();

          // Update line type and index
          selectedLineType.value = _getLineType(centerIndex);
          selectedIndex.value = centerIndex;
        }
      }
    }
  }

  // Method to manually scroll to a specific value
  void scrollToValue(double valueInCm) {
    if (scrollController.hasClients) {
      final index = (valueInCm * marksPerUnit).toInt();
      final scrollPosition = index * itemHeight;

      scrollController.animateTo(
        scrollPosition,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );

      // Update values
      selectedValue.value = valueInCm;
      final totalInches = valueInCm / 2.54;
      selectedFeetValue.value = (totalInches / 12).floor();
      selectedInchesValue.value = (totalInches % 12).round();
      selectedLineType.value = _getLineType(index);
      selectedIndex.value = index;
    }
  }

  // Reset to initial state
  void reset() {
    selectedValue.value = 0.0;
    selectedFeetValue.value = 0;
    selectedInchesValue.value = 0;
    selectedLineType.value = null;
    selectedIndex.value = 0;

    if (scrollController.hasClients) {
      scrollController.jumpTo(0);
    }
  }

  // Get display strings
  String get displayValue {
    return "${selectedValue.value.toStringAsFixed(2)} $unitLabel";
  }

  String get displayFeetInches {
    return "${selectedFeetValue.value}ft ${selectedInchesValue.value}in";
  }

  String get selectedTypeName {
    if (selectedLineType.value == null) return "Unknown";
    return _getLineTypeName(selectedLineType.value!);
  }

  Color get selectedTypeColor {
    if (selectedLineType.value == null) return Colors.grey;
    return _getLineTypeColor(selectedLineType.value!);
  }

  // Helper methods
  RulerLineType _getLineType(int index) {
    if (index % 10 == 0) return RulerLineType.centimeter;
    if (index % 5 == 0) return RulerLineType.halfCentimeter;
    return RulerLineType.millimeter;
  }

  LineProperties _getLineProperties(RulerLineType type) {
    switch (type) {
      case RulerLineType.centimeter:
        return LineProperties(1.0, 2.5, Colors.red);
      case RulerLineType.halfCentimeter:
        return LineProperties(0.6, 1.5, Colors.blue);
      case RulerLineType.millimeter:
        return LineProperties(0.3, 1.0, Colors.black);
    }
  }

  String _getLineTypeName(RulerLineType type) {
    switch (type) {
      case RulerLineType.centimeter:
        return "Centimeter Mark";
      case RulerLineType.halfCentimeter:
        return "Half Centimeter Mark";
      case RulerLineType.millimeter:
        return "Millimeter Mark";
    }
  }

  Color _getLineTypeColor(RulerLineType type) {
    switch (type) {
      case RulerLineType.centimeter:
        return Colors.red;
      case RulerLineType.halfCentimeter:
        return Colors.blue;
      case RulerLineType.millimeter:
        return Colors.black;
    }
  }

  // Get line properties for UI
  LineProperties getLinePropertiesForIndex(int index) {
    final type = _getLineType(index);
    return _getLineProperties(type);
  }

  // Check if index is center item
  bool isCenterItem(int index) {
    return selectedIndex.value == index;
  }

  // Check label visibility
  bool showMajorLabel(int index) {
    return index % (marksPerUnit * 5) == 0;
  }

  bool showMinorLabel(int index) {
    return index % marksPerUnit == 0;
  }

  // Get label text
  String getLabelText(int index) {
    final value = index / marksPerUnit;
    return value.toStringAsFixed(value % 1 == 0 ? 0 : 1);
  }
}
