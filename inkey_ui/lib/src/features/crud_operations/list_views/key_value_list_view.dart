import 'package:flutter/material.dart';

class KeyValueListView extends StatelessWidget {
  final Map<String, dynamic> keyValues;
  final void Function((String, dynamic) entry)? onEdit, onDelete;

  const KeyValueListView({
    super.key,
    required this.keyValues,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    var keys = keyValues.keys.toList();
    return ListView.separated(
        itemBuilder: (context, index) {
          var key = keys[index];
          var value = keyValues[key];

          return Container(
            padding: const EdgeInsets.all(16.0),
            decoration: const BoxDecoration(
              // color: Color.fromARGB(0, 214, 41, 41),
              border: Border(
                bottom: BorderSide(
                  width: 0.5,
                ),
              ),
            ),
            child: Row(
              children: [
                Text("${index + 1} "),
                Expanded(
                  child: Row(
                    children: [
                      Text("$key: "),
                      Text("$value"),
                    ],
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        if (onEdit == null) return;
                        onEdit!((key, value));
                      },
                      icon: const Icon(Icons.edit),
                    ),
                    IconButton(
                      onPressed: () {
                        if (onDelete == null) return;
                        onDelete!((key, value));
                      },
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.redAccent,
                      ),
                    )
                  ],
                )
              ],
            ),
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
