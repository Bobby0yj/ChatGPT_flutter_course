import 'package:flutter/material.dart';
import '../providers copy/color_provider.dart';
import '../providers/color_provider.dart';
import 'package:provider/provider.dart';

class ColorsBottomSheet extends StatelessWidget {
  const ColorsBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    var myColors = context.watch<ColorProvider>().colors;
    Color selectedColor;
    return Container(
      height: 250,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
      child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
          ),
          itemCount: myColors.length,
          itemBuilder: (context, index) {
            final currentColor = myColors[index];
            return GestureDetector(
              onTap: () {
                context.read<ColorProvider>().setBgColor(currentColor);
                selectedColor = currentColor;
                Navigator.pop(context, selectedColor.value);
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: 20, // Set the desired width
                  height: 20, // Set the desired height
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: currentColor,
                  ),
                ),
              ),
            );
          }),
    );
  }
}
