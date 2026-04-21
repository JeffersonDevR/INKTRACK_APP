import 'package:InkTrack/features/locales/data/models/local.dart';

abstract class LocalesRepository {
  Future<List<Local>> getAll();
  Future<Local?> getById(String id);
  Future<void> save(Local local);
  Future<void> update(String id, Local local);
  Future<void> delete(String id);
}
