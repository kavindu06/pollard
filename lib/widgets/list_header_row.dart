import 'package:flutter/material.dart';
import 'package:pollard/theme/app_theme.dart';

/// One column of a [ListHeaderRow] / [DataRowItem].
class RowColumn {
  final int flex;
  final TextAlign align;

  const RowColumn({this.flex = 1, this.align = TextAlign.right});
}

/// Uppercase gray header row shown at the top of a list card
/// (e.g. ITEM | PRICE | QTY).
class ListHeaderRow extends StatelessWidget {
  final List<String> labels;
  final List<RowColumn> columns;

  const ListHeaderRow({
    Key? key,
    required this.labels,
    required this.columns,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surfaceContainer,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          for (int i = 0; i < labels.length; i++)
            Expanded(
              flex: columns[i].flex,
              child: Text(
                labels[i].toUpperCase(),
                textAlign: columns[i].align,
                style: AppTextStyles.labelMd,
              ),
            ),
        ],
      ),
    );
  }
}

/// A data row matching a [ListHeaderRow]'s columns: first cell styled as the
/// item label, remaining cells as numeric data. Pass widgets for custom cells
/// (e.g. a StatusBadge).
class DataRowItem extends StatelessWidget {
  final List<Widget> cells;
  final List<RowColumn> columns;

  const DataRowItem({
    Key? key,
    required this.cells,
    required this.columns,
  }) : super(key: key);

  /// Convenience: builds a row of texts — first as label, rest as data.
  factory DataRowItem.texts({
    required List<String> values,
    required List<RowColumn> columns,
    bool bold = false,
  }) {
    return DataRowItem(
      columns: columns,
      cells: [
        for (int i = 0; i < values.length; i++)
          Text(
            values[i],
            textAlign: columns[i].align,
            style: i == 0
                ? AppTextStyles.bodyLg.copyWith(
                    fontWeight: bold ? FontWeight.w700 : FontWeight.w600)
                : AppTextStyles.dataMono.copyWith(
                    fontWeight: bold ? FontWeight.w700 : FontWeight.w500),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          for (int i = 0; i < cells.length; i++)
            Expanded(
              flex: columns[i].flex,
              child: Align(
                alignment: columns[i].align == TextAlign.right
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
                child: cells[i],
              ),
            ),
        ],
      ),
    );
  }
}
