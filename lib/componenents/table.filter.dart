import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:paged_datatable/paged_datatable.dart';
import 'package:flutter/services.dart';
import 'package:visibility_detector/visibility_detector.dart';


class IntegerTextTableFilter extends TableFilter<int> {
  final InputDecoration? decoration;
  final TextEditingController _controller = TextEditingController();

  IntegerTextTableFilter({
    required super.id,
    required super.name,
    required super.chipFormatter,
    super.initialValue,
    super.enabled = true,
    this.decoration,
  }) {
    // Initialize the controller with the initial value if present
    _controller.text = initialValue?.toString() ?? '';
  }

  @override
  Widget buildPicker(BuildContext context, FilterState<int> state) {
    return TextFormField(
      controller: _controller,
      keyboardType: TextInputType.number,  // Set keyboard type to number
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly, // Allow only digits
      ],
      decoration: InputDecoration(
        labelText: name,
        hintText: 'Enter an integer',  // Placeholder
        hintStyle: TextStyle(color: Colors.grey), // Set hint text color to grey
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black, width: 2),
        ),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
        border: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
      ).copyWith(
        hintText: decoration?.hintText ?? 'Enter an integer', // Fallback to custom hintText if provided
      ),
      onChanged: (value) {
        // Update the state only if the value is a valid integer
        if (_isValidInteger(value)) {
          state.value = int.tryParse(value); // Only update with valid integer
        } else {
          state.value = null; // Clear the state value if invalid
        }
      },
    );
  }

  // Method to check if the input value is a valid integer
  bool _isValidInteger(String input) {
    if (input.isEmpty) return false; // Reject empty input
    return int.tryParse(input) != null; // Check if the input can be parsed to an integer
  }
}

class DateTextTableFilter extends TableFilter<String> {
  final InputDecoration? decoration;
  final TextEditingController _controller = TextEditingController();

  DateTextTableFilter({
    required super.id,
    required super.name,
    required super.chipFormatter,
    super.initialValue,
    super.enabled = true,
    this.decoration,
  }) {
    // Initialize the controller with the initial value if present
    _controller.text = initialValue ?? '';
  }

  @override
  Widget buildPicker(BuildContext context, FilterState<String> state) {
    return TextFormField(
      controller: _controller,
      keyboardType: TextInputType.datetime,
      inputFormatters: [
        DateInputFormatter(), // Custom formatter for date input
      ],
      decoration: InputDecoration(
        labelText: name,
        hintText: 'dd/MM/yyyy', // Placeholder format
        hintStyle: TextStyle(color: Colors.grey), // Set hint text color to grey
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black, width: 2),
        ),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
        border: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
      ).copyWith(
        hintText: decoration?.hintText ??
            'dd/MM/yyyy', // Fallback to custom hintText if provided
      ),
      onChanged: (value) {
        // Update the state only if the date is valid
        if (_isValidDate(value)) {
          state.value = value;
        } else {
          // Clear the state value if invalid
          state.value = null;
        }
      },
    );
  }

  // Method to validate the date format strictly
  bool _isValidDate(String input) {
    if (input.isEmpty) return false; // Reject empty input
    try {
      final parsedDate = DateFormat('dd/MM/yyyy').parseStrict(input);

      // Check if the parsed date matches the original input
      if (input != DateFormat('dd/MM/yyyy').format(parsedDate)) {
        return false;
      }

      // Check if the date is less than or equal to today
      // if (parsedDate.isAfter(DateTime.now())) {
      //   return false; // Reject future dates
      // }

      return _isValidDayMonth(
          parsedDate.day, parsedDate.month, parsedDate.year);
    } catch (e) {
      return false;
    }
  }

  // Method to check if the day and month are valid
  bool _isValidDayMonth(int day, int month, int year) {
    if (month < 1 || month > 12) return false; // Invalid month
    if (year < 1900 || year > 2100)
      return false; // Adjust year limits as necessary
    if (day < 1 || day > _daysInMonth(month, year)) return false; // Invalid day
    return true;
  }

  // Method to return the number of days in a month
  int _daysInMonth(int month, int year) {
    // Adjust for leap years
    if (month == 2) {
      return DateTime(year, month + 1, 0).day; // Last day of February
    }
    return [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31][month - 1];
  }
}

class DateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;

    // Pattern to allow only numbers and forward slashes in dd/MM/yyyy format
    if (!RegExp(r'^\d{0,2}\/?\d{0,2}\/?\d{0,4}$').hasMatch(text)) {
      return oldValue; // Reject if it doesn't match the pattern
    }

    // Prevent multiple slashes
    if (text.split('/').length > 3) {
      return oldValue; // Reject if more than two slashes are found
    }

    return newValue; // Allow the input as is
  }
}

class CustomDropdownTableFilter<T extends Object> extends TableFilter<T> {
  final InputDecoration? decoration;
  final Future<List<T>> Function() loadOptions;
  final ValueChanged<T?>? onChanged;
  final String Function(T) displayStringForOption;

  // Adding a ValueNotifier to track changes
  final ValueNotifier<List<T>> _optionsNotifier = ValueNotifier<List<T>>([]);
  bool _isLoading = true;
  bool _isVisible = false;  // To track visibility

  CustomDropdownTableFilter({
    this.decoration,
    required super.chipFormatter,
    required super.id,
    required super.name,
    required this.loadOptions,
    required this.displayStringForOption,
    super.initialValue,
    super.enabled = true,
    this.onChanged,
  }) : super();

  // Method to load options and notify listeners
  Future<void> _loadOptions() async {
    _isLoading = true;
    final options = await loadOptions();
    _isLoading = false;

    // Notify listeners when the options are updated
    _optionsNotifier.value = options;
  }

  @override
  Widget buildPicker(BuildContext context, FilterState<T> state) {
    return VisibilityDetector(
      key: Key(id),  // Use a unique key for each filter
      onVisibilityChanged: (visibilityInfo) {
        if (visibilityInfo.visibleFraction > 0 && !_isVisible) {
          // If the widget is now visible, start loading options
          _isVisible = true;
          _loadOptions();  // Load options when the widget becomes visible
        }
        if (visibilityInfo.visibleFraction == 0 && _isVisible) {
          // If the widget is no longer visible, set _isVisible to false
          _isVisible = false;
        }
      },
      child: ValueListenableBuilder<List<T>>(
        valueListenable: _optionsNotifier,
        builder: (context, loadedOptions, child) {
          // Don't reload options if options are already loaded or loading
          if (loadedOptions.isEmpty && !_isLoading && _isVisible) {
            _loadOptions();  // Ensure we load options only if empty and widget is visible
          }

          return GestureDetector(
            onTap: () async {
              // Reload options if they are empty and widget is visible
              if (loadedOptions.isEmpty && !_isLoading && _isVisible) {
                await _loadOptions();
              }
            },
            child: DropdownButtonFormField<T>(
              items: _isLoading || loadedOptions.isEmpty
                  ? null // Show no items if still loading or no options
                  : loadedOptions.map<DropdownMenuItem<T>>((T item) {
                      return DropdownMenuItem<T>(
                        value: item,
                        child: Text(
                          displayStringForOption(item),
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
                        ),
                      );
                    }).toList(),
              value: state.value,
              onChanged: loadedOptions.isNotEmpty
                  ? (newValue) {
                      if (onChanged != null) {
                        onChanged!(newValue); // Trigger onChanged if set
                      }
                      state.value = newValue; // Update the filter state
                    }
                  : null, // Disable onChanged if no options are available
              onSaved: (newValue) {
                state.value = newValue;
              },
              decoration: (decoration ?? InputDecoration(labelText: name)).copyWith(
                hintText: _isLoading ? 'Loading options...' : 'Select an option',
                // Add a border to ensure only the bottom line is visible
                border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black), // Bottom border color
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black, width: 2),
                ),
              ),
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
            ),
          );
        },
      ),
    );
  }
}

class AutocompleteTableFilter<T extends Object> extends TableFilter<T> {
  final String Function(T) displayStringForOption;
  final InputDecoration? decoration;
  final Future<List<T>> Function() loadOptions; // Function to load options

  const AutocompleteTableFilter({
    required this.displayStringForOption,
    required super.chipFormatter,
    required super.id,
    required super.name,
    required this.loadOptions, // Function for loading options
    super.initialValue,
    super.enabled = true,
    this.decoration,
  }) : super(); // Call the superclass constructor

  @override
  Widget buildPicker(BuildContext context, FilterState<T> state) {
    // Load options when the widget is built
    return FutureBuilder<List<T>>(
      future: loadOptions(), // Call the provided loadOptions function
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
              child: CircularProgressIndicator()); // Show loading indicator
        } else if (snapshot.hasError) {
          return Center(
              child: Text('Error: ${snapshot.error}')); // Handle error
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
              child: Text('No options available')); // Handle no data case
        }

        final options = snapshot.data!; // Get the loaded options

        return RawAutocomplete<T>(
          optionsBuilder: (TextEditingValue textEditingValue) {
            if (textEditingValue.text.isEmpty) {
              return Iterable<T>.empty();
            }
            return options.where((T option) {
              return displayStringForOption(option)
                  .toLowerCase()
                  .contains(textEditingValue.text.toLowerCase());
            });
          },
          displayStringForOption: displayStringForOption,
          initialValue: TextEditingValue(
              text: state.value != null
                  ? displayStringForOption(state.value!)
                  : ''),
          onSelected: (T selection) {
            state.value = selection;
          },
          fieldViewBuilder: (BuildContext context,
              TextEditingController textEditingController,
              FocusNode focusNode,
              VoidCallback onFieldSubmitted) {
            return TextFormField(
              controller: textEditingController,
              focusNode: focusNode,
              decoration: decoration?.copyWith(
                    labelText: name,
                    border: const UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.black), // Default border
                    ),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.black), // Color for enabled border
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.black,
                          width: 2), // Color for focused border
                    ),
                  ) ??
                  InputDecoration(
                    labelText: name,
                    border: const UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.black), // Default border
                    ),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.black), // Color for enabled border
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.black,
                          width: 2), // Color for focused border
                    ),
                  ),
              onChanged: (value) {
                state.value = null; // Reset value when the input changes
              },
            );
          },
          optionsViewBuilder: (BuildContext context,
              AutocompleteOnSelected<T> onSelected, Iterable<T> options) {
            return Align(
              alignment: Alignment.topLeft,
              child: Material(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.0)),
                child: Container(
                  width: 300,
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: Colors.black), // Add border around the dropdown
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: options.length,
                    shrinkWrap:
                        true, // Prevents ListView from taking unlimited space
                    physics:
                        const NeverScrollableScrollPhysics(), // Prevents ListView from scrolling on its own
                    itemBuilder: (BuildContext context, int index) {
                      final T option = options.elementAt(index);
                      return ListTile(
                        title: Text(displayStringForOption(option)),
                        onTap: () => onSelected(option),
                      );
                    },
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}


