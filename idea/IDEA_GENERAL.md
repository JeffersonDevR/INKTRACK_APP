## Idea general de InkTrack

InkTrack es una app tipo **POS / control de negocio pequeño** pensada para comercios que quieren llevar un registro sencillo de:

- Clientes que compran (a veces “a fiado”).
- Proveedores que traen mercadería.
- Inventario de productos y stock mínimo.
- Movimientos de dinero (ingresos y egresos).
- Ventas registradas día a día.

La app está construida con **Flutter** y usa una base de datos local con **Drift** (`AppDatabase`), para que funcione sin conexión.

### Usuarios principales

- Dueños y encargados de pequeños comercios o kioscos.
- Personas que necesitan ver rápido:
  - cuánto stock tienen,
  - qué deben a proveedores,
  - qué les deben los clientes,
  - y el resumen de movimientos del día.
  - Resumen de perdidas, ganacias y productos mas vendidos.

### Objetivo del producto

- Dar una vista clara y amigable del negocio desde la pantalla principal (`MainLayoutPage`).
- Tener un dashboard amigable para un ownder de un negocio sin dolores de cabeza
- Funcionalidad de OCR para leer facturas de proveedores y extraer fiados desde un cuaderno
- Poder manejar productos en el inventario a travez de un codigo de barras.
- Permitir registrar movimientos, clientes, proveedores, productos y ventas **rápido y sin fricción**.
- Mantener los datos **locales y bajo control** del usuario.

### Criterios de éxito (versión simple)

- La app inicia sin errores y abre siempre en la pantalla principal.
- Desde la pantalla principal se puede navegar a:
  - Clientes,
  - Proveedores,
  - Inventario,
  - Movimientos.
- El dueño puede registrar un nuevo movimiento, cliente, proveedor o producto en pocos pasos.

Este archivo sirve como punto de partida conceptual.  
Los detalles concretos de comportamiento vivirán en las carpetas de `specs/` (por ejemplo, `SPEC-001` para el arranque y layout principal).

