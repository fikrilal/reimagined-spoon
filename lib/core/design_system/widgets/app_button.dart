import 'package:flutter/material.dart';
import 'package:reimagined_spoon/core/design_system/theme/tokens/app_sizing.dart';
import 'package:reimagined_spoon/core/design_system/theme/tokens/app_spacing.dart';

enum AppButtonVariant { primary, outline, danger }

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.icon,
    this.isLoading = false,
    this.isExpanded = false,
  });

  const AppButton.primary({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
    this.isExpanded = false,
  }) : variant = AppButtonVariant.primary;

  const AppButton.outline({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
    this.isExpanded = false,
  }) : variant = AppButtonVariant.outline;

  const AppButton.danger({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
    this.isExpanded = false,
  }) : variant = AppButtonVariant.danger;

  final String text;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final Widget? icon;
  final bool isLoading;
  final bool isExpanded;

  @override
  Widget build(BuildContext context) {
    final action = isLoading ? null : onPressed;
    final child = _ButtonContent(text: text, icon: icon, isLoading: isLoading);
    final Widget button = switch (variant) {
      AppButtonVariant.primary => ElevatedButton(
        onPressed: action,
        child: child,
      ),
      AppButtonVariant.outline => OutlinedButton(
        onPressed: action,
        child: child,
      ),
      AppButtonVariant.danger => ElevatedButton(
        onPressed: action,
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.error,
          foregroundColor: Theme.of(context).colorScheme.onError,
        ),
        child: child,
      ),
    };

    if (!isExpanded) {
      return button;
    }

    return SizedBox(width: double.infinity, child: button);
  }
}

class _ButtonContent extends StatelessWidget {
  const _ButtonContent({
    required this.text,
    required this.icon,
    required this.isLoading,
  });

  final String text;
  final Widget? icon;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final leading = isLoading
        ? SizedBox.square(
            dimension: AppSizing.iconSmall,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: DefaultTextStyle.of(context).style.color,
            ),
          )
        : icon;

    if (leading == null) {
      return Text(text);
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        leading,
        const SizedBox(width: AppSpacing.space8),
        Flexible(child: Text(text, overflow: TextOverflow.ellipsis)),
      ],
    );
  }
}
