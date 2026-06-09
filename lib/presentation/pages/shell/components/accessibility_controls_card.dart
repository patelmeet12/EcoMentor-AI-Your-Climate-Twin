import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../providers/theme_provider.dart';

/// A component that renders controls to update theme mode, high contrast mode, and text scale sizing.
class AccessibilityControlsCard extends ConsumerWidget {
  final bool isDark;
  final bool highContrast;

  const AccessibilityControlsCard({
    super.key,
    required this.isDark,
    required this.highContrast,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        // Theme Mode Toggle
        _buildAccessibilityRow(
          icon: isDark ? Icons.dark_mode : Icons.light_mode,
          label: 'Theme Mode',
          widget: Switch(
            value: isDark,
            onChanged: (val) {
              ref.read(themeModeProvider.notifier).state = val ? ThemeMode.dark : ThemeMode.light;
            },
            activeColor: AppColors.primary,
          ),
        ),
        // High Contrast Toggle
        _buildAccessibilityRow(
          icon: Icons.remove_red_eye_outlined,
          label: 'High Contrast',
          widget: Switch(
            value: highContrast,
            onChanged: (val) {
              ref.read(highContrastProvider.notifier).state = val;
            },
            activeColor: AppColors.primary,
          ),
        ),
        // Text Size Toggle
        _buildAccessibilityRow(
          icon: Icons.text_fields,
          label: 'Text Size',
          widget: DropdownButton<double>(
            value: ref.watch(textScaleProvider),
            dropdownColor: isDark ? AppColors.darkCard : Colors.white,
            underline: const SizedBox.shrink(),
            onChanged: (val) {
              if (val != null) {
                ref.read(textScaleProvider.notifier).state = val;
              }
            },
            items: const [
              DropdownMenuItem(value: 0.85, child: Text('Small', style: TextStyle(fontSize: 12))),
              DropdownMenuItem(value: 1.0, child: Text('Normal', style: TextStyle(fontSize: 12))),
              DropdownMenuItem(value: 1.2, child: Text('Large', style: TextStyle(fontSize: 12))),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAccessibilityRow({
    required IconData icon,
    required String label,
    required Widget widget,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: Colors.grey),
              const SizedBox(width: 8),
              Text(label, style: const TextStyle(fontSize: 12)),
            ],
          ),
          widget,
        ],
      ),
    );
  }
}
