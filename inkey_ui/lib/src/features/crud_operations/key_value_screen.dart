import 'package:flutter/material.dart';
import 'package:inkey_flutter_v1/inkey_flutter_v1.dart';
import 'package:inkey_ui/src/features/crud_operations/list_views/key_value_list_view.dart';
import 'package:inkey_ui/src/features/transactions/set_transaction_screen.dart';
import 'package:inkey_ui/src/shared/components/add_edit_key_value_modal.dart';

class KeyValueScreen extends StatefulWidget {
  const KeyValueScreen({super.key});

  @override
  State<KeyValueScreen> createState() => _KeyValueScreenState();
}

class _KeyValueScreenState extends State<KeyValueScreen> {
  InKeyDB inKeyDB = InKeyDB();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Key-Value"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return const SetTransactionScreen();
                  },
                ),
              );
            },
            child: const Text("Transact"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return Scaffold(
                      appBar: AppBar(),
                      body: SetRunningStateStatefulWidget(inKeyDB: inKeyDB),
                    );
                  },
                ),
              );
            },
            child: const Text("Config"),
          ),
          TextButton(
            onPressed: () {
              setState(() {});
            },
            child: const Text("Refresh"),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: FutureBuilder<Map<String, dynamic>>(
                future: inKeyDB.getAllEntries(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const CircularProgressIndicator();
                  }

                  return Column(
                    children: [
                      Text("Entries(${snapshot.data!.length})"),
                      Expanded(
                        child: KeyValueListView(
                          keyValues: snapshot.data!,
                          onEdit: (entry) async {
                            showAddEditKeyValueModalSheet(
                              context: context,
                              onDone: (
                                formKey,
                                keyController,
                                valueController,
                              ) async {
                                // bool res =
                                //     formKey.currentState?.validate() ?? false;
                                // if (!res) return;

                                // try {
                                //   await inKeyDB.update(
                                //     key: keyController.text,
                                //     value: valueController.text,
                                //   );
                                // } catch (_) {
                                //   return;
                                // }

                                // setState(() {});
                              },
                              onCancel: () async {},
                            );
                          },
                          onDelete: (entry) async {
                            await inKeyDB.delete(key: entry.$1);
                            setState(() {});
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showAddEditKeyValueModalSheet(
            context: context,
            onDone: (formKey, keyController, valueController) async {
              bool res = formKey.currentState?.validate() ?? false;
              if (!res) return;

              try {
                await inKeyDB.put(
                  key: keyController.text,
                  value: valueController.text,
                );
              } catch (_) {
                return;
              }

              setState(() {});
            },
            onCancel: () async {},
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
