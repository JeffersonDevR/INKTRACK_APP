import 'package:flutter/foundation.dart';

abstract class BaseCrudViewModel<T> extends ChangeNotifier {
  
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

  T? getById(String id) {
    try {
      return _items.firstWhere((item) => _getId(item) == id);
    } catch (e) {
      return null;
    }
  }

  String _getId(T item) {
    if (item is HasId) {
      return (item as HasId).id;
    }
    throw UnimplementedError('Item must implement HasId or override _getId');
  }
}

abstract class HasId {
  String get id;
}
