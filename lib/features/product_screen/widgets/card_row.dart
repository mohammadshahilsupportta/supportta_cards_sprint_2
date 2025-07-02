import 'package:flutter/material.dart';

class CardRow extends StatelessWidget {
  final String prefixText;
  final String suffixText;
  final TextStyle? prefixstyle;
  final TextStyle? sufixstyle;

  const CardRow({
    this.prefixstyle,
    this.sufixstyle,
    required this.prefixText,
    required this.suffixText,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(prefixText, style: prefixstyle),
        Spacer(),
        Expanded(
          child: Text(
            textAlign: TextAlign.right,
            suffixText,
            softWrap: true,
            maxLines: 3,
            overflow: TextOverflow.visible,
            style: sufixstyle,
          ),
        ),
      ],
    );
  }
}
