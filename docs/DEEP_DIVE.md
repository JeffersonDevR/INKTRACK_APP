# InkTrack: Masterclass de Arquitectura Flutter (Senior Dev Edition)

Bienvenido al "Deep Dive" definitivo. Como Senior Dev, mi objetivo es que no solo entiendas el *qué*, sino que domines el *cómo* y el *porqué* a través de ejemplos reales de tu código. 

---

### 1. Modelos Inmutables: El Corazón del Estado
En Flutter, el estado debe ser predecible. Por eso usamos **inmutabilidad**.

#### Ejemplo: `Cliente`
```dart
class Cliente implements HasId {
  final String id;
  final String nombre;
  // ... todos los campos son final
  
  // El "truco" senior: copyWith
  Cliente copyWith({String? nombre, double? saldoPendiente, ...}) {
    return Cliente(
      id: id, // El ID nunca cambia
      nombre: nombre ?? this.nombre,
      saldoPendiente: saldoPendiente ?? this.saldoPendiente,
      // ...
    );
  }
}
```
**Lección**: Nunca modifiques una variable directamente (ej: `cliente.nombre = 'Juan'`). Siempre crea una copia. Esto garantiza que la UI sepa exactamente cuándo hubo un cambio para repintarse.

---

### 2. Repositorios: Aislando la Base de Datos
No queremos que nuestra UI sepa que usamos SQLite. Usamos el **Repository Pattern**.

#### Ejemplo: `DriftClientesRepository`
```dart
class DriftClientesRepository implements ClientesRepository {
  // Conversión de Fila de BD a Objeto de Negocio
  Cliente _toModel(ClienteData data) {
    return Cliente(
      id: data.id,
      nombre: data.nombre,
      saldoPendiente: data.saldoPendiente,
      // ...
    );
  }

  @override
  Future<void> save(Cliente item) async {
    await _db.into(_db.clientes).insert(
      ClientesCompanion.insert(
        id: item.id,
        nombre: item.nombre,
        syncStatus: const Value('pending_upload'), // Marcado para la nube
      ),
    );
  }
}
```
**Lección**: El repositorio es un "traductor". Convierte los datos crudos de la base de datos (`ClienteData`) en algo que el resto de la app entienda (`Cliente`).

---

### 3. ViewModels: La Orquesta del Estado
El ViewModel es donde vive la lógica. **Nunca pongas lógica en los Widgets.**

#### Ejemplo: `ClientesViewModel`
```dart
Future<void> actualizarSaldo(String id, double delta) async {
  final c = getById(id);
  if (c != null) {
    // 1. Calculamos el nuevo estado de forma inmutable
    final actualizado = c.copyWith(saldoPendiente: c.saldoPendiente + delta);

    // 2. Persistimos en la base de datos
    await _repository.update(id, actualizado);

    // 3. Actualizamos la memoria y notificamos a la UI
    update(id, actualizado); // Esto llama internamente a notifyListeners()
  }
}
```
**Lección**: El ViewModel sigue un flujo 1-2-3: Calcula -> Persiste -> Notifica. Esto mantiene la app sincronizada y rápida.

---

### 4. La UI: Consumo Granular de Datos
Usamos `Consumer` para reaccionar a los cambios de forma eficiente.

#### Ejemplo: `ClientesPage`
```dart
body: Consumer<ClientesViewModel>(
  builder: (context, viewModel, child) {
    if (viewModel.clientes.isEmpty) return _EmptyClientes();
    
    return CustomScrollView(
      slivers: [
        // Uso de Slivers para rendimiento máximo en listas largas
        SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            final cliente = viewModel.clientes[index];
            return ClienteCard(cliente: cliente);
          }, childCount: viewModel.clientes.length),
        ),
      ],
    );
  },
),
```
**Lección**: El `Consumer` actúa como una antena. Solo se activa cuando el `ClientesViewModel` grita `notifyListeners()`. Usar `CustomScrollView` asegura que la lista sea fluida incluso con cientos de clientes.

---

### 5. Sincronización Offline-First vía REST
Esta es la parte más avanzada del proyecto. No usamos el SDK para sincronizar porque queremos control total sobre el tráfico de red.

#### Ejemplo: `SupabaseSyncService`
```dart
final response = await http.post(
  Uri.parse('$_supabaseUrl/rest/v1/clientes'),
  headers: {
    'apikey': _supabaseKey,
    'Prefer': 'resolution=merge-duplicates', // ¡Clave para evitar errores!
  },
  body: jsonEncode(data),
);

if (response.statusCode == 201) {
  // Solo marcamos como sincronizado si el servidor respondió OK
  await _db.update(_db.clientes)...write(const ClientesCompanion(syncStatus: Value('synced')));
}
```
**Lección**: Al usar REST, podemos enviar el header `Prefer: resolution=merge-duplicates`, lo que hace que Supabase ignore los duplicados y actualice los registros existentes. Es una técnica senior para manejar la "eventual consistency" en apps offline.

---

### Bonus: ¿Por qué generamos IDs en el cliente?
```dart
id: IdUtils.generateTimestampId(),
```
Si esperas a que la nube te dé un ID, tu app se "rompe" sin internet. Al generarlo localmente (usando de base el tiempo y aleatoriedad), puedes crear, vender y cobrar sin conexión, y la base de datos simplemente se sincronizará cuando vuelvas a estar online.
