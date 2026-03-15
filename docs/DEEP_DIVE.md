# InkTrack: Deep-Dive Developer Implementation Guide 🖋️🚀
698.
> **Para quién es esta guía:** Esta escrito para desarrolladores que conocen **POO en Java** pero nunca han trabajado con **Flutter** o **Dart**. Acá vamos a explicar CADA concepto desde cero, con analogías y ejemplos prácticos.

---

# PRIMERA PARTE: FUNDAMENTOS 🧱

Antes de meternos con la arquitectura del proyecto, necesitamos entender las bases de Flutter. Si alguna vez usaste Android con Kotlin o Java, este enfoque te va a sorprendo.

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

**Pensa un Widget como una "caja" que puede:**
1. Mostrar algo (texto, imagen, icono)
2. Containear otros widgets (agruparlos)
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
final String APELLIDO = "Perez";  // const en Dart

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
String? nombre = null;  // Necesitas el ? para permitir null
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

# PARTE INTERMEDIA: EL PROCESO SDD 📜

Antes de seguir con el código, tenés que entender **CÓMO trabajamos**. En InkTrack no tiramos código al azar. Usamos **Spec-Driven Development (SDD)**.

## ¿Qué es SDD?
Es "Desarrollo Guiado por Especificaciones". Primero definimos qué vamos a hacer, cómo lo vamos a hacer, y recién ahí codificamos.

### El "Combo de 4 Archivos"
Cada funcionalidad grande (como `Clientes`, `Inventario` o `Ventas`) tiene su propia carpeta en `specs/` con 4 archivos obligatorios:

1.  **`spec.md`**: El "Qué". Define el comportamiento, reglas de negocio y actores.
2.  **`plan.md`**: El "Cómo". Define los cambios técnicos, qué archivos se tocan y qué lógica se agrega.
3.  **`tasks.md`**: El checklist. Se va marcando `[x]` a medida que avanzamos.
4.  **`history.md`**: El diario. Registra qué se hizo y cuándo.

**¿Por qué hacemos esto?**
Para que un desarrollador nuevo (¡como vos!) pueda entrar a `specs/003-clientes-basic-lifecycle/` y entender TODA la lógica de clientes sin tener que leer 500 líneas de código Dart primero.

---


# SEGUNDA PARTE: PROVIDER Y MANEJO DE ESTADO 💡

Ahora vamos a lo más importante del proyecto: **Provider**.

## 2.1 El problema que resuelve Provider

Imaginate una app con 5 pantallas. En la pantalla 1, el usuario inicia sesión. En la pantalla 5, necesitás saber si inició sesión.

**En Java/Android tradicional:**
- Guardás el estado en un Singleton o en una base de datos
- Cada Activity pregunta "está logueado?"

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

## 2.5 MultiProvider: Multiples fuentes de datos

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
│  VIEWMODEL (Logica y Estado)                               │
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
- `plements HasId` ≈ `imimplements Identifiable` (contrato: tener un id)
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

## 3.7 La Capa de Datos: Drift (SQLite) 💾

Originalmente, este proyecto usaba listas en memoria (RAM), pero para una app real necesitás que los datos sobrevivan al cerrar el app. Usamos **Drift**, el mejor motor de base de datos para Flutter.

**La analogía con Java/Android:**
`Drift` es como `Room` en Android. Definís tablas como clases y él genera el código SQL por vos.

### ¿Cómo definimos una Tabla?
Mirá este ejemplo de `lib/core/data/local/database.dart`:

```dart
@DataClassName('ClienteData')
class Clientes extends Table {
  TextColumn get id => text()();
  TextColumn get nombre => text()();
  TextColumn get telefono => text()();
  BoolColumn get esFiado => boolean().withDefault(const Constant(false))();
  RealColumn get saldoPendiente => real().withDefault(const Constant(0.0))();

  @override
  Set<Column> get primaryKey => {id};
}
```

**Puntos clave:**
1.  **Columnas tipadas**: `text()`, `boolean()`, `real()` (para números con decimales).
2.  **Valores por defecto**: Como `Constant(false)`.
3.  **Clave Primaria**: Definimos `id` como la llave única.

### El Repositorio Real
El repositorio actúa como un puente. Los ViewModels no saben que existe una base de datos; solo piden "dame todos los clientes".

```dart
// lib/features/clientes/data/repositories/clientes_repository.dart
class ClientesRepository {
  final AppDatabase _db;
  
  ClientesRepository(this._db);

  Future<List<Cliente>> getAll() async {
    // Esto hace un "SELECT * FROM Clientes" por abajo
    final items = await _db.select(_db.clientes).get();
    return items.map((data) => Cliente.fromData(data)).toList();
  }
}
```

**¿Ves la magia?** No escribiste `SELECT`, no abriste conexiones manualmente. Drift y el Repositorio se encargan de todo.

---

## 3.8 La Vista (Las páginas)


Finalmente, la vista consume los datos del ViewModel:

```dart
// lib/features/ventas/presentation/pages/home_page.dart (simplificado)

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('InkTrack Proto')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const _ResumenDiario(),
            const SizedBox(height: 24),
            Text(
              'Historial de Actividad',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            // --- ACA ESTÁ LA MAGIA DE PROVIDER ---
            Consumer<MovimientosViewModel>(
              builder: (context, viewModel, child) {
                final historial = viewModel.historialCompleto;
                
                if (historial.isEmpty) {
                  return Center(
                    child: Text('No hay actividad registrada.'),
                  );
                }
                
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: historial.length > 10 ? 10 : historial.length,
                  itemBuilder: (context, index) {
                    final mov = historial[index];
                    
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        title: Text(mov.concepto),
                        subtitle: Text('${mov.fecha}'),
                        trailing: Text('\$${mov.monto}'),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
```

**Puntos clave:**
1. `Consumer<MovimientosViewModel>` → Se suscribe a los cambios
2. `viewModel.historialCompleto` → Lee los datos
3. Cuando `historialCompleto` cambia, el widget se redibuja automáticamente

---

# CUARTA PARTE: AGREGAR NUEVAS FEATURES 📦

Ahora vas a ver cómo agregar un módulo completo al proyecto. Esto es lo que看你 mostraría un interviewer.

## El Flujo: Model → ViewModel → Registro → Vista

### Paso 1: Crear el Modelo

1. Creá `lib/features/tu_feature/data/models/tu_modelo.dart`
2. Implementá `HasId`

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

1. Creá `lib/features/tu_feature/data/repositories/tu_repository.dart`
2. Implementá `BaseRepository<TuModelo>`

```dart
// lib/features/productos/data/repositories/productos_repository.dart
import 'package:InkTrack/core/data/base_repository.dart';
import 'package:InkTrack/features/productos/data/models/producto.dart';

class ProductosRepository implements BaseRepository<Producto> {
  final List<Producto> _items = [];

  @override
  Future<List<Producto>> getAll() async {
    return List.unmodifiable(_items);
  }

  @override
  Future<Producto?> getById(String id) async {
    try {
      return _items.firstWhere((item) => item.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> save(Producto item) async {
    _items.add(item);
  }

  @override
  Future<void> update(String id, Producto item) async {
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

### Paso 3: Crear el ViewModel

1. Creá `lib/features/tu_feature/presentation/viewmodels/tu_viewmodel.dart`
2. Extendé de `BaseCrudViewModel<TuModelo>`

```dart
// lib/features/productos/presentation/viewmodels/productos_viewmodel.dart
import 'package:InkTrack/core/base_crud_viewmodel.dart';
import 'package:InkTrack/core/utils/id_utils.dart';
import 'package:InkTrack/features/productos/data/models/producto.dart';
import 'package:InkTrack/features/productos/data/repositories/productos_repository.dart';

class ProductosViewModel extends BaseCrudViewModel<Producto> {
  final ProductosRepository _repository;

  ProductosViewModel(this._repository) {
    _loadProductos();
  }

  List<Producto> get productos => items;

  Future<void> _loadProductos() async {
    final loaded = await _repository.getAll();
    for (var producto in loaded) {
      add(producto);
    }
  }

  // Lógica específica: buscar por nombre
  List<Producto> buscarPorNombre(String query) {
    if (query.isEmpty) return items;
    return items.where((p) => 
      p.nombre.toLowerCase().contains(query.toLowerCase())
    ).toList();
  }

  // Lógica específica: productos con poco stock
  List<Producto> get productosBajoStock => 
    items.where((p) => p.stock < 10).toList();

  // Guardar (crear o actualizar)
  Future<void> guardar(Producto producto) async {
    final bool isNew = producto.id.isEmpty;
    final id = isNew 
        ? IdUtils.generateTimestampId()
        : producto.id;

    final productoAGuardar = producto.copyWith(id: id);

    if (isNew) {
      await _repository.save(productoAGuardar);
      add(productoAGuardar);
    } else {
      await _repository.update(id, productoAGuardar);
      update(id, productoAGuardar);
    }
  }

  Future<void> eliminar(String id) async {
    await _repository.delete(id);
    delete(id);
  }
}
```

### Paso 4: Registrar en main.dart

Agregá el Provider en `lib/main.dart`:

```dart
// lib/main.dart (solo la parte relevante)
import 'package:InkTrack/features/productos/data/repositories/productos_repository.dart';
import 'package:InkTrack/features/productos/presentation/viewmodels/productos_viewmodel.dart';

// En el método build():
return MultiProvider(
  providers: [
    // ... otros providers existentes
    Provider.value(value: ProductosRepository()),
    ChangeNotifierProvider(create: (_) => ProductosViewModel(
      context.read<ProductosRepository>(),  // Se pasa el repo
    )),
  ],
  child: // ...
);
```

### Paso 5: Crear la Vista

1. Creá `lib/features/tu_feature/presentation/pages/tu_pagina.dart`

```dart
// lib/features/productos/presentation/pages/productos_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:InkTrack/features/productos/presentation/viewmodels/productos_viewmodel.dart';

class ProductosPage extends StatelessWidget {
  const ProductosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Productos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // Navegar al formulario de agregar
            },
          ),
        ],
      ),
      body: Consumer<ProductosViewModel>(
        builder: (context, viewModel, child) {
          final productos = viewModel.productos;

          if (productos.isEmpty) {
            return const Center(
              child: Text('No hay productos aún'),
            );
          }

          return ListView.builder(
            itemCount: productos.length,
            itemBuilder: (context, index) {
              final producto = productos[index];
              return ListTile(
                title: Text(producto.nombre),
                subtitle: Text('\$${producto.precio} - Stock: ${producto.stock}'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    viewModel.eliminar(producto.id);
                  },
                ),
                onTap: () {
                  // Navegar al formulario de editar
                },
              );
            },
          );
        },
      ),
    );
  }
}
```

---

# QUINTA PARTE: CALIDAD Y TDD 🧪

Para asegurarnos de que la lógica de negocio (como el cálculo de deudas o el stock) funcione siempre, usamos **Unit Testing**.

## 5.1 ¿Por qué testear?
En una app de finanzas, un error de `+500` en lugar de `-500` es un desastre. Los tests nos dan la tranquilidad de que la lógica "aburrida" pero crítica funciona.

## 5.2 Estructura de un Test
Mirá `test/features/clientes/clientes_viewmodel_test.dart`:

```dart
test('registrarPago reduce deuda y crea movimiento', () async {
  // 1. Arrange (Preparar)
  final vm = ClientesViewModel(repo);
  await vm.actualizarSaldo('cliente-1', 500.0);

  // 2. Act (Actuar)
  await vm.registrarPago('cliente-1', 200.0, movimientosVM);

  // 3. Assert (Verificar)
  expect(vm.getById('cliente-1')!.saldoPendiente, 300.0);
});
```

**La regla de oro:** Cada vez que agregás una función crítica en un ViewModel, agregá un test. Si el test pasa, podés dormir tranquilo.

---

# SEXTA PARTE: CONCLUSIÓN 🚀

¡Felicidades! Ahora sabés cómo se construye InkTrack:
1.  **SDD**: Primero la especificación en `specs/`.
2.  **MVVM**: Separación clara entre Datos, Lógica (ViewModel) y Vista.
3.  **Provider**: Estado reactivo que actualiza la UI automáticamente.
4.  **Drift**: Persistencia real en SQLite.
5.  **TDD**: Calidad asegurada con tests.

Este es un enfoque de **Nivel Senior**. No solo se trata de que la app "funcione", sino de que sea mantenible, escalable y libre de errores. ¡A seguir codeando! 🖋️🚀

Cada vez que ejecutás `flutter run`, la app empieza con listas vacías:

```dart
final List<Venta> _items = [];  // Se crea vacía cada vez
```

Esto es como tener un archivo en Java que no hacés `save()` - todo se pierde al cerrar.

## 5.2 La Solución: Repository Pattern

El Repository es un "intermediario" entre el ViewModel y la base de datos:

```
┌──────────────┐     ┌──────────────┐     ┌──────────────┐
│   ViewModel  │────▶│  Repository  │────▶│Base de Datos│
│   (Lógica)   │     │ (Traductor)  │     │ (SQLite/Hive)│
└──────────────┘     └──────────────┘     └──────────────┘
```

**La idea clave:** El ViewModel NO sabe de dónde vienen los datos. Solo sabe que puede pedirle al Repository.

## 5.3 SQLite vs Hive

| Característica | SQLite | Hive |
|----------------|--------|------|
| **Tipo** | Relacional (tablas) | NoSQL (key-value) |
| **Mejor para** | Datos complejos, relaciones | Datos simples, rápido |
| **Setup** | Medio (esquemas) | Fácil (anotaciones) |

Para InkTrack, **Hive** sería más fácil porque los datos son bastante simples (ventas, productos, clientes).

## 5.4 Ejemplo: Persistencia con Hive

### Paso 1: Agregar dependencias

```yaml
# pubspec.yaml
dependencies:
  hive: ^2.2.3
  hive_flutter: ^1.1.0
```

### Paso 2: Crear el Adapter

```dart
// lib/features/productos/data/models/producto.dart
import 'package:hive/hive.dart';

part 'producto.g.dart';  // Se genera automáticamente

@HiveType(typeId: 0)
class Producto extends HiveObject {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String nombre;
  
  @HiveField(2)
  final double precio;
  
  @HiveField(3)
  final int stock;
  
  Producto({
    required this.id,
    required this.nombre,
    required this.precio,
    required this.stock,
  });
}
```

### Paso 3: El Repository Real

```dart
// lib/features/productos/data/repositories/hive_productos_repository.dart
import 'package:hive/hive.dart';
import '../models/producto.dart';

class HiveProductosRepository implements BaseRepository<Producto> {
  final Box<Producto> _box;
  
  HiveProductosRepository(this._box);

  @override
  Future<List<Producto>> getAll() async {
    return _box.values.toList();
  }

  @override
  Future<Producto?> getById(String id) async {
    return _box.get(id);
  }

  @override
  Future<void> save(Producto item) async {
    await _box.put(item.id, item);
  }

  @override
  Future<void> update(String id, Producto item) async {
    await _box.put(id, item);
  }

  @override
  Future<void> delete(String id) async {
    await _box.delete(id);
  }
}
```

### Paso 4: Inicializar en main()

```dart
// lib/main.dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicializar Hive
  await Hive.initFlutter();
  Hive.registerAdapter(ProductoAdapter());
  
  // Abrir la caja
  final productosBox = await Hive.openBox<Producto>('productos');
  final productosRepo = HiveProductosRepository(productosBox);
  
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => ProductosViewModel(productosRepo)),
    ],
    child: const InkTrackApp(),
  ));
}
```

---

# SEXTA PARTE: CONCEPTOS AVANZADOS 🚀

## 6.1 ¿Qué es el BuildContext?

El `BuildContext` es como la "dirección" de tu widget en el árbol de widgets.

```dart
Widget build(BuildContext context) {
  // context es como: "Yo estoy en este lugar del árbol"
  // Puedo buscar widgets padres usando context.ancestorXxx()
  
  final algo = context.findAncestorWidgetOfExactType<MiWidget>();
  return Container();
}
```

**Analogía:** Es como el sistema de archivos de una computadora. Si estás en `/home/usuario/Documentos`, podés acceder a `/home` (padre) pero no a `/etc` (rama diferente).

## 6.2 ¿Por qué Provider busca "hacia arriba"?

Cuando hacés `context.watch<MiViewModel>()`, Flutter busca desde tu widget hacia arriba hasta encontrar el primer Provider de ese tipo.

```
Scaffold (nivel raíz)
  └── MultiProvider
        ├── Provider<ClientesViewModel>
        │     └── Column
        │           └── Consumer<ClientesViewModel>  ← LO ENCUENTRA ACA
        └── Provider<ProductosViewModel>
              └── Column
                    └── Consumer<ProductosViewModel>
```

**Regla:** El Provider debe estar ARRIBA (en el árbol) del widget que lo usa.

## 6.3 Composicion vs Herencia

En Java, para reutilizar código usás herencia:
```java
class ButtonAzul extends Button { ... }
class ButtonRojo extends Button { ... }
```

En Flutter, usás **composición** (wrapear widgets):

```dart
// En vez de heredar, PASAS lo que necesitás
class BotonColor extends StatelessWidget {
  final Widget child;
  final Color color;
  
  const BotonColor({
    super.key,
    required this.child,
    required this.color,
  });
  
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: child,
    );
  }
}

// Uso:
BotonColor(
  color: Colors.blue,
  child: Text("Click me"),
)
```

**Por qué?**
- Más flexible (puede env cualquier cosa)
- Más fácil de testar
- Flutter está diseñado para esto

## 6.4 ¿Cuándo usar StatefulWidget vs Provider?

| Escenario | Solución |
|-----------|----------|
| Un checkbox en una pantalla | StatefulWidget |
| Lista de productos que viene de BD | Provider |
| Un toggle visual simple | StatefulWidget |
| Datos que se comparten entre pantallas | Provider |
| Un contador simple | StatefulWidget |

**Regla práctica:** Si los datos vienen del exterior (API, BD, Provider) → Provider. Si son puramente locales al widget → StatefulWidget.

---

# SÉPTIMA PARTE: EJERCICIOS PARA PRACTICAR 🎯

Ahora que entendiste la teoría, estos ejercicios te van a ayudar a consolidar el conocimiento.

## Ejercicio 1: Agregar un "Proveedor" al Inventario

Creá un módulo completo para registrar proveedores (personas/empresas que te venden productos).

**Estructura a crear:**
```
lib/features/proveedores/
├── data/
│   ├── models/
│   │   └── proveedor.dart
│   └── repositories/
│       └── proveedores_repository.dart
└── presentation/
    ├── viewmodels/
    │   └── proveedores_viewmodel.dart
    └── pages/
        └── proveedores_page.dart
```

**El modelo Proveedor:**
```dart
class Proveedor implements HasId {
  @override
  final String id;
  final String nombre;
  final String? telefono;
  final String? email;
  final String? direccion;
  
  Proveedor({
    required this.id,
    required this.nombre,
    this.telefono,
    this.email,
    this.direccion,
  });
}
```

## Ejercicio 2: Agregar Reportes de Ventas

Creá una página que muestre:
- Total de ventas del día
- Total de la semana
- Un gráfico simple (puede ser solo texto por ahora)

**Pista:** Vas a necesitar:
1. Un modelo `Reporte`
2. Métodos en `VentasViewModel` para calcular los totales
3. Una nueva página que consuma esos datos

## Ejercicio 3: Persistir los Datos

Agregá Hive al proyecto para que los datos no se borren al cerrar la app.

**Pasos:**
1. Agregar `hive` y `hive_flutter` en pubspec.yaml
2. Crear los adapters
3. Cambiar los repositories para que usen Hive
4. Inicializar Hive en main()

---

# SECCIÓN EXTRA: PROFUNDIZANDO EN LO DIFÍCIL 🎯

Esta sección profundiza en los conceptos que más cuestan entender a los que vienen de Java. Tranqui, es normal sentirse perdido con estos.

---

## X.1 EL REPOSITORY PATTERN: ¿POR QUÉ EXISTE ESTA CAPA EXTRA?

Si venís de Java, probablemente te estés preguntando: "¿Por qué no meto la lógica de base de datos directamente en el ViewModel?"

**La respuesta larga:**

### Sin Repository (el problema)

```dart
// ❌ ASI NO SE HACE - ViewModel knows TOO MUCH
class VentasViewModel extends BaseCrudViewModel<Venta> {
  // directito a la base de datos - MAL
  final Database _db = SQLiteDatabase();
  
  Future<void> guardar(Venta venta) async {
    // ViewModel sabe CÓMO se guarda, DÓNDE, y el FORMATO
    await _db.insert('ventas', {
      'id': venta.id,
      'monto': venta.monto,
      'fecha': venta.fecha.toIso8601String(),
    });
    add(venta);
  }
}
```

**Problemas con este enfoque:**
1. ¿Qué pasa si mañana querés cambiar de SQLite a Firebase? → TENÉS que reescribir TODO el ViewModel
2. ¿Cómo testeas? → Necesitás una base de datos real para testear
3. El ViewModel tiene DEMASIADA responsabilidad (lógica + datos)

### Con Repository (la solución)

```dart
// ✅ ASI ESTÁ BIEN - Separación de responsabilidades

// Repository: SABE cómo guardar, PERO NO LE IMPORTA el qué
class VentasRepository implements BaseRepository<Venta> {
  final Database _db;
  
  VentasRepository(this._db);
  
  @override
  Future<void> save(Venta item) async {
    // Acá está toda la lógica de base de datos
    // El ViewModel solo llama a save(), no sabe qué pasa acá
    await _db.insert('ventas', _toMap(item));
  }
  
  // Private helpers - ViewModel no ve esto
  Map<String, dynamic> _toMap(Venta item) => {...};
}

// ViewModel: SABE el QUÉ, PERO NO el CÓMO
class VentasViewModel extends BaseCrudViewModel<Venta> {
  final VentasRepository _repository;
  
  VentasViewModel(this._repository);
  
  Future<void> guardar(Venta venta) async {
    // Solo dice "guardalo" - no sabe si va a SQLite, Firebase, o un archivo de texto
    await _repository.save(venta);
    add(venta);
  }
}
```

### La analogía del dependiente de tienda

```
┌─────────────────────────────────────────────────────────────┐
│                         ANALOGÍA                            │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  Cliente (ViewModel): "Quiero guardar estos datos"          │
│         │                                                    │
│         ▼                                                    │
│  Dependent (Repository): "Se lo passo al encargado"       │
│         │                                                    │
│         ▼                                                    │
│  Encargado (Base de datos): "Yo sé dónde y cómo guardarlo" │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

**El ViewModel NO sabe:**
- Si los datos van a SQLite, Firebase, API REST, o un archivo
- Cuál es el formato exacto de la base de datos
- Cómo se hace un INSERT o UPDATE

**El ViewModel SÍ sabe:**
- Qué es una Venta
- Qué datos tiene una Venta
- Las reglas de negocio ("no guardar ventas con monto 0")

### El beneficio REAL: Testing

```dart
// TEST sin base de datos real - MÁGICO
class FakeVentasRepository implements BaseRepository<Venta> {
  final List<Venta> _fakeItems = [];
  
  @override
  Future<List<Venta>> getAll() async => _fakeItems;
  
  @override
  Future<void> save(Venta item) async => _fakeItems.add(item);
}

// Test
test('guardar venta llama al repository', () {
  final fakeRepo = FakeVentasRepository();
  final viewModel = VentasViewModel(fakeRepo);
  
  viewModel.guardar(Venta(id: '1', monto: 100, fecha: DateTime.now()));
  
  expect(fakeRepo._fakeItems.length, 1);  // ¡Funciona sin DB!
});
```

**¿Ves el poder?** Podés testear toda tu lógica SIN tener una base de datos.

---

## X.2 INYECCIÓN DE DEPENDENCIAS: ¿POR QUÉ PASAMOS COSAS POR CONSTRUCTOR?

Esto es probablemente lo más confuso si nunca usaste DI. "¿Por qué no hago el repository directamente dentro del ViewModel?"

### El problema: Acoplamiento fuerte

```dart
// ❌ MAL - Acoplamiento fuerte
class VentasViewModel extends BaseCrudViewModel<Venta> {
  // ViewModel CREA su propio repository - PROBLEMA
  final VentasRepository _repository = VentasRepository();
}
```

**Problema:** Si querés usar un `FakeVentasRepository` para testing, no podés. El ViewModel crea el real sí o sí.

### La solución: Inyección por constructor

```dart
// ✅ BIEN - Dependency Injection
class VentasViewModel extends BaseCrudViewModel<Venta> {
  final VentasRepository _repository;  // Alguien me lo da desde afuera
  
  // Alguien me pasa el repository cuando me crea
  VentasViewModel(this._repository);
}
```

**Ahora, en main.dart, podemos elegir:**

```dart
// Producción - usa el real
final ventasRepo = VentasRepository();
final viewModel = VentasViewModel(ventasRepo);

// Testing - usa el falso
final fakeRepo = FakeVentasRepository();
final viewModel = VentasViewModel(fakeRepo);
```

### La analogía del restaurante

```
┌─────────────────────────────────────────────────────────────┐
│                    RESTAURANTE                              │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  Cocinero (ViewModel): "Yo sé cooking, necesito ingredientes"│
│         │                                                   │
│  Cliente (main.dart): "Yo te doy los ingredientes"         │
│         │                                                   │
│  Delivery (Provider): "Yo traigo los ingredientes"         │
│                                                             │
│  Ingredients (Repository): "Estoy acápá usarme"             │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

El cocinero NO va al mercado a comprar. Espera que le pasen los ingredientes. Si mañana cambia el proveedor (SQLite → Firebase), el cocinero ni se entera. Sigue cooking igual.

---

## X.3 FUTURES Y ASYNC/AWAIT: EL FLUJO ASÍNCRONO EXPLICADO

Esto confunde MUNDO a los que vienen de Java. "¿Por qué todo es Future? ¿Por qué necesito async/await?"

### El problema: Java es síncrono, Dart puede ser asíncrono

En Java, cuando llamás a un método, esperás hasta que termine:

```java
// Java - Síncrono
public void guardar() {
    db.insert(venta);  // Se ejecuta y listo, hasta que termina
    System.out.println("Guardado!");  // Esto corre DESPUÉS
}
```

En Dart/Flutter, las operaciones de base de datos son ASÍNCRONAS (no bloquean):

```dart
// Dart - Asíncrono
Future<void> guardar() async {
    await db.insert(venta);  // "Esperá a que termine, pero no bloquues todo"
    print("Guardado!");  // Esto corre DESPUÉS
}
```

### ¿Por qué Async?

Imaginá que tu app tiene que pedir datos a un servidor:

```
┌─────────────────────────────────────────────────────────────┐
│                    SIN Async/Await                          │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  Usuario toca "Cargar Productos"                           │
│         │                                                   │
│         ▼                                                   │
│  App: "Voy a pedir al servidor..."                         │
│  [USUARIO ESPERA 5 SEGUNDOS SIN PODER HACER NADA]          │
│         │                                                   │
│         ▼                                                   │
│  Servidor responde: "Aquí están los productos"              │
│         │                                                   │
│         ▼                                                   │
│  App muestra los productos                                  │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

```
┌─────────────────────────────────────────────────────────────┐
│                    CON Async/Await                          │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  Usuario toca "Cargar Productos"                           │
│         │                                                   │
│         ▼                                                   │
│  App: "Voy a pedir al servidor..."                         │
│  [USUARIO PUEDE SEGUIR USANDO LA APP]                      │
│         │                                                   │
│         ▼                                                   │
│  (cuando termina) → App muestra los productos              │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### Los 3 estados de un Future

```dart
// El Future puede estar en 3 estados:

// 1. PENDIENTE - Está corriendo
final future = _repository.getAll();

// 2. COMPLETADO - Terminó bien
future.then((items) => print(items));

// 3. ERROR - Falló
future.catchError((error) => print("Error: $error"));
```

### La forma moderna: async/await

```dart
// Forma recomendada - parece código síncrono pero NO lo es
Future<void> cargarProductos() async {
  try {
    // El usuario ve un loading mientras esto corre
    final items = await _repository.getAll();
    
    // Esto se ejecuta DESPUÉS de que items tenga datos
    for (var item in items) {
      add(item);
    }
  } catch (e) {
    // Si hay error, entra acá
    print("Error al cargar: $e");
  }
}
```

### El error común: olvidas el await

```dart
// ❌ ERROR COMÚN - olvidas await
void cargar() {
  final items = _repository.getAll();  // Esto es un Future, NO una lista!
  print(items);  // Imprime: Instance of Future<List<Producto>>
}

// ✅ CORRECTO
Future<void> cargar() async {
  final items = await _repository.getAll();  // Ahora sí es una lista
  print(items);  // Imprime: [producto1, producto2, ...]
}
```

---

## X.4 notifyListeners(): EL CICLO DE VIDA COMPLETO

Este es el corazón de Provider, y es donde más errores pasan.

### El flujo completo visual

```
┌─────────────────────────────────────────────────────────────┐
│                    FLUJO DE notifyListeners                 │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  1. Usuario toca "Guardar Venta"                           │
│         │                                                   │
│         ▼                                                   │
│  2. ViewModel.guardar() se ejecuta                         │
│     - Lógica de negocio                                    │
│     - await repository.save()                              │
│         │                                                   │
│         ▼                                                   │
│  3. repository.save() termina                             │
│         │                                                   │
│         ▼                                                   │
│  4. ViewModel.add(venta) → _items.add() + notifyListeners()│
│         │                                                   │
│         ▼                                                   │
│  5. Flutter dice: "Los datos cambiaron"                   │
│     - Busca todos los widgets que watch/lean el ViewModel  │
│         │                                                   │
│         ▼                                                   │
│  6. Los widgets SE REDIBUJAN con los nuevos datos         │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### Errores comunes con notifyListeners()

**Error 1: Llamarlo cuando no cambió nada**

```dart
// ❌ MAL - Llama notifyListeners() siempre
void buscar(String query) {
  notifyListeners();  // Redibuja aunque no haya cambiado nada!
}

// ✅ BIEN - Solo cuando cambia algo
void buscar(String query) {
  if (_busquedaAnterior == query) return;  // Optimización
  _busquedaAnterior = query;
  notifyListeners();
}
```

**Error 2: No llamarlo cuando SÍ cambió**

```dart
// ❌ MAL - Cambió los datos pero no avisa
void actualizarPrecio(String id, double nuevoPrecio) {
  final index = _items.indexWhere((i) => i.id == id);
  if (index != -1) {
    _items[index] = _items[index].copyWith(precio: nuevoPrecio);
    // ¡Olvidaste notifyListeners()! La UI no se actualiza
  }
}

// ✅ BIEN
void actualizarPrecio(String id, double nuevoPrecio) {
  final index = _items.indexWhere((i) => i.id == id);
  if (index != -1) {
    _items[index] = _items[index].copyWith(precio: nuevoPrecio);
    notifyListeners();  // ¡Avisa a la UI!
  }
}
```

**Error 3: Llamarlo en el constructor (循环!)**

```dart
// ❌ MAL - Crea un loop infinito
MiViewModel() {
  _loadData();  // Esto llama notifyListeners()
  // Que llama a build()
  // Que crea el ViewModel otra vez
  // Que llama _loadData() otra vez
  // ¡INFINITE LOOP!
}

// ✅ BIEN - Solo carga, no notifica en constructor
MiViewModel(this._repo) {
  // Solo carga, los widgets que ya están watcheando se enterarán
}
```

### El método correto: usar los métodos de BaseCrudViewModel

```dart
// ✅ LA FORMA CORRECTA - delegá a los métodos base
class VentasViewModel extends BaseCrudViewModel<Venta> {
  // Los métodos add(), update(), delete() ya llaman notifyListeners()
  // No tenés que llamarlo manualmente!
  
  Future<void> guardar(Venta venta) async {
    await _repository.save(venta);
    add(venta);  // Esto llama notifyListeners() automáticamente
  }
}
```

---

## X.5 EL BUILDCONTEXT: ¿POR QUÉ LOS WIDGETS NECESITAN CONTEXTO?

Esta es una de las partes más abstractas. Veamos:

### La analogía del árbol genealógico

```
                    MultiProvider (ABUELO)
                           │
            ┌──────────────┼──────────────┐
            │              │              │
      Provider A      Provider B     Provider C
      (PADRE)         (PADRE)        (PADRE)
            │              │              │
       Column        Column         Column
            │              │              │
       Consumer    Consumer      Consumer
       (HIJO)       (HIJO)        (HIJO)
```

Cada widget sabe QUIÉNES son sus ancestros (padre, abuelo), pero NO conoce a sus tíos o primos.

### El Context es como la ubicación en el árbol

```dart
class MiWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // context = "Yo estoy en este lugar específico del árbol"
    // Puedo preguntar: "¿Hay algún Provider arriba mío?"
    
    // Preguntar al árbol: "¿Tenés un VentasViewModel?"
    final vm = context.watch<VentasViewModel>();
    
    return Text("Tengo ${vm.items.length} ventas");
  }
}
```

### Por qué Provider busca "hacia arriba"

```dart
// Cuando hacés esto:
context.watch<MiViewModel>();

// Flutter hace:
// 1. Empezar en el widget actual
// 2. Ir al widget padre
// 3. ¿Hay un Provider<MiViewModel>? → USARLO
// 4. No? → Ir al siguiente padre
// 5. ... hasta llegar al raíz
// 6. Si no encontró → ERROR
```

**Por eso el Provider debe estar ARRIBA en el árbol:**

```dart
// ✅ CORRECTO - Provider ARRIBA del widget que lo usa
MultiProvider(
  providers: [
    ChangeNotifierProvider(create: (_) => MiViewModel()),
  ],
  child: MiWidget(),  // Este puede usar context.watch()
)

// ❌ INCORRECTO - Provider ABAJO del widget que lo usa
MiWidget(  // ERROR! No puede encontrar el Provider
  children: [
    ChangeNotifierProvider(create: (_) => MiViewModel()),
  ],
)
```

### ¿Qué pasa si no hay Provider?

```dart
// Este código da ERROR si no hay Provider<MiViewModel> arriba
class MiWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Error: Provider not found
    final vm = context.watch<MiViewModel>();
    return Text("...");
  }
}
```

**Solución:** Wrappear con un Provider o Consumer.

---

## X.6 ERRORES COMUNES DE INICIANTES (Y CÓMO EVITARLOS)

Después de ver muchos proyectos, estos son los errores que más se repiten:

### Error 1: Olvidar Provider.value()

```dart
// ❌ ERROR - Provider.value() vs ChangeNotifierProvider
Provider(create: (_) => MiRepo()),  // Solo crea el valor
ChangeNotifierProvider(create: (_) => MiViewModel()),  // Crea + observa cambios

// En el primer caso, podés usar context.read<MiRepo>()
// Pero context.watch<MiRepo>() NO va a funcionar para notifyListeners
```

### Error 2: No usar const cuando se puede

```dart
// ❌ MAL - Se crea una nueva instancia cada rebuild
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text("Hola"),  // Esto se recrea siempre
    ),
  );
}

// ✅ BIEN - Se crea una vez y reutiliza
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text("Hola"),  // const = no se recrea
    ),
  );
}
```

### Error 3: Crear Controllers en StatelessWidget

```dart
// ❌ ERROR - StatefulWidget necesita su estado
class MiForm extends StatelessWidget {
  final TextEditingController controller = TextEditingController();  // NO!
  
  @override
  Widget build(BuildContext context) {
    return TextField(controller: controller);
  }
}

// ✅ CORRECTO - StatefulWidget maneja el ciclo de vida
class MiForm extends StatefulWidget {
  @override
  State<MiForm> createState() => _MiFormState();
}

class _MiFormState extends State<MiForm> {
  late TextEditingController controller;
  
  @override
  void initState() {
    super.initState();
    controller = TextEditingController();  // Acá sí
  }
  
  @override
  void dispose() {
    controller.dispose();  // Y acá se limpia
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return TextField(controller: controller);
  }
}
```

### Error 4: Rebuilds innecesarios

```dart
// ❌ MAL - Todo el widget se redibuja
class MiPagina extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final vm = context.watch<MiViewModel>();  // Todo rebuild si cambia
    
    return Column(
      children: [
        Text("Algo que no depende de vm"),  // También se redibuja!
        Text(vm.dato),  // Solo esto necesitaba watcher
      ],
    );
  }
}

// ✅ BIEN - Solo la parte que cambia se redibuja
class MiPagina extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("Algo que no depende de vm"),  // No se redibuja
        Consumer<MiViewModel>(  // Solo esto cambia
          builder: (context, vm, child) {
            return Text(vm.dato);  // Solo esto se redibuja
          },
        ),
      ],
    );
  }
}
```

### Error 5: Null safety sin entender

```dart
// ❌ ERROR - String? NO es lo mismo que String
String? nombre;  // Puede ser null
String nombre;   // NUNCA puede ser null

void saludar() {
  // Esto da error de compilación!
  print(nombre.length);  // nombre puede ser null!
  
  // ✅ Solución 1: Null check
  if (nombre != null) {
    print(nombre.length);
  }
  
  // ✅ Solución 2: Null assertion (si estás seguro)
  print(nombre!.length);  // "Confiá en mí, no es null"
  
  // ✅ Solución 3: Null-aware operator
  print(nombre?.length ?? 0);  // Si es null, usa 0
}
```

---

## X.7 UN EJEMPLO COMPLETO: CÓMO FLUYEN LOS DATOS DE VERDAD

Vamos a hacer un recorrido completo desde el usuario hasta la base de datos:

### El escenario: Usuario guarda una venta

```
┌─────────────────────────────────────────────────────────────┐
│ 1. USUARIO COMPLETA EL FORMULARIO                          │
│                                                             │
│ - Monto: $500                                             │
│ - Cliente: "Juan"                                          │
│ - Concepto: "Impresión 100 hojas"                          │
└──────────────────────┬──────────────────────────────────────┘
                       │
                       ▼ Toca "Guardar"
┌─────────────────────────────────────────────────────────────┐
│ 2. PÁGINA (Vista)                                          │
│                                                             │
│ class RegistrarVentaPage extends StatelessWidget {        │
│   ...                                                      │
│   void _guardar() {                                        │
│     final venta = Venta(                                   │
│       id: '',  // vacío = nueva                            │
│       monto: 500,                                          │
│       ...                                                  │
│     );                                                     │
│                                                             │
│     //Llama al ViewModel                                   │
│     context.read<VentasViewModel>().guardar(venta);       │
│   }                                                        │
└──────────────────────┬──────────────────────────────────────┘
                       │
                       ▼ .guardar()
┌─────────────────────────────────────────────────────────────┐
│ 3. VIEWMODEL (Lógica de negocio)                           │
│                                                             │
│ class VentasViewModel extends BaseCrudViewModel<Venta> {  │
│   final VentasRepository _repository;                      │
│                                                             │
│   Future<void> guardar(Venta venta) async {               │
│     // 1. Validar                                          │
│     if (venta.monto <= 0) return;                         │
│                                                             │
│     // 2. Generar ID si es nueva                           │
│     final id = venta.id.isEmpty                           │
│         ? IdUtils.generateTimestampId()                  │
│         : venta.id;                                        │
│                                                             │
│     final ventaAGuardar = venta.copyWith(id: id);        │
│                                                             │
│     // 3. Guardar en BD (Repository)                       │
│     await _repository.save(ventaAGuardar);               │
│                                                             │
│     // 4. Agregar a la lista local                         │
│     add(ventaAGuardar);  // ← notifyListeners() aquí     │
│                                                             │
│     // 5. También crear un movimiento (flujo caja)        │
│     if (movimientosVM != null) {                         │
│       await movimientosVM.guardar(Movimiento(...));      │
│     }                                                      │
│   }                                                        │
│ }                                                          │
└──────────────────────┬──────────────────────────────────────┘
                       │
                       ▼ await _repository.save()
┌─────────────────────────────────────────────────────────────┐
│ 4. REPOSITORY (Persistencia)                               │
│                                                             │
│ class VentasRepository implements BaseRepository<Venta> { │
│   final List<Venta> _items = [];  // Por ahora en RAM     │
│                                                             │
│   @override                                                │
│   Future<void> save(Venta item) async {                  │
│     // Habla con la "base de datos"                       │
│     // (En el futuro: SQLite, Firebase, API)              │
│     _items.add(item);                                     │
│   }                                                        │
│ }                                                          │
└──────────────────────┬──────────────────────────────────────┘
                       │
                       ▼ return (terminó)
┌─────────────────────────────────────────────────────────────┐
│ 5. VIEWMODEL - add()                                       │
│                                                             │
│ // En BaseCrudViewModel:                                   │
│ void add(T item) {                                         │
│   _items.add(item);                                       │
│   notifyListeners();  // ← ¡LA MAGIA!                      │
│ }                                                          │
└──────────────────────┬──────────────────────────────────────┘
                       │
                       ▼ notifyListeners()
┌─────────────────────────────────────────────────────────────┐
│ 6. FLUTTER REDIBUJA                                        │
│                                                             │
│ Flutter busca todos los widgets que hacen                 │
│ context.watch<VentasViewModel>() o                         │
│ Consumer<VentasViewModel>()                                │
│                                                             │
│ Les dice: "Sus datos cambiaron, rebuild"                  │
│                                                             │
│ La lista de ventas se muestra con el nuevo item           │
└─────────────────────────────────────────────────────────────┘
```

### En código:

```dart
// ============ VISTA (Pagina) ============
class RegistrarVentaPage extends StatelessWidget {
  final _montoController = TextEditingController();
  
  void _guardar(BuildContext context) {
    final venta = Venta(
      id: '',  // Nueva venta
      monto: double.parse(_montoController.text),
      fecha: DateTime.now(),
    );
    
    // ¡Solo llama al método! No sabe nada de BD
    context.read<VentasViewModel>().guardar(venta);
    
    Navigator.pop(context);  // Vuelve a la pantalla anterior
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TextField(
        controller: _montoController,
        keyboardType: TextInputType.number,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _guardar(context),
        child: Icon(Icons.save),
      ),
    );
  }
}

// ============ VIEWMODEL ============
class VentasViewModel extends BaseCrudViewModel<Venta> {
  final VentasRepository _repository;
  
  VentasViewModel(this._repository);
  
  List<Venta> get ventas => items;
  
  Future<void> guardar(Venta venta) async {
    if (venta.monto <= 0) return;
    
    // Lógica de negocio
    final bool isNew = venta.id.isEmpty;
    final id = isNew 
        ? IdUtils.generateTimestampId() 
        : venta.id;
    
    final ventaAGuardar = venta.copyWith(id: id);
    
    if (isNew) {
      // Persistencia
      await _repository.save(ventaAGuardar);
      
      // UI update
      add(ventaAGuardar);
    } else {
      await _repository.update(id, ventaAGuardar);
      update(id, ventaAGuardar);
    }
  }
}

// ============ REPOSITORY ============
class VentasRepository implements BaseRepository<Venta> {
  final List<Venta> _items = [];  // RAM por ahora
  
  @override
  Future<void> save(Venta item) async {
    _items.add(item);
  }
  
  // ... otros métodos
}
```

---

# RESUMEN: GLOSARIO RÁPIDO 📝

| Término | Significado |
|---------|-------------|
| **Widget** | Componente básico de UI en Flutter (como View en Android) |
| **StatelessWidget** | Widget que no cambia (solo se dibuja una vez) |
| **StatefulWidget** | Widget que puede cambiar y redibujarse |
| **ChangeNotifier** | Clase que puede notificar cambios a la UI |
| **Provider** | Herramienta que conecta datos con widgets |
| **context.watch<T>()** | Lee datos y se redibuja cuando cambian |
| **context.read<T>()** | Lee datos SIN redibujar (solo acción) |
| **Consumer<T>** | Widget que envuelve y subscribe solo su children |
| **ViewModel** | Clase que maneja lógica y estado (como un Controller) |
| **Repository** | Abstracción de la fuente de datos (como un DAO) |
| **Model** | Clase que representa datos (como un POJO) |
| **notifyListeners()** | Método que dice "los datos cambiaron, redibujen" |
| **BuildContext** | La "ubicación" de un widget en el árbol |
| **Future** | Representa un valor que aún no está disponible (como Promise en JS) |
| **async/await** | Sintaxis para escribir código asíncrono de forma "síncrona" |
| **Inyección de dependencias** | Pasar objetos por constructor en vez de crearlos internamente |
| **Acoplamiento** | Qué tanto depende un componente de otro |
| **copyWith()** | Método que crea una copia del objeto con algunos campos modificados |
| **const** | Keyword que marca algo como inmutable en tiempo de compilación |
| **null safety** | Sistema de Dart que previene NullPointerExceptions |
| **String?** | Tipo que PUEDE ser null |
| **String** | Tipo que NUNCA puede ser null |

---

# PRÓXIMOS PASOS 🚶

1. **Primeros pasos:** Corré la app y Familiarízate con la UI
2. **Experimento:** Agregá un print() en algún método del ViewModel y ved cómo se ejecuta
3. **Practica:** Hacé el Ejercicio 1 de arriba (proveedores)
4. **Profundizá:** Investigá Flutter Widgets (Container, Column, Row, ListView, GridView)
5. **Siguiente nivel:** Aprendé sobre navegación (Navigator 2.0) y testing
6. **Lee esto:** Repasá la sección X.7 (Ejemplo completo) - ahí está todo integrado

---

**LECTURA RECOMENDADA ANTES DE EMPEZAR A PROGRAMAR:**

1. Sections 1.1 a 1.4 (Fundamentos)
2. Sección 2 completa (Provider)
3. Sección X.1 a X.5 (Lo difícil)
4. Sección X.7 (El flujo completo)

Después de eso, ya podés empezar con la práctica. ¡Suerte! 🔥

---

# APÉNDICE: CONCEPTOS QUE DEBERÍAS SABER 🧠

> Esta sección es para cuando ya domines lo anterior. Acá vas a encontrar conceptos, patrones y principios que aplican NO solo a Flutter, sino a Java, C#, y prácticamente cualquier lenguaje moderno. Son cosas que te van a hacer un MEJOR desarrollador, sin importar dónde trabajes.

---

## A.1 PRINCIPIOS SOLID - Los 5 pilares del buen código

Estos principios existen desde hace décadas y aplican a TODO. Si los aplicás, tu código será más mantenible, testeable y escalable.

### Single Responsibility Principle (SRP)
**Una clase debe tener una sola razón para cambiar.**

```dart
// ❌ MAL - Esta clase hace MIL cosas
class Usuario {
  void guardar() { ... }      // Persistencia
  void validarEmail() { ... }  // Validación
  void enviarEmail() { ... }   // Envío de emails
  void calcularImpuestos() { ... }  // Lógica de negocio
}

// ✅ BIEN - Cada clase tiene UNA responsabilidad
class Usuario { ... }  // Solo datos
class UsuarioRepository { ... }  // Solo persistencia
class ValidadorUsuario { ... }   // Solo validación
class EmailService { ... }       // Solo emails
```

**Analogía:** Un doctor no opera, NO receta, NO cobra. Si hace todo, seguro lo hace mal. Cada persona tiene un rol.

---

### Open/Closed Principle (OCP)
**Abierto para extensión, cerrado para modificación.**

```dart
// ❌ MAL - Si agregás un nuevo tipo, modificás esta clase
class Descuento {
  double calcular(double precio, String tipo) {
    if (tipo == 'estudiante') return precio * 0.5;
    if (tipo == 'jubilado') return precio * 0.7;
    if (tipo == 'vip') return precio * 0.8;
    return precio;
  }
}

// ✅ BIEN - Agregás nuevos descuentos SIN modificar el código existente
abstract class Descuento {
  double calcular(double precio);
}

class DescuentoEstudiante extends Descuento {
  @override
  double calcular(double precio) => precio * 0.5;
}

class DescuentoVIP extends Descuento {
  @override
  double calcular(double precio) => precio * 0.8;
}
```

**La idea:** Si mañana agregás "descuento por cumpleañeros", NO tocás la clase original. Agregás una nueva clase.

---

### Liskov Substitution Principle (LSP)
**Las clases hijo deben poder usarse en lugar de la clase padre sin romper el código.**

```dart
// ❌ ROMPE LSP - El hijo no puede cumplir el contrato del padre
abstract class Ave {
  void volar();
}

class Pinguino extends Ave {
  @override
  void volar() {
    throw Exception("Los pingüinos no vuelan");  // ROMPE EL CONTRATO
  }
}

// ✅ CUMPLE LSP - Interfaz más específica
abstract class Ave {}
abstract class AveVoladora extends Ave {
  void volar();
}
abstract class AveNadadora extends Ave {
  void nadar();
}

class Pinguino extends AveNadadora {
  @override
  void nadar() { ... }
}
```

---

### Interface Segregation Principle (ISP)
**Es mejor tener muchas interfaces específicas que una interface genérica.**

```dart
// ❌ MAL - Esta interfaz tiene métodos que no todos usan
abstract class Operario {
  void operarMaquina();
  void programar();
  void manejarCamion();
}

// Un operador de máquina NO necesita programar ni manejar camión

// ✅ BIEN - Interfaces específicas
abstract class OperarioMaquina { void operarMaquina(); }
abstract class Programador { void programar(); }
abstract class Chofer { void manejarCamion(); }

class OperadorPlanta implements OperarioMaquina, Chofer {
  // Solo implementa lo que necesita
}
```

---

### Dependency Inversion Principle (DIP)
**Depende de abstracciones, no de implementaciones concretas.**

```dart
// ❌ MAL - Depende de la implementación concreta
class CarritoCompras {
  final SQLiteDatabase db = SQLiteDatabase();  // Dependencia concreta
  
  void guardar() {
    db.insert(...);  // Y si mañana usas Firebase?
  }
}

// ✅ BIEN - Depiende de una abstracción
abstract class Database { ... }

class CarritoCompras {
  final Database db;  // No importa cuál sea
  
  CarritoCompras(this.db);  // Se inyecta
}

// Ahora podés usar SQLite, Firebase, o lo que quieras
class CarritoSQL extends CarritoCompras {
  CarritoSQL() : super(SQLiteDatabase());
}

class CarritoFirebase extends CarritoCompras {
  CarritoFirebase() : super(FirebaseDatabase());
}
```

**Esta es la base de la inyección de dependencias que usamos en Flutter.**

---

## A.2 PATRONES DE DISEÑO QUE DEBERÍAS CONOCER

Estos patrones solving problemas comunes en TODOS los lenguajes.

### Repository Pattern (Patrón Repositorio)
Ya lo viste en el proyecto. Es un intermediario entre la lógica de negocio y la fuente de datos.

```
APLICACIÓN → REPOSITORIO → BASE DE DATOS
```

**Para qué sirve:**
- Abstraer la fuente de datos
- Facilitar el testing (mocking)
- Cambiar la BD sin reescribir lógica

---

### Observer Pattern (Patrón Observador)
Es la base de Provider/ChangeNotifier.

```
SUJETO → NOTIFICA → OBSERVADORES
   │                    ↑
   └────────────────────┘
   "Cuando cambie, avisales a todos"
```

**En Flutter:** `ChangeNotifier` es el sujeto, `Consumer` son los observadores.

---

### Factory Pattern (Patrón Fábrica)
Sirve para crear objetos sin especificar la clase exacta.

```dart
// ❌ CREACIÓN DIRECTA
class App {
  void crearDatabase() {
    final db = SQLiteDatabase();  // Acoplado
  }
}

// ✅ CON FÁBRICA
abstract class DatabaseFactory {
  Database crear();
}

class SQLiteFactory implements DatabaseFactory {
  @override
  Database crear() => SQLiteDatabase();
}

class FirebaseFactory implements DatabaseFactory {
  @override
  Database crear() => FirebaseDatabase();
}

class App {
  final DatabaseFactory factory;
  App(this.factory);
  
  void crear() {
    final db = factory.crear();  // No sabe qué tipo es
  }
}
```

---

### Builder Pattern (Patrón Constructor)
Ya lo usaste en el proyecto: `copyWith()`. Sirve para crear objetos complejos paso a paso.

```dart
// Con Builder
class PizzaBuilder {
  String _tamano = 'mediana';
  bool _queso = true;
  bool _jamon = false;
  
  PizzaBuilder tamano(String t) { _tamano = t; return this; }
  PizzaBuilder conQueso(bool s) { _queso = s; return this; }
  PizzaBuilder conJamon(bool s) { _jamon = s; return this; }
  
  Pizza build() => Pizza(_tamano, _queso, _jamon);
}

// Uso - MUY legible
final pizza = PizzaBuilder()
  .tamano('grande')
  .conQueso(true)
  .conJamon(true)
  .build();
```

**En Dart, `copyWith()` es una versión simplificada del Builder.**

---

### Singleton Pattern (Patrón Singleton)
Una sola instancia de una clase en toda la app.

```dart
// ❌ PROBLEMA: Cada vez es una nueva instancia
class Configuracion {
  String apiUrl = 'http://localhost';
}

final c1 = Configuracion();
final c2 = Configuracion();
print(identical(c1, c2));  // false - son distintos!

// ✅ SINGLETON - Una sola instancia
class Configuracion {
  static final Configuracion _instance = Configuracion._internal();
  
  factory Configuracion() => _instance;
  
  Configuracion._internal();
  
  String apiUrl = 'http://localhost';
}

// Ahora TODOS usan la MISMA instancia
final c1 = Configuracion();
final c2 = Configuracion();
print(identical(c1, c2));  // true - es la misma!
```

**En Flutter con Provider, NO necesitás Singleton.** El Provider ya lo hace por vos.

---

## A.3 CONCEPTOS DE ARQUITECTURA

### Clean Architecture (Arquitectura Limpia)

Es una forma de estructurar tu aplicación en CAPAS independientes:

```
┌─────────────────────────────────────────┐
│           PRESENTATION                   │
│   (Widgets, Pages, ViewModels)          │
└────────────────────┬────────────────────┘
                     │
┌────────────────────▼────────────────────┐
│              DOMAIN                      │
│   (Use Cases, Entities, Interfaces)     │
└────────────────────┬────────────────────┘
                     │
┌────────────────────▼────────────────────┐
│               DATA                        │
│   (Repositories, Data Sources, Models)  │
└─────────────────────────────────────────┘
```

**La regla clave:** Cada capa SOLO conoce a la capa de abajo. La presentación NO conoce la base de datos.

**En InkTrack usamos una versión simplificada:**
- Presentación (Pages/Widgets/ViewModels)
- Domain/Data (Models/Repositories)

---

### CQRS (Command Query Responsibility Segregation)

Separa las OPERACIONES de LECTURA:

```dart
// COMANDOS (Write) - Cambian estado
class GuardarVentaCommand {
  ejecutar(Venta venta) { ... }
}

class EliminarVentaCommand {
  ejecutar(String id) { ... }
}

// QUERIES (Read) - Solo leen
class ObtenerVentasQuery {
  ejecutar() => Lista<Venta>;
}

class ObtenerVentasPorClienteQuery {
  ejecutar(String clienteId) => Lista<Venta>;
}
```

**Beneficio:** Optimizás las lecturas independiente de las escrituras.

---

## A.4 CONCEPTOS DE PROGRAMACIÓN MODERNA

### Inmutabilidad

Los objetos NO cambian después de creados. Si necesitás cambiarlos, creás uno nuevo.

```dart
// ❌ MUTABLE - Puede cambiar
class Persona {
  String nombre;
  Persona(this.nombre);
}

var p = Persona('Juan');
p.nombre = 'Pedro';  // Cambió el original!

// ✅ INMUTABLE - Nunca cambia
class Persona {
  final String nombre;  // final = no puede cambiar
  Persona(this.nombre);
}

var p = Persona('Juan');
// p.nombre = 'Pedro';  // ERROR! No se puede cambiar

// Para "cambiar", creás uno nuevo
var p2 = Persona('Pedro');
```

**Beneficios:**
- Menos bugs (nada cambia sin que te des cuenta)
- Más fácil testing
- Thread-safe (si usás multi-threading)

**En Dart:** Usá `final` siempre que puedas y `copyWith()` para crear copias modificadas.

---

### Programación Asíncrona

Ya la cubrimos en la sección X.3, pero acá van los conceptos transferibles:

| Término Flutter | Término Java | Término C# |
|-----------------|--------------|-------------|
| `Future<T>` | `CompletableFuture<T>` | `Task<T>` |
| `async/await` | `async/await` | `async/await` |
| `Stream<T>` | `Flow<T>` / RxJava | `IObservable<T>` |

**La idea central:** No bloquees el hilo principal. Mientras esperás datos, la UI sigue respondiendo.

---

### Genéricos (Templates)

Código que funciona con cualquier tipo.

```dart
// ❌ SIN genéricos - Repetido
class ListaEnteros {
  List<int> items = [];
  void add(int i) => items.add(i);
}

class ListaStrings {
  List<String> items = [];
  void add(String s) => items.add(s);
}

// ✅ CON genéricos - Una sola clase
class Lista<T> {  // <T> es el tipo genérico
  List<T> items = [];
  void add(T item) => items.add(item);
}

var listaInt = Lista<int>();
var listaStr = Lista<String>();
```

**En el proyecto:** `BaseCrudViewModel<T extends HasId>` es genérico. Funciona con cualquier modelo que tenga ID.

---

## A.5 CONSEJOS PARA SER MEJOR DESARROLLADOR

### 1. Lee código de otros
- Busca proyectos open source bien rankeados
- Analiza POR QUÉ escribieron las cosas así

### 2. Escribe tests
- Un código sin test es código que no sabés si funciona
- Empezá con test de unidades (Unit Tests)
- Después test de integración

### 3. Aprende a debuggear
- No pongas prints everywhere
- Usá el debugger de tu IDE
- Entendé cómo funciona breakpoints

### 4. Documenta tu código
- Nombres claros de variables y funciones
- Comments en decisiones difíciles
- README en tus proyectos

### 5. Versiona con Git
- Commits atómicos (una cosa por commit)
- Mensajes descriptivos
- Branching para features

### 6. Aprende tu IDE
- Shortcuts de teclado
- Refactoring tools
- Live templates

---

## A.6 ROADMAP DE APRENDIZAJE RECOMENDADO

```
MES 1: Flutter fundamentals
├── Dart básico
├── Widgets básicos (Text, Column, Row, Container)
├── Estado con StatefulWidget
└── Navegación básica

MES 2: Provider y arquitectura
├── Provider/ChangeNotifier
├── Repository pattern
├── Clean Architecture básica
└── Dependencias (pub.dev)

MES 3: Profundizar
├── Widgets avanzados (ListView, GridView, CustomPaint)
├── Formularios y validación
├── Persistencia local (Hive/SQLite)
└── Fetching de APIs (HTTP)

MES 4: Conceptos avanzados
├── Testing
├── Animaciones
├── Performance optimization
└── Publicación de apps
```

---

## A.7 RECURSOS PARA SEGUIR APRENDIENDO

### Documentación oficial
- [Flutter Docs](https://docs.flutter.dev/)
- [Dart Docs](https://dart.dev/guides)
- [Provider package](https://pub.dev/packages/provider)

### Cursos recomendados
- The Complete Flutter Development Bootcamp (Angela Yu)
- Flutter & Dart - The Complete Guide (Maximilian Schwarzmüller)

### Comunidades
- r/FlutterDev (Reddit)
- Flutter Community (Discord)
- Stack Overflow

### Para arquitectura y patrones
- "Clean Architecture" - Robert C. Martin
- "Design Patterns" - Gang of Four
- "Refactoring" - Martin Fowler

---

## RESUMEN FINAL

Lo más importante que te llevás de esta guía:

1. **Widgets** = Los bloques de construcción de Flutter
2. **Provider** = La forma de compartir estado
3. **Repository** = La abstracción de datos
4. **MVVM** = La arquitectura del proyecto
5. **Inmutabilidad** = Datos que no cambian = menos bugs
6. **SOLID** = Principios universales de buen código
7. **Patrones** = Soluciones probadas a problemas comunes

Pero sobre todo: **PRACTICA**. No vas a aprender leyendo nomás. Abrí el proyecto, tocá código, rompé cosas, arreglalas.

¡Mucha suerte en tu camino como desarrollador Flutter! 🚀

---

¿Dudas? ¿Querés que profundice en algún tema específico de esta sección?
