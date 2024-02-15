import 'package:flutter/material.dart';

class NumericKeypad extends StatefulWidget {
  final Function checkImport;
  final TextEditingController controller;
  final TextEditingController controllerAdj;
  final double moneyValueCart;

  const NumericKeypad(
      {super.key,
      required this.checkImport,
      required this.controller,
      required this.controllerAdj,
      required this.moneyValueCart});

  @override
  State<NumericKeypad> createState() => _NumericKeypadState();
}

class _NumericKeypadState extends State<NumericKeypad> {
  late TextEditingController _controller;
  late TextEditingController _controllerAdj;
  late double _moneyValueCart;
  late double _toBeReturned;
  late double _realToBeReturned = 0;
  late bool _isNumericPadVisible = true;
  final List<bool> _selectedPayment = <bool>[true, false, false, false];

  @override
  void initState() {
    super.initState();
    _controller = widget.controller..addListener(_onSelectionChanged);
    _controllerAdj = widget.controllerAdj;
    _moneyValueCart = widget.moneyValueCart;
    _toBeReturned = 0;
    _isNumericPadVisible = true;
  }

  @override
  void dispose() {
    _controller.removeListener(_onSelectionChanged);
    super.dispose();
  }

  void _onSelectionChanged() {
    setState(() {
      String insertedStringValue = _controller.text;
      if (insertedStringValue.isNotEmpty) {
        int insertedIntValue = int.parse(insertedStringValue);
        double insertedValue = insertedIntValue / 100;
        _controllerAdj.text =
            "Importo inserito da tastierino numerico: $insertedValue";
        _realToBeReturned = (insertedValue - _moneyValueCart);
        double showRest = (_moneyValueCart - insertedValue) < 0
            ? (-(_moneyValueCart - insertedValue))
            : 0;
        String inString = showRest.toStringAsFixed(2);
        _toBeReturned = double.parse(inString);
        widget.checkImport(0, _realToBeReturned);
      } else {
        _controllerAdj.text = "";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0, top: 16.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ToggleButtons(
                direction: Axis.horizontal,
                onPressed: (int index) {
                  setState(() {
                    // The button that is tapped is set to true, and the others to false.
                    for (int i = 0; i < _selectedPayment.length; i++) {
                      _selectedPayment[i] = i == index;
                    }
                    if (index == 0) {
                      _isNumericPadVisible = true;
                    } else {
                      _isNumericPadVisible = false;
                    }
                    widget.checkImport(index, _realToBeReturned);
                  });
                },
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                selectedBorderColor: Colors.blueAccent[100],
                selectedColor: Colors.white,
                fillColor: Colors.blueAccent[100],
                color: Colors.black,
                // constraints: const BueConstraints(
                //   minHeight: 40.0,
                //   minWidth: 80.0,
                // ),
                isSelected: _selectedPayment,
                children: [
                  SizedBox(
                    height: 50,
                    width: width > 1200 ? 200 : width * 0.20,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(Icons.euro),
                        Text('Contanti',
                            style: Theme.of(context).textTheme.bodyMedium),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 50,
                    width: width > 1200 ? 200 : width * 0.20,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(Icons.card_giftcard),
                        Text('Bancomat',
                            style: Theme.of(context).textTheme.bodyMedium),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 50,
                    width: width > 1200 ? 200 : width * 0.20,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(Icons.credit_card),
                        Text('Carta di credito',
                            style: Theme.of(context).textTheme.bodyMedium),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 50,
                    width: width > 1200 ? 150 : width * 0.25,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(Icons.fact_check),
                        Text('Assegni',
                            style: Theme.of(context).textTheme.bodyMedium),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          Visibility(
              maintainSize: true,
              maintainAnimation: true,
              maintainState: true,
              visible: _isNumericPadVisible,
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                          child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          height: 50, //height of button
                          width: double.infinity,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Icon(Icons.money),
                              Text('Resto da consegnare: $_toBeReturned',
                                  style:
                                      Theme.of(context).textTheme.titleSmall),
                            ],
                          ),
                        ),
                      )),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildButton('1', width),
                      _buildButton('2', width),
                      _buildButton('3', width),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildButton('4', width),
                      _buildButton('5', width),
                      _buildButton('6', width),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildButton('7', width),
                      _buildButton('8', width),
                      _buildButton('9', width),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildButton('00', width),
                      _buildButton('0', width),
                      _buildButton('⌫', width, onPressed: _backspace),
                    ],
                  ),
                ],
              )),
        ],
      ),
    );
  }

  Widget _buildButton(String text, double width, {VoidCallback? onPressed}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 40, //height of button
        width: width > 1200 ? 200 : width * 0.30,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            // backgroundColor: Colors.lightBlue[100],
            side: const BorderSide(
                width: 1, // the thickness
                color: Colors.grey // the color of the border
                ),
            // padding:
            //     const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
            // textStyle:
            //     const TextStyle(fontSize: 30, fontWeight: FontWeight.bold)
          ),
          onPressed: onPressed ?? () => _input(text),
          child: Text(text,
              style: const TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  void _input(String text) {
    final value = _controller.text + text;
    _controller.text = value;
  }

  void _backspace() {
    final value = _controller.text;
    if (value.isNotEmpty) {
      _controller.text = value.substring(0, value.length - 1);
    }
  }
}
