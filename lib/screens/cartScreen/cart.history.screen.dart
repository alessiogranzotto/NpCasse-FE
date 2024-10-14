import 'package:flutter/material.dart';
import 'package:paged_datatable/paged_datatable.dart';

class CartHistoryScreen extends StatefulWidget {
  const CartHistoryScreen({Key? key}) : super(key: key);

  @override
  State<CartHistoryScreen> createState() => _CartHistoryScreenState();
}

class _CartHistoryScreenState extends State<CartHistoryScreen> {
  // Mock data to simulate paginated API data
  Future<(List<Map<String, dynamic>>, String?)> fetchData(
      int pageSize, SortModel? sortModel, FilterModel? filterModel, String? pageToken) async {
    // Simulating fetching data for each page
    List<Map<String, dynamic>> data = List.generate(
      pageSize,
      (index) => {
        'firstName': 'First ${index + 1 + (pageToken != null ? int.parse(pageToken!) : 0)}', // Adjusting for pagination
        'lastName': 'Last ${index + 1 + (pageToken != null ? int.parse(pageToken!) : 0)}',
        'amount': (index + 1 + (pageToken != null ? int.parse(pageToken!) : 0)) * 100.0,
        '': '', // Initial status
      },
    );

    // Simulating a total of 100 records and next page token
    String? nextPageToken = (data.length < 100) ? (int.parse(pageToken ?? '0') + data.length).toString() : null;

    return (data, nextPageToken);
  }

  void onStatusChange(String? newValue, Map<String, dynamic> item) {
    // Perform actions based on the selected value
    print('Selected status for ${item['firstName']} ${item['lastName']}: $newValue');
    // Additional functionality can be added here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false, // Disable the back button
        title: Text(
          'Storico Carello',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Optional: Add padding around the table
        child: PagedDataTable<String, Map<String, dynamic>>(
          columns: [
            TableColumn(
              title: const Text('First Name'),
              cellBuilder: (context, item, index) => Text(item['firstName'] ?? ''),
              size: const FractionalColumnSize(0.25), // 25% of available width
            ),
            TableColumn(
              title: const Text('Last Name'),
              cellBuilder: (context, item, index) => Text(item['lastName'] ?? ''),
              size: const FractionalColumnSize(0.25), // 25% of available width
            ),
            TableColumn(
              title: const Text('Amount'),
              cellBuilder: (context, item, index) => Text(item['amount'].toString()),
              size: const FractionalColumnSize(0.25), // 25% of available width
            ),
            // Dropdown column with DropdownMenuItem
            DropdownTableColumn<String, Map<String, dynamic>, String>(
              title: const Text(''),
              items: [
                DropdownMenuItem(value: 'Select format', child: Text('Select format')),
                DropdownMenuItem(value: 'Small', child: Text('Small')),
                DropdownMenuItem(value: 'Large', child: Text('Large')),
              ],
              // Define the setter
              setter: (item, value, index) {
                // Call the function when the dropdown value changes
                onStatusChange(value, item); // Handle the status change
                // item['status'] = value; // Update the item's status
                return Future.value(true); // Return true to indicate success
              },
              // Define the getter
              getter: (item, index) => item['status'] ?? 'Select format', // Default value for display
              size: const FractionalColumnSize(0.25), // 25% of available width
            ),
          ],
          fetcher: (pageSize, sortModel, filterModel, pageToken) => fetchData(pageSize, sortModel, filterModel, pageToken),
        ),
      ),
    );
  }
}

class PaginatedData<K, T> {
  final int totalRecords;
  final List<T> data;

  PaginatedData({
    required this.totalRecords,
    required this.data,
  });
}
