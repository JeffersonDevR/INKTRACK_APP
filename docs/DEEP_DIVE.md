# InkTrack: Deep-Dive Developer Implementation Guide 🖋️🚀

> **Para quién es esta guía:** Está escrito para desarrolladores que conocen **POO en Java** pero nunca han trabajado con **Flutter** o **Dart**. Acá vamos a explicar CADA concepto desde cero, con analogías y ejemplos prácticos.

---

# PRIMERA PARTE: FUNDAMENTOS 🧱

Antes de meternos con la arquitectura del proyecto, necesitamos entender las bases de Flutter. Si alguna vez usaste Android con Kotlin o Java, este enfoque te va a sorprender.

## 1.1 ¿Qué es Flutter y por qué es diferente?

En Java/Android, vos construís interfaces usando:
- **XML** para el layout
- **Activities/Fragments** para la lógica
- **ViewBinding** para conectar todo

En Flutter, TODO es **Dart**. No hay XML, no hay archivos de layout separados. Todo está en un solo lenguaje.

**La diferencia clave:**
- **Android:** Vos decís "quiero un Button XML y un TextView XML y los conecto con este Activity"
- **Flutter:** Vos decís "quiero un Widget que ES un Button" y listo

```dart
// Esto es TODO lo que necesitás para un botón en Flutter
ElevatedButton(
  onPressed: () => print("Me presionaron!"),
  child: Text("Click me"),
)
```

¿Ves? No hay XML, no hay archivos separados. Todo está junto.

## 1.2 ¿Qué demonios es un Widget?

Esta es la pregunta más importante de Flutter. Un **Widget** es la unidad básica de todo en Flutter. Es como un "componente" en React o un "View" en Android, pero con superpoderes.

**La analogía con Java:**
En Android, tenés `TextView`, `Button`, `LinearLayout`, etc. Cada uno hace UNA cosa.

En Flutter, un `Text` es un widget, un `ElevatedButton` es un widget, un `Container` (como un div) es un widget, y hasta la pantalla entera (`Scaffold`) es un widget.

**Pensá un Widget como una "caja" que puede:**
1. Mostrar algo (texto, imagen, icono)
2. Contener otros widgets (agruparlos)
3. Responder a interacciones (tap, swipe)
4. Tener estado (cambiar su apariencia)

**Ejemplo visual de la jerarquía:**

```
Scaffold (La pantalla completa)
├── AppBar (La barra de arriba)
│   └── Text ("InkTrack Proto")
├── Body (El contenido principal)
│   └── Column (Una columna vertical)
│       ├── Text ("Bienvenido")
│       ├── SizedBox (Espacio vacío)
│       └── ElevatedButton (Un botón)
└── FloatingActionButton (Botón flotante)
```

## 1.3 La diferencia entre STATELESS y STATEFUL

Esta es otra distinción clave. En Java, si querés un TextView que cambie, necesitás referencias y setters. En Flutter, hay dos tipos de widgets:

### StatelessWidget (Sin estado)
Son widgets que **nunca cambian**. Su contenido se define una vez y ya.

```dart
class MiBoton extends StatelessWidget {
  final String texto;
  
  const MiBoton({super.key, required this.texto});
  
  @override
  Widget build(BuildContext context) {
    // Este botón siempre se ve igual
    return ElevatedButton(
      onPressed: () {},
      child: Text(texto),
    );
  }
}
```

### StatefulWidget (Con estado)
Son widgets que **pueden cambiar**. Si el usuario interactúa o los datos cambian, el widget se "redibuja".

```dart
class Contador extends StatefulWidget {
  const Contador({super.key});
  
  @override
  State<Contador> createState() => _ContadorState();
}

class _ContadorState extends State<Contador> {
  int _contador = 0;  // Este valor puede cambiar
  
  void _incrementar() {
    setState(() {  // Esto le dice a Flutter: "¡Redibujame!"
      _contador++;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("Count: $_contador"),
        ElevatedButton(
          onPressed: _incrementar,
          child: Text("Sumar"),
        ),
      ],
    );
  }
}
```

**La diferencia clave:**
- `StatelessWidget`: `build()` se llama UNA vez
- `StatefulWidget`: `build()` se llama CADA vez que `setState()` se ejecuta

## 1.4 ¿Qué es Dart?

Dart es el lenguaje de Flutter. Si sabés Java, Dart te va a parecer muy familiar. Acá están las diferencias principales:

### Variables
```dart
// Java
String nombre = "Juan";
int edad = 25;
final String APELLIDO = "Perez";  // final en Java es const/final en Dart

// Dart
String nombre = "Juan";
int edad = 25;
const String APELLIDO = "Perez";  // const es inmutable en compile time
final String nombre2 = "Juan";      // final es inmutable en runtime
```

### Null Safety (MUY IMPORTANTE)
En Dart, por defecto, las variables **no pueden ser null**. Esto es diferente de Java.

```dart
// Java
String nombre = null;  // Perfecto

// Dart
String? nombre = null;  // Necesitás el ? para permitir null
String nombre = "Juan"; // No puede ser null (String normal)
```

### Funciones flecha (Arrow functions)
Igual que en Java 8+:
```dart
int sumar(int a, int b) => a + b;

// Equivalente a:
int sumar(int a, int b) {
  return a + b;
}
```

### Constructores con nombre
```dart
class Persona {
  String nombre;
  int edad;
  
  // Constructor simple
  Persona(this.nombre, this.edad);
  
  // Constructor con nombre
  Persona.jubilado(this.nombre) : edad = 65;
}

// Uso
var juan = Persona("Juan", 30);
var maria = Persona.jubilado("Maria");  // edad = 65
```

---

# SEGUNDA PARTE: PROVIDER Y MANEJO DE ESTADO 💡

Ahora vamos a lo más importante del proyecto: **Provider**.

## 2.1 El problema que resuelve Provider

Imaginate una app con 5 pantallas. En la pantalla 1, el usuario inicia sesión. En la pantalla 5, necesitás saber si inició sesión.

**En Java/Android tradicional:**
- Guardás el estado en un Singleton o en una base de datos
- Cada Activity pregunta "¿está logueado?"

**En Flutter con Provider:**
- El estado vive en un lugar centralizado
- Cualquier widget puede "suscribirse" a esos datos
- Cuando los datos cambian, Flutter redibuja automáticamente lo que sea necesario

## 2.2 ¿Qué es un ChangeNotifier?

Es como un "Observable" en Java. Es una clase que puede notificar a otros que sus datos cambiaron.

```dart
import 'package:flutter/foundation.dart';

class ContadorNotifier extends ChangeNotifier {
  int _contador = 0;
  
  int get contador => _contador;  // Getter (propiedad de solo lectura)
  
  void incrementar() {
    _contador++;
    notifyListeners();  // ¡Le dice a todos: "Los datos cambiaron, actualícense"!
  }
}
```

**Analogía:** Es como un periódico. El `ChangeNotifier` es el periódico, y `notifyListeners()` es cuando sale una edición nueva. Todos los que están suscritos reciben la actualización automáticamente.

## 2.3 ¿Qué es un Provider?

Un **Provider** es la herramienta que conecta los datos con la UI. Es como un "tubo" que atraviesa toda tu app.

```dart
// En el main.dart, envolvés toda tu app con un Provider
MultiProvider(
  providers: [
    ChangeNotifierProvider(create: (_) => ContadorNotifier()),
  ],
  child: MiApp(),
)
```

Ahora CUALQUIER widget abajo en el árbol puede acceder a `ContadorNotifier`.

## 2.4 Las 3 formas de usar Provider en un Widget

### Opción 1: context.watch<T>()
Se usa para **leer datos** y redibujar cuando cambian.

```dart
class MiPantalla extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Esto dice: "Estoy observando ContadorNotifier"
    // Cada vez que llames notifyListeners(), este widget se redibuja
    final notificador = context.watch<ContadorNotifier>();
    
    return Text("El contador es: ${notificador.contador}");
  }
}
```

**Analogía:** Es como mirar una TV. Si cambia el canal (los datos), vos te enterás automáticamente.

### Opción 2: context.read<T>()
Se usa para **ejecutar acciones** SIN redibujar.

```dart
class MiBoton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // Esto dice: "Quiero ejecutar una acción"
        // No necesito redibujar nada, solo ejecutar lógica
        context.read<ContadorNotifier>().incrementar();
      },
      child: Text("Sumar"),
    );
  }
}
```

**Analogía:** Es como usar un control remoto. Presionás un botón (acción), pero no te "suscribís" a la TV.

### Opción 3: Consumer<T>
Es un widget que envuelve UNA parte de la UI. Es más eficiente.

```dart
class MiPantalla extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("Este NO se redibuja"),
        // Solo esto se redibuja cuando el contador cambia
        Consumer<ContadorNotifier>(
          builder: (context, notificador, child) {
            return Text("Contador: ${notificador.contador}");
          },
        ),
      ],
    );
  }
}
```

**Analogía:** Es como tener un noticiero en un canal y una película en otro. No necesitás redibujar toda la pantalla, solo la parte que cambió.

## 2.5 MultiProvider: Múltiples fuentes de datos

En InkTrack, tenemos VARIOS ViewModels (Ventas, Inventario, Clientes, etc.). Por eso usamos `MultiProvider`:

```dart
MultiProvider(
  providers: [
    // Cada Provider es una "fuente de datos"
    ChangeNotifierProvider(create: (_) => VentasViewModel(ventasRepo)),
    ChangeNotifierProvider(create: (_) => InventarioViewModel(productosRepo)),
    ChangeNotifierProvider(create: (_) => ClientesViewModel(clientesRepo)),
    ChangeNotifierProvider(create: (_) => ProveedoresViewModel(proveedoresRepo)),
    ChangeNotifierProvider(create: (_) => MovimientosViewModel(movimientosRepo)),
  ],
  child: MaterialApp(
    home: MainLayoutPage(),
  ),
)
```

**Analogía:** Es como tener varios departamentos en una empresa:
- Recursos Humanos (Clientes)
- Contabilidad (Ventas)
- Depósito (Inventario)

Cada uno maneja su propia información, pero todos están bajo el mismo techo (MultiProvider).

---

# TERCERA PARTE: ARQUITECTURA DEL PROYECTO 🏗️

Ahora que sabés los fundamentos, vamos a ver cómo está estructurado InkTrack.

## 3.1 Estructura de Carpetas

```
lib/
├── main.dart                    # Punto de entrada
├── core/                        # Cosas compartidas
│   ├── base_crud_viewmodel.dart # Clase base para ViewModels
│   ├── base_repository.dart     # Interface para repositorios
│   ├── theme/                   # Colores y temas
│   └── widgets/                 # Widgets reutilizables
└── features/                    # Las "funciones" de la app
    ├── ventas/
    │   ├── data/
    │   │   ├── models/          # Clases de datos
    │   │   └── repositories/   # Acceso a datos
    │   └── presentation/
    │       ├── viewmodels/     # Lógica y estado
    │       └── pages/          # Pantallas
    ├── inventario/
    ├── clientes/
    ├── proveedores/
    └── movimientos/
```

**Esta estructura se llama "Feature-First"**: Cada funcionalidad (ventas, inventario, etc.) tiene TODO lo que necesita dentro de su carpeta.

**En Java, sería como:**
```
com/inktrack/
├── Ventas/
│   ├── model/
│   ├── repository/
│   └── viewmodel/
├── Inventario/
│   ├── model/
│   ├── repository/
│   └── viewmodel/
```

## 3.2 El Flujo de Datos (El "Ciclo de Vida")

```
┌─────────────────────────────────────────────────────────────┐
│  USUARIO                                                   │
│  (Toca un botón, escribe, etc.)                            │
└─────────────────────┬───────────────────────────────────────┘
                      │
                      ▼
┌─────────────────────────────────────────────────────────────┐
│  VISTA (Pages/Widgets)                                     │
│  - context.read<ViewModel>().guardar(producto)             │
│  - Muestra los datos que le da el ViewModel               │
└─────────────────────┬───────────────────────────────────────┘
                      │ "Ejecuta una acción"
                      ▼
┌─────────────────────────────────────────────────────────────┐
│  VIEWMODEL (Lógica y Estado)                               │
│  - Tiene la lista de productos                             │
│  - Tiene métodos como guardar(), eliminar(), buscar()     │
│  - Cuando cambia algo, llama notifyListeners()            │
└─────────────────────┬───────────────────────────────────────┘
                      │ "Guarda/Obtiene datos"
                      ▼
┌─────────────────────────────────────────────────────────────┐
│  REPOSITORY (Abstracción de datos)                         │
│  - Habla con la base de datos (o un API)                  │
│  - El ViewModel NO sabe de dónde vienen los datos         │
└─────────────────────────────────────────────────────────────┘
```

## 3.3 Los Modelos (data/models/)

Los modelos son como los POJOs en Java. Son clases simples que representan datos.

```dart
// lib/features/ventas/data/models/venta.dart

class Venta implements HasId {
  @override  // Esto es como @Override en Java - cumple un contrato
  final String id;
  final double monto;
  final DateTime fecha;
  final String? clienteId;
  final String? clienteNombre;
  final String? concepto;

  Venta({
    required this.id,
    required this.monto,
    required this.fecha,
    this.clienteId,
    this.clienteNombre,
    this.concepto,
  });
  
  // Método copyWith (como Builder pattern en Java)
  Venta copyWith({
    String? id,
    double? monto,
    DateTime? fecha,
    String? clienteId,
    String? clienteNombre,
    String? concepto,
  }) {
    return Venta(
      id: id ?? this.id,
      monto: monto ?? this.monto,
      fecha: fecha ?? this.fecha,
      clienteId: clienteId ?? this.clienteId,
      clienteNombre: clienteNombre ?? this.clienteNombre,
      concepto: concepto ?? this.concepto,
    );
  }
}
```

**Analogía con Java:**
- `class Venta` ≈ POJO `Venta`
- `implements HasId` ≈ `implements Identifiable` (contrato: tener un id)
- `copyWith()` ≈ Builder Pattern (crea una copia con algunos campos cambiados)

## 3.4 La Interfaz HasId

Esta es una interfaz simple que asegura que todos los modelos tengan un ID:

```dart
// lib/core/base_crud_viewmodel.dart

abstract class HasId {
  String get id;  // Similar a interface Java con un método
}
```

**Uso:**
```dart
class Venta implements HasId {
  @override  // Obligatorio implementar
  final String id;
  // ...
}
```

## 3.5 El BaseCrudViewModel (El corazón del estado)

Este es el ViewModel base que usan todos los demás. Es como un "DAO genérico" en Java.

```dart
// lib/core/base_crud_viewmodel.dart

abstract class BaseCrudViewModel<T extends HasId> extends ChangeNotifier {
  final List<T> _items = [];
  
  // Getter público (los widgets lo usan)
  List<T> get items => List.unmodifiable(_items);
  
  // Agregar
  void add(T item) {
    _items.add(item);
    notifyListeners();  // ¡Actualiza la UI!
  }
  
  // Actualizar
  void update(String id, T item) {
    final index = _items.indexWhere((i) => i.id == id);
    if (index != -1) {
      _items[index] = item;
      notifyListeners();
    }
  }
  
  // Eliminar
  void delete(String id) {
    _items.removeWhere((i) => i.id == id);
    notifyListeners();
  }
  
  // Buscar por ID
  T? getById(String id) {
    try {
      return _items.firstWhere((i) => i.id == id);
    } catch (e) {
      return null;
    }
  }
}
```

**Analogía con Java:**
- `BaseCrudViewModel<T extends HasId>` ≈ `BaseDao<T extends Identifiable>`
- `List<T> get items` ≈ `List<T> getAll()`
- `add(item)` ≈ `insert(item)` + notify

## 3.6 El ViewModel Concreto (VentasViewModel)

Ahora veamos cómo un ViewModel real extiende esta base:

```dart
// lib/features/ventas/presentation/viewmodels/ventas_viewmodel.dart

class VentasViewModel extends BaseCrudViewModel<Venta> {
  final VentasRepository _repository;  // Inyección de dependencia

  VentasViewModel(this._repository) {
    _loadVentas();  // Carga inicial
  }

  // Getter para acceder más fácil
  List<Venta> get ventas => items;

  // Cargar todas las ventas
  Future<void> _loadVentas() async {
    final loaded = await _repository.getAll();
    for (var venta in loaded) {
      add(venta);  // Agrega a la lista y notifica
    }
  }

  // Calcula el total de ventas del día
  double get totalVentasDia {
    final now = DateTime.now();
    return items
        .where(
          (venta) =>
              venta.fecha.year == now.year &&
              venta.fecha.month == now.month &&
              venta.fecha.day == now.day,
        )
        .fold(0.0, (sum, item) => sum + item.monto);
  }

  // Guardar una venta
  Future<void> guardar(Venta venta, {MovimientosViewModel? movimientosVM}) async {
    if (venta.monto <= 0) return;
    
    final bool isNew = venta.id.isEmpty;
    final id = isNew 
        ? IdUtils.generateTimestampId()
        : venta.id;

    final ventaAGuardar = venta.copyWith(id: id);

    if (isNew) {
      await _repository.save(ventaAGuardar);
      add(ventaAGuardar);
      
      // También registra un movimiento (flujo relacionado)
      if (movimientosVM != null) {
        final movimiento = Movimiento(
          id: IdUtils.generateId(),
          monto: venta.monto,
          fecha: venta.fecha,
          tipo: MovimientoType.ingreso,
          concepto: 'Venta: ${venta.concepto ?? "Venta general"}',
          categoria: 'Ventas',
        );
        await movimientosVM.guardar(movimiento);
      }
    } else {
      await _repository.update(id, ventaAGuardar);
      update(id, ventaAGuardar);
    }
  }
}
```

**Puntos clave:**
1. **Inyección de dependencia:** El repositorio se pasa en el constructor (`VentasViewModel(this._repository)`)
2. **Lógica de negocio:** El ViewModel decide CÓMO guardar, no solo lo hace
3. **Relaciones:** Cuando se guarda una venta, también crea un movimiento (flujo de caja)

## 3.7 El Repository (La capa de datos)

El Repository es como un DAO en Java. Abstrae la fuente de datos.

```dart
// lib/features/ventas/data/repositories/ventas_repository.dart

class VentasRepository implements BaseRepository<Venta> {
  final List<Venta> _items = [];  // Por ahora, solo en memoria (RAM)

  @override
  Future<List<Venta>> getAll() async {
    return List.unmodifiable(_items);
  }

  @override
  Future<Venta?> getById(String id) async {
    try {
      return _items.firstWhere((item) => item.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> save(Venta item) async {
    _items.add(item);
  }

  @override
  Future<void> update(String id, Venta item) async {
    final index = _items.indexWhere((i) => i.id == id);
    if (index != -1) {
      _items[index] = item;
    }
  }

  @override
  Future<void> delete(String id) async {
    _items.removeWhere((item) => item.id == id);
  }
}
```

**Analogía con Java:**
- `implements BaseRepository<Venta>` ≈ `class VentasDao implements Dao<Venta>`
- Los métodos son todos `Future` porque eventualmente se conectarán a una base de datos real

---

# CUARTA PARTE: AGREGAR NUEVAS FEATURES 📦

## El Flujo: Model → Repository → ViewModel → Registro en Main → Vista

### Paso 1: Crear el Modelo

Implementá `HasId` para que el ViewModel base sepa cómo manejarlo.

```dart
// lib/features/productos/data/models/producto.dart
import 'package:InkTrack/core/base_crud_viewmodel.dart';

class Producto implements HasId {
  @override
  final String id;
  final String nombre;
  final double precio;
  final int stock;

  Producto({
    required this.id,
    required this.nombre,
    required this.precio,
    required this.stock,
  });

  Producto copyWith({
    String? id,
    String? nombre,
    double? precio,
    int? stock,
  }) {
    return Producto(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      precio: precio ?? this.precio,
      stock: stock ?? this.stock,
    );
  }
}
```

### Paso 2: Crear el Repository

Implementá `BaseRepository<TuModelo>`.

```dart
// lib/features/productos/data/repositories/productos_repository.dart
import 'package:InkTrack/core/data/base_repository.dart';
import 'package:InkTrack/features/productos/data/models/producto.dart';

class ProductosRepository implements BaseRepository<Producto> {
  final List<Producto> _items = [];

  @override
  Future<List<Producto>> getAll() async => List.unmodifiable(_items);

  @override
  Future<void> save(Producto item) async => _items.add(item);

  // ... implementar el resto de métodos de la interfaz
}
```

### Paso 3: Crear el ViewModel

Extendé de `BaseCrudViewModel<TuModelo>`.

```dart
// lib/features/productos/presentation/viewmodels/productos_viewmodel.dart
class ProductosViewModel extends BaseCrudViewModel<Producto> {
  final ProductosRepository _repository;

  ProductosViewModel(this._repository) {
    _loadProductos();
  }

  Future<void> _loadProductos() async {
    final loaded = await _repository.getAll();
    for (var producto in loaded) add(producto);
  }

  Future<void> guardar(Producto producto) async {
    final isNew = producto.id.isEmpty;
    final id = isNew ? IdUtils.generateTimestampId() : producto.id;
    final item = producto.copyWith(id: id);

    if (isNew) {
      await _repository.save(item);
      add(item); // Notifica a la UI automáticamente
    } else {
      await _repository.update(id, item);
      update(id, item);
    }
  }
}
```

### Paso 4: Registrar en main.dart

Agregá el Provider para que esté disponible en toda la app.

```dart
// lib/main.dart
MultiProvider(
  providers: [
    ChangeNotifierProvider(create: (_) => ProductosViewModel(productosRepo)),
    // ...
  ],
  child: // ...
)
```

---

# QUINTA PARTE: DE VOLÁTIL A PERMANENTE 💾

Actualmente, los datos de InkTrack viven solo en RAM. Si cerrás la app, se borra todo.

## 5.1 El Problema: Memoria Volátil
Cada vez que ejecutás la app, las listas empiezan vacías porque los Repositories actuales solo guardan en una `List` privada en memoria.

## 5.2 La Solución: Hive (NoSQL para Flutter)
Para InkTrack, **Hive** es ideal por ser rápido y fácil de configurar.

### Ejemplo de cambio a persistencia:
En lugar de una `List`, el Repository usaría una `Box` de Hive:

```dart
class HiveProductosRepository implements BaseRepository<Producto> {
  final Box<Producto> _box;
  HiveProductosRepository(this._box);

  @override
  Future<void> save(Producto item) async => await _box.put(item.id, item);
  
  @override
  Future<List<Producto>> getAll() async => _box.values.toList();
}
```

---

# SÉPTIMA PARTE: EJERCICIOS PARA PRACTICAR 🎯

## Ejercicio 1: Categorías de Productos (Nivel: Medio)
Agregá un campo `categoria` al modelo `Producto` y permití filtrar el inventario por categoría.

**Pasos:**
1. Modificá `lib/features/inventario/data/models/producto.dart`.
2. Actualizá el formulario en `lib/features/inventario/presentation/pages/producto_form_page.dart`.
3. Agregá un método `getFilteredByCategory(String category)` en `InventarioViewModel`.

## Ejercicio 2: Reporte de Ventas Mensual (Nivel: Difícil)
Creá una nueva página que muestre el total de ventas acumulado del mes actual.

**Pista:**
- Necesitás un método en `VentasViewModel` que filtre `items` por `venta.fecha.month == DateTime.now().month`.
- Usá un `Consumer<VentasViewModel>` en la nueva página.

## Ejercicio 3: Persistencia Real (Nivel: Experto)
Implementá Hive para el módulo de Clientes.

**Pasos:**
1. Agregá las dependencias en `pubspec.yaml`.
2. Generá el adapter para el modelo `Cliente`.
3. Creá un `HiveClientesRepository`.
4. Inicializá Hive en el `main()`.

---

# RESUMEN: GLOSARIO RÁPIDO 📝

| Término | Significado |
|---------|-------------|
| **Widget** | Componente básico de UI en Flutter. |
| **ChangeNotifier** | Clase que puede notificar cambios a la UI. |
| **Provider** | Herramienta que conecta datos con widgets. |
| **context.watch<T>()** | Lee datos y se redibuja cuando cambian. |
| **context.read<T>()** | Lee datos SIN redibujar (solo para acciones/botones). |
| **ViewModel** | Clase que maneja lógica y estado. |
| **Repository** | Abstracción de la fuente de datos. |
| **notifyListeners()** | Método que dice "los datos cambiaron, redibujen". |
| **Future** | Valor que estará disponible más tarde (Asincronía). |

---

¡Mucha suerte en tu camino como desarrollador Flutter! 🚀
