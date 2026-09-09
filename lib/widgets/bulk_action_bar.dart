import 'package:flutter/material.dart';

class BulkActionBar extends StatelessWidget {
  final bool selectAll;
  final VoidCallback onSelectAll;
  final VoidCallback onDelete;
  final VoidCallback onExport;

  const BulkActionBar({
    super.key,
    required this.selectAll,
    required this.onSelectAll,
    required this.onDelete,
    required this.onExport,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Checkbox(
            value: selectAll,
            onChanged: (_) => onSelectAll(),
          ),
          const Text("انتخاب همه"),
          const Spacer(),
          IconButton(
            onPressed: onExport,
            tooltip: "خروجی اکسل",
            icon: const Icon(Icons.file_download_outlined),
          ),
          IconButton(
            onPressed: onDelete,
            tooltip: "حذف انتخاب شده",
            icon: const Icon(
              Icons.delete_outline,
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}
