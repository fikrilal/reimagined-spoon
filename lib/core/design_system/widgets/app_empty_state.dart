import 'package:flutter/material.dart';
import 'package:reimagined_spoon/core/design_system/theme/tokens/app_sizing.dart';
import 'package:reimagined_spoon/core/design_system/theme/tokens/app_spacing.dart';
import 'package:reimagined_spoon/core/design_system/widgets/app_button.dart';

class AppEmptyState extends StatelessWidget {
  const AppEmptyState({
    super.key,
    required this.title,
    this.description,
    this.icon = Icons.inbox_outlined,
    this.actionLabel,
    this.onAction,
  }) : assert(
         (actionLabel == null) == (onAction == null),
         'actionLabel and onAction must be provided together.',
       );

  final String title;
  final String? description;
  final IconData icon;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.space24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: AppSizing.iconLarge,
              color: theme.colorScheme.outline,
            ),
            const SizedBox(height: AppSpacing.space12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium,
            ),
            if (description case final value?) ...[
              const SizedBox(height: AppSpacing.space8),
              Text(
                value,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
            if (actionLabel case final label?) ...[
              const SizedBox(height: AppSpacing.space24),
              AppButton.primary(text: label, onPressed: onAction),
            ],
          ],
        ),
      ),
    );
  }
}
