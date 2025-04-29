import 'package:budgetpro/components/section_header.dart';
import 'package:budgetpro/models/income_category_enum.dart';
import 'package:budgetpro/models/income_model.dart';
import 'package:budgetpro/pages/income/ui/income_details_page.dart';
import 'package:budgetpro/utits/colors.dart';
import 'package:budgetpro/utits/utils.dart';
import 'package:flutter/material.dart';

// Import the new income summary widget
import 'income_summary_widget.dart'; // Adjust import path as needed

enum IncomeSortType {
  dateNewest,
  dateOldest,
  amountHighest,
  amountLowest,
}

class AllIncomesPage extends StatefulWidget {
  final List<IncomeModel> incomes;
  final String month;
  final String year;

  const AllIncomesPage(
      {super.key,
      required this.incomes,
      required this.month,
      required this.year});

  @override
  State<AllIncomesPage> createState() => _AllIncomesPageState();
}

class _AllIncomesPageState extends State<AllIncomesPage> {
  late List<IncomeModel> _sortedIncomes;
  IncomeSortType _currentSortType = IncomeSortType.dateOldest;
  bool _shouldRefresh = false;

  @override
  void initState() {
    super.initState();
    _sortedIncomes = List.from(widget.incomes);
    _sortIncomes();
  }

  void _sortIncomes() {
    switch (_currentSortType) {
      case IncomeSortType.dateNewest:
        _sortedIncomes.sort((a, b) =>
            Utils.parseDate(b.date).compareTo(Utils.parseDate(a.date)));
        break;
      case IncomeSortType.dateOldest:
        _sortedIncomes.sort((a, b) =>
            Utils.parseDate(a.date).compareTo(Utils.parseDate(b.date)));
        break;
      case IncomeSortType.amountHighest:
        _sortedIncomes.sort((a, b) => b.amount.compareTo(a.amount));
        break;
      case IncomeSortType.amountLowest:
        _sortedIncomes.sort((a, b) => a.amount.compareTo(b.amount));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true, // Allow normal back button behavior
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        // When back button pressed, pass the refresh flag to previous screen
        Navigator.of(context).pop(_shouldRefresh);
      },
      child: Scaffold(
        appBar: AppBar(
            title: Text('${widget.month} ${widget.year}',
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontFamily: "Sora")),
            foregroundColor: Colors.white,
            backgroundColor: AppColors.primaryColor),
        body: Container(
          color: Colors.grey.shade200,
          height: MediaQuery.of(context).size.height,
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  const SectionHeader(text: 'Income Summary'),
                  // Income Summary Widget
                  IncomeSummaryWidget(incomes: widget.incomes),

                  const SizedBox(height: 16),
                  // Sort indicator
                  Row(children: [
                    const SectionHeader(text: 'All Incomes'),
                    const Spacer(),
                    PopupMenuButton<IncomeSortType>(
                      icon: const Icon(Icons.sort),
                      onSelected: (IncomeSortType result) {
                        setState(() {
                          _currentSortType = result;
                          _sortIncomes();
                        });
                      },
                      itemBuilder: (BuildContext context) =>
                          <PopupMenuEntry<IncomeSortType>>[
                        const PopupMenuItem<IncomeSortType>(
                          value: IncomeSortType.dateNewest,
                          child: Text('Date (Newest First)'),
                        ),
                        const PopupMenuItem<IncomeSortType>(
                          value: IncomeSortType.dateOldest,
                          child: Text('Date (Oldest First)'),
                        ),
                        const PopupMenuItem<IncomeSortType>(
                          value: IncomeSortType.amountHighest,
                          child: Text('Amount (Highest First)'),
                        ),
                        const PopupMenuItem<IncomeSortType>(
                          value: IncomeSortType.amountLowest,
                          child: Text('Amount (Lowest First)'),
                        ),
                      ],
                    ),
                    SizedBox(width: 10),
                  ]),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, bottom: 8),
                    child: Row(
                      children: [
                        const Text(
                          'Sorted by: ',
                          style: TextStyle(
                            fontFamily: "Sora",
                            fontWeight: FontWeight.w400,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          _getSortTypeText(),
                          style: const TextStyle(
                            fontFamily: "Sora",
                            fontWeight: FontWeight.w500,
                            color: AppColors.primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Incomes list
                  Container(
                    color: Colors.white,
                    child: ListView.separated(
                      padding: const EdgeInsets.all(8),
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: _sortedIncomes.length,
                      separatorBuilder: (context, index) {
                        return const Divider(
                          height: 1,
                          thickness: 1,
                          indent: 16,
                          endIndent: 16,
                          color: Color(0xFFEEEEEE),
                        );
                      },
                      itemBuilder: (context, index) {
                        // Display income items
                        final item = _sortedIncomes[index];
                        return _incomeItem(
                          context,
                          icon: item.category.icon,
                          iconBackgroundColor:
                              item.category.color.withOpacity(0.2),
                          iconColor: item.category.color,
                          title: item.source,
                          subtitle: item.date,
                          trailingText: Utils.formatRupees(item.amount),
                          onTap: () => _navigateToIncomeDetails(item),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _navigateToIncomeDetails(IncomeModel income) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => IncomeDetailsPage(income: income),
      ),
    );

    // If there was a change (update or delete), set the flag to refresh parent
    if (result == true && mounted) {
      setState(() {
        _shouldRefresh = true;
      });

      Navigator.pop(context, true);
    }
  }

  String _getSortTypeText() {
    switch (_currentSortType) {
      case IncomeSortType.dateNewest:
        return 'Date (Newest First)';
      case IncomeSortType.dateOldest:
        return 'Date (Oldest First)';
      case IncomeSortType.amountHighest:
        return 'Amount (Highest First)';
      case IncomeSortType.amountLowest:
        return 'Amount (Lowest First)';
    }
  }

  Widget _incomeItem(
    BuildContext context, {
    required IconData icon,
    required Color iconBackgroundColor,
    required Color iconColor,
    required String title,
    String? subtitle,
    String? trailingText,
    Color? textColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(top: 10, bottom: 10, left: 8, right: 8),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: iconBackgroundColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                size: 20,
                color: iconColor,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: "Sora",
                      fontWeight: FontWeight.w500,
                      color: textColor ?? Colors.black,
                    ),
                  ),
                  if (subtitle != null)
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: "Sora",
                        fontWeight: FontWeight.w400,
                        color: textColor ?? Colors.grey,
                      ),
                    ),
                ],
              ),
            ),
            if (trailingText != null)
              Text(
                trailingText,
                style: const TextStyle(
                  fontSize: 14,
                  fontFamily: "Sora",
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            const Icon(
              Icons.chevron_right,
              color: Colors.grey,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
