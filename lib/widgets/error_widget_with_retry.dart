
import 'package:flutter/material.dart';


class ErrorWidgetWithRetry extends StatelessWidget {
  const ErrorWidgetWithRetry({
    super.key,
    required this.exception,
    required this.retry,
  });

  final Exception exception;
  final VoidCallback retry;

  @override
  Widget build(BuildContext context) {
    Widget widget = Container();
    switch (exception.runtimeType) {


      //TODO : plug Dio after configuring the dio api integration
      // case const (DioException):
      //   widget = DioExceptionWidget(exception: exception as DioException);
      default:
        widget = Center(
          child: Column(
            children: [Text(exception.toString(), textAlign: TextAlign.center)],
          ),
        );
    }
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            widget,
            TextButton(onPressed: retry, child: const Text("Retry")),
          ],
        ),
      ),
    );
  }
}
