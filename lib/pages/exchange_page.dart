import 'package:exchange/logic/conversion_logic.dart';
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
    conversionLogic.getExchangeRates('USD');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Current Exchange Rates',
            style: TextStyle(color: Colors.white)),
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
                              bottom: BorderSide(
                                  color: Colors.grey.shade600, width: 1))),
                      height: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.monetization_on,
                                color: Colors.grey.shade600,
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
      icon:
          const Icon(Icons.keyboard_arrow_down, color: Colors.deepPurpleAccent),
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
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
          border: Border(bottom: BorderSide(color: Colors.grey.shade300))),
      child: InkWell(
        onTap: () {
          conversionLogic.convertBasedOnCurrency(currency);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(currency,
                style: currency == conversionLogic.currentCurrency
                    ? const TextStyle(color: Colors.deepPurpleAccent)
                    : null),
            Text(
              value.toString(),
              style: currency == conversionLogic.currentCurrency
                  ? const TextStyle(color: Colors.deepPurpleAccent)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
