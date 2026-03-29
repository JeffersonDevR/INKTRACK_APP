## Bitácora diaria – 2026-03-15 – Initial SDD setup

- Especificaciones trabajadas: **SPEC-001** (InkTrack startup and main layout)

### Objetivo de la sesión

Integrar la estructura de Spec-Driven Development (`idea/`, `specs/`, `bitacora/`) en InkTrack sin romper el comportamiento actual, y documentar el flujo de inicio y layout principal.

### Qué se hizo hoy

- Se crearon las carpetas base:
  - `idea/`, `specs/`, `bitacora/`, `docs/`.
- Se escribió `idea/IDEA_GENERAL.md` con la idea general del producto InkTrack.
- Se configuró `specs/`:
  - `specs/README.md` explicando cómo usamos specs.
  - `specs/INDEX.md` con la entrada `001 – InkTrack startup and main layout`.
  - Plantillas en `specs/_template/` para futuros specs.
- Se creó el primer bundle de especificación:
  - `specs/001-inktrack-startup-main-layout/spec.md` (comportamiento actual de arranque y layout principal).
  - `plan.md`, `tasks.md`, `history.md` para `SPEC-001`.
- Se definió una convención de trazabilidad:
  - Specs usan IDs (`SPEC-001`).
  - `spec.md` enlaza a archivos de código relevantes (`lib/main.dart`, `database.dart`, `app_theme.dart`, `main_layout_page.dart`).
  - La bitácora referencia los IDs de las specs tocadas.

### Confirmación de comportamiento

- No se modificó ningún archivo Dart relacionado con lógica o UI.
- La intención es que la app siga comportándose exactamente igual; solo se añadieron archivos de documentación y estructura SDD.

### Próximos pasos

- Crear nuevas especificaciones para:
  - Clientes (lifecycle básico).
  - Inventario.
  - Ventas.
- Añadir pruebas automáticas mínimas para `SPEC-001` (tests de arranque y pantalla inicial).
- Usar esta misma estructura (`spec.md`, `plan.md`, `tasks.md`, `history.md`, `bitacora/`) en futuras sesiones.

