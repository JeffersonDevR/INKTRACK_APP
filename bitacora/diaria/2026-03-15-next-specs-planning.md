## Bitácora diaria – 2026-03-15 – Next specs planning (SPEC-003, 004, 005)

- Especificaciones trabajadas: **SPEC-003**, **SPEC-004**, **SPEC-005**

### Objetivo de la sesión

Crear los bundles de especificación para las tres áreas de funcionalidad principales que ya tienen código pero no tenían documentación SDD: Clientes, Inventario, y Ventas/Movimientos.

### Qué se hizo hoy

- Se llegó a un acuerdo sobre la stack: **Flutter + Drift + Riverpod** (corregido en `MANDATORY.md`).
- Se creó el archivo `specs/MANDATORY.md` con las convenciones SDD del proyecto, incluyendo:
  - Reglas obligatorias por spec (SPEC-001, SPEC-002).
  - Convención de stack y proceso de aprobación.
  - Mezcla SDD + TDD: specs y tasks primero, código después de aprobación.
- Se actualizó `specs/INDEX.md` para incluir SPEC-003, 004, y 005 (status: draft).
- Se crearon los bundles completos (`spec.md`, `plan.md`, `tasks.md`, `history.md`) para:
  - **SPEC-003** – Clientes basic lifecycle (CRUD, fiado, saldoPendiente).
  - **SPEC-004** – Inventario basic lifecycle (CRUD, barcode scan, stock alerts).
  - **SPEC-005** – Ventas and movements (sales flow, ingresos/egresos, KPIs dashboard).

### Confirmación de comportamiento

- No se modificó ningún archivo Dart.
- Solo se crearon y actualizaron archivos de documentación/especificación.

### Próximos pasos

- Verificar comportamientos abiertos en las `tasks.md` de SPEC-003, 004 y 005.
- Proponer spec SPEC-006 para la funcionalidad de OCR (facturas y cuadernos).
- Comenzar fase TDD: escribir widget tests para los criterios de aceptación definidos en cada spec.
