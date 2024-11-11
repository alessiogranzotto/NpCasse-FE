import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:np_casse/core/models/product.catalog.model.dart';
import 'package:np_casse/core/models/product.history.model.dart';
import 'package:np_casse/core/notifiers/category.catalog.notifier.dart';
import 'package:np_casse/core/notifiers/product.catalog.notifier.dart';
import 'package:paged_datatable/paged_datatable.dart';
import 'package:provider/provider.dart';
import 'package:np_casse/core/notifiers/report.notifier.dart';
import 'package:np_casse/core/models/user.app.institution.model.dart';
import 'package:np_casse/core/notifiers/authentication.notifier.dart';
import 'package:np_casse/core/models/category.catalog.model.dart';
import 'package:flutter/services.dart';
class ProductHistoryScreen extends StatefulWidget {
  const ProductHistoryScreen({Key? key}) : super(key: key);

  @override
  State<ProductHistoryScreen> createState() => _ProductHistoryScreenState();
}

class _ProductHistoryScreenState extends State<ProductHistoryScreen> {
  final PagedDataTableController<String, Map<String, dynamic>> tableController =
      PagedDataTableController();
  UserAppInstitutionModel? cSelectedUserAppInstitution;
  UserAppInstitutionModel? previousSelectedInstitution;

  List<DropdownMenuItem<CategoryCatalogModel>> categoryDropdownItems = [];
  List<DropdownMenuItem<CategoryCatalogModel>> subCategoryDropdownItems = [];
  List<DropdownMenuItem<ProductCatalogModel>> productDropdownItems = [];

  CategoryCatalogModel? selectedCategory; // Track the selected category
  CategoryCatalogModel? selectedSubCategory; // Track the selectedSubCategory

  bool isLoadingCategories = true; // Add loading state variable

  @override
  void initState() {
    super.initState();
  }


  Future<(List<Map<String, dynamic>>, String?)> fetchData(int pageSize,
      SortModel? sortModel, FilterModel? filterModel, String? pageToken) async {
    final reportNotifier = Provider.of<ReportNotifier>(context, listen: false);
    try {
      int pageNumber = (pageToken != null) ? int.parse(pageToken) : 1;
      var authNotifier =
          Provider.of<AuthenticationNotifier>(context, listen: false);
      UserAppInstitutionModel cUserAppInstitutionModel =
          authNotifier.getSelectedUserAppInstitution();

      String? sortBy;
      String? sortDirection;
      String? sortColumnAndDirection = '';

      if (sortModel != null) {
        sortBy = sortModel.fieldName;
        sortDirection = sortModel.descending ? 'DESC' : 'ASC';
        sortColumnAndDirection = '$sortBy;$sortDirection';
      }

      print('filterModel');
      print(filterModel);

      var response = await reportNotifier.findProductList(
        context: context,
        token: authNotifier.token,
        idUserAppInstitution: cUserAppInstitutionModel.idUserAppInstitution,
        pageNumber: pageNumber,
        pageSize: pageSize,
        orderBy: (sortBy != null) ? [sortColumnAndDirection] : [],
      );

      if (response is ProductHistoryModel) {
        List<Map<String, dynamic>> data = response.productHistoryList
            .map((cart) =>
                cart.toJson()) // Assuming CartModel has a toJson method
            .toList();

        String? nextPageToken =
            response.hasNext ? (pageNumber + 1).toString() : null;
        return (data, nextPageToken);
      } else {
        return (<Map<String, dynamic>>[], null);
      }
    } catch (e) {
      print('Error fetching data: $e');
      return (<Map<String, dynamic>>[], null);
    }
  }

  void handleDownloadProductList(BuildContext context) async {
    final reportNotifier = Provider.of<ReportNotifier>(context, listen: false);
    var authNotifier = Provider.of<AuthenticationNotifier>(context, listen: false);
    UserAppInstitutionModel cUserAppInstitutionModel = authNotifier.getSelectedUserAppInstitution();

    await reportNotifier.downloadProductList(
      context: context,
      token: authNotifier.token,
      idUserAppInstitution: cUserAppInstitutionModel.idUserAppInstitution,
    );
  }

   @override
  Widget build(BuildContext context) {
    AuthenticationNotifier authenticationNotifier =
        Provider.of<AuthenticationNotifier>(context);

    UserAppInstitutionModel cUserAppInstitutionModel =
        authenticationNotifier.getSelectedUserAppInstitution();

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
          'Report prodotti ${cUserAppInstitutionModel.idInstitutionNavigation.nameInstitution}',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child:  PagedDataTable<String, Map<String, dynamic>>(
                controller: tableController,
                initialPageSize: 20,
                pageSizes: const [10, 20, 50],
                fetcher: (pageSize, sortModel, filterModel, pageToken) => 
                    fetchData(pageSize, sortModel, filterModel, pageToken),
                filterBarChild: PopupMenuButton(
                  icon: const Icon(Icons.more_vert_outlined),
                  itemBuilder: (context) => <PopupMenuEntry>[
                    PopupMenuItem(
                      child: const Text("Seleziona tutti"),
                      onTap: () {
                        tableController.selectAllRows();
                      },
                    ),
                    PopupMenuItem(
                      child: const Text("Deseleziona tutti"),
                      onTap: () {
                        tableController.unselectAllRows();
                      },
                    ),
                    const PopupMenuDivider(),
                    PopupMenuItem(
                      child: const Text("Export Excel"),
                      onTap: () {
                        handleDownloadProductList(context);
                      },
                    ),
                  ],
                ),
                columns: [
                  RowSelectorColumn(),
                  TableColumn(
                    id: 'docNumberCart',
                    title: const Text('#'),
                    cellBuilder: (context, item, index) =>
                        Text(item['docNumberCart'].toString().padLeft(6, '0')),
                    size: const FixedColumnSize(100),
                    sortable: true,
                  ),
                  TableColumn(
                    id: 'nameProduct',
                    title: const Text('Nome prodotto'),
                    cellBuilder: (context, item, index) =>
                        Text(item['nameProduct'].toString()),
                    size: const FixedColumnSize(150),
                    sortable: true,
                  ),
                  TableColumn(
                    id: 'productAttributeExplicit',
                    title: const Text('Variante'),
                    cellBuilder: (context, item, index) =>
                        Text(item['productAttributeExplicit'].toString()),
                    size: const FixedColumnSize(350),
                    sortable: false,
                  ),
                  TableColumn(
                    id: 'quantityCartProduct',
                    title: const Text('Q.ta'),
                    cellBuilder: (context, item, index) => Text(
                        (item['quantityCartProduct'] as ValueNotifier<int>)
                            .value
                            .toString()),
                    size: const FixedColumnSize(100),
                    sortable: true,
                  ),
                  TableColumn(
                    id: 'priceCartProduct',
                    title: const Text('Prezzo'),
                    cellBuilder: (context, item, index) =>
                        Text(item['priceCartProduct'].toStringAsFixed(2) + ' €'),
                    size: const FixedColumnSize(100),
                    sortable: true,
                  ),
                  TableColumn(
                    id: 'notesCartProduct',
                    title: const Text('Note'),
                    cellBuilder: (context, item, index) =>
                        Text(item['notesCartProduct'].toString()),
                    size: const FixedColumnSize(350),
                    sortable: true,
                  ),
                ],
                filters: [
                   // Category filter
                  CustomDropdownTableFilter<CategoryCatalogModel>(
                    loadOptions: () async {
                      final categoryCatalogNotifier = Provider.of<CategoryCatalogNotifier>(context, listen: false);
                      final authNotifier = Provider.of<AuthenticationNotifier>(context, listen: false);
                      final idUserAppInstitution = authNotifier.getSelectedUserAppInstitution().idUserAppInstitution;

                      final categories = await categoryCatalogNotifier.getCategories(
                        context: context,
                        token: authNotifier.token,
                        idUserAppInstitution: idUserAppInstitution,
                        idCategory: 0,
                        levelCategory: 'FirstLevelCategory',
                        readAlsoDeleted: false,
                        numberResult: 'All',
                        nameDescSearch: '',
                        readImageData: false,
                        orderBy: 'NameCategory',
                      );

                      print("Fetched categories: $categories");
                      return categories;
                    },
                    chipFormatter: (value) => 'Category: ${value?.nameCategory ?? "None"}',
                    id: "categoryFilter",
                    name: "Categoria",
                    onChanged: (newValue) {
                      setState(() {
                        selectedCategory = newValue;
                      });
                    },
                    displayStringForOption: (category) => category.nameCategory,
                  ),

                  // Subcategory filter
                  CustomDropdownTableFilter<CategoryCatalogModel>(
                    loadOptions: () async {
                      if (selectedCategory == null) return []; // Return empty if no category is selected

                      final categoryCatalogNotifier = Provider.of<CategoryCatalogNotifier>(context, listen: false);
                      final authNotifier = Provider.of<AuthenticationNotifier>(context, listen: false);
                      final idUserAppInstitution = authNotifier.getSelectedUserAppInstitution().idUserAppInstitution;

                      final categories = await categoryCatalogNotifier.getCategories(
                        context: context,
                        token: authNotifier.token,
                        idUserAppInstitution: idUserAppInstitution,
                        idCategory: selectedCategory!.idCategory, // Use the selected category ID
                        levelCategory: 'SubCategory',
                        readAlsoDeleted: false,
                        numberResult: 'All',
                        nameDescSearch: '',
                        readImageData: false,
                        orderBy: 'NameCategory',
                      );

                      print("Fetched subcategories: $categories");
                      return categories;
                    },
                    chipFormatter: (value) => 'Sub Categoria: ${value?.nameCategory ?? "None"}',
                    id: "subcategoryFilter",
                    name: "Sub Categoria",
                    onChanged: (newValue) {
                      setState(() {
                        selectedSubCategory = newValue;
                      });
                    },
                    displayStringForOption: (category) => category.nameCategory,
                  ),

                AutocompleteTableFilter<ProductCatalogModel>(
                // options: [], // Initially empty; will be loaded
                displayStringForOption: (ProductCatalogModel product) => product.nameProduct,
                id: 'productFilter',
                name: 'Prodotto',
                chipFormatter: (ProductCatalogModel product) => 'Prodotto: ${product.nameProduct}',
                loadOptions: () async {
                  final productCatalogNotifier = Provider.of<ProductCatalogNotifier>(context, listen: false);
                  final authNotifier = Provider.of<AuthenticationNotifier>(context, listen: false);
                  final idUserAppInstitution = authNotifier.getSelectedUserAppInstitution().idUserAppInstitution;
                  return await productCatalogNotifier.getProducts(
                    context: context,
                    token: authNotifier.token,
                    idUserAppInstitution: idUserAppInstitution,
                    idCategory:selectedCategory?.idCategory == null
                            ? selectedCategory?.idCategory ?? 0
                            : selectedSubCategory?.idCategory ?? 0,
                    readAlsoDeleted: false,
                    numberResult: 'All',
                    nameDescSearch: '',
                    readImageData: false,
                    shoWVariant: false,
                    orderBy: 'NameProduct',
                    viewOutOfAssortment: true,
                  );
                },
                decoration: InputDecoration(
                  labelText: 'Prodotto',
                  border: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 2),
                  ),
                ),
              ),
              DateTextTableFilter(
                id: "startDate",
                chipFormatter: (value) => 'Da "$value"',
                name: "Da",
              ),
              DateTextTableFilter(
                id: "endDate",
                chipFormatter: (value) => 'A "$value"',
                name: "A",
              ),
          ],
        ),
      ),
    );
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
        hintText: decoration?.hintText ?? 'dd/MM/yyyy', // Fallback to custom hintText if provided
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
      if (parsedDate.isAfter(DateTime.now())) {
        return false; // Reject future dates
      }

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
  }) : super() {
    _loadOptions();
  }

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
    return ValueListenableBuilder<List<T>>(
      valueListenable: _optionsNotifier,
      builder: (context, loadedOptions, child) {
        if (loadedOptions.isEmpty && !_isLoading) {
            _loadOptions();
        }
        return GestureDetector(
          onTap: () async {
            // Reload options on tap if they are empty
            if (loadedOptions.isEmpty && !_isLoading) {
              await _loadOptions();
            }
          },
          child: DropdownButtonFormField<T>(
            items: _isLoading || loadedOptions.isEmpty
                ? null // Display nothing if still loading or no options available
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
                      onChanged!(newValue);
                    }
                    state.value = newValue;
                  }
                : null, // Disable if no options
            onSaved: (newValue) {
              state.value = newValue;
            },
            decoration: (decoration ?? InputDecoration(labelText: name)).copyWith(
              hintText: _isLoading ? 'Loading options...' : 'Select an option',
            ),
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
          ),
        );
      },
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
          return Center(child: CircularProgressIndicator()); // Show loading indicator
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}')); // Handle error
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No options available')); // Handle no data case
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
              text: state.value != null ? displayStringForOption(state.value!) : ''),
          onSelected: (T selection) {
            state.value = selection;
          },
          fieldViewBuilder: (BuildContext context, TextEditingController textEditingController,
              FocusNode focusNode, VoidCallback onFieldSubmitted) {
            return TextFormField(
              controller: textEditingController,
              focusNode: focusNode,
              decoration: decoration?.copyWith(
                labelText: name,
                border: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black), // Default border
                ),
                enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black), // Color for enabled border
                ),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black, width: 2), // Color for focused border
                ),
              ) ?? InputDecoration(
                labelText: name,
                border: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black), // Default border
                ),
                enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black), // Color for enabled border
                ),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black, width: 2), // Color for focused border
                ),
              ),
              onChanged: (value) {
                state.value = null; // Reset value when the input changes
              },
            );
          },
          optionsViewBuilder: (BuildContext context, AutocompleteOnSelected<T> onSelected,
              Iterable<T> options) {
            return Align(
              alignment: Alignment.topLeft,
              child: Material(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
                child: Container(
                  width: 300,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black), // Add border around the dropdown
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: options.length,
                    shrinkWrap: true, // Prevents ListView from taking unlimited space
                    physics: const NeverScrollableScrollPhysics(), // Prevents ListView from scrolling on its own
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
