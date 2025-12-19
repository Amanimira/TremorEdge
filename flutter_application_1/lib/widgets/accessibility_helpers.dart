import 'package:flutter/material.dart';
import 'package:tremor_ring_app/services/accessibility_service.dart';
import 'package:tremor_ring_app/utils/colors.dart';
import 'package:tremor_ring_app/utils/theme.dart';

/// Accessibility Helper Widgets
/// Pre-built widgets with accessibility built-in

/// Enhanced button with large touch target and haptic feedback
class AccessibleButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;
  final IconData? icon;
  final Color? color;
  final bool isLoading;
  final String? semanticLabel;
  final double minSize;

  const AccessibleButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.icon,
    this.color,
    this.isLoading = false,
    this.semanticLabel,
    this.minSize = AppTheme.minTouchSize,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticLabel ?? label,
      button: true,
      enabled: !isLoading,
      onTap: isLoading ? null : onPressed,
      child: SizedBox(
        height: minSize,
        child: ElevatedButton.icon(
          onPressed: isLoading
              ? null
              : () {
                  AccessibilityService.mediumTap();
                  onPressed();
                },
          icon: isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : Icon(icon ?? Icons.check),
          label: Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
          ),
        ),
      ),
    );
  }
}

/// Card with accessibility label and tap feedback
class AccessibleCard extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final String? semanticLabel;
  final Color? color;
  final double elevation;

  const AccessibleCard({
    super.key,
    required this.child,
    this.onTap,
    this.semanticLabel,
    this.color,
    this.elevation = 0,
  });

  @override
  State<AccessibleCard> createState() => _AccessibleCardState();
}

class _AccessibleCardState extends State<AccessibleCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: widget.semanticLabel,
      button: widget.onTap != null,
      enabled: widget.onTap != null,
      onTap: widget.onTap,
      child: GestureDetector(
        onTapDown: (_) {
          if (widget.onTap != null) {
            setState(() => _isPressed = true);
            AccessibilityService.lightTap();
          }
        },
        onTapUp: (_) {
          if (widget.onTap != null) {
            setState(() => _isPressed = false);
            widget.onTap?.call();
          }
        },
        onTapCancel: () {
          if (widget.onTap != null) {
            setState(() => _isPressed = false);
          }
        },
        child: Card(
          color: widget.color,
          elevation: _isPressed ? widget.elevation + 2 : widget.elevation,
          child: widget.child,
        ),
      ),
    );
  }
}

/// Text input with large font and accessible label
class AccessibleTextField extends StatefulWidget {
  final String label;
  final String? hint;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final VoidCallback? onChanged;
  final String? Function(String?)? validator;
  final String? semanticLabel;
  final int maxLines;
  final int minLines;

  const AccessibleTextField({
    super.key,
    required this.label,
    this.hint,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.onChanged,
    this.validator,
    this.semanticLabel,
    this.maxLines = 1,
    this.minLines = 1,
  });

  @override
  State<AccessibleTextField> createState() => _AccessibleTextFieldState();
}

class _AccessibleTextFieldState extends State<AccessibleTextField> {
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    if (_focusNode.hasFocus) {
      AccessibilityService.lightTap();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: widget.semanticLabel ?? widget.label,
      textField: true,
      enabled: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: widget.controller,
            focusNode: _focusNode,
            keyboardType: widget.keyboardType,
            maxLines: widget.maxLines,
            minLines: widget.minLines,
            onChanged: (_) => widget.onChanged?.call(),
            validator: widget.validator,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
            decoration: InputDecoration(
              hintText: widget.hint,
              hintStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:
                    const BorderSide(color: AppColors.border, width: 2),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Accessible switch with large touch area
class AccessibleSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final String label;
  final String? description;
  final String? semanticLabel;

  const AccessibleSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    required this.label,
    this.description,
    this.semanticLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticLabel ?? label,
      button: true,
      enabled: true,
      onTap: () {
        AccessibilityService.mediumTap();
        onChanged(!value);
      },
      child: GestureDetector(
        onTap: () {
          AccessibilityService.mediumTap();
          onChanged(!value);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    if (description != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        description!,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                      ),
                    ],
                  ],
                ),
              ),
              Switch(
                value: value,
                onChanged: (newValue) {
                  AccessibilityService.mediumTap();
                  onChanged(newValue);
                },
                activeThumbColor: AppColors.success,
                inactiveThumbColor: AppColors.textSecondary,
                inactiveTrackColor: AppColors.border,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Accessible slider with large touch area
class AccessibleSlider extends StatelessWidget {
  final double value;
  final ValueChanged<double> onChanged;
  final double min;
  final double max;
  final String label;
  final String Function(double) valueFormatter;
  final String? semanticLabel;

  const AccessibleSlider({
    super.key,
    required this.value,
    required this.onChanged,
    required this.label,
    this.min = 0,
    this.max = 100,
    required this.valueFormatter,
    this.semanticLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticLabel ?? label,
      slider: true,
      enabled: true,
      onIncrease: value < max ? () => onChanged(value + 1) : null,
      onDecrease: value > min ? () => onChanged(value - 1) : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Text(
                valueFormatter(value),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Slider(
            value: value,
            onChanged: onChanged,
            min: min,
            max: max,
            divisions: ((max - min) / 5).toInt(),
            activeColor: AppColors.primary,
            inactiveColor: AppColors.border,
          ),
        ],
      ),
    );
  }
}

/// Alert dialog with accessibility support
Future<void> showAccessibleDialog({
  required BuildContext context,
  required String title,
  required String content,
  required String positiveButtonText,
  String? negativeButtonText,
  required VoidCallback onPositive,
  VoidCallback? onNegative,
}) async {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return Semantics(
        label: title,
        enabled: true,
        child: AlertDialog(
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
          ),
          content: SingleChildScrollView(
            child: Text(
              content,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          contentPadding: const EdgeInsets.all(24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          actions: [
            if (negativeButtonText != null)
              SizedBox(
                height: AppTheme.minTouchSize,
                child: TextButton(
                  onPressed: () {
                    AccessibilityService.mediumTap();
                    Navigator.pop(context);
                    onNegative?.call();
                  },
                  child: Text(
                    negativeButtonText,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            SizedBox(
              height: AppTheme.minTouchSize,
              child: ElevatedButton(
                onPressed: () {
                  AccessibilityService.mediumTap();
                  Navigator.pop(context);
                  onPositive();
                },
                child: Text(
                  positiveButtonText,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}

/// Snackbar with accessibility support
void showAccessibleSnackBar(
  BuildContext context, {
  required String message,
  SnackBarAction? action,
  Duration duration = const Duration(seconds: 3),
  bool isSuccess = false,
}) {
  AccessibilityService.lightTap();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Semantics(
        label: message,
        enabled: true,
        child: Text(
          message,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Colors.white,
          ),
        ),
      ),
      backgroundColor:
          isSuccess ? AppColors.success : AppColors.surface,
      duration: duration,
      action: action,
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  );
}

/// Tooltip with larger text
class AccessibleTooltip extends StatelessWidget {
  final Widget child;
  final String message;
  final Duration showDuration;

  const AccessibleTooltip({
    super.key,
    required this.child,
    required this.message,
    this.showDuration = const Duration(seconds: 3),
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: message,
      showDuration: showDuration,
      textStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: Colors.white,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      margin: const EdgeInsets.all(20),
      child: child,
    );
  }
}
