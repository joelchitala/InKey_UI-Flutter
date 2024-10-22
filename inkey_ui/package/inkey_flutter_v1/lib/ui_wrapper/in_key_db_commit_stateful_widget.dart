import 'package:flutter/material.dart';
import 'package:inkey_flutter_v1/inkey_flutter_v1.dart';
import 'package:inkey_flutter_v1/src/in_key_data_store_manager.dart';

class InKeyDbCommitStatefulWidget extends StatefulWidget {
  final String filePath;
  final List<AppLifecycleState> commitStates;
  final InKeyDB inKeyDB;
  final Widget body;

  const InKeyDbCommitStatefulWidget({
    super.key,
    required this.filePath,
    required this.commitStates,
    required this.inKeyDB,
    required this.body,
  });

  @override
  State<InKeyDbCommitStatefulWidget> createState() =>
      _InKeyDbStatefulWrapperState();
}

class _InKeyDbStatefulWrapperState extends State<InKeyDbCommitStatefulWidget>
    with WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);

    if (widget.inKeyDB.storeManger.runState == RunStates.inMemoryOnly) {
      return;
    }

    if (widget.commitStates.contains(state)) {
      await widget.inKeyDB.commit(filePath: widget.filePath);
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    return widget.body;
  }
}
