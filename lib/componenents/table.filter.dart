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
    if (_controller.text != state.value?.toString()) {
      _controller.text = state.value?.toString() ?? '';
    }

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
  final FocusNode _focusNode = FocusNode();

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

    // Attach a listener to the focus node to handle onEditingComplete
  }

  @override
  Widget buildPicker(BuildContext context, FilterState<String> state) {
    // Store the state for later access when needed
    // We will use this state reference inside _onEditingComplete()

    if (_controller.text != state.value) {
      _controller.text = state.value ?? '';
    }
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        // Call _onEditingComplete when the field loses focus
        _onEditingComplete(state);
      }
    });
    return TextFormField(
      controller: _controller,
      focusNode: _focusNode, // Attach the focus node to detect when the field loses focus
      keyboardType: TextInputType.datetime,
      inputFormatters: [
        DateInputFormatter(), // Custom formatter for date input
      ],
      decoration: InputDecoration(
        labelText: name,
        hintText: 'dd/MM/yyyy', // Placeholder format
        hintStyle: TextStyle(color: Colors.grey),
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
        hintText: decoration?.hintText ?? 'dd/MM/yyyy', // Fallback to custom hintText if provided
      ),
      onChanged: (value) {
        // Update the state only if the date is valid
        if (_isValidDate(value)) {
          state.value = value;
        } else {
          state.value = null;
        }
      },
    );
  }
  String removeLastSlash(String input) {
    int lastSlashIndex = input.lastIndexOf('/');
    if (lastSlashIndex != -1) {
      return input.substring(0, lastSlashIndex) + input.substring(lastSlashIndex + 1);
    }
    return input; // Return the original string if no slash is found
  }

  // This function is triggered when the user leaves the field (onEditingComplete)
  void _onEditingComplete(FilterState<String> state) {
    // Directly access the state from the parent class (TableFilter<String>)
    String value = _controller.text.trim();
    DateTime now = DateTime.now();

    // Check if the user has entered only the day (e.g., '04') and there are no slashes
    if (value.isNotEmpty && value.length == 3 && value.contains('/') && value.indexOf('/') == 2) {
      String day = value.replaceAll("/", "");

      if (int.parse(day) >= 1 && int.parse(day) <= 31) {
        // Format the current date with today's month and year
        String currentDate = '$day/${now.month.toString().padLeft(2, '0')}/${now.year}';

        // Update the controller text with the new date
        _controller.text = currentDate;

        // Manually update the state with the new date
        state.value = currentDate;
      }
    } else if (value.isNotEmpty && value.length == 6 && value.contains('/') 
      && value.indexOf('/') == 2 && value.lastIndexOf('/') == 5)  {
      List<String> parts = removeLastSlash(value).split('/');

      if (parts.length == 2) {
        String dayStr = parts[0];
        String monthStr = parts[1];

        int day = int.tryParse(dayStr) ?? -1;
        int month = int.tryParse(monthStr) ?? -1;

        if ((day > 0 && day <= 31  && month > 0 && month <= 12))  {
          // Format the date to dd/MM/yyyy
          String currentDate =
              '${dayStr}/${monthStr}/${now.year}';

          // Update the controller text with the new date
          _controller.text = currentDate;

          // Manually update the state
          state.value = currentDate;
        }
      }
    } else if (value.isNotEmpty &&
      value.length == 8 &&
      value.contains('/') &&
      value.indexOf('/') == 2 &&
      value.lastIndexOf('/') == 5) {
    String day = value.substring(0, 2); // Extract the day (first two characters)
    String month = value.substring(3, 5); // Extract the month (fourth and fifth characters)
    String year = value.substring(6, 8); // Extract the year (last two characters)
    // DateTime now = DateTime.now();

    // Check if the day, month, and year are valid
    if (int.parse(day) > 0 && int.parse(day) <= 31 && int.parse(month) > 0 
    && int.parse(month) <= 12 && int.parse(year) >= 0 && int.parse(month) <= 99) {
      // Add the current millennium and century to the year
      int fullYear = int.parse('20$year');

      // // Check if the entered date is in the valid past or current date range
      // DateTime enteredDate = DateTime(fullYear, int.parse(month), int.parse(day));
      // if (enteredDate.isBefore(now) || enteredDate.isAtSameMomentAs(now)) {
        String formattedDate = '$day/$month/$fullYear';

        // Update the controller text with the new formatted date
        _controller.text = formattedDate;

        // Manually update the state with the new date
        state.value = formattedDate;
      // }
    }
  }
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

      // Check if the date is valid
      return _isValidDayMonth(parsedDate.day, parsedDate.month, parsedDate.year);
    } catch (e) {
      return false;
    }
  }

  // Method to check if the day and month are valid
  bool _isValidDayMonth(int day, int month, int year) {
    if (month < 1 || month > 12) return false; // Invalid month
    if (year < 1900 || year > 2100) return false; // Adjust year limits as necessary
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

// Custom input formatter for the date field
class DateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String text = newValue.text;

    // If the user is backspacing and removing a slash, allow that to happen
    if (oldValue.text.length > newValue.text.length) {
      // If the last character is a slash, remove it
      if (oldValue.text.endsWith('/')) {
        text = text.substring(0, text.length - 1);
      }
    }

    // Allow only numbers and slashes, and make sure there are no more than two slashes
    if (!RegExp(r'^\d{0,2}\/?\d{0,2}\/?\d{0,4}$').hasMatch(text)) {
      return oldValue; // Reject if it doesn't match the pattern
    }

    // Add the first slash after two digits (for day)
    if (text.length == 2 && !text.contains('/')) {
      text = '$text/';
    }
    // Add the second slash after the month (5th character)
    if (text.length == 5 && !text.contains('/', 3)) {
      text = '$text/';
    }

    // Prevent adding a second slash in any place
    if (text.contains('//')) {
      text = oldValue.text; // Restore to old value if there's more than one slash
    }

    // Ensure the length doesn't exceed 10 characters (dd/MM/yyyy)
    if (text.length > 10) {
      text = text.substring(0, 10);
    }

    // Return the modified text with the caret at the end of the input
    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
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
  bool _isVisible = false;

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
    _optionsNotifier.value = options;
  }

  @override
  Widget buildPicker(BuildContext context, FilterState<T> state) {
    return VisibilityDetector(
      key: Key(id),
      onVisibilityChanged: (visibilityInfo) {
        if (visibilityInfo.visibleFraction > 0 && !_isVisible) {
          // The widget has become visible, so load the options
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
          if (loadedOptions.isEmpty && !_isLoading && _isVisible) {
            _loadOptions();  // Ensure we load options only if empty and widget is visible
          }
          // Ensure that the filter is always shown, regardless of loading state
          return Column(
            children: [
              // The actual dropdown (visible only when the widget is visible)
              GestureDetector(
                onTap: () async {
                  if (loadedOptions.isEmpty && !_isLoading && _isVisible) {
                    await _loadOptions();
                  }
                },
                child: DropdownButtonFormField<T>(
                  items: _isLoading || loadedOptions.isEmpty
                      ? null // Show no items if still loading or no options available
                      : loadedOptions.map<DropdownMenuItem<T>>((T item) {
                          return DropdownMenuItem<T>(
                            value: item,
                            child: Text(
                              displayStringForOption(item),
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                                color: Colors.black, // Set a color for the item text
                              ),
                            ),
                          );
                        }).toList(),
                  value: _getValueFromDisplayString(state.value, loadedOptions),
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
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    color: Colors.black, // Make the selected text color black
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }

  // Helper method to get the correct value based on displayStringForOption
  T? _getValueFromDisplayString(T? currentValue, List<T> loadedOptions) {
    if (currentValue == null) {
      return null;
    }

    // Check if the current value is part of the loaded options and matches the display string
    for (T option in loadedOptions) {
      if (displayStringForOption(option) == displayStringForOption(currentValue)) {
        return option;
      }
    }
    return null;
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


