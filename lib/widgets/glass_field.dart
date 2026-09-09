import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/app_colors.dart';


class GlassField extends StatelessWidget {

  final String title;
  final IconData icon;
  final TextEditingController controller;
  final bool phone;


  const GlassField({
    super.key,
    required this.title,
    required this.icon,
    required this.controller,
    this.phone = false,
  });


  @override
  Widget build(BuildContext context) {

    return Container(

      margin: const EdgeInsets.only(bottom: 12),

      decoration: BoxDecoration(

        color: Colors.white.withValues(alpha: .85),

        borderRadius: BorderRadius.circular(16),

        boxShadow: [

          BoxShadow(
            color: Colors.black.withValues(alpha: .05),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),

        ],

      ),

      child: TextField(

        controller: controller,

        keyboardType: phone
            ? TextInputType.phone
            : TextInputType.text,

        inputFormatters: phone
            ? [
          FilteringTextInputFormatter.digitsOnly,
        ]
            : null,

        textAlign: TextAlign.right,

        decoration: InputDecoration(

          prefixIcon: Icon(
            icon,
            color: AppColors.primary,
          ),

          hintText: title,

          border: InputBorder.none,

          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 12,
          ),

        ),

      ),

    );

  }

}