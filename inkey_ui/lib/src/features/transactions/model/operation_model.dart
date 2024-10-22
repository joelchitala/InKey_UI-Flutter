enum OperationType {
  put,
  update,
  delete,
  falsify,
}

class OperationModel {
  String content;
  OperationType operationType;
  Future<void> Function() func;

  OperationModel({
    required this.content,
    required this.operationType,
    required this.func,
  });

  Future<void> run() async {
    await func();
  }
}
