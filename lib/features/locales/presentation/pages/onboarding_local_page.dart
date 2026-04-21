import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:InkTrack/features/locales/presentation/viewmodels/locales_viewmodel.dart';
import 'package:InkTrack/features/locales/data/models/local.dart';
import 'package:InkTrack/core/theme/app_theme.dart';
import 'package:InkTrack/core/utils/id_utils.dart';
import 'package:InkTrack/core/services/auth_service.dart';

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
