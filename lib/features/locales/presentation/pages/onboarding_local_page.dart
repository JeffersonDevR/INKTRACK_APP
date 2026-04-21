import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:InkTrack/features/locales/presentation/viewmodels/locales_viewmodel.dart';
import 'package:InkTrack/features/locales/data/models/local.dart';
import 'package:InkTrack/core/theme/app_theme.dart';
import 'package:InkTrack/core/utils/id_utils.dart';
import 'package:InkTrack/core/services/auth_service.dart';
import 'package:InkTrack/features/inventario/presentation/viewmodels/inventario_viewmodel.dart';
import 'package:InkTrack/features/clientes/presentation/viewmodels/clientes_viewmodel.dart';
import 'package:InkTrack/features/proveedores/presentation/viewmodels/proveedores_viewmodel.dart';
import 'package:InkTrack/features/inventario/data/repositories/drift_productos_repository.dart';
import 'package:InkTrack/features/clientes/data/repositories/drift_clientes_repository.dart';
import 'package:InkTrack/features/proveedores/data/repositories/drift_proveedores_repository.dart';
import 'package:InkTrack/core/data/local/database.dart';

class OnboardingLocalPage extends StatefulWidget {
  final String userId;
  final AuthService authService;

  const OnboardingLocalPage({
    super.key,
    required this.userId,
    required this.authService,
  });

  @override
  State<OnboardingLocalPage> createState() => _OnboardingLocalPageState();
}

class _OnboardingLocalPageState extends State<OnboardingLocalPage> {
  final _nombreController = TextEditingController();
  final _direccionController = TextEditingController();
  final _telefonoController = TextEditingController();
  String _tipo = 'tienda';
  bool _isLoading = false;

  @override
  void dispose() {
    _nombreController.dispose();
    _direccionController.dispose();
    _telefonoController.dispose();
    super.dispose();
  }

  Future<void> _crearLocal() async {
    if (_nombreController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('El nombre es obligatorio')));
      return;
    }

    setState(() => _isLoading = true);

    try {
      final viewModel = context.read<LocalesViewModel>();

      final nuevoLocal = Local(
        id: IdUtils.generateTimestampId(),
        nombre: _nombreController.text.trim(),
        direccion: _direccionController.text.trim().isEmpty
            ? null
            : _direccionController.text.trim(),
        telefono: _telefonoController.text.trim().isEmpty
            ? null
            : _telefonoController.text.trim(),
        tipo: _tipo,
        userId: widget.userId,
        isActivo: true,
      );

      await viewModel.guardar(nuevoLocal);
      viewModel.seleccionarLocal(nuevoLocal.id);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Sincronizando local...'),
          duration: Duration(seconds: 1),
        ),
      );

      final syncSuccess = await _syncLocalToSupabase(nuevoLocal);
      if (syncSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Local sincronizado correctamente'),
            backgroundColor: Colors.green,
          ),
        );
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Local guardado pero error al sincronizar. Podrás usarlo localmente.',
            ),
          ),
        );
      }

      await _autoMigrateData(nuevoLocal.id);

      Navigator.of(context).pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error al crear local: $e')));
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _autoMigrateData(String localId) async {
    final invVM = context.read<InventarioViewModel>();
    final cliVM = context.read<ClientesViewModel>();
    final provVM = context.read<ProveedoresViewModel>();

    final db = context.read<AppDatabase>();
    final productosRepo = DriftProductosRepository(db);
    final clientesRepo = DriftClientesRepository(db);
    final proveedoresRepo = DriftProveedoresRepository(db);

    final productosSinLocal = invVM.items
        .where((p) => p.localId == null)
        .toList();
    final clientesSinLocal = cliVM.items
        .where((c) => c.localId == null)
        .toList();
    final proveedoresSinLocal = provVM.items
        .where((p) => p.localId == null)
        .toList();

    if (productosSinLocal.isEmpty &&
        clientesSinLocal.isEmpty &&
        proveedoresSinLocal.isEmpty) {
      return;
    }

    for (final p in productosSinLocal) {
      final actualizado = p.copyWith(localId: localId);
      await productosRepo.update(p.id, actualizado);
      invVM.update(p.id, actualizado);
    }

    for (final c in clientesSinLocal) {
      final actualizado = c.copyWith(localId: localId);
      await clientesRepo.update(c.id, actualizado);
      cliVM.update(c.id, actualizado);
    }

    for (final p in proveedoresSinLocal) {
      final actualizado = p.copyWith(localId: localId);
      await proveedoresRepo.update(p.id, actualizado);
      provVM.update(p.id, actualizado);
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Se migraron ${productosSinLocal.length} productos, '
            '${clientesSinLocal.length} clientes, '
            '${proveedoresSinLocal.length} proveedores',
          ),
        ),
      );
    }
  }

  Future<bool> _syncLocalToSupabase(Local local) async {
    try {
      final supabase = Supabase.instance.client;
      await supabase.from('locales').insert({
        'id': local.id,
        'nombre': local.nombre,
        'direccion': local.direccion,
        'telefono': local.telefono,
        'tipo': local.tipo,
        'user_id': local.userId,
        'is_activo': local.isActivo,
      });
      return true;
    } catch (e) {
      debugPrint('Error syncing local to Supabase: $e');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),
              Icon(Icons.store_rounded, size: 80, color: AppTheme.primaryColor),
              const SizedBox(height: 24),
              Text(
                'Bienvenido a InkTrack',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Crea tu primer local para comenzar',
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(color: AppTheme.textSecondary),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              TextField(
                controller: _nombreController,
                decoration: const InputDecoration(
                  labelText: 'Nombre del local',
                  hintText: 'Ej. Tienda Principal',
                  prefixIcon: Icon(Icons.storefront_rounded),
                ),
                textCapitalization: TextCapitalization.words,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _direccionController,
                decoration: const InputDecoration(
                  labelText: 'Dirección (opcional)',
                  hintText: 'Ej. Calle 123 #45-67',
                  prefixIcon: Icon(Icons.location_on_outlined),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _telefonoController,
                decoration: const InputDecoration(
                  labelText: 'Teléfono (opcional)',
                  prefixIcon: Icon(Icons.phone_outlined),
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _tipo,
                decoration: const InputDecoration(
                  labelText: 'Tipo de local',
                  prefixIcon: Icon(Icons.category_outlined),
                ),
                items: const [
                  DropdownMenuItem(value: 'tienda', child: Text('Tienda')),
                  DropdownMenuItem(value: 'bodega', child: Text('Bodega')),
                  DropdownMenuItem(value: 'oficina', child: Text('Oficina')),
                ],
                onChanged: (value) {
                  setState(() => _tipo = value ?? 'tienda');
                },
              ),
              const SizedBox(height: 40),
              FilledButton(
                onPressed: _isLoading ? null : _crearLocal,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text('Crear local'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
