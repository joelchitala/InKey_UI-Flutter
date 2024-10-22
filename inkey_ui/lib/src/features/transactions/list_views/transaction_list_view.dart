import 'package:flutter/material.dart';
import 'package:inkey_ui/src/features/transactions/model/operation_model.dart';

class TransactionListView extends StatelessWidget {
  final List<OperationModel> operations;
  final void Function(OperationModel operation) onDelete;

  const TransactionListView({
    super.key,
    required this.operations,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        shrinkWrap: true,
        itemBuilder: (context, index) {
          var operation = operations[index];

          return Container(
            padding: const EdgeInsets.all(16.0),
            decoration: const BoxDecoration(
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
                  child: Column(
                    children: [
                      Text("${operation.runtimeType}: "),
                      Text("${operation.content}: "),
                    ],
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        onDelete(operation);
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
        itemCount: operations.length);
  }
}
