import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ViewModelProvider<T extends ChangeNotifier> extends StatefulWidget {
  final Function(T value) onInit;
  final Function(T value) onDidChange;
  final Function(T value) onDispose;
  final T viewModel;
  final Widget Function(T value) builder;
  ViewModelProvider(
      {@required this.viewModel,
      @required this.builder,
      this.onInit,
      this.onDidChange,
      this.onDispose});

  @override
  _ViewModelProviderState<T> createState() => _ViewModelProviderState<T>();
}

class _ViewModelProviderState<T extends ChangeNotifier>
    extends State<ViewModelProvider<T>> {
  @override
  void initState() {
    super.initState();
    if (widget.onInit != null) {
      widget.onInit(widget.viewModel);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (widget.onDidChange != null) {
      widget.onDidChange(widget.viewModel);
    }
  }

  @override
  void dispose() {
    super.dispose();
    if (widget.onDispose != null) {
      widget.onDispose(widget.viewModel);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<T>(
      create: (_) => widget.viewModel,
      child: Consumer(
        builder: (BuildContext context, T value, Widget child) =>
            widget.builder(value),
      ),
    );
  }
}
