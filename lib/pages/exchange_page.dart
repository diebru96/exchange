import 'package:exchange/consts/colors.dart';
import 'package:exchange/consts/consts.dart';
import 'package:exchange/logic/exchange_logic.dart';
import 'package:exchange/models/exchange_model.dart';
import 'package:flutter/material.dart';

class ExchangePage extends StatefulWidget {
  const ExchangePage({super.key});

  @override
  State<ExchangePage> createState() => _ExchangePageState();
}

class _ExchangePageState extends State<ExchangePage> {
  ConversionLogic conversionLogic = ConversionLogic();
  @override
  void initState() {
    conversionLogic.getExchangeRates(starting_currency);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Current Exchange Rates',
            style: TextStyle(color: backgroundColor)),
      ),
      body: StreamBuilder<Exchangerate>(
          stream: conversionLogic.currencyStreamController.stream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text("Error: ${snapshot.error}"),
              );
            } else if (snapshot.hasData) {
              return Column(
                children: [
                  Container(
                      margin: const EdgeInsets.only(left: 10, right: 10),
                      decoration: BoxDecoration(
                          border: Border(
                              bottom:
                                  BorderSide(color: dividerColor, width: 1))),
                      height: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.monetization_on,
                                color: dividerColor,
                              ),
                              const Text(
                                "Currency selected:",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 16),
                              ),
                            ],
                          ),
                          dropDownSelect(),
                        ],
                      )),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(15.0, 0, 15.0, 10),
                      child: ListView(
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          ...snapshot.data!.conversionRates!.entries
                              .map((entry) {
                            return currencyTile(entry.key, entry.value);
                          }),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return Container();
            }
          }),
    );
  }

  dropDownSelect() {
    return DropdownButton<String>(
      value: conversionLogic.currentCurrency,
      icon: Icon(Icons.keyboard_arrow_down, color: selectionColor),
      elevation: 16,
      style: TextStyle(color: darkSelectionColor),
      underline: Container(
        height: 2,
        color: selectionColor,
      ),
      onChanged: (String? value) {
        if (value != null) {
          conversionLogic.convertBasedOnCurrency(value);
        }
      },
      items: conversionLogic.exchangerate!.conversionRates!.keys
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  currencyTile(String currency, double value) {
    return Container(
      padding: const EdgeInsets.only(left: 5, right: 5),
      decoration: BoxDecoration(
          color: currency == conversionLogic.currentCurrency
              ? lightSelectionColor.withOpacity(0.3)
              : backgroundColor,
          border: Border(bottom: BorderSide(color: lightTextColor))),
      child: InkWell(
        onTap: () {
          conversionLogic.convertBasedOnCurrency(currency);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(currency,
                style: currency == conversionLogic.currentCurrency
                    ? TextStyle(color: selectionColor)
                    : null),
            Text(
              value.toStringAsFixed(conversionLogic.numberOfDecimals),
              style: currency == conversionLogic.currentCurrency
                  ? TextStyle(color: selectionColor)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
