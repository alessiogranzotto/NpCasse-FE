import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:np_casse/componenents/text.form.field.dart';
import 'package:np_casse/core/api/geo.autocomplete.api.dart';
import 'package:np_casse/core/models/geo.model.dart';
import 'package:np_casse/core/models/user.app.institution.model.dart';
import 'package:np_casse/core/notifiers/authentication.notifier.dart';
import 'package:provider/provider.dart';

// const Duration fakeAPIDuration = Duration(seconds: 1);
// const Duration debounceDuration = Duration(milliseconds: 500);

class StreetAutocomplete extends StatefulWidget {
  final TextEditingController cTextEditingController;
  final FocusNode focusNode;
  final String country;
  final String city;
  // final void Function(String)? onChanged;
  final void Function(GeoStreetItemModel)? onValueSelected;
  final String? Function(String?)? validator;
  final String labelText;
  final String hintText;
  final bool enabled;

  const StreetAutocomplete(
      {Key? key,
      required this.cTextEditingController,
      required this.focusNode,
      required this.country,
      required this.city,
      // required this.onChanged,
      required this.onValueSelected,
      required this.validator,
      required this.labelText,
      required this.hintText,
      required this.enabled})
      : super(key: key);

  @override
  State<StreetAutocomplete> createState() => StreetAutocompleteState();
}

class StreetAutocompleteState extends State<StreetAutocomplete> {
  // The query currently being searched for. If null, there is no pending
  // request.
  String? _currentQuery;

  // The most recent options received from the API.
  late Iterable<GeoStreetItemModel> _lastOptions = <GeoStreetItemModel>[];

  late final _Debounceable<Iterable<GeoStreetItemModel>?, String>
      _debouncedSearch;

  // Calls the "remote" API to search with the given query. Returns null when
  // the call has been made obsolete.
  Future<Iterable<GeoStreetItemModel>?> _search(String query) async {
    _currentQuery = query;

    // In a real application, there should be some error handling here.

    AuthenticationNotifier authenticationNotifier =
        Provider.of<AuthenticationNotifier>(context, listen: false);
    UserAppInstitutionModel cUserAppInstitutionModel =
        authenticationNotifier.getSelectedUserAppInstitution();

    if (_currentQuery!.isEmpty) {
      return null;
    }
    var response = await GeoAutocompleteAPI.getStreetSuggestion(
        token: authenticationNotifier.token,
        idUserAppInstitution: cUserAppInstitutionModel.idUserAppInstitution,
        country: widget.country,
        city: widget.city,
        queryStreet: _currentQuery!);

    // If another search happened after this one, throw away these options.
    if (_currentQuery != query) {
      return null;
    }
    _currentQuery = null;

    if (response != null) {
      final Map<String, dynamic> parseData =
          await jsonDecode(response as String);
      bool isOk = parseData['isOk'];
      if (isOk) {
        final Iterable<GeoStreetItemModel> suggestions =
            List.from(parseData['okResult'])
                .map((e) => GeoStreetItemModel.fromJson(e))
                .toList();
        return suggestions;
      }
    } else {
      return null;
    }

    return null;
  }

  @override
  void initState() {
    super.initState();
    _debouncedSearch =
        _debounce<Iterable<GeoStreetItemModel>?, String>(_search);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return RawAutocomplete<GeoStreetItemModel>(
        focusNode: widget.focusNode,
        textEditingController: widget.cTextEditingController,
        optionsBuilder: (TextEditingValue textEditingValue) async {
          final Iterable<GeoStreetItemModel>? options =
              await _debouncedSearch(textEditingValue.text);
          if (options == null) {
            return _lastOptions;
          }
          _lastOptions = options;
          return options;
        },
        onSelected: (GeoStreetItemModel selection) {
          widget.onValueSelected!(selection);
        },
        displayStringForOption: (option) {
          return option.street;
        },
        fieldViewBuilder: (
          BuildContext context,
          TextEditingController textEditingController,
          FocusNode focusNode,
          VoidCallback onFieldSubmitted,
        ) {
          return AGTextFormField(
              controller: textEditingController,
              enabled: widget.enabled,
              // validator: (value) =>
              //     value!.toString().isEmpty
              //         ? "Inserisci il comune"
              //         : null,
              focusNode: focusNode,
              // onChanged: widget.onChanged,
              validator: widget.validator,
              labelText: widget.labelText,
              hintText: widget.hintText);
        },
        optionsViewBuilder: (BuildContext context,
            AutocompleteOnSelected<GeoStreetItemModel> onSelected,
            Iterable<GeoStreetItemModel> options) {
          return Align(
            alignment: Alignment.topLeft,
            child: Material(
              shape: RoundedRectangleBorder(
                side: BorderSide(
                    color: Theme.of(context).colorScheme.inversePrimary),
                borderRadius: const BorderRadius.all(Radius.circular(10.0)),
              ),
              child: SizedBox(
                // height: 52.0 * options.length,
                height:
                    52.0 * options.length > 250 ? 250 : 52.0 * options.length,
                width: constraints.biggest.width, // <-- Right here !
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: options.length,
                  shrinkWrap: false,
                  itemBuilder: (BuildContext context, int index) {
                    final GeoStreetItemModel option = options.elementAt(index);
                    return InkWell(
                      onTap: () => onSelected(option),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.flag),
                            Text(option.street)
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        },
      );
    });
  }
}

const Duration debounceDuration = Duration(milliseconds: 500);

typedef _Debounceable<S, T> = Future<S?> Function(T parameter);

/// Returns a new function that is a debounced version of the given function.
///
/// This means that the original function will be called only after no calls
/// have been made for the given Duration.
_Debounceable<S, T> _debounce<S, T>(_Debounceable<S?, T> function) {
  _DebounceTimer? debounceTimer;

  return (T parameter) async {
    if (debounceTimer != null && !debounceTimer!.isCompleted) {
      debounceTimer!.cancel();
    }
    debounceTimer = _DebounceTimer();
    try {
      await debounceTimer!.future;
    } catch (error) {
      if (error is _CancelException) {
        return null;
      }
      rethrow;
    }
    return function(parameter);
  };
}

// A wrapper around Timer used for debouncing.
class _DebounceTimer {
  _DebounceTimer() {
    _timer = Timer(debounceDuration, _onComplete);
  }

  late final Timer _timer;
  final Completer<void> _completer = Completer<void>();

  void _onComplete() {
    _completer.complete();
  }

  Future<void> get future => _completer.future;

  bool get isCompleted => _completer.isCompleted;

  void cancel() {
    _timer.cancel();
    _completer.completeError(const _CancelException());
  }
}

// An exception indicating that the timer was canceled.
class _CancelException implements Exception {
  const _CancelException();
}