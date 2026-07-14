import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:InkTrack/l10n/app_localizations.dart';
import 'package:InkTrack/features/ventas/presentation/viewmodels/ventas_viewmodel.dart';
import 'package:InkTrack/features/ventas/data/models/venta.dart';
import 'package:InkTrack/features/clientes/data/models/cliente.dart';
import 'package:InkTrack/features/clientes/presentation/viewmodels/clientes_viewmodel.dart';
import 'package:InkTrack/features/movimientos/presentation/viewmodels/movimientos_viewmodel.dart';
import 'package:InkTrack/features/inventario/presentation/viewmodels/inventario_viewmodel.dart';
import 'package:InkTrack/features/inventario/presentation/pages/barcode_scanner_page.dart';
import 'package:InkTrack/features/locales/presentation/viewmodels/locales_viewmodel.dart';
import 'package:InkTrack/core/input_formatters.dart';
import 'package:InkTrack/core/theme/app_theme.dart';
import 'package:InkTrack/core/utils/number_formatter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:bcrypt/bcrypt.dart';
import 'package:InkTrack/core/data/local/database.dart';
import 'package:InkTrack/features/clientes/presentation/widgets/credit_limit_dialog.dart';


class RegistrarVentaPage extends StatefulWidget {
  const RegistrarVentaPage({super.key});

  @override
  State<RegistrarVentaPage> createState() => _RegistrarVentaPageState();
}

class _RegistrarVentaPageState extends State<RegistrarVentaPage> {
  final _formKey = GlobalKey<FormState>();
  final _montoController = TextEditingController();
  final _clienteNombreController = TextEditingController();
  final _conceptoController = TextEditingController();
  String? _clienteId;
  bool _esFiado = false;
  String? _managerIdForOverride;
  final List<_VentaItemState> _productos = [];

  static const String _kWriteNameValue = '__write_name__';

  @override
  void dispose() {
    _montoController.dispose();
    _clienteNombreController.dispose();
    _conceptoController.dispose();
    super.dispose();
  }

  double get _montoTotal => _productos.fold(0.0, (sum, p) => sum + p.subtotal);

  void _actualizarMonto() {
    _montoController.text = NumberFormatter.formatCurrency(
      _montoTotal,
    ).replaceAll('\$', '');
  }

  Future<void> _agregarProducto() async {
    final result = await showModalBottomSheet<_VentaItemState>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => const _AgregarProductoSheet(),
    );

    if (result != null) {
      setState(() {
        final existingIndex = _productos.indexWhere(
          (p) => p.productoId == result.productoId,
        );
        if (existingIndex != -1) {
          _productos[existingIndex].cantidad += result.cantidad;
          _productos[existingIndex].precioUnitario = result.precioUnitario;
        } else {
          _productos.add(result);
        }
        _actualizarMonto();
      });
    }
  }

  Future<void> _escanearProducto() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BarcodeScannerPage(
          mode: BarcodeScannerMode.burst,
          onBurstScan: (producto, {weightKg, embeddedPrice}) {
            if (!mounted) return;
            setState(() {
              final existingIndex = _productos.indexWhere(
                (p) => p.productoId == producto.id && !p.isUnidad,
              );
              if (existingIndex != -1) {
                _productos[existingIndex].cantidad += 1;
              } else {
                double precio = producto.precioVenta;
                int cantidad = 1;
                if (weightKg != null && producto.unidad == 'kg') {
                  precio = producto.precioVenta * weightKg;
                } else if (embeddedPrice != null) {
                  precio = embeddedPrice;
                }
                _productos.add(
                  _VentaItemState(
                    productoId: producto.id,
                    nombre: producto.nombre,
                    cantidad: cantidad,
                    precioUnitario: precio,
                  ),
                );
              }
              _actualizarMonto();
            });
          },
        ),
      ),
    );
  }

  void _executeSave(double monto, String? clienteNombre, String? productosJson, String? auditString) {
    final localesVM = context.read<LocalesViewModel>();
    final localIdSeleccionado = localesVM.localIdSeleccionado;
    final l10n = AppLocalizations.of(context)!;
    final inventarioVM = context.read<InventarioViewModel>();

    String finalConcepto = _conceptoController.text.trim();
    if (auditString != null) {
      finalConcepto = finalConcepto.isEmpty ? auditString : "$finalConcepto $auditString";
    }

    final venta = Venta(
      id: '',
      monto: monto,
      fecha: DateTime.now(),
      clienteId: _clienteId == _kWriteNameValue ? null : _clienteId,
      esFiado: _esFiado,
      clienteNombre: clienteNombre,
      concepto: finalConcepto,
      productosJson: productosJson,
      localId: localIdSeleccionado,
    );

    context.read<VentasViewModel>().guardar(
      venta,
      movimientosVM: context.read<MovimientosViewModel>(),
      clientesVM: context.read<ClientesViewModel>(),
      inventarioVM: inventarioVM,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.ventaRegistradaExitoMsg),
        backgroundColor: AppTheme.successColor,
      ),
    );
    Navigator.pop(context);
  }

  void _guardarVenta() {
    if (!_formKey.currentState!.validate()) return;

    final monto = NumberFormatter.parseAmount(_montoController.text);
    String? clienteNombre;
    if (_clienteId == _kWriteNameValue) {
      clienteNombre = _clienteNombreController.text.trim();
      if (clienteNombre.isEmpty) {
        return;
      }
    }

    final inventarioVM = context.read<InventarioViewModel>();
    final l10n = AppLocalizations.of(context)!;
    for (final prod in _productos) {
      final product = inventarioVM.getById(prod.productoId);
      if (product != null && !product.isActivo) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.productoInactivo(product.nombre)),
            backgroundColor: AppTheme.errorColor,
          ),
        );
        return;
      }
      if (product != null && product.cantidad < prod.cantidad) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              l10n.noHaySuficienteStock(product.nombre, product.cantidad),
            ),
            backgroundColor: AppTheme.errorColor,
          ),
        );
        return;
      }
    }

    final productosJson = _productos.isEmpty
        ? null
        : jsonEncode(
            _productos
                .map(
                  (p) => {
                    'productoId': p.productoId,
                    'nombre': p.nombre,
                    'cantidad': p.cantidad,
                    'precioUnitario': p.precioUnitario,
                    'isUnidad': p.isUnidad,
                  },
                )
                .toList(),
          );

    final clientesVM = context.read<ClientesViewModel>();
    final clienteIdVal = _clienteId == _kWriteNameValue ? null : _clienteId;

    if (_esFiado && clienteIdVal != null) {
      final cliente = clientesVM.getById(clienteIdVal);
      if (cliente != null && cliente.limiteCredito != null) {
        if (cliente.saldoPendiente + monto > cliente.limiteCredito!) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (dialogCtx) => CreditLimitDialog(
              actual: cliente.saldoPendiente,
              nuevo: monto,
              limite: cliente.limiteCredito!,
              onVerifyPin: (pin) async {
                final db = context.read<AppDatabase>();
                final users = await db.select(db.localUsers).get();
                for (final user in users) {
                  if (user.rol == 'gerente' && user.pinHash != null) {
                    try {
                      if (BCrypt.checkpw(pin, user.pinHash!)) {
                        _managerIdForOverride = user.id;
                        return true;
                      }
                    } catch (_) {}
                  }
                }
                return false;
              },
              onOverrideSuccess: () {
                final auditString = "OVERRIDE_LIMIT gerenteId=$_managerIdForOverride ts=${DateTime.now().millisecondsSinceEpoch} monto=$monto limite=${cliente.limiteCredito} saldoPrevio=${cliente.saldoPendiente}";
                _executeSave(monto, clienteNombre, productosJson, auditString);
              },
            ),
          );
          return;
        }
      }
    }

    _executeSave(monto, clienteNombre, productosJson, null);
  }


  Future<void> _pickAndScanImage(ImageSource source) async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: source);
    if (image == null) return;

    final viewModel = context.read<VentasViewModel>();
    final result = await viewModel.procesarImagenOCR(image);

    if (result != null) {
      bool foundSomething = false;

      if (result.amount != null) {
        _montoController.text = NumberFormatter.formatCurrency(
          result.amount!,
        ).replaceAll('\$', '');
        foundSomething = true;
      }

      if (result.clientName != null) {
        final clientName = result.clientName!;
        final clientesVM = context.read<ClientesViewModel>();
        final match = clientesVM.clientes.firstWhere(
          (c) =>
              c.nombre.toLowerCase().contains(clientName.toLowerCase()) ||
              clientName.toLowerCase().contains(c.nombre.toLowerCase()),
          orElse: () => Cliente(id: '', nombre: '', telefono: '', email: ''),
        );

        setState(() {
          if (match.id.isNotEmpty) {
            _clienteId = match.id;
            _clienteNombreController.clear();
          } else {
            _clienteId = _kWriteNameValue;
            _clienteNombreController.text = clientName;
          }
        });
        foundSomething = true;
      }

      if (foundSomething) {
        final l10n = AppLocalizations.of(context)!;
        String message = l10n.datosDetectados;
        if (result.amount != null) {
          message +=
              '\n- ${l10n.monto}: ${NumberFormatter.formatCurrency(result.amount!)}';
        }
        if (result.clientName != null) {
          message += '\n- ${l10n.cliente}: ${result.clientName}';
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: AppTheme.primaryColor,
          ),
        );
      } else {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.noSeDetectaronDatos),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    }
  }

  void _showScanMenu() {
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              l10n.escanearNotaRecibo,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: _ScanOption(
                    icon: Icons.camera_alt_rounded,
                    label: l10n.camara,
                    onTap: () {
                      Navigator.pop(ctx);
                      _pickAndScanImage(ImageSource.camera);
                    },
                  ),
                ),
                Expanded(
                  child: _ScanOption(
                    icon: Icons.photo_library_rounded,
                    label: l10n.galeria,
                    onTap: () {
                      Navigator.pop(ctx);
                      _pickAndScanImage(ImageSource.gallery);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final currencyFormat = NumberFormat.currency(
      symbol: '\$',
      decimalDigits: 2,
    );

    return Scaffold(
      appBar: AppBar(title: Text(l10n.registrarVenta)),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(24.0),
          children: [
            Text(l10n.concepto, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            TextFormField(
              controller: _conceptoController,
              decoration: InputDecoration(
                labelText: l10n.concepto,
                hintText: 'Ej. Tatuaje ',
              ),
              textCapitalization: TextCapitalization.sentences,
              inputFormatters: [InputFormatters.textOnly],
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return l10n.ingreseConceptoVenta;
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    l10n.montoTotal,
                    style: Theme.of(context).textTheme.titleMedium,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Consumer<VentasViewModel>(
                  builder: (context, vm, _) {
                    if (vm.isScanning) {
                      return const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      );
                    }
                    return TextButton.icon(
                      onPressed: _showScanMenu,
                      icon: const Icon(
                        Icons.document_scanner_rounded,
                        size: 18,
                      ),
                      label: Text(l10n.escanear),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _montoController,
              decoration: InputDecoration(
                labelText: l10n.monto,
                prefixText: '\$ ',
                hintText: '0.00',
              ),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              inputFormatters: [InputFormatters.decimal],
              textInputAction: TextInputAction.next,
              onChanged: (_) => setState(() {}),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return l10n.ingreseMontoVenta;
                }
                final number = NumberFormatter.parseAmount(value);
                if (number <= 0) {
                  return l10n.montoMayorCero;
                }
                if (number > 999999999) {
                  return l10n.maximoMonto;
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            Text(
              l10n.clienteOpcional2,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            Consumer<ClientesViewModel>(
              builder: (context, clientesViewModel, child) {
                final items = <DropdownMenuItem<String>>[
                  DropdownMenuItem(
                    value: null,
                    child: Text(l10n.sinClienteVentaGeneral),
                  ),
                  ...clientesViewModel.clientes.map((cliente) {
                    return DropdownMenuItem(
                      value: cliente.id,
                      child: Text(cliente.nombre),
                    );
                  }),
                  DropdownMenuItem(
                    value: _kWriteNameValue,
                    child: Text(l10n.escribirNombreCliente),
                  ),
                ];
                return DropdownButtonFormField<String>(
                  initialValue: _clienteId,
                  decoration: InputDecoration(labelText: l10n.cliente),
                  items: items,
                  onChanged: (value) {
                    setState(() {
                      _clienteId = value;
                      if (value != _kWriteNameValue) {
                        _clienteNombreController.clear();
                      }
                    });
                  },
                );
              },
            ),
            if (_clienteId == _kWriteNameValue) ...[
              const SizedBox(height: 16),
              TextFormField(
                controller: _clienteNombreController,
                decoration: InputDecoration(
                  labelText: l10n.nombre,
                  hintText: l10n.ejemploNombre,
                ),
                textCapitalization: TextCapitalization.words,
                inputFormatters: [InputFormatters.textOnly],
                validator: (value) {
                  if (_clienteId == _kWriteNameValue &&
                      (value == null || value.trim().isEmpty)) {
                    return l10n.ingreseNombreCliente;
                  }
                  return null;
                },
              ),
            ],
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.productos,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Row(
                  children: [
                    TextButton.icon(
                      onPressed: _escanearProducto,
                      icon: const Icon(Icons.qr_code_scanner, size: 18),
                      label: Text(l10n.escanear),
                    ),
                    TextButton.icon(
                      onPressed: _agregarProducto,
                      icon: const Icon(Icons.add, size: 18),
                      label: Text(l10n.agregar),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (_productos.isEmpty)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    children: [
                      Icon(
                        Icons.inventory_2_outlined,
                        size: 48,
                        color: AppTheme.textSecondary.withValues(alpha: 0.5),
                      ),
                      const SizedBox(height: 8),
                      Text(l10n.noHayProductos),
                      const SizedBox(height: 4),
                      Text(
                        l10n.escaneeOAgregueProductos,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              )
            else
              ...List.generate(_productos.length, (index) {
                final producto = _productos[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    title: Text(producto.nombre),
                    subtitle: Text(
                      '${producto.cantidad} x ${currencyFormat.format(producto.precioUnitario)}',
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          currencyFormat.format(producto.subtotal),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              _productos.removeAt(index);
                              _actualizarMonto();
                            });
                          },
                          icon: const Icon(
                            Icons.delete_outline,
                            color: AppTheme.errorColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            const SizedBox(height: 24),
            if (_clienteId != null) ...[
              SwitchListTile(
                title: Text(l10n.ventaCreditoFiado),
                subtitle: Text(l10n.aumentaraSaldoPendiente),
                value: _esFiado,
                onChanged: (value) {
                  setState(() => _esFiado = value);
                },
              ),
            ],
            const SizedBox(height: 32),
            if (_productos.isNotEmpty)
              Card(
                color: AppTheme.primaryColor.withValues(alpha: 0.1),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        l10n.totalProductos,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        currencyFormat.format(_montoTotal),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 16),
            SizedBox(
              height: 52,
              child: ElevatedButton(
                onPressed: _guardarVenta,
                child: Text(l10n.guardarVenta),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _VentaItemState {
  final String productoId;
  final String nombre;
  int cantidad;
  double precioUnitario;
  bool isUnidad;

  _VentaItemState({
    required this.productoId,
    required this.nombre,
    required this.cantidad,
    required this.precioUnitario,
    this.isUnidad = false,
  });

  double get subtotal => cantidad * precioUnitario;
}

class _AgregarProductoSheet extends StatefulWidget {
  const _AgregarProductoSheet();

  @override
  State<_AgregarProductoSheet> createState() => _AgregarProductoSheetState();
}

class _AgregarProductoSheetState extends State<_AgregarProductoSheet> {
  final _busquedaController = TextEditingController();
  String? _productoSeleccionadoId;
  String? _productoSeleccionadoNombre;
  double _precioUnitario = 0;
  bool _isUnidad = false;
  int _unidadesPorPaquete = 1;
  bool _esPaquete = false;
  final _cantidadController = TextEditingController(text: '1');
  final _precioController = TextEditingController();

  @override
  void dispose() {
    _busquedaController.dispose();
    _cantidadController.dispose();
    _precioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      maxChildSize: 0.9,
      minChildSize: 0.5,
      expand: false,
      builder: (context, scrollController) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    l10n.agregarProductoTitle,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _busquedaController,
              decoration: InputDecoration(
                labelText: l10n.buscarProductoPlaceholder,
                prefixIcon: const Icon(Icons.search),
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 16),
            if (_productoSeleccionadoId == null)
              Expanded(
                child: Consumer<InventarioViewModel>(
                  builder: (context, invm, child) {
                    var productos = invm.productos;
                    final busqueda = _busquedaController.text
                        .trim()
                        .toLowerCase();
                    if (busqueda.isNotEmpty) {
                      productos = productos
                          .where(
                            (p) =>
                                p.nombre.toLowerCase().contains(busqueda) ||
                                p.categoria.toLowerCase().contains(busqueda),
                          )
                          .toList();
                    }
                    return ListView.builder(
                      controller: scrollController,
                      itemCount: productos.length,
                      itemBuilder: (context, index) {
                        final producto = productos[index];
                        return ListTile(
                          title: Text(producto.nombre),
                          subtitle: Text(
                            l10n.stockLabel(producto.cantidad.toInt()) +
                                ' • \$${producto.precioVenta.toStringAsFixed(2)}',
                          ),
                          onTap: () {
                            setState(() {
                              _productoSeleccionadoId = producto.id;
                              _productoSeleccionadoNombre = producto.nombre;
                              _precioUnitario = producto.precioVenta;
                              _esPaquete = producto.esPaquete;
                              _unidadesPorPaquete = producto.unidadesPorPaquete;
                              _isUnidad = false;
                              _precioController.text = producto.precioVenta
                                  .toString();
                            });
                          },
                        );
                      },
                    );
                  },
                ),
              )
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    child: ListTile(
                      title: Text(_productoSeleccionadoNombre!),
                      trailing: IconButton(
                        onPressed: () {
                          setState(() {
                            _productoSeleccionadoId = null;
                            _productoSeleccionadoNombre = null;
                          });
                        },
                        icon: const Icon(Icons.edit),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (_esPaquete) ...[
                    SwitchListTile(
                      title: const Text('Vender por Unidad'),
                      subtitle: Text('Contenido: $_unidadesPorPaquete unidades'),
                      value: _isUnidad,
                      onChanged: (value) {
                        setState(() {
                          _isUnidad = value;
                          if (value) {
                            // Suggest unit price (divided by package units)
                            _precioUnitario = _precioUnitario / _unidadesPorPaquete;
                            _precioController.text = _precioUnitario.toStringAsFixed(0);
                          } else {
                            // Restore package price
                            // Note: This is a simple heuristic, ideally we'd re-fetch the product
                            final invVM = context.read<InventarioViewModel>();
                            final prod = invVM.getById(_productoSeleccionadoId!);
                            if (prod != null) {
                              _precioUnitario = prod.precioVenta;
                              _precioController.text = prod.precioVenta.toString();
                            }
                          }
                        });
                      },
                    ),
                    const SizedBox(height: 8),
                  ],
                  TextField(
                    controller: _cantidadController,
                    decoration: InputDecoration(
                      labelText: _isUnidad ? 'Cantidad (Unidades)' : l10n.cantidad,
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _precioController,
                    decoration: InputDecoration(
                      labelText: _isUnidad ? 'Precio por Unidad' : l10n.precioUnitario,
                      prefixText: '\$ ',
                    ),
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    onChanged: (value) {
                      _precioUnitario = double.tryParse(value) ?? 0;
                    },
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        final cantidad =
                            int.tryParse(_cantidadController.text) ?? 0;
                        if (_productoSeleccionadoId != null &&
                            cantidad > 0 &&
                            _precioUnitario > 0) {
                          Navigator.pop(
                            context,
                            _VentaItemState(
                              productoId: _productoSeleccionadoId!,
                              nombre: _productoSeleccionadoNombre! + (_isUnidad ? ' (Unidad)' : ''),
                              cantidad: cantidad,
                              precioUnitario: _precioUnitario,
                              isUnidad: _isUnidad,
                            ),
                          );
                        }
                      },
                      child: Text(l10n.agregar),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class _ScanOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ScanOption({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(icon, size: 40, color: AppTheme.primaryColor),
            const SizedBox(height: 8),
            Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}
