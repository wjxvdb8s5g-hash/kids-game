import 'package:flutter/material.dart';

class ComboMeter extends StatelessWidget {
  const ComboMeter({super.key, required this.combo});

  final int combo;

  @override
  Widget build(BuildContext context) {
    final progress = (combo % 10) / 10;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Combo: $combo', style: const TextStyle(color: Colors.white)),
        Semantics(
          label: 'Combo göstergesi',
          value: '${(progress * 100).toStringAsFixed(0)} yüzde',
          child: LinearProgressIndicator(value: progress, minHeight: 8),
        ),
      ],
    );
  }
}
