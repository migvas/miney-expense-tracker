# Miney - Expense Tracking App

A Flutter expense tracking app for Android that allows users to track expenses with categories, view analytics, and manage expense types.

## Disclaimer

This project was created as a way to test [Claude Code](https://claude.ai/code) in a technology stack (Flutter/Dart) that I had no prior experience with. The entire codebase was developed with assistance from Claude Code to explore its capabilities in an unfamiliar domain.

## Features

- **Expense Management**: Add, view, and delete expenses with descriptions, amounts, and dates
- **Category System**: Organize expenses by categories with custom colors
- **Analytics**: Visual insights with pie charts (by category) and bar charts (monthly trends)
- **Data Persistence**: Local SQLite database storage
- **Material Design UI**: Clean, intuitive interface following Material Design principles

## Screenshots

*Screenshots coming soon*

## Getting Started

### Prerequisites

- Flutter SDK (latest stable version)
- Android Studio or VS Code with Flutter extensions
- Android device or emulator

### Installation

1. Clone the repository:
```bash
git clone https://github.com/migvas/miney-expense-tracker.git
cd miney-expense-tracker
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

### Building

To build a release APK:
```bash
flutter build apk
```

## Architecture

### Core Components
- **Models** (`lib/models/`): Data classes for Expense and ExpenseType
- **Database** (`lib/database/`): SQLite database helper with CRUD operations
- **Screens** (`lib/screens/`): UI screens for different app features

### Database Schema
- `expenses` table: id, description, amount, date, expenseTypeId
- `expense_types` table: id, name, color
- Comes with 5 default expense categories (Food, Transportation, Entertainment, Shopping, Bills)

### Key Dependencies
- `sqflite`: SQLite database for local storage
- `fl_chart`: Charts and graphs for analytics visualization
- `intl`: Date formatting and internationalization

## Testing

Run tests with:
```bash
flutter test
```

Check for code issues:
```bash
flutter analyze
```

## Contributing

This is a personal learning project, but feel free to fork and experiment with it!

## License

This project is open source and available under the [MIT License](LICENSE).
