import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:InkTrack/core/data/local/database.dart';
import 'package:InkTrack/core/services/analytics_service.dart';
import 'package:InkTrack/core/theme/app_theme.dart';
import 'package:InkTrack/features/categorias/data/repositories/categorias_repository.dart';

class CategoryEditorDialog extends StatefulWidget {
  final String title;
  final String tipo;

  const CategoryEditorDialog({
    super.key,
    required this.title,
    required this.tipo,
  });

  @override
  State<CategoryEditorDialog> createState() => _CategoryEditorDialogState();
}

class _CategoryEditorDialogState extends State<CategoryEditorDialog> {
  final _controller = TextEditingController();
  bool _isLoading = true;
  List<CategoriaData> _categories = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final repo = context.read<CategoriasRepository>();
    final cats = await repo.getAll(widget.tipo);
    if (!mounted) return;
    setState(() {
      _categories = cats;
      _isLoading = false;
    });
  }

  Future<void> _add() async {
    final nombre = _controller.text.trim();
    if (nombre.isEmpty) return;

    final repo = context.read<CategoriasRepository>();
    if (await repo.exists(nombre, widget.tipo)) return;

    await repo.save(nombre, widget.tipo);
    AnalyticsService.instance.track('category_added', properties: {
      'tipo': widget.tipo,
      'nombre': nombre,
    });
    _controller.clear();
    await _load();
  }

  Future<void> _delete(CategoriaData cat) async {
    final repo = context.read<CategoriasRepository>();
    await repo.delete(cat.id);
    AnalyticsService.instance.track('category_deleted', properties: {
      'tipo': widget.tipo,
      'nombre': cat.nombre,
    });
    await _load();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: SizedBox(
        width: double.maxFinite,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          decoration: const InputDecoration(
                            hintText: 'Nueva categoría...',
                            isDense: true,
                          ),
                          onSubmitted: (_) => _add(),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        onPressed: _add,
                        icon: const Icon(Icons.add_circle,
                            color: AppTheme.primaryColor),
                      ),
                    ],
                  ),
                  const Divider(),
                  if (_categories.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(16),
                      child: Text('Sin categorías aún'),
                    )
                  else
                    Flexible(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: _categories.length,
                        itemBuilder: (context, index) {
                          final cat = _categories[index];
                          return ListTile(
                            dense: true,
                            title: Text(cat.nombre),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete_outline,
                                  color: AppTheme.errorColor),
                              onPressed: () => _delete(cat),
                            ),
                          );
                        },
                      ),
                    ),
                ],
              ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cerrar'),
        ),
      ],
    );
  }
}
