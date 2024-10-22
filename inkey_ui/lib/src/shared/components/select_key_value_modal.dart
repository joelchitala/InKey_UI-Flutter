import 'package:flutter/material.dart';
import 'package:inkey_flutter_v1/inkey_flutter_v1.dart';
import 'package:inkey_ui/src/shared/components/select_key_value_widget.dart';

void selectKeyValueModal({
  required BuildContext context,
  required InKeyDB inKeyDB,
  required void Function((String, dynamic) entry) onClick,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) {
      return SizedBox(
        height: 640,
        child: Column(
          children: [
            const Text("Select Key-Value Pair"),
            Expanded(
              child: FutureBuilder(
                future: inKeyDB.getAllEntries(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const CircularProgressIndicator();
                  }

                  return SelectKeyValueWidget(
                    keyValues: snapshot.data!,
                    onClick: (entry) {
                      Navigator.of(context).pop();
                      onClick(entry);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      );
    },
  );
}
