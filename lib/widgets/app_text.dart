import 'package:flutter/cupertino.dart';

class AppText extends StatelessWidget {
  const AppText({
    super.key,
    required this.text,
    required this.size,
    required this.weight,
    required this.textColor,
    this.textAlign = TextAlign.start,
    this.maxLines = 5,
  });

  final String text;
  final FontWeight weight;
  final double size;
  final Color textColor;
  final TextAlign textAlign;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      style: TextStyle(
        fontSize: size,
        fontWeight: weight,
        color: textColor,
        fontFamily: 'Helvetica',
      ),
      overflow: TextOverflow.ellipsis,
      maxLines: maxLines,
    );
  }
}
