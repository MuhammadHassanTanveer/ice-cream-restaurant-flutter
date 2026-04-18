import 'package:flutter/material.dart';

class FooterViewWidget extends StatefulWidget {
  final Widget child;
  final double minHeight;
  final bool visibility;
  const FooterViewWidget({super.key, required this.child, this.minHeight = 0.65, this.visibility = true});

  @override
  State<FooterViewWidget> createState() => _FooterViewWidgetState();
}

class _FooterViewWidgetState extends State<FooterViewWidget> {

  @override
  Widget build(BuildContext context) {
    return Column( mainAxisAlignment: MainAxisAlignment.start, children: [
      ConstrainedBox(
        constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height *0.65 ) ,
        child: Align(alignment: Alignment.topCenter, child: widget.child),
      ),

    ]);
  }
}