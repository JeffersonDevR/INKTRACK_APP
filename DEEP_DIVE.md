# InkTrack: Deep-Dive Developer Implementation Guide 🖋️🚀

Welcome to the mastery phase of InkTrack. This guide is designed to transform you from a developer who "uses" the architecture to an architect who "evolves" it.

---

## 1. The "New Feature" Workflow: Adding the "Reports" Module

When adding a new feature, follow this "Inside-Out" approach: **Model -> ViewModel -> Registration -> View**.

### Step A: Define the Model (The "What")
Every feature starts with data. In InkTrack, models must implement `HasId` to be compatible with our `BaseCrudViewModel`.

1. Create `lib/features/reports/models/report.dart`.
2. Implement your class and mix in or extend `HasId`.

```dart
import '../../../core/base_crud_viewmodel.dart';

class Report implements HasId {
  @override
  final String id;
  final String title;
  final DateTime date;
  final double totalSales;

  Report({
    required this.id,
    required this.title,
    required this.date,
    required this.totalSales,
  });
}
```

### Step B: Extend BaseCrudViewModel (The "How")
The ViewModel handles the logic. By extending `BaseCrudViewModel<Report>`, you get `items`, `add()`, `update()`, and `delete()` for free.

1. Create `lib/features/reports/viewmodels/reports_viewmodel.dart`.

```dart
import '../../../core/base_crud_viewmodel.dart';
import '../models/report.dart';

class ReportsViewModel extends BaseCrudViewModel<Report> {
  // Add feature-specific logic here
  double get totalRevenue => items.fold(0.0, (sum, item) => sum + item.totalSales);

  void generateDailyReport(double sales) {
    final newReport = Report(
      id: DateTime.now().toIso8601String(),
      title: "Resumen Diario",
      date: DateTime.now(),
      totalSales: sales,
    );
    add(newReport); // This calls notifyListeners() automatically
  }
}
```

### Step C: Register the Provider (The "Where")
To make the ViewModel accessible, add it to `main.dart`. To avoid a "provider mess," keep the list organized.

```dart
// lib/main.dart
MultiProvider(
  providers: [
    ChangeNotifierProvider(create: (_) => VentasViewModel()),
    ChangeNotifierProvider(create: (_) => ReportsViewModel()), // ¡Nuevo!
    // ... otros providers
  ],
  child: const InkTrackApp(),
)
```

### Step D: Connect the UI (The "Mental Bridge")
When building the View, use `context.watch<T>()` for reactive data and `context.read<T>()` for actions (callbacks).

**Thinking Process:**
*   **Need to show a list?** -> `final reports = context.watch<ReportsViewModel>().items;`
*   **Need to trigger an action?** -> `context.read<ReportsViewModel>().generateDailyReport(100.0);`

---

## 2. Data Persistence Mental Model: Bridging to the Real World

Currently, InkTrack is "Volatile" (data resides only in RAM). To make it "Persistent," we introduce the **Repository Pattern**.

### The Repository Layer (The "Shield")
The Repository is a buffer. The ViewModel asks for data; it doesn't care if it comes from a JSON file, a database, or a Cloud Service.

**The Flow:**
`ViewModel` <--> `Repository (Interface)` <--> `Data Source (Hive/Supabase)`

#### Local Persistence (Hive/SQLite)
*   **Flow:** `ViewModel -> ReportsRepository -> HiveBox`.
*   The Repository handles the conversion between Dart Objects and the database format (Adapter).

#### Cloud Persistence (Supabase) & Async States
When moving to the cloud, data isn't instant. You must handle the "Wait."

**Mental Model for Async UI:**
1.  **State Loading:** Show a `CircularProgressIndicator`.
2.  **State Success:** Show the data.
3.  **State Error:** Show a friendly message with a "Retry" button.

```dart
// Inside ViewModel
bool _isLoading = false;
bool get isLoading => _isLoading;

Future<void> loadData() async {
  _isLoading = true;
  notifyListeners(); // Tell UI to show loading spinner
  
  try {
    _items = await _repository.fetchFromCloud();
  } catch (e) {
    // Handle error
  } finally {
    _isLoading = false;
    notifyListeners(); // Tell UI to stop loading and show data
  }
}
```

---

## 3. Mastering the "Building Blocks"

### Why Composition over Inheritance?
In Flutter, we don't "extend" widgets to change them; we "wrap" them.
*   **Inheritance:** Creating a `BlueButton` that extends `Button`. (Fragile, rigid)
*   **Composition:** A `Button` that takes a `child` (Text, Icon, etc.) and a `color` parameter. (Flexible, reusable)
*   **InkTrack Rule:** If a `build` method is > 60 lines, extract a sub-widget. Small widgets are easier to test and rebuild faster.

### The Context Chain: How `Provider.of<T>` works
Think of `BuildContext` as your location in the widget tree.
*   When you call `context.watch<T>()`, Flutter starts at your current widget and "looks up" the tree until it finds the first parent that provides `T`.
*   This is why `MultiProvider` is at the very top (root)—so everyone below can "see" and "access" the data models.

### State Lifecycle: When to `notifyListeners()`?
*   **Rule:** Only call it when the data the UI depends on has actually changed.
*   **Too frequent:** App becomes laggy (jank) because it's re-rendering unnecessarily.
*   **Too rare:** The UI looks "frozen" even though the data changed in the background.
*   **InkTrack Best Practice:** Use the `add/update/delete` methods in `BaseCrudViewModel`, as they encapsulate the `notifyListeners()` call safely.

---

**Mastery Tip:** Always ask, *"Who owns this data?"* If the data needs to live across different screens, it belongs in a **ViewModel**. If it's just for a checkbox on one screen, it belongs in a `StatefulWidget`.
