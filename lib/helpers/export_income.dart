import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:csv/csv.dart';
import '../model/epenses_model.dart';
import '../model/income_model.dart';

import 'dart:io';

class ExportController {
  List<Expense> expenses = [];
  List<Income> incomes = [];
//fetch expense and incomes data from the firebase

  Future<void> fetchExpensesData(String userId) async {
    final expenseSnapshot = await FirebaseFirestore.instance
        .collection('expenses')
        .where('userId', isEqualTo: userId)
        .get();
    expenses =
        expenseSnapshot.docs.map((doc) => Expense.fromFirestore(doc)).toList();
  }

  Future<void> fetchIncomeData(String userId) async {
    final incomeSnapshot = await FirebaseFirestore.instance
        .collection('incomes')
        .where('userId', isEqualTo: userId)
        .get();
    incomes =
        incomeSnapshot.docs.map((doc) => Income.fromFirestore(doc)).toList();
  }

  void _addTableToPDF(PdfPage page, Size pageSize, List<dynamic> data, String tableName) {
    // Create the table
    PdfGrid table = PdfGrid();

    // Add the columns to the table
    table.columns.add(count: 5);

    // Add the table header
    PdfGridRow headerRow = table.headers.add(1)[0];
    headerRow.cells[0].value = 'Type';
    headerRow.cells[1].value = 'Amount';
    headerRow.cells[2].value = 'Details';
    headerRow.cells[3].value = 'Category';
    headerRow.cells[4].value = 'Created At';

    // Add the data rows
    for (var dataItem in data) {
      String type = (dataItem is Expense) ? 'Expense' : 'Income';
      String amount = dataItem.amount.toString();
      String details = dataItem.details;
      String category = dataItem.category;
      String createdAt = dataItem.createdAt.toString();

      PdfGridRow dataRow = table.rows.add();
      dataRow.cells[0].value = type;
      dataRow.cells[1].value = amount;
      dataRow.cells[2].value = details;
      dataRow.cells[3].value = category;
      dataRow.cells[4].value = createdAt;
    }

    // Set table style
    table.style = PdfGridStyle(
      font: PdfStandardFont(PdfFontFamily.helvetica, 12),
      cellPadding: PdfPaddings(top: 5, left: 5, right: 5, bottom: 5),
    );

    // Set header style
    headerRow.style = PdfGridCellStyle(
      backgroundBrush: PdfSolidBrush(PdfColor(240, 240, 240)),
      textBrush: PdfSolidBrush(PdfColor(0, 0, 0)),
      font: PdfStandardFont(PdfFontFamily.helvetica, 14, style: PdfFontStyle.bold),
    );

    // Set cell borders
    for (int i = 0; i < table.rows.count; i++) {
      PdfGridRow row = table.rows[i];
      for (int j = 0; j < row.cells.count; j++) {
        PdfGridCell cell = row.cells[j];
        cell.style.borders.all = PdfPens.black;
      }
    }
    // Draw the table on the page
    table.draw(
      page: page,
      bounds: Rect.fromLTWH(0, pageSize.height - 100, pageSize.width, pageSize.height - 100),
    );

    // Add table title below the table
    PdfFont tableTitleFont = PdfStandardFont(PdfFontFamily.helvetica, 14, style: PdfFontStyle.bold);
    PdfStringFormat format = PdfStringFormat(alignment: PdfTextAlignment.center);
    Size tableTitleSize = tableTitleFont.measureString(tableName, format: format);
    double tableTitleX = (pageSize.width - tableTitleSize.width) / 2;
    double tableTitleY = pageSize.height - 120;

    page.graphics.drawString(
      tableName,
      tableTitleFont,
      bounds: Rect.fromLTWH(tableTitleX, tableTitleY, tableTitleSize.width, tableTitleSize.height),
      format: format,
    );
  }

  Future<void> exportToPDF() async {
    // Get the current user ID from Firebase Auth
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        return;
      }

      String userId = user.uid;
      await fetchExpensesData(userId);
      await fetchIncomeData(userId);

      // Create PDF document for expenses
      PdfDocument expensesDocument = PdfDocument();
      PdfPage expensesPage = expensesDocument.pages.add();
      Size pageSize = expensesPage.getClientSize();

      // Add expenses table to the expenses document
      _addTableToPDF(expensesPage, pageSize, expenses, "Expenses");

      // Save the expenses PDF document
      List<int> expensesBytes = await expensesDocument.save();
      expensesDocument.dispose();
      await saveAndLaunchFile(expensesBytes, 'Patofy_Expenses.pdf');

      // Create PDF document for incomes
      PdfDocument incomesDocument = PdfDocument();
      PdfPage incomesPage = incomesDocument.pages.add();

      // Add incomes table to the incomes document
      _addTableToPDF(incomesPage, pageSize, incomes, "Incomes");

      // Save the incomes PDF document
      List<int> incomesBytes = await incomesDocument.save();
      incomesDocument.dispose();
      await saveAndLaunchFile(incomesBytes, 'Patofy_Incomes.pdf');
    } catch (e) {
      // Handle the error gracefully
    }
  }
  String getCurrentFormattedDate() {
    DateTime now = DateTime.now();
    String formattedDate = "${now.day}-${now.month}-${now.year}";
    return formattedDate;
  }

  Future<String> saveAndLaunchFile(List<int> bytes, String filename) async {
    final path = (await getExternalStorageDirectory())!.path;
  final file = File('$path/$filename');
  await file.writeAsBytes(bytes, flush: true);
  return file.path;
  }

  // Method to export user data to CSV format
  Future<void> exportToCSV() async {
    // Get the current user ID from Firebase Auth
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return;
    }

    String userId = user.uid;
    await fetchExpensesData(userId);
    await fetchIncomeData(userId);

    // Combine expenses and incomes data into a single list
    List<dynamic> combinedData = [];
    combinedData.addAll(expenses);
    combinedData.addAll(incomes);

    // Convert the combined data to CSV format
    List<List<dynamic>> csvData = [];

    // Add CSV headers
    csvData.add(['Type', 'Amount', 'Details', 'Category', 'Created At']);

    // Add data rows
    for (var data in combinedData) {
      String type = (data is Expense) ? 'Expense' : 'Income';
      String amount = data.amount.toString();
      String details = data.details;
      String category = data.category;
      String createdAt =
          data.createdAt.toString(); // Assuming createdAt is of type DateTime

      csvData.add([type, amount, details, category, createdAt]);
    }

    // Generate CSV content
    String csvContent = const ListToCsvConverter().convert(csvData);

    // Save the CSV data to a file
    final path = (await getExternalStorageDirectory())!.path;
    final file = File('$path/PatofyData.csv');
    await file.writeAsString(csvContent);

  }
}
