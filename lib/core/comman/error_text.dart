import 'package:flutter/material.dart';

class ErrorText extends StatelessWidget {
  final String errorMessage;
  const ErrorText({super.key, required this.errorMessage});

  @override
  Widget build(BuildContext context) {
    return  Center(
      child: Text(
        errorMessage,
        style: TextStyle(
          color: Theme.of(context).colorScheme.error,
          fontSize: 16,
        ),
      ),
    );
  }
}