import 'package:flutter/material.dart';

void showAddEditKeyValueModalSheet({
  required BuildContext context,
  required Future<void> Function(
          GlobalKey<FormState> formKey,
          TextEditingController keyController,
          TextEditingController valueController)
      onDone,
  required Future<void> Function() onCancel,
  (String, dynamic)? entry,
}) {
  final formKey = GlobalKey<FormState>();
  TextEditingController keyController = TextEditingController();
  TextEditingController valueController = TextEditingController();

  if (entry != null) {
    keyController.text = entry.$1;

    var value = entry.$2;
    valueController.text = "$value";
  }

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (context) {
      return SizedBox(
        height: 600,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                const Text("Add Entry"),
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: keyController,
                        enabled: entry == null ? true : false,
                        decoration: InputDecoration(
                          label: const Text("Key"),
                          hintText: "name",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.0),
                            borderSide: const BorderSide(
                              width: 0,
                              style: BorderStyle.solid,
                              color: Color(0x00212143),
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Key can not be empty';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      TextFormField(
                        controller: valueController,
                        decoration: InputDecoration(
                          label: const Text("Value"),
                          hintText: "Joel",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.0),
                            borderSide: const BorderSide(
                              width: 0,
                              style: BorderStyle.solid,
                              color: Color(0x00212143),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  onPressed: () async {
                    onDone(formKey, keyController, valueController);
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(
                    Icons.check,
                    size: 64,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(
                    Icons.close,
                    size: 64,
                  ),
                ),
              ],
            )
          ],
        ),
      );
    },
  );
}
