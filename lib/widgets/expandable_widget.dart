import 'package:flutter/material.dart';

class ExpandableItemModel {
  ExpandableItemModel(
      {required this.title, required this.body, this.isExpanded = false});
  Widget title;
  Widget body;
  bool isExpanded;
}

class ExpandableWidget extends StatefulWidget {
  const ExpandableWidget({super.key, required this.expandables});

  final List<ExpandableItemModel> expandables;

  @override
  State<ExpandableWidget> createState() => _ExpandableWidgetState();
}

class _ExpandableWidgetState extends State<ExpandableWidget> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: _renderSteps(),
      ),
    );
  }

  Widget _renderSteps() {
    return ExpansionPanelList(
      materialGapSize: 1,
      elevation: 1,
      dividerColor: Colors.transparent,
      expandedHeaderPadding: const EdgeInsets.all(0.0),
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          widget.expandables[index].isExpanded = isExpanded;
        });
      },
      children: widget.expandables
          .map<ExpansionPanel>((ExpandableItemModel expandable) {
        return ExpansionPanel(
          headerBuilder: (BuildContext context, bool isExpanded) {
            return expandable.title;
          },
          body: expandable.body,
          isExpanded: expandable.isExpanded,
        );
      }).toList(),
    );
  }
}
