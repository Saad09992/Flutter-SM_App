import 'package:flutter/material.dart';

class RoundButton extends StatelessWidget {
  final String title;
  final bool loading;
  final VoidCallback onPress;

  const RoundButton(
      {super.key,
      required this.title,
      this.loading = false,
      required this.onPress});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPress,
      child: Container(
        height: 40,
        width: 200,
        decoration: BoxDecoration(
            color: Colors.purple, borderRadius: BorderRadius.circular(30)),
        child: Center(
          child: loading
              ? const CircularProgressIndicator()
              : Text(
                  title,
                  style: const TextStyle(fontSize: 20, color: Colors.white),
                ),
        ),
      ),
    );
  }
}
