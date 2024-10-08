import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import '../../../../core/constants/app_colors.dart';
import '../painters/grid_painter.dart';
import '../painters/arrow_painter.dart';
import '../../../../core/constants/image_paths.dart';

class GameGridWidget extends StatefulWidget {
  final int purpleColumns;
  final int cyanRows;
  final Set<int> selectedSquares;
  final Function(int) toggleSquareSelection;
  final Function(int) updatePurpleColumns;
  final Function(int) updateCyanRows;
  final Function onReset;
  final bool highlightGreen;
  final bool showCelebration;

  const GameGridWidget({
    required this.purpleColumns,
    required this.cyanRows,
    required this.selectedSquares,
    required this.toggleSquareSelection,
    required this.updatePurpleColumns,
    required this.updateCyanRows,
    required this.onReset,
    required this.highlightGreen,
    required this.showCelebration,
  });

  @override
  _GameGridWidgetState createState() => _GameGridWidgetState();
}

class _GameGridWidgetState extends State<GameGridWidget> {
  double verticalArrowPosition = 85.h;
  double horizontalArrowPosition = 85.w;
  int tempCyanRows = 6;
  int tempPurpleColumns = 5;

  @override
  void initState() {
    super.initState();
    tempCyanRows = widget.cyanRows;
    tempPurpleColumns = widget.purpleColumns;
  }

  void _updateRowCount(double newPosition) {
    setState(() {
      verticalArrowPosition = newPosition.clamp(0.0, 170.h);
      tempCyanRows = (verticalArrowPosition / 30).round().clamp(1, 10);
    });
  }

  void _updateColumnCount(double newPosition) {
    setState(() {
      horizontalArrowPosition = newPosition.clamp(0.0, 170.w);
      tempPurpleColumns = (horizontalArrowPosition / 30).round().clamp(1, 10);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Main Game Grid
        Container(
          height: 200.h,
          width: 200.w,
          child: Stack(
            children: [
              CustomPaint(
                size: Size(200.w, 200.h),
                painter:
                    GridPainter(columns: tempPurpleColumns, rows: tempCyanRows),
              ),
              for (int row = 0; row < tempCyanRows; row++)
                for (int col = 0; col < tempPurpleColumns; col++)
                  Positioned(
                    top: row * (200.h / tempCyanRows),
                    left: col * (200.w / tempPurpleColumns),
                    child: GestureDetector(
                      onTap: () => widget
                          .toggleSquareSelection(row * tempPurpleColumns + col),
                      child: Container(
                        width: (200.w / tempPurpleColumns) - 2,
                        height: (200.h / tempCyanRows) - 2,
                        color: widget.selectedSquares
                                .contains(row * tempPurpleColumns + col)
                            ? (widget.highlightGreen
                                ? Colors.green
                                : AppColors.cyen)
                            : AppColors.grey700,
                      ),
                    ),
                  ),
              Positioned(
                top: verticalArrowPosition,
                left: 0.w,
                child: GestureDetector(
                  onPanUpdate: (details) {
                    _updateRowCount(verticalArrowPosition + details.delta.dy);
                  },
                  onPanEnd: (_) {
                    widget.updateCyanRows(tempCyanRows);
                  },
                  child: CustomPaint(
                    size: Size(25.w, 25.h),
                    painter: ArrowPainter(
                      color: AppColors.cyen,
                      direction: ArrowDirection.right,
                      number: tempCyanRows,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: verticalArrowPosition,
                right: 0.w,
                child: GestureDetector(
                  onPanUpdate: (details) {
                    _updateRowCount(verticalArrowPosition + details.delta.dy);
                  },
                  onPanEnd: (_) {
                    widget.updateCyanRows(tempCyanRows);
                  },
                  child: CustomPaint(
                    size: Size(25.w, 25.h),
                    painter: ArrowPainter(
                      color: AppColors.cyen,
                      direction: ArrowDirection.left,
                      number: tempCyanRows,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 0.h,
                left: horizontalArrowPosition,
                child: GestureDetector(
                  onPanUpdate: (details) {
                    _updateColumnCount(
                        horizontalArrowPosition + details.delta.dx);
                  },
                  onPanEnd: (_) {
                    widget.updatePurpleColumns(tempPurpleColumns);
                  },
                  child: CustomPaint(
                    size: Size(25.w, 25.h),
                    painter: ArrowPainter(
                      color: AppColors.purple,
                      direction: ArrowDirection.down,
                      number: tempPurpleColumns,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0.h,
                left: horizontalArrowPosition,
                child: GestureDetector(
                  onPanUpdate: (details) {
                    _updateColumnCount(
                        horizontalArrowPosition + details.delta.dx);
                  },
                  onPanEnd: (_) {
                    widget.updatePurpleColumns(tempPurpleColumns);
                  },
                  child: CustomPaint(
                    size: Size(25.w, 25.h),
                    painter: ArrowPainter(
                      color: AppColors.purple,
                      direction: ArrowDirection.up,
                      number: tempPurpleColumns,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Positioned Lottie animation to overlay on the grid without affecting layout
        if (widget.showCelebration)
          Positioned.fill(
            child: Center(
              child: Lottie.asset(
                ImagePaths.celebration,
                width: 500.w,
                height: 500.h,
                repeat: false,
              ),
            ),
          ),
      ],
    );
  }
}
