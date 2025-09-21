# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview
Miney is a Flutter expense tracking app for Android that allows users to track expenses with categories, view analytics, and manage expense types.

## Development Commands

### Flutter Commands
- `flutter pub get` - Install dependencies
- `flutter run` - Run the app in debug mode  
- `flutter build apk` - Build release APK for Android
- `flutter test` - Run tests
- `flutter analyze` - Analyze code for issues
- `flutter doctor` - Check Flutter installation and dependencies

### Testing
- `flutter test` - Run all unit tests
- `flutter integration_test` - Run integration tests (if available)

## Architecture

### Core Components
- **Models** (`lib/models/`): Data classes for Expense and ExpenseType
- **Database** (`lib/database/`): SQLite database helper with CRUD operations
- **Screens** (`lib/screens/`): UI screens for different app features
- **Main Navigation**: Bottom navigation with 3 tabs (Expenses, Analytics, Categories)

### Database Schema
- `expenses` table: id, description, amount, date, expenseTypeId
- `expense_types` table: id, name, color
- Comes with 5 default expense categories (Food, Transportation, Entertainment, Shopping, Bills)

### Key Features
- Add expenses with date picker, description, amount, and category selection
- View expenses in a list with total calculation
- Analytics with pie charts (by category) and bar charts (monthly trends)
- Manage expense categories (add/delete custom categories with color selection)
- Data persistence using SQLite

### Dependencies
- `sqflite`: SQLite database for local storage
- `fl_chart`: Charts and graphs for analytics visualization
- `intl`: Date formatting and internationalization
- `path`: File path utilities

### Screen Flow
1. **MainScreen**: Bottom navigation controller with IndexedStack
2. **ExpensesListScreen**: Shows expense list with delete functionality and total
3. **AddExpenseScreen**: Form to add new expenses
4. **AnalyticsScreen**: Charts showing expense patterns by category and time
5. **ManageTypesScreen**: Add/delete expense categories

### Database Operations
All database operations are handled through `DatabaseHelper` singleton class:
- Expense CRUD operations
- ExpenseType CRUD operations  
- Analytics queries for charts (expenses by type, expenses by month)
- Automatic creation of default expense types on first run

### UI Patterns
- Material Design with blue primary theme
- FloatingActionButton for adding expenses (only on Expenses tab)
- Card-based layouts for list items
- Color-coded categories throughout the app
- Form validation for required fields