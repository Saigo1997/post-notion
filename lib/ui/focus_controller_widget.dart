import 'package:flutter/material.dart';

class FocusController extends StatelessWidget {
  final Widget child;

  const FocusController({
    required this.child,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final focusNode = FocusNode();

    return Focus(
      focusNode: focusNode,
      child: GestureDetector(
        onTap: focusNode.requestFocus,
        child: child,
      ),
    );
  }
}
