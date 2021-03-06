import 'package:flutter/material.dart';
import 'package:ghulam_app/utils/constants.dart';

class Accordion extends StatefulWidget {
  final String title;
  final String content;
  final Widget icon;

  Accordion(this.title, this.content, this.icon);
  @override
  _AccordionState createState() => _AccordionState();
}

class _AccordionState extends State<Accordion> {
  bool _showContent = false;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(children: [
        ListTile(
          leading: widget.icon,
          title: Text(widget.title, style: TextStyle(fontWeight: FontWeight.bold,color: kPrimaryColor)),
          trailing: IconButton(
            icon: Icon(
                _showContent ? Icons.arrow_drop_up : Icons.arrow_drop_down),
            onPressed: () {
              setState(() {
                _showContent = !_showContent;
              });
            },
          ),
        ),
        _showContent
            ? Container(
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
          child: Text(widget.content),
        )
            : Container()
      ]),
    );
  }
}