import 'package:flutter/material.dart';
import 'package:inkey_flutter_v1/inkey_flutter_v1.dart';
import 'package:inkey_flutter_v1/src/in_key_data_store_manager.dart';

class SetRunningStateStatefulWidget extends StatefulWidget {
  final InKeyDB inKeyDB;

  const SetRunningStateStatefulWidget({
    super.key,
    required this.inKeyDB,
  });

  @override
  State<SetRunningStateStatefulWidget> createState() =>
      _SetRunStateStatefulWidgetState();
}

class _SetRunStateStatefulWidgetState
    extends State<SetRunningStateStatefulWidget> {
  late InKeyDB inKeyDB;

  @override
  void initState() {
    super.initState();

    inKeyDB = widget.inKeyDB;
  }

  @override
  Widget build(BuildContext context) {
    RunStates currentState = inKeyDB.storeManger.runState;

    return Column(
      children: [
        Text("The current InKeyDB running state is ${currentState.name}"),
        Expanded(
          child: RunStateListView(
            inKeyDB: inKeyDB,
            onclick: (runState) {
              try {
                setState(() {
                  inKeyDB.setInKeyRunState(runState);
                });
              } catch (_) {}
            },
          ),
        ),
      ],
    );
  }
}

class RunStateListTile extends StatelessWidget {
  final RunStates runState;
  final Function(RunStates runState) onclick;
  final ButtonStyle? buttonStyle;
  final TextStyle? textStyle;

  const RunStateListTile({
    super.key,
    required this.runState,
    required this.onclick,
    this.buttonStyle,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        onclick(runState);
      },
      style: buttonStyle,
      child: Text(
        runState.name,
        style: textStyle,
      ),
    );
  }
}

class RunStateListView extends StatefulWidget {
  final InKeyDB inKeyDB;
  final void Function(RunStates runState) onclick;
  final ButtonStyle? selectedButtonStyle, unselectedButtonStyle;
  final TextStyle? selectedTextStyle, unselectedTextStyle;

  const RunStateListView({
    super.key,
    required this.inKeyDB,
    required this.onclick,
    this.selectedButtonStyle,
    this.unselectedButtonStyle,
    this.selectedTextStyle,
    this.unselectedTextStyle,
  });

  @override
  State<RunStateListView> createState() => _RunStateListViewState();
}

class _RunStateListViewState extends State<RunStateListView> {
  late InKeyDB inKeyDB;

  @override
  void initState() {
    super.initState();

    inKeyDB = widget.inKeyDB;
  }

  @override
  Widget build(BuildContext context) {
    RunStates currentState = inKeyDB.storeManger.runState;
    List<RunStates> runStates = RunStates.values;

    return ListView.separated(
      itemBuilder: (context, index) {
        var state = runStates[index];

        var tile = RunStateListTile(
          runState: state,
          buttonStyle: currentState == state
              ? widget.selectedButtonStyle
              : widget.unselectedButtonStyle,
          textStyle: currentState == state
              ? widget.selectedTextStyle
              : widget.unselectedTextStyle,
          onclick: (runState) {
            setState(() {
              widget.onclick(runState);
            });
          },
        );

        return tile;
      },
      separatorBuilder: (context, index) {
        return const SizedBox(height: 10);
      },
      itemCount: runStates.length,
    );
  }
}
