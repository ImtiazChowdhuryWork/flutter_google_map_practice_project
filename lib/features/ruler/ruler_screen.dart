import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_map_practice_project/features/ruler/widgets/ruler_stroke.dart';

class RulerScreen extends StatefulWidget {
  final double rulerContainerHeight;

  const RulerScreen({
    super.key,
    this.rulerContainerHeight = 0.5, // Default to 70% of screen height
  });

  @override
  State<RulerScreen> createState() => _RulerScreenState();
}

class _RulerScreenState extends State<RulerScreen> {
  // Configurable parameters
  static const double maxValue = 500.0;
  static const double marksPerUnit = 10.0; // How many marks per unit value
  static const String unitLabel = "cm"; // Unit label (cm, mm, in, etc.)

  // State variables
  double? selectedValue;
  int? selectedFeetValue; // Feet part of FIT value
  int? selectedInchesValue; // Inches part of FIT value
  RulerLineType? selectedLineType;
  int? selectedIndex;
  final ScrollController _scrollController = ScrollController();

  // Track item height for accurate calculation
  double _itemHeight = 0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);

    // Get item height after layout
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _calculateCenterValue();
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    _calculateCenterValue();
  }

  void _calculateCenterValue() {
    if (_scrollController.hasClients) {
      // Get the visible viewport
      final viewportHeight = _scrollController.position.viewportDimension;
      final scrollOffset = _scrollController.offset;

      // Calculate the center position in the viewport
      final centerPosition = scrollOffset + (viewportHeight / 2);

      // Calculate which item is at the center
      // Each item takes 12.h (container) + 1.h (separator) = 13.h
      _itemHeight = 13.h;

      if (_itemHeight > 0) {
        final centerIndex = (centerPosition / _itemHeight).floor();

        if (centerIndex >= 0 && centerIndex <= (maxValue * marksPerUnit)) {
          setState(() {
            selectedValue = centerIndex / marksPerUnit;

            // Convert cm to total inches first (1 inch = 2.54 cm)
            double totalInches = selectedValue! / 2.54;

            // Calculate feet and remaining inches
            selectedFeetValue = (totalInches / 12).floor(); // Total feet
            selectedInchesValue = (totalInches % 12)
                .round(); // Remaining inches

            selectedLineType = _getLineType(centerIndex);
            selectedIndex = centerIndex;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final int totalMarks = (maxValue * marksPerUnit).toInt();

    return Scaffold(
      backgroundColor: Colors.teal,
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text("Make Ruler Using Custom Painter"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 20.h),

          // Selected value display
          Container(
            padding: EdgeInsets.all(10.sp),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Column(
              children: [
                Text(
                  "Center Line Value:",
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                ),
                SizedBox(height: 5.h),
                Text(
                  selectedValue != null
                      ? "${selectedValue!.toStringAsFixed(2)} $unitLabel"
                      : "Scroll to see value",
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
                SizedBox(height: 5.h),
                Text(
                  selectedFeetValue != null && selectedInchesValue != null
                      ? "${selectedFeetValue}ft ${selectedInchesValue}in" // Display as feet and inches
                      : "Calculating...",
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.blue,
                  ),
                ),
                if (selectedLineType != null)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 12.w,
                        height: 12.h,
                        decoration: BoxDecoration(
                          color: _getLineTypeColor(selectedLineType!),
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: 5.w),
                      Text(
                        _getLineTypeName(selectedLineType!),
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: _getLineTypeColor(selectedLineType!),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                if (selectedIndex != null)
                  Text(
                    "Mark Index: $selectedIndex",
                    style: TextStyle(fontSize: 10.sp, color: Colors.grey),
                  ),
              ],
            ),
          ),
          SizedBox(height: 20.h),

          // Stack containing both the Ruler Container and the Positioned widget
          Stack(
            alignment: Alignment.center,
            children: [
              // The Ruler Container with Fixed Center Marker
              Center(
                child: Container(
                  width: 0.3.sw,
                  height:
                      MediaQuery.of(context).size.height *
                      widget.rulerContainerHeight,
                  color: Colors.grey.shade200,
                  child: Stack(
                    children: [
                      // The Ruler List - scrolled content
                      NotificationListener<ScrollNotification>(
                        onNotification: (ScrollNotification notification) {
                          // Update on all scroll notifications
                          if (notification is ScrollNotification) {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              _calculateCenterValue();
                            });
                          }
                          return false;
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 20.h),
                          padding: EdgeInsets.symmetric(horizontal: 10.w),
                          child: _buildRuler(totalMarks),
                        ),
                      ),

                      // Full-width horizontal center line with marker
                      IgnorePointer(
                        child: Center(
                          child: Container(
                            width:
                                double.infinity, // Full width of the container
                            height: 20.h, // Height to accommodate the marker
                            child: Stack(
                              children: [
                                // The horizontal line spanning full width
                                Positioned(
                                  top: 10
                                      .h, // Center vertically in the container
                                  left: 0,
                                  right: 0,
                                  child: Container(
                                    height: 1,
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          color: Colors.green.withOpacity(0.5),
                                          width: 1.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                // The center marker positioned in the middle
                                // Positioned.fill(
                                //   child: Align(
                                //     alignment: Alignment.center,
                                //     child: Container(
                                //       padding: EdgeInsets.symmetric(
                                //         horizontal: 8.w,
                                //         vertical: 4.h,
                                //       ),
                                //       decoration: BoxDecoration(
                                //         color: Colors.green,
                                //         borderRadius: BorderRadius.circular(
                                //           4.r,
                                //         ),
                                //       ),
                                //       child: Row(
                                //         mainAxisSize: MainAxisSize.min,
                                //         children: [
                                //           Icon(
                                //             Icons.straighten,
                                //             color: Colors.white,
                                //             size: 14.sp,
                                //           ),
                                //           SizedBox(width: 4.w),
                                //           Text(
                                //             "Center",
                                //             style: TextStyle(
                                //               fontSize: 10.sp,
                                //               color: Colors.white,
                                //               fontWeight: FontWeight.bold,
                                //             ),
                                //           ),
                                //         ],
                                //       ),
                                //     ),
                                //   ),
                                // ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Positioned widget moved OUTSIDE the ruler container
              // Position it to the left of the ruler container
              Positioned(
                left: 0.05.sw, // Adjust this value to position it properly
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 8.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Text(
                            selectedFeetValue != null &&
                                    selectedInchesValue != null
                                ? "${selectedFeetValue}ft ${selectedInchesValue}in" // Display as feet and inches
                                : "Calculating...",
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.blue,
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Icon(
                            Icons.arrow_back,
                            color: Colors.redAccent,
                            size: 16.sp,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // You can also add another Positioned widget on the right side
              // Positioned widget on the right side
              Positioned(
                right: 0.15.sw,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 8.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(8.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      ///------------->>> Show +1 value ONLY for positive current values
                      if (selectedFeetValue != null && selectedFeetValue! >= 0)
                        Text(
                          "${selectedFeetValue! + 1}",
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 28.sp,
                            color: Colors.white54,
                          ),
                        ),
                      if (selectedFeetValue != null && selectedFeetValue! >= 0)
                        SizedBox(height: 10.h),

                      ///----------->>> Current Fit Value (ALWAYS show)
                      Text(
                        selectedFeetValue != null ? "$selectedFeetValue" : "--",
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 28.sp,
                          color: Colors.white,
                        ),
                      ),

                      // Conditionally show/hide the SizedBox based on selectedFeetValue
                      selectedFeetValue == 0
                          ? SizedBox.shrink()
                          : (selectedFeetValue != null && selectedFeetValue! > 0
                                ? SizedBox(height: 10.h)
                                : SizedBox.shrink()),

                      ///------------->>> Show -1 value ONLY for negative current values
                      if (selectedFeetValue != null && selectedFeetValue! > 0)
                        Text(
                          "${selectedFeetValue! - 1}",
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 28.sp,
                            color: Colors.white54,
                          ),
                        ),
                      if (selectedFeetValue != null && selectedFeetValue! > 0)
                        SizedBox(height: 10.h),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRuler(int totalMarks) {
    return ListView.builder(
      controller: _scrollController,
      physics: const BouncingScrollPhysics(),
      itemCount: totalMarks + 1,
      itemBuilder: (context, index) {
        // Only show labels at certain intervals to avoid overcrowding
        final bool showMajorLabel =
            index % (marksPerUnit * 5) == 0; // Every 5 units
        final bool showMinorLabel = index % marksPerUnit == 0; // Every unit

        final lineType = _getLineType(index);
        final lineProperties = _getLineProperties(lineType);

        // Highlight if this is the center item
        final bool isCenterItem = selectedIndex == index;

        return Container(
          height: 12.h, // Further reduced height
          margin: EdgeInsets.only(
            bottom: 1.h,
          ), // Further reduced separator as margin
          color: isCenterItem
              ? _getLineTypeColor(lineType).withOpacity(0.2)
              : Colors.transparent,
          child: Row(
            children: [
              // Right side line only (as per your commented code)
              Expanded(
                child: RulerStroke(
                  linePercentage: lineProperties.percentage,
                  strokeWidth: isCenterItem
                      ? lineProperties.width * 1.5
                      : lineProperties.width,
                  lineColor: isCenterItem ? Colors.green : lineProperties.color,
                  alignment: Alignment.centerRight,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLabel(int index, bool isMajor, bool isCenterItem) {
    final double value = index / marksPerUnit;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8.w),
      child: Text(
        value.toStringAsFixed(value % 1 == 0 ? 0 : 1),
        style: TextStyle(
          fontSize: isCenterItem
              ? (isMajor ? 16.sp : 12.sp)
              : (isMajor ? 14.sp : 10.sp),
          fontWeight: isCenterItem
              ? FontWeight.bold
              : (isMajor ? FontWeight.bold : FontWeight.normal),
          color: isCenterItem
              ? Colors.green
              : (isMajor ? Colors.red : Colors.blue),
        ),
      ),
    );
  }

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
}

// Helper classes
enum RulerLineType { centimeter, halfCentimeter, millimeter }

class LineProperties {
  final double percentage;
  final double width;
  final Color color;

  LineProperties(this.percentage, this.width, this.color);
}
