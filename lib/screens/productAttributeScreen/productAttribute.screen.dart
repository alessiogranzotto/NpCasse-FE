import 'package:flutter/material.dart';
import 'package:np_casse/app/constants/colors.dart';
import 'package:np_casse/app/customized_component/sliver_grid_delegate_fixed_cross_axis_count_and_fixed_height.dart';
import 'package:np_casse/app/routes/app_routes.dart';
import 'package:np_casse/core/models/product.attribute.model.dart';
import 'package:np_casse/core/models/user.app.institution.model.dart';
import 'package:np_casse/core/notifiers/authentication.notifier.dart';
import 'package:np_casse/core/notifiers/product.attribute.notifier.dart';
import 'package:np_casse/screens/productAttributeScreen/product.attribute.card.dart';
import 'package:provider/provider.dart';

class ProductAttributeScreen extends StatefulWidget {
  const ProductAttributeScreen({super.key});

  @override
  State<ProductAttributeScreen> createState() => _ProductAttributeScreenState();
}

class _ProductAttributeScreenState extends State<ProductAttributeScreen> {
  late int currentPage;
  late int pageSize;

  final double widgetWitdh = 200;
  final double widgetRatio = 1;
  final double gridMainAxisSpacing = 10;

  TextEditingController nameDescSearchController = TextEditingController();
  bool readAlsoDeleted = false;
  String numberResult = 'All';
  String orderBy = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AuthenticationNotifier authenticationNotifier =
        Provider.of<AuthenticationNotifier>(context);

    UserAppInstitutionModel cUserAppInstitutionModel =
        authenticationNotifier.getSelectedUserAppInstitution();

    // List<ExpandableColumn<dynamic>> createColumns(
    //     List<ProductAttributeModel> data) {
    //   List<ExpandableColumn<dynamic>> headers = [
    //     ExpandableColumn<String>(columnTitle: "First name", columnFlex: 2),
    //     // ExpandableColumn<String>(columnTitle: "Last name", columnFlex: 2),
    //     // ExpandableColumn<String>(columnTitle: "Maiden name", columnFlex: 2),
    //     // ExpandableColumn<int>(columnTitle: "Age", columnFlex: 1),
    //     // ExpandableColumn<String>(columnTitle: "Gender", columnFlex: 1),
    //     // ExpandableColumn<String>(columnTitle: "Email", columnFlex: 4),
    //   ];
    //   return headers;
    // }

    // List<ExpandableRow> createRows(List<ProductAttributeModel> data) {
    //   List<ExpandableRow> rows = data.map<ExpandableRow>((e) {
    //     return ExpandableRow(cells: [
    //       ExpandableCell<String>(columnTitle: "First name", value: e.name),
    //     ]);
    //   }).toList();
    //   return rows;
    // }

    // void changedPage(int? val) {
    //   print(val);
    //   setState(() {
    //     currentPage = val!;
    //   });
    // }

    // void changedPageSize(int? val) {
    //   print(val);
    //   setState(() {
    //     pageSize = val!;
    //   });
    // }

    return Scaffold(
        appBar: AppBar(
          backgroundColor: CustomColors.darkBlue,
          centerTitle: true,
          title: Text(
            'Attributi prodotti ${cUserAppInstitutionModel.idInstitutionNavigation.nameInstitution}',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          automaticallyImplyLeading: false,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Consumer<ProductAttributeNotifier>(
              builder: (context, productAttributeNotifier, _) {
                return SizedBox(
                  height: MediaQuery.of(context).size.height * 0.9,
                  width: MediaQuery.of(context).size.width,
                  child: FutureBuilder(
                    future: productAttributeNotifier.getProductAttributes(
                        context: context,
                        token: authenticationNotifier.token,
                        idUserAppInstitution:
                            cUserAppInstitutionModel.idUserAppInstitution,
                        readAlsoDeleted: readAlsoDeleted,
                        numberResult: numberResult,
                        nameDescSearch: nameDescSearchController.text,
                        orderBy: orderBy),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Center(
                                  child: SizedBox(
                                      width: 100,
                                      height: 100,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 5,
                                        color: Colors.redAccent,
                                      ))),
                            ],
                          ),
                        );
                      } else if (!snapshot.hasData) {
                        return const Center(
                          child: Text(
                            'No data...',
                            style: TextStyle(
                              color: Colors.redAccent,
                            ),
                          ),
                        );
                      } else {
                        List<ProductAttributeModel> tSnapshot =
                            snapshot.data as List<ProductAttributeModel>;
                        return GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCountAndFixedHeight(
                              crossAxisCount:
                                  (MediaQuery.of(context).size.width) ~/
                                      widgetWitdh,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: gridMainAxisSpacing,
                              height: 200,
                            ),
                            physics: const ScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: tSnapshot.length,
                            // scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              ProductAttributeModel productAttributeModel =
                                  tSnapshot[index];
                              return ProductAttributeCard(
                                productAttributeModel: productAttributeModel,
                              );
                            });
                      }
                    },
                  ),
                );
              },
            ),
          ),
        ),
        floatingActionButton: Container(
          margin: const EdgeInsets.all(10),
          child: FloatingActionButton(
            shape: const CircleBorder(eccentricity: 0.5),
            onPressed: () {
              Navigator.of(context).pushNamed(
                AppRouter.productAttributeDetailRoute,
                arguments: ProductAttributeModel.empty(),
              );
            },
            //backgroundColor: Colors.deepOrangeAccent,
            child: const Icon(Icons.add),
          ),
        ));
  }
}

// Widget _buildEditDialog(ExpandableRow row, Function(ExpandableRow) onSuccess) {
//   return AlertDialog(
//     title: SizedBox(
//       height: 300,
//       child: TextButton(
//         child: const Text("Change name"),
//         onPressed: () {
//           row.cells[1].value = "x3";
//           onSuccess(row);
//         },
//       ),
//     ),
//   );
// }
