import 'package:InkTrack/features/clientes/data/models/abono.dart';

abstract class AbonosRepository {
  Future<List<Abono>> getByCliente(String clienteId);
  Future<void> save(Abono item);
  Future<void> delete(String id);
  Future<double> getSaldoPendiente(String clienteId);
}
