
import 'dart:math';

import '../expense_repository.dart';

class FirebaseExpenseRepo implements ExpenseRepository {
  @override
  Future <void> createCategory(Category category) async {
    try {

    } catch(e)  {
      log(e.toString());
      rethrow; 
    }
  }
}