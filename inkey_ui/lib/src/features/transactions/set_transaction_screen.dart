import 'package:flutter/material.dart';
import 'package:inkey_flutter_v1/inkey_flutter_v1.dart';
import 'package:inkey_ui/src/features/transactions/list_views/transaction_list_view.dart';
import 'package:inkey_ui/src/features/transactions/model/operation_model.dart';
import 'package:inkey_ui/src/shared/components/add_edit_key_value_modal.dart';
import 'package:inkey_ui/src/shared/components/select_key_value_modal.dart';

class SetTransactionScreen extends StatefulWidget {
  const SetTransactionScreen({super.key});

  @override
  State<SetTransactionScreen> createState() => _SetTransactionScreenState();
}

class _SetTransactionScreenState extends State<SetTransactionScreen> {
  InKeyDB inKeyDB = InKeyDB();

  List<OperationModel> operations = [];

  void addOperation({
    required String content,
    required OperationType operationType,
    required Future<void> Function() func,
  }) {
    setState(() {
      operations.add(
        OperationModel(
          content: content,
          operationType: operationType,
          func: func,
        ),
      );
    });
  }

  void deleteOperation(OperationModel operation) {
    setState(() {
      operations.remove(operation);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Set Transaction"),
        actions: [
          TextButton(
              onPressed: () async {
                var transaction = inKeyDB.transaction(
                  () async {
                    for (var operation in operations) {
                      await operation.run();
                    }
                  },
                );

                bool res = await transaction.execute();

                await transaction.commit();

                if (res) {
                  setState(() {
                    operations = [];
                  });
                }
              },
              child: const Text("Execute")),
        ],
      ),
      body: Column(
        children: [
          Text("Operations (${operations.length}) "),
          Expanded(
            child: TransactionListView(
              operations: operations,
              onDelete: (operation) {
                deleteOperation(operation);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (context) {
              return SizedBox(
                width: double.maxFinite,
                height: 360,
                child: Column(
                  children: [
                    const Text("Select Operation"),
                    Column(
                      children: [
                        TextButton(
                          onPressed: () {
                            showAddEditKeyValueModalSheet(
                              context: context,
                              onDone: (
                                formKey,
                                keyController,
                                valueController,
                              ) async {
                                bool res =
                                    formKey.currentState?.validate() ?? false;
                                if (!res) return;

                                addOperation(
                                  content:
                                      "Operation to Put > ${keyController.text} : ${valueController.text}",
                                  operationType: OperationType.put,
                                  func: () async {
                                    await inKeyDB.put(
                                      key: keyController.text,
                                      value: valueController.text,
                                    );
                                  },
                                );

                                // if (context.mounted) {
                                //   Navigator.of(context).pop();
                                // }
                              },
                              onCancel: () async {
                                // if (context.mounted) {
                                //   Navigator.of(context).pop();
                                // }
                              },
                            );
                          },
                          child: const Text(
                            "Put Operation",
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        TextButton(
                          onPressed: () {
                            selectKeyValueModal(
                              context: context,
                              inKeyDB: inKeyDB,
                              onClick: (entry) {
                                showAddEditKeyValueModalSheet(
                                  entry: entry,
                                  context: context,
                                  onDone: (
                                    formKey,
                                    keyController,
                                    valueController,
                                  ) async {
                                    bool res =
                                        formKey.currentState?.validate() ??
                                            false;
                                    if (!res) return;

                                    addOperation(
                                      content:
                                          "Operation to Update > ${keyController.text} : ${valueController.text}",
                                      operationType: OperationType.update,
                                      func: () async {
                                        await inKeyDB.update(
                                          key: keyController.text,
                                          value: valueController.text,
                                        );
                                      },
                                    );

                                    // if (context.mounted) {
                                    //   Navigator.of(context).pop();
                                    // }
                                  },
                                  onCancel: () async {
                                    // if (context.mounted) {
                                    //   Navigator.of(context).pop();
                                    // }
                                  },
                                );
                              },
                            );
                          },
                          child: const Text(
                            "Update Operation",
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        TextButton(
                          onPressed: () {
                            selectKeyValueModal(
                              context: context,
                              inKeyDB: inKeyDB,
                              onClick: (entry) {
                                addOperation(
                                  content:
                                      "Operation to Delete key: ${entry.$1}",
                                  operationType: OperationType.delete,
                                  func: () async {
                                    await inKeyDB.delete(key: entry.$1);
                                  },
                                );
                              },
                            );
                          },
                          child: const Text(
                            "Delete Operation",
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        TextButton(
                          onPressed: () {
                            addOperation(
                              content: "Operation to Falsify trasaction",
                              operationType: OperationType.falsify,
                              func: () async {
                                await inKeyDB.falsifyTransactional();
                              },
                            );

                            // Navigator.of(context).pop();
                          },
                          child: const Text(
                            "Falsify Operation",
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                      ],
                    )
                  ],
                ),
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
