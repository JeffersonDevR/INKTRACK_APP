import 'package:flutter/foundation.dart';

abstract class BaseCrudViewModel<T extends HasId> extends ChangeNotifier {
  final List<T> _items = [];
  List<T>? _cachedItems;

  List<T> get items {
    _cachedItems ??= List.unmodifiable(_items);
    return _cachedItems!;
  }

  int get count => _items.length;
  bool get isEmpty => _items.isEmpty;
  bool get isNotEmpty => _items.isNotEmpty;

  void add(T item) {
    _items.add(item);
    _cachedItems = null;
    notifyListeners();
  }

  void update(String id, T item) {
    final index = _items.indexWhere((item) => _getId(item) == id);
    if (index != -1) {
      _items[index] = item;
      _cachedItems = null;
      notifyListeners();
    }
  }

  void delete(String id) {
    _items.removeWhere((item) => _getId(item) == id);
    _cachedItems = null;
    notifyListeners();
  }

  void clearAll() {
    _items.clear();
    _cachedItems = null;
  }

  T? getById(String id) {
    try {
      return _items.firstWhere((item) => _getId(item) == id);
    } catch (e) {
      return null;
    }
  }

  String _getId(T item) => item.id;

  Future<void> refresh() async {
    await loadItems();
    notifyListeners();
  }

  Future<void> loadItems() async {}
}

abstract class HasId {
  String get id;
}
