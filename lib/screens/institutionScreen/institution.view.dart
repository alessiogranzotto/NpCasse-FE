import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:np_casse/app/constants/colors.dart';
import 'package:np_casse/core/models/user.app.institution.model.dart';
import 'package:np_casse/core/notifiers/authentication.notifier.dart';
import 'package:provider/provider.dart';

class InstitutionScreen extends StatefulWidget {
  const InstitutionScreen({super.key});

  @override
  State<InstitutionScreen> createState() => _InstitutionScreenState();
}

class _InstitutionScreenState extends State<InstitutionScreen> {
  final TextEditingController _searchController = TextEditingController();
  int _currentPage = 0;
  final int _itemsPerPage = 12;

  List<UserAppInstitutionModel> _allInstitutions = [];
  List<UserAppInstitutionModel> _filteredInstitutions = [];
  Timer? _debounce;
  UserAppInstitutionModel? _selectedInstitution;
  final Map<String, Uint8List> _imageCache = {};

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final authNotifier = Provider.of<AuthenticationNotifier>(context);
    final newInstitutions = authNotifier.getUserAppInstitution();
    final selected = authNotifier.getSelectedUserAppInstitution();
    if (_allInstitutions.isEmpty && newInstitutions.isNotEmpty) {
      setState(() {
        _allInstitutions = newInstitutions;
        _filteredInstitutions = newInstitutions;
        _selectedInstitution = selected;
      });
    }
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      final query = _searchController.text.toLowerCase();
      setState(() {
        _currentPage = 0;
        if (query.isEmpty) {
          _filteredInstitutions = _allInstitutions;
        } else {
          _filteredInstitutions = _allInstitutions
              .where((inst) => inst.idInstitutionNavigation.nameInstitution
                  .toLowerCase()
                  .contains(query))
              .toList();
        }
      });
    });
  }

  void _selectInstitution(UserAppInstitutionModel institution) {
    final authNotifier =
        Provider.of<AuthenticationNotifier>(context, listen: false);
    authNotifier.setSelectedUserAppInstitution(institution);
    authNotifier.reinitAccount(context: context);
    setState(() {
      _selectedInstitution = institution;
    });
  }

  int get totalPages =>
      (_filteredInstitutions.length / _itemsPerPage).ceil().clamp(1, 9999);

  List<UserAppInstitutionModel> get currentPageItems {
    final start = _currentPage * _itemsPerPage;
    final end = (_currentPage + 1) * _itemsPerPage;
    return _filteredInstitutions.sublist(
      start,
      end > _filteredInstitutions.length ? _filteredInstitutions.length : end,
    );
  }

  void _goToPreviousPage() {
    if (_currentPage > 0) {
      setState(() {
        _currentPage--;
      });
    }
  }

  void _goToNextPage() {
    if (_currentPage < totalPages - 1) {
      setState(() {
        _currentPage++;
      });
    }
  }

  ButtonStyle navigationButtonStyle(bool enabled) {
    return ButtonStyle(
      backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
        if (!enabled) return Colors.grey.shade300;
        return Colors.white;
      }),
      foregroundColor: WidgetStateProperty.resolveWith<Color>((states) {
        if (!enabled) return Colors.grey.shade600;
        return CustomColors.darkBlue;
      }),
      textStyle: WidgetStateProperty.all(
        const TextStyle(fontWeight: FontWeight.bold),
      ),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      padding: WidgetStateProperty.all(
        const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      elevation: WidgetStateProperty.resolveWith<double>((states) {
        if (!enabled) return 0;
        return 4;
      }),
    );
  }

  Widget buildNavigationBar() {
    final bool canGoPrevious = _currentPage > 0;
    final bool canGoNext = _currentPage < totalPages - 1;

    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 16, left: 24, right: 24),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isSmallScreen = constraints.maxWidth < 500;

          return Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
            decoration: BoxDecoration(
              color: CustomColors.darkBlue,
              borderRadius: BorderRadius.circular(12),
            ),
            child: isSmallScreen
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ElevatedButton.icon(
                        onPressed: canGoPrevious ? _goToPreviousPage : null,
                        icon: const Icon(Icons.arrow_back_ios_new, size: 16),
                        label: const Text('Precedente'),
                        style: navigationButtonStyle(canGoPrevious),
                      ),
                      const SizedBox(height: 12),
                      Center(
                        child: Text(
                          'Pagina ${_currentPage + 1} di $totalPages\nTotale associazioni: ${_filteredInstitutions.length}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton.icon(
                        onPressed: canGoNext ? _goToNextPage : null,
                        icon: const Icon(Icons.arrow_forward_ios, size: 16),
                        label: const Text('Successivo'),
                        style: navigationButtonStyle(canGoNext),
                      ),
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton.icon(
                        onPressed: canGoPrevious ? _goToPreviousPage : null,
                        icon: const Icon(Icons.arrow_back_ios_new, size: 16),
                        label: const Text('Precedente'),
                        style: navigationButtonStyle(canGoPrevious),
                      ),
                      Text(
                        'Pagina ${_currentPage + 1} di $totalPages - Totale associazioni: ${_filteredInstitutions.length}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: canGoNext ? _goToNextPage : null,
                        icon: const Icon(Icons.arrow_forward_ios, size: 16),
                        label: const Text('Successivo'),
                        style: navigationButtonStyle(canGoNext),
                      ),
                    ],
                  ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  Widget buildInstitutionCard(UserAppInstitutionModel institution) {
    final base64Image = institution.idInstitutionNavigation.logoInstitution;
    final isSelected = _selectedInstitution == institution;

    Widget imageWidget;

    if (base64Image.isEmpty) {
      imageWidget = const Icon(Icons.image_not_supported, size: 80);
    } else {
      try {
        Uint8List? bytes = _imageCache[base64Image];
        if (bytes == null) {
          bytes = base64Decode(base64Image);
          _imageCache[base64Image] = bytes;
        }

        imageWidget = Image.memory(
          bytes,
          fit: BoxFit.contain,
          width: 80,
          height: 80,
          gaplessPlayback: true,
        );
      } catch (_) {
        imageWidget = const Icon(Icons.broken_image, size: 80);
      }
    }

    return Card(
      key: ValueKey(institution.idInstitutionNavigation.idInstitution),
      elevation: 4,
      shape: RoundedRectangleBorder(
        side: isSelected
            ? BorderSide(color: CustomColors.darkBlue, width: 2)
            : BorderSide.none,
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _selectInstitution(institution),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            crossAxisAlignment:
                CrossAxisAlignment.center, // centra verticalmente
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  width: 80,
                  height: 80,
                  child: imageWidget,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  mainAxisAlignment:
                      MainAxisAlignment.center, // centra testo verticalmente
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      institution.idInstitutionNavigation.nameInstitution,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'P.IVA: ${institution.idInstitutionNavigation.pIvaInstitution}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: CustomColors.darkBlue,
        centerTitle: true,
        title: Text(
          'Associazioni',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              controller: _searchController,
              onChanged: (_) => _onSearchChanged(),
              decoration: InputDecoration(
                labelText: 'Cerca associazioni',
                labelStyle: TextStyle(
                  color: _searchController.text.isEmpty
                      ? Colors.grey
                      : CustomColors.darkBlue,
                  fontWeight: FontWeight.bold,
                ),
                hintText: 'Cerca associazioni',
                hintStyle: const TextStyle(color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: CustomColors.darkBlue),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: CustomColors.darkBlue),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      BorderSide(color: CustomColors.darkBlue, width: 2),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                isDense: true,
              ),
            ),
          ),
          Expanded(
            child: _filteredInstitutions.isEmpty
                ? const Center(child: Text('Nessuna associazione trovata'))
                : LayoutBuilder(
                    builder: (context, constraints) {
                      double width = constraints.maxWidth;
                      int crossAxisCount = 1;

                      if (width >= 1200) {
                        crossAxisCount = 4;
                      } else if (width >= 900) {
                        crossAxisCount = 3;
                      } else if (width >= 600) {
                        crossAxisCount = 2;
                      }

                      return GridView.builder(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 3.5,
                        ),
                        itemCount: currentPageItems.length,
                        itemBuilder: (context, index) {
                          final institution = currentPageItems[index];
                          return buildInstitutionCard(institution);
                        },
                      );
                    },
                  ),
          ),
          buildNavigationBar(),
        ],
      ),
    );
  }
}
