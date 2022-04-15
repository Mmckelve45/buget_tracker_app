import 'package:buget_tracker_app/model/transaction_item.dart';
import 'package:buget_tracker_app/services/budget_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final budgetService = context.watch<BudgetService>();
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.all(15),
              child: SizedBox(
                width: screenSize.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: Consumer<BudgetService>(
                        builder: ((context, value, child) {
                          return CircularPercentIndicator(
                            radius: screenSize.width / 2,
                            lineWidth: 10.0,
                            percent: value.balance / value.budget,
                            backgroundColor: Colors.white,
                            center: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "\$" + value.balance.toString().split(".")[0],
                                  style: TextStyle(
                                      fontSize: 48,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "Balance",
                                  style: TextStyle(fontSize: 18),
                                ),
                                Text(
                                  "Budget: \$" + value.budget.toString(),
                                  style: TextStyle(fontSize: 12),
                                )
                              ],
                            ),
                            progressColor:
                                Theme.of(context).colorScheme.primary,
                          );
                        }),
                      ),
                    ),
                    const SizedBox(
                      height: 35,
                    ),
                    const Text(
                      "Items",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Consumer<BudgetService>(
                      builder: ((context, value, child) {
                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: value.items.length,
                          physics: const ClampingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return TransactionCard(
                              transactionItem: value.items[index],
                            );
                          }
                        );
                      })
                    ),
                    // ...List.generate(
                    //   items.length,
                    //   (index) => TransactionCard(transactionItem: items[index]),
                    // ),
                    // TransactionCard(
                    //   transactionItem: TransactionItem(
                    //       itemTitle: "Apple Watch", amount: 105.99),
                    // ),
                    // TransactionCard(
                    //   transactionItem: TransactionItem(
                    //       itemTitle: "Apple iPhone",
                    //       amount: 800,
                    //       isExpense: false),
                    // )
                  ],
                ),
              ))),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return AddTransactionDialog(itemToAdd: (transactionItem) {
                  final budgetService = context.read<BudgetService>();
                  budgetService.addItem(transactionItem);
                });
              });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class TransactionCard extends StatelessWidget {
  final TransactionItem transactionItem;
  // final double amount;
  // final bool isExpense;

  TransactionCard({required this.transactionItem, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 5, top: 5),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.05),
              offset: const Offset(0, 25),
              blurRadius: 50,
            )
          ],
        ),
        padding: const EdgeInsets.all(15),
        width: MediaQuery.of(context).size.width,
        child: Row(
          children: [
            Text(
              transactionItem.itemTitle,
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
            const Spacer(),
            Text(
              (!transactionItem.isExpense ? "+ " : "- ") +
                  transactionItem.amount.toString(),
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

class AddTransactionDialog extends StatefulWidget {
  final Function(TransactionItem) itemToAdd;
  const AddTransactionDialog({Key? key, required this.itemToAdd})
      : super(key: key);

  @override
  State<AddTransactionDialog> createState() => _AddTransactionDialogState();
}

class _AddTransactionDialogState extends State<AddTransactionDialog> {
  final TextEditingController itemTitleController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  bool _isExpenseController = true;
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        width: MediaQuery.of(context).size.width / 1.3,
        height: 300,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              const Text(
                "Add and expense",
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(
                height: 15,
              ),
              TextField(
                controller: itemTitleController,
                decoration: const InputDecoration(hintText: "Name of expense"),
              ),
              TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly,
                  // FilteringTextInputFormatter.allow('.')
                ],
                decoration: const InputDecoration(hintText: "Amount in \$"),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Is expense?"),
                  Switch.adaptive(
                      value: _isExpenseController,
                      onChanged: (b) {
                        setState(() {
                          _isExpenseController = b;
                        });
                      })
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              ElevatedButton(
                  onPressed: () {
                    if (amountController.text.isNotEmpty &&
                        itemTitleController.text.isNotEmpty) {
                      widget.itemToAdd(TransactionItem(
                          amount: double.parse(amountController.text),
                          itemTitle: itemTitleController.text,
                          isExpense: _isExpenseController));
                      Navigator.pop(context);
                    }
                  },
                  child: const Text("Add"))
            ],
          ),
        ),
      ),
    );
  }
}