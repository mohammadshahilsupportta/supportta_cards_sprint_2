// ignore_for_file: use_build_context_synchronously

import '/widgets/common_bottom_sheet.dart';
import '/widgets/loading_button.dart';
import 'package:flutter/material.dart';

// For `navigatorKey`

mixin FormValidatorMixin<T extends StatefulWidget> on State<T> {
  bool buttonLoading = false;
  bool dataChanged = false;
  String debugLabel = "form_key_debug_label";

  late final GlobalKey<FormState> formKey;
  final ScrollController formScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    formKey = GlobalKey<FormState>(debugLabel: debugLabel);
  }

  void makeButtonLoading() {
    buttonLoading = true;
    setState(() {});
  }

  void makeButtonNotLoading() {
    buttonLoading = false;
    setState(() {});
  }

  void makeDataChanged() {
    dataChanged = true;
  }

  Widget discardBottomSheet(BuildContext context) {
    return CommonBottomSheet(
      title: "Discard Changes",
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 24),
          const Text("Are you sure you want to discard the changes?"),
          const SizedBox(height: 16),
          LoadingButton(
            buttonLoading: false,
            text: "Discard",
            onPressed: () => Navigator.maybePop(context, true),
          ),
        ],
      ),
    );
  }

  Future<void> onFormPopInvoked(bool didPop, dynamic result) async {
    final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

    if (didPop) return;
    if (dataChanged) {
      final discard = await showModalBottomSheet(
        context: navigatorKey.currentContext!,
        builder: (context) => discardBottomSheet(context),
      );
      if (discard == true && mounted) {
        Navigator.pop(context);
      }
    } else {
      if (mounted) {
        Navigator.pop(context, true);
      }
    }
  }

  bool validate() {
    if (!formKey.currentState!.validate()) {
      tougleScroll();
      return false;
    }
    return true;
  }

  void tougleScroll() {
    if (!formScrollController.hasClients) return;
    atBottom() ? scrollToTop() : scrollToBottom();
  }

  bool atBottom() {
    if (!formScrollController.hasClients) return false;
    return formScrollController.position.pixels ==
        formScrollController.position.maxScrollExtent;
  }

  void scrollToTop() {
    if (!formScrollController.hasClients) return;
    formScrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.fastOutSlowIn,
    );
  }

  void scrollToBottom() {
    if (!formScrollController.hasClients) return;
    formScrollController.animateTo(
      formScrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.fastOutSlowIn,
    );
  }
}
