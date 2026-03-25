# InkTrack 🖋️🚀

Prototype of a POS (Point of Sale) system for local shops, built with Flutter.

InkTrack is designed to help small business owners manage their daily operations, including sales tracking, inventory management, customer and supplier relationships, and cash flow monitoring.

## 🌟 Features

-   **Sales Management**: Register sales, calculate daily totals, and maintain a history of transactions.
-   **Inventory Tracking**: Manage products, track stock levels, and update prices.
-   **Customer & Supplier Directory**: Keep a record of your business contacts, including contact details and visit days for suppliers.
-   **Movement History**: Monitor all monetary and activity-based movements within the app.
-   **Modern UI**: A clean, professional interface with support for light and dark modes.

## 🏗️ Architecture

The project follows the **MVVM (Model-View-ViewModel)** architectural pattern combined with `Provider` for state management. This ensuring a clean separation of concerns:

-   **Models**: Represent the data structures.
-   **ViewModels**: Handle business logic and notify the UI of state changes.
-   **Views**: Flutter widgets that display the state and forward user actions to ViewModels.
-   **Repositories**: Abstract the data source, allowing for easy transitions between in-memory storage and persistent databases.

## 🚀 Getting Started

### Prerequisites

-   Flutter SDK (^3.10.7)
-   Dart SDK

### Installation

1.  Clone the repository:
    ```bash
    git clone https://github.com/your-repo/inktrack_proto.git
    ```
2.  Navigate to the project directory:
    ```bash
    cd inktrack_proto
    ```
3.  Install dependencies:
    ```bash
    flutter pub get
    ```

### Running the App

To run the app in debug mode:
```bash
flutter run
```

### Running Tests

To execute the unit tests:
```bash
flutter test
```

## 📚 Documentation

For a more in-depth look at the implementation and architecture, refer to the following guides:
-   [Deep-Dive Developer Implementation Guide](docs/DEEP_DIVE.md)
-   [MVVM Architecture Guide](docs/GUIA_MVVM.md)
