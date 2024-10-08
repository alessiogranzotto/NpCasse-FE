import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:np_casse/componenents/custom.text.form.field.dart';
import 'package:np_casse/core/api/geo.autocomplete.api.dart';
import 'package:np_casse/core/models/geo.model.dart';
import 'package:np_casse/core/models/user.app.institution.model.dart';
import 'package:np_casse/core/notifiers/authentication.notifier.dart';
import 'package:provider/provider.dart';

class FullAddressAutocomplete extends StatefulWidget {
  final TextEditingController cTextEditingController;
  final FocusNode focusNode;
  // final void Function(String)? onChanged;
  final void Function(GeoFullAddressItemModel)? onValueSelected;
  final String? Function(String?)? validator;
  final String labelText;
  final String hintText;
  final bool enabled;

  const FullAddressAutocomplete(
      {super.key,
      required this.cTextEditingController,
      required this.focusNode,
      // this.onChanged,
      this.onValueSelected,
      this.validator,
      required this.labelText,
      required this.hintText,
      required this.enabled});

  @override
  State<FullAddressAutocomplete> createState() =>
      FullAddressAutocompleteState();
}

class FullAddressAutocompleteState extends State<FullAddressAutocomplete> {
  // The query currently being searched for. If null, there is no pending
  // request.
  String? _currentQuery;

  // The most recent options received from the API.
  late Iterable<GeoFullAddressItemModel> _lastOptions =
      <GeoFullAddressItemModel>[];

  late final _Debounceable<Iterable<GeoFullAddressItemModel>?, String>
      _debouncedSearch;

  // Calls the "remote" API to search with the given query. Returns null when
  // the call has been made obsolete.
  Future<Iterable<GeoFullAddressItemModel>?> _search(String query) async {
    _currentQuery = query;

    // In a real application, there should be some error handling here.

    AuthenticationNotifier authenticationNotifier =
        Provider.of<AuthenticationNotifier>(context, listen: false);
    UserAppInstitutionModel cUserAppInstitutionModel =
        authenticationNotifier.getSelectedUserAppInstitution();

    if (_currentQuery!.isEmpty) {
      return null;
    }
    var response = await GeoAutocompleteAPI.getFullAddressSuggestion(
        token: authenticationNotifier.token,
        idUserAppInstitution: cUserAppInstitutionModel.idUserAppInstitution,
        queryFullAddress: _currentQuery!);

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
        final Iterable<GeoFullAddressItemModel> suggestions =
            List.from(parseData['okResult'])
                .map((e) => GeoFullAddressItemModel.fromJson(e))
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
        _debounce<Iterable<GeoFullAddressItemModel>?, String>(_search);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return RawAutocomplete<GeoFullAddressItemModel>(
        focusNode: widget.focusNode,
        textEditingController: widget.cTextEditingController,
        optionsBuilder: (TextEditingValue textEditingValue) async {
          final Iterable<GeoFullAddressItemModel>? options =
              await _debouncedSearch(textEditingValue.text);
          if (options == null) {
            return _lastOptions;
          }
          _lastOptions = options;
          return options;
        },
        onSelected: (GeoFullAddressItemModel selection) {
          widget.onValueSelected!(selection);
        },
        displayStringForOption: (option) {
          return option.fullAddressDesc
              .replaceAll('<b>', '')
              .replaceAll('</b>', '');
        },
        fieldViewBuilder: (
          BuildContext context,
          TextEditingController textEditingController,
          FocusNode focusNode,
          VoidCallback onFieldSubmitted,
        ) {
          return CustomTextFormField(
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
            AutocompleteOnSelected<GeoFullAddressItemModel> onSelected,
            Iterable<GeoFullAddressItemModel> options) {
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
                height: 22.0 * options.length,
                width: constraints.biggest.width, // <-- Right here !
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: options.length,
                  shrinkWrap: false,
                  itemBuilder: (BuildContext context, int index) {
                    final GeoFullAddressItemModel option =
                        options.elementAt(index);
                    return InkWell(
                      onTap: () => onSelected(option),
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.gps_fixed),
                                Expanded(
                                  child:
                                      Html(data: ' ${option.fullAddressDesc}'),
                                ),
                              ],
                            ),
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
