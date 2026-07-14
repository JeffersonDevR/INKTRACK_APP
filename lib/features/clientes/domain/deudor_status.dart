import 'package:InkTrack/features/clientes/data/models/cliente.dart';

enum DeudorStatus { alDia, porVencer, vencido }

DeudorStatus computeStatus(Cliente cliente, {DateTime? now}) {
  final current = now ?? DateTime.now();
  final saldo = cliente.saldoPendiente;

  if (saldo <= 0) {
    return DeudorStatus.alDia;
  }

  final promesa = cliente.promesaPago;
  if (promesa == null) {
    // Tiene deuda pero no hay promesa de pago → no puede estar "al día"
    return DeudorStatus.porVencer;
  }

  final currentDateOnly = DateTime(current.year, current.month, current.day);
  final promesaDateOnly = DateTime(promesa.year, promesa.month, promesa.day);

  if (promesaDateOnly.isBefore(currentDateOnly)) {
    return DeudorStatus.vencido;
  }

  final diffDays = promesaDateOnly.difference(currentDateOnly).inDays;
  if (diffDays <= 7) {
    return DeudorStatus.porVencer;
  }

  return DeudorStatus.alDia;
}
