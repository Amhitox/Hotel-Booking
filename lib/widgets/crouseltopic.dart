import 'package:chawi_hotel/utils/constants/colors.dart';
import 'package:flutter/material.dart';

class Crouseltopic extends StatelessWidget {
  final bool isSelected;
  final String topic;
  const Crouseltopic(
      {super.key, required this.isSelected, required this.topic});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 165,
      margin: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primary : Colors.grey[300],
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          if (isSelected)
            BoxShadow(
              color: AppColors.primary.withOpacity(0.5),
              blurRadius: 2,
              spreadRadius: 1,
            ),
        ],
      ),
      alignment: Alignment.center,
      child: Text(
        topic,
        style: isSelected
            ? TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              )
            : Theme.of(context).textTheme.titleLarge,
      ),
    );
  }
}
