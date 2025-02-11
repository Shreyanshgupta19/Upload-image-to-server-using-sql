import 'package:flutter/material.dart';

class ShimmerGroup extends StatelessWidget {
  final MainAxisAlignment? rowMainAxisAlignment;
  final CrossAxisAlignment? rowCrossAxisAlignment;
  final MainAxisAlignment? columnMainAxisAlignment;
  final CrossAxisAlignment? columnCrossAxisAlignment;
  final List<Widget>? insideChildren;
  final List<Widget>? outsideChildren;

  const ShimmerGroup({
    super.key,
    this.rowMainAxisAlignment,
    this.rowCrossAxisAlignment,
    this.columnMainAxisAlignment,
    this.columnCrossAxisAlignment,
    this.insideChildren,
    this.outsideChildren,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: rowMainAxisAlignment ?? MainAxisAlignment.start,
      crossAxisAlignment: rowCrossAxisAlignment ?? CrossAxisAlignment.start,
      children: [
        Column(
          mainAxisAlignment: columnMainAxisAlignment ?? MainAxisAlignment.start,
          crossAxisAlignment: columnCrossAxisAlignment ?? CrossAxisAlignment.start,
          children: insideChildren ?? [],
        ),
        if (outsideChildren != null && outsideChildren!.isNotEmpty) ...[
          const SizedBox(width: 16),
          ...outsideChildren!,
        ],
      ],
    );
  }
}