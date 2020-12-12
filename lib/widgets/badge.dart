import 'package:flutter/material.dart';

class Badge extends StatelessWidget {
  const Badge({
    Key key,
    @required this.child,
    @required this.value,
    this.color,
  }) : super(key: key);

  final Widget child;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [child, buildPositioned(context)],
    );
  }

  Positioned buildPositioned(BuildContext context) {
    return Positioned(
      right: 8,
      top: 8,
      child: buildContainer(context),
    );
  }

  Container buildContainer(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        minWidth: 16,
        minHeight: 16,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: color != null ? color : Theme.of(context).accentColor,
      ),
      padding: EdgeInsets.all(2.0),
      child: buildText(),
    );
  }

  Text buildText() {
    return Text(
      value,
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 10),
    );
  }
}
