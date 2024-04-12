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
        title: const Text('Exchange Page'),
      ),
      body: StreamBuilder<Exchangerate>(
          stream: conversionLogic.currencyStreamController.stream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return const Center(
                child: Text("Errore"),
              );
            } else if (snapshot.hasData) {
              return Column(
                children: [
                  const Text("Tassi di conversione attuali"),
                  Text(
                      "CURRENT CURRENCY : ${conversionLogic.currentCurrency} --- 1.0"),
                  //select
                  Expanded(
                    child: ListView(
                      children: [
                        ...snapshot.data!.conversionRates!.entries.map((entry) {
                          return InkWell(
                            onTap: () {
                              conversionLogic.convertBasedOnCurrency(entry.key);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(entry.key),
                                Text(entry.value.toString()),
                              ],
                            ),
                          );
                        }),
                      ],
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
}
