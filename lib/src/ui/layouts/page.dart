import 'package:flutter/material.dart';

import 'package:tabnews/src/extensions/dark_mode.dart';
import 'package:tabnews/src/ui/widgets/progress_indicator.dart';
import 'package:tabnews/src/ui/widgets/top_bar.dart';

class PageLayout extends StatelessWidget {
  final Widget body;
  final bool isLoading;
  final Future<void> Function() onRefresh;

  const PageLayout({
    super.key,
    required this.body,
    required this.onRefresh,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppTopBar(),
      body: RefreshIndicator(
        color: context.isDarkMode ? Colors.white : Colors.black,
        onRefresh: onRefresh,
        child: isLoading ? const AppProgressIndicator() : body,
      ),
    );
  }
}
