import 'package:flutter/material.dart';
import 'package:np_casse/app/utilities/image_utils.dart';
import 'package:np_casse/core/models/product.model.dart';
import 'package:np_casse/core/models/user.app.institution.model.dart';
import 'package:np_casse/core/notifiers/authentication.notifier.dart';
import 'package:np_casse/core/notifiers/product.notifier.dart';
import 'package:np_casse/core/notifiers/project.notifier.dart';
import 'package:np_casse/core/notifiers/store.notifier.dart';
import 'package:np_casse/core/notifiers/userAppInstitution.notifier.dart';
import 'package:np_casse/core/utils/snackbar.util.dart';
import 'package:provider/provider.dart';

typedef OnPickImageCallback = void Function(
    double? maxWidth, double? maxHeight, int? quality);

class ProductDetailScreen extends StatefulWidget {
  final ProductModel productModelArgument;
  // final ProductDetailsArgs productDetailsArguments;
  const ProductDetailScreen({
    Key? key,
    required this.productModelArgument,
  }) : super(key: key);

  @override
  State<ProductDetailScreen> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetailScreen> {
  final TextEditingController textEditingControllerNameProduct =
      TextEditingController();
  final TextEditingController textEditingControllerDescriptionProduct =
      TextEditingController();
  final TextEditingController textEditingControllerPriceProduct =
      TextEditingController();

  final ValueNotifier<bool> isFreePriceProduct = ValueNotifier<bool>(false);
  String tImageString = '';
  // final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    if (widget.productModelArgument.idProduct != 0) {
      textEditingControllerNameProduct.text =
          widget.productModelArgument.nameProduct;
      textEditingControllerDescriptionProduct.text =
          widget.productModelArgument.descriptionProduct;
      tImageString = widget.productModelArgument.imageProduct;
      textEditingControllerPriceProduct.text =
          widget.productModelArgument.priceProduct.toString();
      isFreePriceProduct.value = widget.productModelArgument.isFreePriceProduct;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AuthenticationNotifier authenticationNotifier =
        Provider.of<AuthenticationNotifier>(context);
    // UserAppInstitutionNotifier userAppInstitutionNotifier =
    //     Provider.of<UserAppInstitutionNotifier>(context);
    ProjectNotifier projectNotifier = Provider.of<ProjectNotifier>(context);
    StoreNotifier storeNotifier = Provider.of<StoreNotifier>(context);
    ProductNotifier productNotifier = Provider.of<ProductNotifier>(context);

    UserAppInstitutionModel cUserAppInstitutionModel =
        authenticationNotifier.getSelectedUserAppInstitution();

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text(
          'Dettaglio progetto: ${productNotifier.getNameProduct}',
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        actions: [
          IconButton(
              onPressed: () {
                ProductModel productModel = ProductModel(
                    idProduct: widget.productModelArgument.idProduct,
                    idStore: widget.productModelArgument.idStore,
                    nameProduct: textEditingControllerNameProduct.text,
                    descriptionProduct:
                        textEditingControllerDescriptionProduct.text,
                    priceProduct: double.tryParse(
                            textEditingControllerPriceProduct.text) ??
                        0,
                    imageProduct: tImageString,
                    isWishlisted: ValueNotifier<bool>(false),
                    isFreePriceProduct: isFreePriceProduct.value);
                productNotifier
                    .addOrUpdateProduct(
                        context: context,
                        token: authenticationNotifier.token,
                        idUserAppInstitution:
                            cUserAppInstitutionModel.idUserAppInstitution,
                        idProject: projectNotifier.getIdProject,
                        idStore: storeNotifier.getIdStore,
                        productModel: productModel)
                    .then((value) {
                  if (value) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackUtil.stylishSnackBar(
                        text: 'Info Updated',
                        context: context,
                      ),
                    );
                    Navigator.of(context).pop();
                    productNotifier.refresh();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackUtil.stylishSnackBar(
                        text: 'Error Please Try Again , After a While',
                        context: context,
                      ),
                    );
                    Navigator.of(context).pop();
                  }
                });
              },
              icon: const Icon(Icons.check)),
        ],
      ),
      body: ListView(
        children: [
          Card(
            color: Theme.of(context).cardColor,
            elevation: 4,
            child: SizedBox(
              height: 200,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: (MediaQuery.of(context).size.width) / 5,
                    height: (MediaQuery.of(context).size.width) / 2,
                  ),
                  Expanded(
                    child: SizedBox(
                      height: (MediaQuery.of(context).size.width) / 2,
                      width: (MediaQuery.of(context).size.width) / 2,
                      child: Padding(
                        padding: const EdgeInsets.all(1.0),
                        child: GestureDetector(
                            onTap: () {
                              showModalBottomSheet(
                                isDismissible: true,
                                context: context,
                                builder: (BuildContext context) {
                                  return Container(
                                    decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                        image: DecorationImage(
                                          image: ImageUtils.getImageFromString(
                                                  stringImage: tImageString)
                                              .image,
                                        )),
                                  );
                                },
                              );
                            },
                            child: Container(
                              width: 130,
                              height: 130,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    image: ImageUtils.getImageFromString(
                                            stringImage: tImageString)
                                        .image,
                                    fit: BoxFit.contain),
                              ),
                            )),
                      ),
                    ),
                  ),
                  Container(
                    height: (MediaQuery.of(context).size.width) / 2,
                    width: (MediaQuery.of(context).size.width) / 5,
                    alignment: Alignment.bottomRight,
                    child: IconButton(
                      icon: const Icon(Icons.photo_camera),
                      onPressed: () {
                        showModalBottomSheet(
                          isDismissible: true,
                          context: context,
                          builder: (BuildContext context) {
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                ListTile(
                                  leading: const Icon(Icons.photo),
                                  title: Text(
                                    'Capture Image',
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                  onTap: () {
                                    ImageUtils.imageSelectorCamera()
                                        .then((value) {
                                      setState(() {
                                        tImageString = value;
                                      });
                                      Navigator.pop(context);
                                    });
                                  },
                                ),
                                ListTile(
                                  leading: const Icon(Icons.folder),
                                  title: Text(
                                    'Select Image',
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                  onTap: () {
                                    ImageUtils.imageSelectorFile()
                                        .then((value) {
                                      setState(() {
                                        tImageString = value;
                                      });
                                      Navigator.pop(context);
                                    });
                                  },
                                ),
                                ListTile(
                                  leading: const Icon(Icons.delete),
                                  title: Text(
                                    'Delete Image',
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                  onTap: () {
                                    setState(() {
                                      tImageString = tImageString =
                                          ImageUtils.setNoImage();
                                    });
                                    Navigator.pop(context);
                                  },
                                ),
                                ListTile(
                                  leading: const Icon(Icons.undo),
                                  title: Text(
                                    'Undo',
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                ),
                                const ListTile(
                                  title: Text(''),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
          Card(
            color: Theme.of(context).cardColor,
            elevation: 4,
            child: ListTile(
              // title: Text(
              //   'Nome Progetto',
              //   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              // ),
              subtitle: Row(
                children: [
                  Expanded(
                    child: TextField(
                      //onChanged: ,
                      controller: textEditingControllerNameProduct,
                      minLines: 3,
                      maxLines: 3,
                      //maxLength: 300,
                      //keyboardType: ,
                      // decoration: const InputDecoration(
                      //   prefixText: '€ ',
                      //   label: Text('amount'),
                      // ),
                      onTapOutside: (event) {
                        FocusManager.instance.primaryFocus?.unfocus();
                      },
                    ),
                  ),
                ],
              ),
              trailing: const Icon(Icons.edit),
              leading: const Icon(Icons.title),
              onTap: () {},
            ),
          ),
          Card(
            color: Theme.of(context).cardColor,
            elevation: 4,
            child: ListTile(
              // title: Text(
              //   'qui ci va la descrizione del progetto',
              //   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, ),
              // ),
              subtitle: Row(
                children: [
                  Expanded(
                    child: TextField(
                      //onChanged: ,
                      controller: textEditingControllerDescriptionProduct,

                      minLines: 5,
                      maxLines: 5,

                      //maxLength: 300,
                      //keyboardType: ,
                      // decoration: const InputDecoration(
                      //   prefixText: '€ ',
                      //   label: Text('amount'),
                      // ),
                      onTapOutside: (event) {
                        FocusManager.instance.primaryFocus?.unfocus();
                      },
                    ),
                  ),
                ],
              ),
              trailing: const Icon(Icons.edit),
              leading: const Icon(Icons.topic),
              onTap: () {},
            ),
          ),
          Card(
            color: Theme.of(context).cardColor,
            elevation: 4,
            child: ListTile(
              // title: Text(
              //   'qui ci va la descrizione del progetto',
              //   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, ),
              // ),
              subtitle: Row(
                children: [
                  Expanded(
                    child: TextField(
                      //onChanged: ,
                      controller: textEditingControllerPriceProduct,
                      keyboardType: const TextInputType.numberWithOptions(),

                      minLines: 1,
                      maxLines: 1,

                      onTapOutside: (event) {
                        FocusManager.instance.primaryFocus?.unfocus();
                      },
                    ),
                  ),
                ],
              ),
              trailing: const Icon(Icons.edit),
              leading: const Icon(Icons.euro),
              onTap: () {},
            ),
          ),
          Card(
            color: Theme.of(context).cardColor,
            elevation: 4,
            child: ListTile(
              subtitle: Row(children: [
                Expanded(
                  child: ValueListenableBuilder<bool>(
                    builder: (BuildContext context, bool value, Widget? child) {
                      return CheckboxListTile(
                          title: const SizedBox(
                              width: 100, child: Text("Importo variabile")),
                          value: isFreePriceProduct.value,
                          onChanged: (bool? value) {
                            isFreePriceProduct.value = value!;
                          },
                          controlAffinity: ListTileControlAffinity.leading);
                    },
                    valueListenable: isFreePriceProduct,
                  ),
                )
              ]),
              // trailing: const Icon(Icons.edit),
              leading: const Icon(Icons.local_offer),
              onTap: () {},
            ),
          )
        ],
      ),
    );
  }
}
