import 'dart:math';

import 'package:expense_repository/expense_repository.dart';
import 'package:expense_tracker/screens/home/views/main_screen.dart';
import 'package:expense_tracker/screens/add_expenses/blocs/create_category_bloc/create_category_bloc.dart';
import 'package:expense_tracker/screens/add_expenses/blocs/get_categories_bloc/get_categories_bloc.dart';
import 'package:expense_tracker/screens/add_expenses/views/add_expense.dart';
import 'package:expense_tracker/screens/home/blocs/get_expenses_bloc/get_expenses_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../add_expenses/blocs/create_expense_bloc/create_expense_bloc.dart';
import '../../stats/stats.dart';
import 'package:expense_tracker/data/sms_parser.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int index = 0;
  late Color selectedItem = Colors.blue;
  Color unselectedItem = Colors.grey;
  final SmsParser smsParser = SmsParser();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetExpensesBloc, GetExpensesState>(
      builder: (context, state) {
        if(state is GetExpensesSuccess) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Expense Tracker'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.sms),
                  tooltip: 'Parse SMS Expenses',
                  onPressed: () async {
                    showDialog(
                      context: context,
                      builder: (context) => const Center(child: CircularProgressIndicator()),
                      barrierDismissible: false,
                    );
                    final granted = await smsParser.requestPermissions();
                    if (!granted) {
                      Navigator.pop(context);
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Permission Denied'),
                          content: const Text('SMS permissions are required.'),
                          actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK'))],
                        ),
                      );
                      return;
                    }
                    final messages = await smsParser.fetchSms();
                    final expenses = smsParser.parseExpenses(messages);
                    Navigator.pop(context);
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Parsed SMS Expenses'),
                        content: SizedBox(
                          width: 300,
                          height: 300,
                          child: ListView.builder(
                            itemCount: expenses.length,
                            itemBuilder: (context, i) {
                              final e = expenses[i];
                              return ListTile(
                                title: Text('Amount: Rs. 	${e['amount']}'),
                                subtitle: Text('${e['sender']}\n${e['body']}'),
                              );
                            },
                          ),
                        ),
                        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close'))],
                      ),
                    );
                  },
                ),
              ],
            ),
            bottomNavigationBar: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
              child: BottomNavigationBar(
                  onTap: (value) {
                    setState(() {
                      index = value;
                    });
                  },
                  showSelectedLabels: false,
                  showUnselectedLabels: false,
                  elevation: 3,
                  items: [BottomNavigationBarItem(icon: Icon(CupertinoIcons.home, color: index == 0 ? selectedItem : unselectedItem), label: 'Home'), BottomNavigationBarItem(icon: Icon(CupertinoIcons.graph_square_fill, color: index == 1 ? selectedItem : unselectedItem), label: 'Stats')]),
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
            floatingActionButton: FloatingActionButton(
              onPressed: () async {
                Expense? newExpense = await Navigator.push(
                  context,
                  MaterialPageRoute<Expense>(
                    builder: (BuildContext context) => MultiBlocProvider(
                      providers: [
                        BlocProvider(
                          create: (context) => CreateCategoryBloc(FirebaseExpenseRepo()),
                        ),
                        BlocProvider(
                          create: (context) => GetCategoriesBloc(FirebaseExpenseRepo())..add(GetCategories()),
                        ),
                        BlocProvider(
                          create: (context) => CreateExpenseBloc(FirebaseExpenseRepo()),
                        ),
                      ],
                      child: const AddExpense(),
                    ),
                  ),
                );

                if(newExpense != null) {
                  setState(() {
                    state.expenses.insert(0, newExpense);
                  });
                }
              },
              shape: const CircleBorder(),
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        Theme.of(context).colorScheme.tertiary,
                        Theme.of(context).colorScheme.secondary,
                        Theme.of(context).colorScheme.primary,
                      ],
                      transform: const GradientRotation(pi / 4),
                    )),
                child: const Icon(CupertinoIcons.add),
              ),
            ),
            body: index == 0 
              ? MainScreen(state.expenses) 
              : const StatScreen());
        } else {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      }
    );
  }
}