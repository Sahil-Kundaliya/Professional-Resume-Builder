import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FormattingToolbar extends StatelessWidget {
  final bool isBold;
  final bool isItalic;
  final bool isUnderline;
  final String selectedFont;
  final VoidCallback onBold;
  final VoidCallback onItalic;
  final VoidCallback onUnderline;
  final VoidCallback onUndo;
  final VoidCallback onRedo;
  final ValueChanged<String> onFontChanged;

  const FormattingToolbar({
    super.key,
    required this.isBold,
    required this.isItalic,
    required this.isUnderline,
    required this.selectedFont,
    required this.onBold,
    required this.onItalic,
    required this.onUnderline,
    required this.onUndo,
    required this.onRedo,
    required this.onFontChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Row(
              children: [
                _ToolBtn(
                  icon: Icons.undo,
                  onTap: onUndo,
                ),
                _ToolBtn(
                  icon: Icons.redo,
                  onTap: onRedo,
                ),
                const SizedBox(width: 4),
                _FormatBtn(
                  label: 'B',
                  bold: true,
                  active: isBold,
                  onTap: onBold,
                  color: const Color(0xFF00A86B),
                ),
                _FormatBtn(
                  label: 'I',
                  italic: true,
                  active: isItalic,
                  onTap: onItalic,
                ),
                _FormatBtn(
                  label: 'U',
                  underline: true,
                  active: isUnderline,
                  onTap: onUnderline,
                ),
                const SizedBox(width: 8),
                // Font selector
                Expanded(
                  child: _FontDropdown(
                    value: selectedFont,
                    onChanged: onFontChanged,
                  ),
                ),
                const SizedBox(width: 4),
                _ToolBtn(icon: Icons.more_horiz, onTap: () {}),
                _ToolBtn(
                  icon: Icons.format_color_text,
                  onTap: () {},
                  iconColor: Colors.red,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ToolBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color? iconColor;

  const _ToolBtn({required this.icon, required this.onTap, this.iconColor});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Icon(icon, size: 20, color: iconColor ?? Colors.black87),
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
  final VoidCallback onTap;
  final Color? color;

  const _FormatBtn({
    required this.label,
    this.bold = false,
    this.italic = false,
    this.underline = false,
    required this.active,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
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
            color: active ? (color ?? Colors.black87) : Colors.black87,
          ),
        ),
      ),
    );
  }
}

class _FontDropdown extends StatelessWidget {
  final String value;
  final ValueChanged<String> onChanged;

  const _FontDropdown({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    const fonts = [
      'SansSerif',
      'Serif',
      'Monospace',
      'Inter',
      'Georgia',
    ];
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(4),
      ),
      child: DropdownButton<String>(
        value: value,
        isDense: true,
        underline: const SizedBox(),
        items: fonts
            .map((f) => DropdownMenuItem(
                  value: f,
                  child: Text(f, style: const TextStyle(fontSize: 13)),
                ))
            .toList(),
        onChanged: (f) { if (f != null) onChanged(f); },
      ),
    );
  }
}
