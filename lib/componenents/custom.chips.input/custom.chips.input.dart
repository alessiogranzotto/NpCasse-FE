import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:np_casse/app/constants/functional.dart';

class ChipsInput<T> extends StatefulWidget {
  const ChipsInput(
      {super.key,
      required this.values,
      this.decoration = const InputDecoration(),
      this.style,
      this.strutStyle,
      required this.label,
      required this.chipBuilder,
      required this.onChanged,
      this.onChipTapped,
      this.onSubmitted,
      this.onTextChanged,
      this.height});

  final List<T> values;
  final InputDecoration decoration;
  final TextStyle? style;
  final StrutStyle? strutStyle;
  final String label;
  final double? height;

  final ValueChanged<List<T>> onChanged;
  final ValueChanged<T>? onChipTapped;
  final ValueChanged<String>? onSubmitted;
  final ValueChanged<String>? onTextChanged;

  final Widget Function(BuildContext context, T data) chipBuilder;

  @override
  ChipsInputState<T> createState() => ChipsInputState<T>();
}

class ChipsInputState<T> extends State<ChipsInput<T>> {
  @visibleForTesting
  late final ChipsInputEditingController<T> controller;

  String _previousText = '';
  TextSelection? _previousSelection;

  @override
  void initState() {
    super.initState();

    controller = ChipsInputEditingController<T>(
      <T>[...widget.values],
      widget.chipBuilder,
    );
    controller.addListener(_textListener);
  }

  @override
  void dispose() {
    controller.removeListener(_textListener);
    controller.dispose();

    super.dispose();
  }

  void _textListener() {
    final String currentText = controller.text;
    if (_previousSelection != null) {
      final int currentNumber = countReplacements(currentText);
      final int previousNumber = countReplacements(_previousText);

      final int cursorEnd = _previousSelection!.extentOffset;
      final int cursorStart = _previousSelection!.baseOffset;

      final List<T> values = <T>[...widget.values];

      // If the current number and the previous number of replacements are different, then
      // the user has deleted the InputChip using the keyboard. In this case, we trigger
      // the onChanged callback. We need to be sure also that the current number of
      // replacements is different from the input chip to avoid double-deletion.
      if (currentNumber < previousNumber && currentNumber != values.length) {
        if (cursorStart == cursorEnd) {
          values.removeRange(cursorStart - 1, cursorEnd);
        } else {
          if (cursorStart > cursorEnd) {
            values.removeRange(cursorEnd, cursorStart);
          } else {
            values.removeRange(cursorStart, cursorEnd);
          }
        }
        widget.onChanged(values);
      }
    }

    _previousText = currentText;
    _previousSelection = controller.selection;
  }

  static int countReplacements(String text) {
    return text.codeUnits
        .where(
            (int u) => u == ChipsInputEditingController.kObjectReplacementChar)
        .length;
  }

  @override
  Widget build(BuildContext context) {
    controller.updateValues(<T>[...widget.values]);

    return SizedBox(
      height: widget.height ?? 100,
      child: TextFormField(
        expands: true,
        maxLines: null,
        minLines: null,
        textInputAction: TextInputAction.next,
        style: widget.style,
        strutStyle: widget.strutStyle,
        decoration: InputDecoration(
          labelText: widget.label,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          labelStyle: Theme.of(context).textTheme.labelLarge,
          hintStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: Theme.of(context).hintColor.withOpacity(0.3),
              ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(
              color: Colors.grey,
              width: 1.0,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(
              color: Colors.black,
              width: 1.0,
            ),
          ),
        ),
        controller: controller,
        onChanged: (value) =>
            widget.onTextChanged?.call(controller.textWithoutReplacements),
        onFieldSubmitted: (value) =>
            widget.onSubmitted?.call(controller.textWithoutReplacements),
      ),
    );
  }
}

class ChipsInputEditingController<T> extends TextEditingController {
  ChipsInputEditingController(this.values, this.chipBuilder)
      : super(
          text: String.fromCharCode(kObjectReplacementChar) * values.length,
        );

  // This constant character acts as a placeholder in the TextField text value.
  // There will be one character for each of the InputChip displayed.
  static const int kObjectReplacementChar = 0xFFFE;

  List<T> values;

  final Widget Function(BuildContext context, T data) chipBuilder;

  /// Called whenever chip is either added or removed
  /// from the outside the context of the text field.
  // void updateValues(List<T> values) {
  //   if (values.length != this.values.length) {
  //     final String char = String.fromCharCode(kObjectReplacementChar);
  //     final int length = values.length;
  //     value = TextEditingValue(
  //       text: char * length,
  //       selection: TextSelection.collapsed(offset: length),
  //     );
  //     this.values = values;
  //   }
  // }

  void updateValues(List<T> values) {
    if (values.length != this.values.length) {
      final String char = String.fromCharCode(kObjectReplacementChar);
      final int length = values.length;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (this.values.length != values.length) {
          value = TextEditingValue(
            text: char * length,
            selection: TextSelection.collapsed(offset: length),
          );
          this.values = values;
        }
      });
    }
  }

  String get textWithoutReplacements {
    final String char = String.fromCharCode(kObjectReplacementChar);
    return text.replaceAll(RegExp(char), '');
  }

  String get textWithReplacements => text;

  @override
  TextSpan buildTextSpan(
      {required BuildContext context,
      TextStyle? style,
      required bool withComposing}) {
    final Iterable<WidgetSpan> chipWidgets =
        values.map((T v) => WidgetSpan(child: chipBuilder(context, v)));

    return TextSpan(
      style: style,
      children: <InlineSpan>[
        ...chipWidgets,
        if (textWithoutReplacements.isNotEmpty)
          TextSpan(text: textWithoutReplacements)
      ],
    );
  }
}

class ToppingSuggestion extends StatelessWidget {
  const ToppingSuggestion(this.topping, {super.key, this.onTap});

  final String topping;
  final ValueChanged<String>? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      key: ObjectKey(topping),
      leading: CircleAvatar(
        child: Text(
          topping[0].toUpperCase(),
        ),
      ),
      title: Text(topping),
      onTap: () => onTap?.call(topping),
    );
  }
}

class ToppingInputChip extends StatelessWidget {
  const ToppingInputChip({
    super.key,
    required this.topping,
    required this.onDeleted,
    required this.onSelected,
  });

  final String topping;
  final ValueChanged<String> onDeleted;
  final ValueChanged<String> onSelected;

  Future<void> copyToClipboard(BuildContext context) async {
    try {
      await Clipboard.setData(ClipboardData(text: topping));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Testo copiato: "$topping"'),
            duration: Duration(seconds: 1)),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Errore durante la copia: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      InputChip(
        side: BorderSide(width: 1.5),
        key: ObjectKey(topping),
        backgroundColor: FunctionalColorUtils.getColorForTag(topping),

        // 👇 la label contiene il testo + il pulsante copia
        label: Text(topping),

        deleteIcon: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: Icon(Icons.close, size: 18),
        ),
        onDeleted: () => onDeleted(topping),
        onSelected: (bool value) => onSelected(topping),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        padding: const EdgeInsets.all(2),
      ),
      const SizedBox(width: 4),

      // Icona copy esterna al chip
      MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () => copyToClipboard(context),
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: FunctionalColorUtils.getColorForTag(topping),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade600, width: 1.5),
            ),
            child: const Icon(
              Icons.copy,
              size: 16,
            ),
          ),
        ),
      ),
      const SizedBox(width: 24),
    ]);
  }
}
