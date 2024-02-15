import 'package:flutter/material.dart';
import 'package:np_casse/core/models/product.model.dart';

class AddCartScreen extends StatefulWidget {
  final ProductModel productModelArgument;
  // final ProjectDetailsArgs projectDetailsArguments;
  const AddCartScreen({
    Key? key,
    required this.productModelArgument,
  }) : super(key: key);

  @override
  State<AddCartScreen> createState() => _AddCartState();
}

class _AddCartState extends State<AddCartScreen> {
  final TextEditingController textEditingControllerNameProduct =
      TextEditingController();
  final TextEditingController textEditingControllerPriceProduct =
      TextEditingController();
  @override
  void initState() {
    if (widget.productModelArgument.idProduct != 0) {
      textEditingControllerNameProduct.text =
          widget.productModelArgument.nameProduct;
      textEditingControllerPriceProduct.text =
          widget.productModelArgument.priceProduct.toString();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // AuthenticationNotifier authenticationNotifier =
    //     Provider.of<AuthenticationNotifier>(context);
    // ProjectNotifier projectNotifier = Provider.of<ProjectNotifier>(context);
    // StoreNotifier storeNotifier = Provider.of<StoreNotifier>(context);
    // ProductNotifier productNotifier = Provider.of<ProductNotifier>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Dettaglio negozioooooo')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: textEditingControllerNameProduct,
                decoration: const InputDecoration(hintText: 'Nome prodotto'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                  controller: textEditingControllerPriceProduct,
                  decoration:
                      const InputDecoration(hintText: 'Prezzo prodotto'),
                  keyboardType: TextInputType.number),
            )
          ],
        ),
      ),
    );
  }
}
