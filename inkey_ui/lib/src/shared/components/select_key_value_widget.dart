import 'package:flutter/material.dart';

class SelectKeyValueWidget extends StatelessWidget {
  final Map<String, dynamic> keyValues;
  final void Function((String, dynamic) entry) onClick;

  const SelectKeyValueWidget({
    super.key,
    required this.keyValues,
    required this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    var keys = keyValues.keys.toList();
    return ListView.separated(
        itemBuilder: (context, index) {
          var key = keys[index];
          var value = keyValues[key];

          return TextButton(
            onPressed: () {
              onClick((key, value));
            },
            child: Text("$key: $value"),
          );
        },
        separatorBuilder: (context, index) {
          return const SizedBox(
            height: 16,
          );
        },
        itemCount: keyValues.length);
  }
}
