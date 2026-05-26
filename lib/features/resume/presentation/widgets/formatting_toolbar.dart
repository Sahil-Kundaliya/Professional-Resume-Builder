import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const resumeToolbarFontOptions = [
  'Inter',
  'SansSerif',
  'Serif',
  'Monospace',
  'Georgia',
];

const resumeToolbarColorOptions = [
  0xDD000000,
  0xFF757575,
  0xFF00A86B,
  0xFF2B4A9F,
  0xFFC62828,
];

TextStyle resolveResumeToolbarTextStyle(
    String fontFamily, TextStyle baseStyle) {
  return switch (fontFamily) {
    'SansSerif' => GoogleFonts.openSans(textStyle: baseStyle),
    'Serif' => GoogleFonts.merriweather(textStyle: baseStyle),
    'Monospace' => GoogleFonts.robotoMono(textStyle: baseStyle),
    'Georgia' => baseStyle.copyWith(fontFamily: 'Georgia'),
    _ => GoogleFonts.inter(textStyle: baseStyle),
  };
}

class FormattingToolbar extends StatelessWidget {
  final bool isBold;
  final bool isItalic;
  final bool isUnderline;
  final double selectedTextSize;
  final String selectedFont;
  final int selectedColorValue;
  final bool isEnabled;
  final bool canUndo;
  final bool canRedo;
  final VoidCallback onBold;
  final VoidCallback onItalic;
  final VoidCallback onUnderline;
  final VoidCallback onUndo;
  final VoidCallback onRedo;
  final VoidCallback onIncreaseTextSize;
  final VoidCallback onDecreaseTextSize;
  final ValueChanged<String> onFontChanged;
  final ValueChanged<int> onTextColorChanged;

  const FormattingToolbar({
    super.key,
    required this.isBold,
    required this.isItalic,
    required this.isUnderline,
    required this.selectedTextSize,
    required this.selectedFont,
    required this.selectedColorValue,
    required this.isEnabled,
    required this.canUndo,
    required this.canRedo,
    required this.onBold,
    required this.onItalic,
    required this.onUnderline,
    required this.onIncreaseTextSize,
    required this.onDecreaseTextSize,
    required this.onUndo,
    required this.onRedo,
    required this.onFontChanged,
    required this.onTextColorChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Divider(height: 1),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Row(
              children: [
                _ToolBtn(
                  icon: Icons.undo,
                  onTap: canUndo ? onUndo : null,
                ),
                _ToolBtn(
                  icon: Icons.redo,
                  onTap: canRedo ? onRedo : null,
                ),
                const SizedBox(width: 4),
                _FormatBtn(
                  label: 'B',
                  bold: true,
                  active: isBold,
                  enabled: isEnabled,
                  onTap: onBold,
                  color: const Color(0xFF00A86B),
                ),
                _FormatBtn(
                  label: 'I',
                  italic: true,
                  active: isItalic,
                  enabled: isEnabled,
                  onTap: onItalic,
                ),
                _FormatBtn(
                  label: 'U',
                  underline: true,
                  active: isUnderline,
                  enabled: isEnabled,
                  onTap: onUnderline,
                ),
                const SizedBox(width: 8),
                _ToolBtn(
                  icon: Icons.text_decrease,
                  onTap: isEnabled ? onDecreaseTextSize : null,
                ),
                SizedBox(
                  width: 34,
                  child: Text(
                    selectedTextSize.toStringAsFixed(0),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color: isEnabled ? Colors.black87 : Colors.grey.shade500,
                    ),
                  ),
                ),
                _ToolBtn(
                  icon: Icons.text_increase,
                  onTap: isEnabled ? onIncreaseTextSize : null,
                ),
                const SizedBox(width: 8),
                SizedBox(
                  width: 132,
                  child: _FontDropdown(
                    value: selectedFont,
                    enabled: isEnabled,
                    onChanged: onFontChanged,
                  ),
                ),
                const SizedBox(width: 8),
                Row(
                  children: resumeToolbarColorOptions
                      .map(
                        (value) => _ColorSwatchBtn(
                          color: Color(value),
                          isSelected: value == selectedColorValue,
                          enabled: isEnabled,
                          onTap: () => onTextColorChanged(value),
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
          ),
          if (!isEnabled)
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Select any editable text field to format text.',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _ToolBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const _ToolBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Icon(
          icon,
          size: 20,
          color: onTap == null ? Colors.grey.shade400 : Colors.black87,
        ),
      ),
    );
  }
}

class _FormatBtn extends StatelessWidget {
  final String label;
  final bool bold;
  final bool italic;
  final bool underline;
  final bool active;
  final bool enabled;
  final VoidCallback onTap;
  final Color? color;

  const _FormatBtn({
    required this.label,
    this.bold = false,
    this.italic = false,
    this.underline = false,
    required this.active,
    required this.enabled,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: BorderRadius.circular(4),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: active ? (color ?? Colors.grey).withOpacity(0.15) : null,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: bold ? FontWeight.w900 : FontWeight.w400,
            fontStyle: italic ? FontStyle.italic : FontStyle.normal,
            decoration: underline ? TextDecoration.underline : null,
            color: !enabled
                ? Colors.grey.shade400
                : active
                    ? (color ?? Colors.black87)
                    : Colors.black87,
          ),
        ),
      ),
    );
  }
}

class _FontDropdown extends StatelessWidget {
  final String value;
  final bool enabled;
  final ValueChanged<String> onChanged;

  const _FontDropdown({
    required this.value,
    required this.enabled,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(4),
        color: enabled ? Colors.white : Colors.grey.shade100,
      ),
      child: DropdownButton<String>(
        value: value,
        isDense: true,
        underline: const SizedBox(),
        items: resumeToolbarFontOptions
            .map((f) => DropdownMenuItem(
                  value: f,
                  child: Text(f, style: const TextStyle(fontSize: 13)),
                ))
            .toList(),
        onChanged: enabled
            ? (f) {
                if (f != null) onChanged(f);
              }
            : null,
      ),
    );
  }
}

class _ColorSwatchBtn extends StatelessWidget {
  final Color color;
  final bool isSelected;
  final bool enabled;
  final VoidCallback onTap;

  const _ColorSwatchBtn({
    required this.color,
    required this.isSelected,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        width: 24,
        height: 24,
        margin: const EdgeInsets.only(right: 6),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: enabled ? color : color.withOpacity(0.4),
          border: Border.all(
            color: isSelected ? Colors.black87 : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
        ),
      ),
    );
  }
}
