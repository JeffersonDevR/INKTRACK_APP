# Requisitos del Sistema InkTrack

Este documento detalla los requisitos funcionales y no funcionales del software InkTrack, un sistema de Punto de Venta (POS) diseñado para tiendas locales, basado en el análisis del código fuente de la rama `sdd_pruebas`.

## 1. Requisitos Funcionales (RF)

### 1.1 Gestión de Ventas
- **RF-01: Registro de Ventas:** El sistema debe permitir registrar ventas especificando el monto, concepto, fecha y si es una venta general o vinculada a un cliente.
- **RF-02: Escaneo de Recibos (OCR):** El sistema debe permitir escanear notas o recibos físicos mediante la cámara o galería para extraer automáticamente el monto y el nombre del cliente utilizando reconocimiento de texto (ML Kit).
- **RF-03: Vinculación con Inventario:** Al registrar una venta, se debe poder seleccionar un producto del inventario para descontar automáticamente el stock.
- **RF-04: Ventas a Crédito (Fiado):** El sistema debe permitir marcar una venta como "fiada", lo cual incrementará automáticamente el saldo pendiente del cliente asociado.

### 1.2 Gestión de Clientes
- **RF-05: Registro de Clientes:** El sistema debe permitir crear, editar y dar de baja (activar/desactivar) clientes con información de nombre, teléfono y email.
- **RF-06: Control de Deudas:** El sistema debe llevar un registro del saldo pendiente de cada cliente y permitir marcar si un cliente es apto para crédito (es fiado).
- **RF-07: Historial de Pagos:** (Inferido) El sistema debe permitir actualizar el saldo de los clientes cuando estos realizan pagos.

### 1.3 Gestión de Inventario
- **RF-08: Catálogo de Productos:** El sistema debe permitir la gestión (CRUD) de productos, incluyendo nombre, cantidad, precio, categoría y proveedor.
- **RF-09: Control de Stock Mínimo:** El sistema debe permitir definir un stock mínimo por producto y generar alertas visuales cuando la cantidad actual sea igual o inferior a este límite.
- **RF-10: Generación de Códigos de Barras:** El sistema debe poder generar automáticamente códigos de barras en formato EAN-13 para nuevos productos.
- **RF-11: Categorización Dinámica:** El sistema debe permitir crear nuevas categorías de productos de forma dinámica desde el formulario de registro.

### 1.4 Gestión de Proveedores
- **RF-12: Registro de Proveedores:** El sistema debe permitir gestionar proveedores, incluyendo su nombre, teléfono y los días de visita programados.
- **RF-13: Vinculación Producto-Proveedor:** Cada producto en el inventario puede estar asociado a un proveedor específico.

### 1.5 Movimientos Financieros
- **RF-14: Registro de Ingresos y Egresos:** El sistema debe permitir registrar manualmente cualquier movimiento de dinero (entrada o salida) que no sea necesariamente una venta directa.
- **RF-15: Categorización de Movimientos:** Los movimientos deben poder clasificarse en categorías como Ventas, Servicios, Sueldos, Alquiler, etc.
- **RF-16: Filtros de Fecha:** El sistema debe permitir filtrar el historial de movimientos por rangos de fecha específicos.
- **RF-17: Balance en Tiempo Real:** El sistema debe calcular y mostrar el balance total, ingresos y egresos tanto del día actual como de periodos filtrados.

### 1.6 Reportes y KPIs
- **RF-18: Resumen Financiero:** El sistema debe presentar un dashboard con el total de ingresos, egresos y balance neto.
- **RF-19: Indicadores de Alerta:** El sistema debe mostrar visualmente la cantidad de productos con bajo stock y la deuda total acumulada por los clientes.
- **RF-20: Gráficos de Tendencia:** (Inferido por `FinancialSummaryHeader`) El sistema debe mostrar gráficos que representen la tendencia de los movimientos financieros.

---

## 2. Requisitos No Funcionales (RNF)

### 2.1 Usabilidad y Diseño
- **RNF-01: Interfaz "Premium Fintech":** La interfaz debe seguir una estética moderna y profesional, utilizando una paleta de colores basada en Índigo (confianza), Esmeralda (éxito) y Ámbar (actividad).
- **RNF-02: Accesibilidad Visual:** El sistema debe utilizar tipografías de alta legibilidad (Plus Jakarta Sans) con tamaños adecuados para entornos de trabajo rápido (mínimo 14-16px en cuerpos de texto).
- **RNF-03: Contraste Elevado:** Se debe garantizar un alto contraste entre el texto y el fondo para facilitar la lectura en diversas condiciones de iluminación.
- **RNF-04: Soporte de Modo Oscuro:** El sistema debe contar con un tema oscuro completo que mantenga la consistencia visual y la legibilidad.

### 2.2 Rendimiento y Persistencia
- **RNF-05: Persistencia Local:** Todos los datos deben almacenarse de forma local en el dispositivo utilizando una base de datos SQLite (vía Drift) para garantizar el funcionamiento sin conexión a internet.
- **RNF-06: Reactividad:** La interfaz de usuario debe actualizarse automáticamente ante cualquier cambio en los datos subyacentes mediante el patrón de manejo de estado Provider.

### 2.3 Arquitectura de Software
- **RNF-07: Arquitectura MVVM:** El código debe estar organizado siguiendo el patrón Model-View-ViewModel para separar claramente la lógica de negocio de la interfaz de usuario.
- **RNF-08: Repositorio Pattern:** El acceso a los datos debe estar abstraído mediante repositorios, permitiendo que el origen de los datos sea intercambiable sin afectar la lógica del ViewModel.
- **RNF-09: Modularidad (Feature-First):** El proyecto debe estar organizado por funcionalidades (features), donde cada módulo contiene sus propios modelos, repositorios, viewmodels y vistas.

### 2.4 Seguridad y Calidad
- **RNF-10: Integridad de Datos:** El sistema debe manejar migraciones de base de datos para asegurar que los datos no se pierdan al actualizar la aplicación.
- **RNF-11: Validaciones de Entrada:** Todos los formularios deben incluir validaciones para prevenir el ingreso de datos erróneos (montos negativos, campos vacíos, formatos de email/teléfono inválidos).
- **RNF-12: Cobertura de Pruebas:** La lógica crítica de negocio (especialmente en ViewModels) debe estar respaldada por pruebas unitarias.
