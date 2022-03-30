import 'package:flutter/material.dart';

class TaskContainer extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color boxColor;

  const TaskContainer(
      {Key? key,
      required this.title,
      required this.subtitle,
      required this.boxColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: const TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w700,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Text(
              subtitle,
              style: const TextStyle(
                fontSize: 14.0,
                color: Colors.black54,
                fontWeight: FontWeight.w400,
              ),
            ),
          )
        ],
      ),
      decoration: BoxDecoration(
          color: boxColor, borderRadius: BorderRadius.circular(30.0)),
    );
  }
}