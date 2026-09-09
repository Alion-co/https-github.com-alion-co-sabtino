import 'package:flutter/material.dart';

import '../models/location_model.dart';
import '../theme/app_colors.dart';
import 'glass_card.dart';

class LocationCard extends StatelessWidget {
  final LocationData item;
  final bool checked;
  final ValueChanged<bool?> onSelected;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onMap;

  const LocationCard({
    super.key,
    required this.item,
    required this.checked,
    required this.onSelected,
    required this.onEdit,
    required this.onDelete,
    required this.onMap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GlassCard(
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Checkbox(
                    value: checked,
                    onChanged: onSelected,
                  ),
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: .12),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.person_outline,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (item.type.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Text(
                              "نوع: ${item.type}",
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        if (item.address.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Text(item.address),
                          ),
                        if (item.phone.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                item.phone,
                                textDirection: TextDirection.ltr,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              const Divider(),
              Row(
                children: [
                  IconButton(
                    onPressed: onEdit,
                    tooltip: "ویرایش",
                    icon: const Icon(Icons.edit_outlined),
                  ),
                  IconButton(
                    onPressed: onDelete,
                    tooltip: "حذف",
                    icon: const Icon(
                      Icons.delete_outline,
                      color: Colors.red,
                    ),
                  ),
                  const Spacer(),
                  TextButton.icon(
                    onPressed: onMap,
                    icon: const Icon(Icons.map_outlined),
                    label: const Text("نقشه"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
