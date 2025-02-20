import 'package:flutter/material.dart';

class PromoCodeInput extends StatefulWidget {
  final Function(String) onSubmit;

  const PromoCodeInput({
    super.key,
    required this.onSubmit,
  });

  @override
  _PromoCodeInputState createState() => _PromoCodeInputState();
}

class _PromoCodeInputState extends State<PromoCodeInput> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            offset: const Offset(0, -4),
            blurRadius: 30,
            spreadRadius: 0,
          ),
        ],
      ),
      child: TextField(
        controller: _controller,
        decoration: InputDecoration(
          hintText: 'Enter your promo code',
          hintStyle: TextStyle(
            color: Colors.grey[400],
            fontSize: 16,
          ),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          suffixIcon: Container(
            margin: const EdgeInsets.all(4),
            decoration: const BoxDecoration(
              color: Colors.black,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: () {
                widget.onSubmit(_controller.text);
              },
              icon: const Icon(
                Icons.arrow_forward,
                color: Colors.white,
                size: 20,
              ),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ),
        ),
      ),
    );
  }
}