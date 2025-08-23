import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../constants/radius_utils.dart';
import '../theme/app_colors.dart';

const List<int> availableRowsPerPageFixed = <int>[10, 20, 30, 40, 50];

class SfDataGridPaginationWithAllData<T> extends StatelessWidget {
  final T controller;
  final List<GridColumn> dynamicColumns;
  final int totalItems;
  final int rowsPerPage;
  final Function(int pageIndex) onPageNavigationStart;
  final Function(int pageIndex) onPageNavigationEnd;
  final ValueChanged<int?>? onRowsPerPageChanged;
  final DataGridSource source;
  final bool hidePaging;
  final List<GridTableSummaryRow> tableSummaryRows;
  final GlobalKey<SfDataGridState>? sfDataKey;
  final bool isScrollbarAlwaysShown;
  final ScrollPhysics verticalScrollPhysics;
  final List<StackedHeaderRow>? stackedHeaderRows;

  const SfDataGridPaginationWithAllData({
    super.key,
    required this.controller,
    required this.dynamicColumns,
    required this.totalItems,
    this.rowsPerPage = 10,
    required this.onPageNavigationStart,
    required this.onPageNavigationEnd,
    required this.onRowsPerPageChanged,
    required this.source,
    this.hidePaging = false,
    this.sfDataKey,
    this.tableSummaryRows = const <GridTableSummaryRow>[],
    this.isScrollbarAlwaysShown = true,
    this.verticalScrollPhysics = const AlwaysScrollableScrollPhysics(),
    this.stackedHeaderRows,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(child: _buildDataGrid(context)),
        hidePaging ? Container() : _buildPager(),
      ],
    );
  }

  Widget _buildDataGrid(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.transparent, width: 0.5),
        borderRadius: RadiusUtils.borderRadiusForDataGrid,
      ),
      child: SfDataGridTheme(
        data: SfDataGridThemeData(
          headerColor: AppColors.blue,
          sortIconColor: Colors.grey.shade300,
          gridLineColor: Colors.transparent,
          rowHoverColor: Colors.black12,
        ),
        child: ClipRRect(
          borderRadius: RadiusUtils.borderRadiusForDataGrid,
          child: SfDataGrid(
            key: sfDataKey ?? GlobalKey<SfDataGridState>(),
            source: source,
            columnWidthMode: ColumnWidthMode.fill,
            tableSummaryRows: tableSummaryRows,
            columnWidthCalculationRange: ColumnWidthCalculationRange.allRows,
            // onQueryRowHeight: (details) {
            //   return details.rowIndex == 0 ? 45.0 : 50.0;
            // },
            onQueryRowHeight: (details) {
              // Header row
              if (details.rowIndex == 0) return 45;

              final DataGridRow row = source.rows[details.rowIndex - 1];

              // Get value of Narr column
              final narrCell = row.getCells().firstWhere(
                    (cell) => cell.columnName == 'Narr',
                orElse: () => const DataGridCell(columnName: 'Narr', value: ''),
              );

              final String text = narrCell.value?.toString() ?? '';

              // Assume Narr column width (match your GridColumn width)
              double columnWidth = 200;

              // Use TextPainter to measure wrapped text
              final textPainter = TextPainter(
                text: TextSpan(
                  text: text,
                  style: const TextStyle(fontSize: 14),
                ),
                textDirection: TextDirection.ltr,
                maxLines: null,
              )..layout(maxWidth: columnWidth);

              final height = textPainter.size.height; // + padding

              // Ensure min 50, max 200
              return height.clamp(50.0, 100.0);
            },
            showHorizontalScrollbar: true,
            showVerticalScrollbar: true,
            verticalScrollPhysics: verticalScrollPhysics,
            isScrollbarAlwaysShown: isScrollbarAlwaysShown,
            allowSorting: true,
            gridLinesVisibility: GridLinesVisibility.both,
            headerGridLinesVisibility: GridLinesVisibility.both,
            columns: dynamicColumns,
            stackedHeaderRows: stackedHeaderRows ?? [],
          ),
        ),
      ),
    );
  }

  Widget _buildPager() {
    final double pageCount = (totalItems / rowsPerPage).ceilToDouble();
    return SfDataPagerTheme(
      data: const SfDataPagerThemeData(
        selectedItemColor: AppColors.blue,
        selectedItemTextStyle: TextStyle(color: Colors.white),
      ),
      child: SfDataPager(
        pageCount: pageCount,
        delegate: source,
        availableRowsPerPage: availableRowsPerPageFixed,
        onPageNavigationStart: onPageNavigationStart,
        onPageNavigationEnd: onPageNavigationEnd,
        onRowsPerPageChanged: onRowsPerPageChanged,
      ),
    );
  }
}
