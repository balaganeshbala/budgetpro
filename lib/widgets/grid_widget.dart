import 'package:flutter/material.dart';

typedef IntCallback = void Function(int);

class GridWidget extends StatelessWidget {
  final IntCallback callback;
  final List<String> gridItems;

  const GridWidget(
      {super.key, required this.gridItems, required this.callback});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: _calculateCrossAxisCount(context),
            crossAxisSpacing: 15.0, // Add spacing between columns
            mainAxisSpacing: 15.0, // Add spacing between rows
            childAspectRatio: 1.2),
        itemCount: gridItems.length,
        itemBuilder: (BuildContext context, int index) {
          return Center(
              child: Card(
                  // color: const Color.fromARGB(255, 220, 220, 187),
                  child: InkWell(
                      onTap: () {
                        callback(index);
                      },
                      child: SizedBox(
                        width: 120, // Set width of the card
                        height: 80, // Set height of the card
                        child: Center(
                          child: Text(
                            gridItems[index],
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 82, 108, 91)),
                          ),
                        ),
                      ))));
        });
  }

  int _calculateCrossAxisCount(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    const itemWidth = 100.0; // Adjust item width as needed
    final crossAxisCount = (screenWidth / itemWidth).floor();
    return crossAxisCount > 0 ? crossAxisCount : 1;
  }
}
