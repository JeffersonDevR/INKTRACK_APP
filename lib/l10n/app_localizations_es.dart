// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'InkTrack';

  @override
  String get home => 'Inicio';

  @override
  String get clientes => 'Clientes';

  @override
  String get proveedores => 'Proveedores';

  @override
  String get inventario => 'Inventario';

  @override
  String get stock => 'Stock';

  @override
  String get reportes => 'Reportes';

  @override
  String get perfil => 'Perfil';

  @override
  String get modoOscuro => 'Modo Oscuro';

  @override
  String get cerrarSesion => 'Cerrar Sesión';

  @override
  String get email => 'Email';

  @override
  String get cancelar => 'Cancelar';

  @override
  String get guardar => 'Guardar';

  @override
  String get idioma => 'Idioma';

  @override
  String get usuario => 'Usuario';

  @override
  String get admin => 'Admin';

  @override
  String get userId => 'ID de Usuario';

  @override
  String get noDisponible => 'No disponible';

  @override
  String get cerrarSesionTitulo => 'Cerrar Sesión';

  @override
  String get cerrarSesionPregunta => '¿Estás seguro de que quieres cerrar sesión?';

  @override
  String get panelDeInicio => 'Panel de Inicio';

  @override
  String get gestionDeClientes => 'Gestión de Clientes';

  @override
  String get proveedoresHeader => 'Proveedores';

  @override
  String get controlDeInventario => 'Control de Inventario';

  @override
  String get reportesDeNegocio => 'Reportes de Negocio';

  @override
  String get sinLocal => 'Sin local';

  @override
  String get movimientos => 'Movimientos';

  @override
  String get productos => 'Productos';

  @override
  String get excel => 'Excel';

  @override
  String get pdf => 'PDF';

  @override
  String get egreso => 'Egreso';

  @override
  String get ingreso => 'Ingreso';

  @override
  String get ocr => 'OCR';

  @override
  String get codigo => 'Código';

  @override
  String get producto => 'Producto';

  @override
  String get cliente => 'Cliente';

  @override
  String get proveedor => 'Proveedor';

  @override
  String get nuevoPedido => 'Nuevo Pedido';

  @override
  String get restock => 'Restock';

  @override
  String get clientesTitulo => 'Clientes';

  @override
  String get proveedoresTitulo => 'Proveedores';

  @override
  String get inventarioTitulo => 'Inventario';

  @override
  String get reportesTitulo => 'Reportes';

  @override
  String pdfExportado(String filename) {
    return 'PDF exportado: $filename';
  }

  @override
  String excelExportado(String filename) {
    return 'Excel exportado: $filename';
  }

  @override
  String errorAlExportarPdf(String error) {
    return 'Error al exportar PDF: $error';
  }

  @override
  String errorAlExportarExcel(String error) {
    return 'Error al exportar Excel: $error';
  }

  @override
  String entregasPendientes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count entregas pendientes',
      one: '1 entrega pendiente',
    );
    return '$_temp0';
  }

  @override
  String get verPedidos => 'Ver Pedidos';

  @override
  String get detalleMovimiento => 'Detalle de movimiento';

  @override
  String get concepto => 'Concepto';

  @override
  String get monto => 'Monto';

  @override
  String get fecha => 'Fecha';

  @override
  String get categoria => 'Categoría';

  @override
  String get tipo => 'Tipo';

  @override
  String get resultados => 'Resultados';

  @override
  String get acumuladoTotal => 'Reporte general';

  @override
  String get ventasTotales => 'Ventas';

  @override
  String get gastosTotales => 'Gastos';

  @override
  String get patrimonio => 'Patrimonio';

  @override
  String get balanceNeto => 'Balance Neto';

  @override
  String get tendenciaFlujo => 'Tendencia de Flujo';

  @override
  String get actividadReciente => 'Actividad Reciente';

  @override
  String get resultadosFiltro => 'Resultados del Filtro';

  @override
  String get limpiar => 'Limpiar';

  @override
  String get noHayActividadRegistrada => 'No hay actividad registrada';

  @override
  String get tusMovimientosApareceranAqui => 'Tus movimientos aparecerán aquí';

  @override
  String get egresoTipo => 'Egreso';

  @override
  String get actividad => 'Actividad';

  @override
  String get resumenClientes => 'Resumen\nClientes';

  @override
  String get resumenFinanciero => 'Resumen\nFinanciero';

  @override
  String get hoy => 'Hoy';

  @override
  String get si => 'Sí';

  @override
  String get no => 'No';

  @override
  String get inicio => 'Inicio';

  @override
  String get fin => 'Fin';

  @override
  String periodo(String start, String end) {
    return 'Período: $start - $end';
  }

  @override
  String get inventarioHoja => 'Inventario';

  @override
  String get clientesHoja => 'Clientes';

  @override
  String get nombre => 'Nombre';

  @override
  String get precio => 'Precio';

  @override
  String get valorTotal => 'Valor Total';

  @override
  String get clientesCategoria => 'Clientes';

  @override
  String get proveedoresCategoria => 'Proveedores';

  @override
  String get fiado => 'Acreedores';

  @override
  String get miercoles => 'Miércoles';

  @override
  String get resumenProveedores => 'Resumen\nProveedores';

  @override
  String get total => 'Total';

  @override
  String get listadoProveedores => 'Listado de Proveedores';

  @override
  String get editar => 'Editar';

  @override
  String get eliminar => 'Eliminar';

  @override
  String get crear => 'Crear';

  @override
  String get actualizar => 'Actualizar';

  @override
  String get agregar => 'Agregar';

  @override
  String get buscar => 'Buscar';

  @override
  String get filtro => 'Filtro';

  @override
  String get catalogoProductos => 'Catálogo de Productos';

  @override
  String get controlDeInventarioTitle => 'Control de\nInventario';

  @override
  String get valorStock => 'Valor Stock';

  @override
  String get deudaTotal => 'Deuda Total';

  @override
  String get listadoClientes => 'Listado de Clientes';

  @override
  String get pedidosProveedores => 'Pedidos a Proveedores';

  @override
  String get pedidosPendientes => 'Pedidos Pendientes';

  @override
  String get nuevoIngreso => 'Nuevo Ingreso';

  @override
  String get nuevoEgreso => 'Nuevo Egreso';

  @override
  String get montoTotal => 'Monto Total';

  @override
  String get totalProductos => 'Total Productos';

  @override
  String get nuevoPedidoProveedor => 'Nuevo Pedido';

  @override
  String get seleccionarProveedor => 'Seleccionar Proveedor';

  @override
  String get fechaEntrega => 'Fecha de Entrega';

  @override
  String get estado => 'Estado';

  @override
  String get estadoPendiente => 'Pendiente';

  @override
  String get estadoCompletado => 'Completado';

  @override
  String get estadoCancelado => 'Cancelado';

  @override
  String get noDataAvailable => 'No hay datos disponibles';

  @override
  String get onCredit => 'Acreedores';

  @override
  String get cash => 'Efectivo';

  @override
  String get registrarVenta => 'Registrar Venta';

  @override
  String get carrito => 'Carrito';

  @override
  String get finalizarVenta => 'Finalizar Venta';

  @override
  String get cobrar => 'Cobrar';

  @override
  String get efectivo => 'Efectivo';

  @override
  String get transferencia => 'Transferencia';

  @override
  String get pagoMixto => 'Pago Mixto';

  @override
  String get contenido => 'Contenido';

  @override
  String get observaciones => 'Observaciones';

  @override
  String get descripcion => 'Descripción';

  @override
  String get telefono => 'Teléfono';

  @override
  String get direccion => 'Dirección';

  @override
  String get notas => 'Notas';

  @override
  String get bodega => 'Bodega';

  @override
  String get local => 'Local';

  @override
  String get resetData => 'Restablecer Datos';

  @override
  String get resetearData => 'Esto eliminará TODOS los datos de la app (productos, clientes, proveedores, ventas, movimientos, locales).';

  @override
  String get resetDataTitle => 'Restablecer Todos los Datos';

  @override
  String get noLocales => 'No hay locales registrados';

  @override
  String get datosIncorrectos => 'Datos incorrectos';

  @override
  String get nombreRequerido => 'El nombre es requerido';

  @override
  String get camposRequeridos => 'Campos requeridos';

  @override
  String get verificarInformacion => 'Por favor verifica la información';

  @override
  String get seleccionarLocal => 'Seleccionar Local';

  @override
  String get ubicacion => 'Ubicación';

  @override
  String get stockMinimo => 'Stock Mínimo';

  @override
  String get stockActual => 'Stock Actual';

  @override
  String get codigoBarras => 'Código de Barras';

  @override
  String get precioVenta => 'Precio de Venta';

  @override
  String get precioCompra => 'Precio de Compra';

  @override
  String get ganancia => 'Ganancia';

  @override
  String get nuevoProducto => 'Nuevo Producto';

  @override
  String get nuevoCliente => 'Nuevo Cliente';

  @override
  String get nuevoProveedor => 'Nuevo Proveedor';

  @override
  String get saldoPendiente => 'Saldo Pendiente';

  @override
  String get abonar => 'Abonar';

  @override
  String get abono => 'Abono';

  @override
  String get abonos => 'Abonos';

  @override
  String get abonoAgregado => 'Abono agregado';

  @override
  String get errorAgregarAbono => 'Error al agregar abono';

  @override
  String get montoAbono => 'Monto del Abono';

  @override
  String get deudaPendiente => 'Deuda Pendiente';

  @override
  String get deudaActual => 'Deuda Actual';

  @override
  String get nuevoMovimiento => 'Nuevo Movimiento';

  @override
  String get conceptoMovimiento => 'Concepto del Movimiento';

  @override
  String get movimientoAgregado => 'Movimiento agregado';

  @override
  String get errorAgregarMovimiento => 'Error al agregar movimiento';

  @override
  String get misLocales => 'Mis Locales';

  @override
  String get agregarLocal => 'Agregar Local';

  @override
  String get eliminarTodosLosDatos => 'Eliminar Todos los Datos';

  @override
  String get agregaTuPrimeraTienda => 'Agrega tu primera tienda o local';

  @override
  String get actual => 'Actual';

  @override
  String get seleccionar => 'Seleccionar';

  @override
  String get nuevoLocal => 'Nuevo Local';

  @override
  String get editarLocal => 'Editar Local';

  @override
  String get tienda => 'Tienda';

  @override
  String get oficina => 'Oficina';

  @override
  String get noHayPedidos => 'No hay pedidos';

  @override
  String get creaUnPedidoProveedor => 'Crea un pedido a proveedor para recibir alertas de entrega.';

  @override
  String get pedidosDelProveedor => 'Pedidos del Proveedor';

  @override
  String get bajo => 'Bajo';

  @override
  String get editarProducto => 'Editar Producto';

  @override
  String get desactivarProducto => 'Desactivar Producto';

  @override
  String get reactivarProducto => 'Reactivar Producto';

  @override
  String reactivarEnCatalogo(String name) {
    return '¿Reactivar \"$name\" en el catálogo?';
  }

  @override
  String get inventarioVacio => 'Inventario vacío';

  @override
  String get comienzaAgregandoProductos => 'Comienza agregando productos manualmente o escaneando códigos de barras.';

  @override
  String get errorAlGuardar => 'Error al guardar';

  @override
  String get productoGuardado => 'Producto guardado';

  @override
  String get categoriaProducto => 'Categoría';

  @override
  String get proveedorProducto => 'Proveedor';

  @override
  String get sinProveedor => 'Sin proveedor';

  @override
  String get escanerCodigoBarras => 'Escáner de Código de Barras';

  @override
  String get subiendoCambios => 'Subiendo cambios...';

  @override
  String get descargandoDeLaNube => 'Descargando de la nube...';

  @override
  String get sincronizandoTodo => 'Sincronizando todo...';

  @override
  String get subirCambios => 'Subir Cambios';

  @override
  String get descargarDeLaNube => 'Descargar de la Nube';

  @override
  String get sincronizarTodo => 'Sincronizar Todo';

  @override
  String get reportesFinancieros => 'Reportes Financieros';

  @override
  String get periodoDeAnalisis => 'PERÍODO DE ANÁLISIS';

  @override
  String get seleccionarPeriodo => 'Seleccionar Período';

  @override
  String get ingresosTotales => 'INGRESOS TOTALES';

  @override
  String get egresosTotales => 'EGRESOS TOTALES';

  @override
  String get ventasRealizadas => 'VENTAS REALIZADAS';

  @override
  String get utilidadNeta => 'UTILIDAD NETA';

  @override
  String get ventasVsGastos => 'Ventas vs Gastos';

  @override
  String get distribucionGastos => 'Distribución de Gastos';

  @override
  String get sinCategoria => 'Sin Categoría';

  @override
  String get otros => 'Otros';

  @override
  String semana(int number) {
    return 'SEM $number';
  }

  @override
  String get sinGastosRegistrados => 'Sin gastos registrados';

  @override
  String get editarProveedor => 'Editar Proveedor';

  @override
  String get editarCliente => 'Editar Cliente';

  @override
  String get guardarActualizar => 'Actualizar';

  @override
  String get cantidad => 'Cantidad';

  @override
  String get agregarProducto => 'Agregar Producto';

  @override
  String get escanearCodigoBarras => 'Escanear Código de Barras';

  @override
  String get buscarProducto => 'Buscar Producto';

  @override
  String get guardadoExitoso => 'Guardado exitosamente';

  @override
  String get ingreseNombre => 'Por favor ingrese el nombre';

  @override
  String get minimo2Caracteres => 'Mínimo 2 caracteres';

  @override
  String get ingreseTelefono => 'Por favor ingrese el teléfono';

  @override
  String get telefono10Digitos => 'El teléfono debe tener exactamente 10 dígitos';

  @override
  String get digitos10SinEspacios => '10 dígitos sin espacios';

  @override
  String get ingreseEmail => 'Por favor ingrese el email';

  @override
  String get ingreseEmailValido => 'Por favor ingrese un email válido';

  @override
  String get diasVisita => 'Días de visita';

  @override
  String get lunes => 'Lunes';

  @override
  String get martes => 'Martes';

  @override
  String get jueves => 'Jueves';

  @override
  String get viernes => 'Viernes';

  @override
  String get sabado => 'Sábado';

  @override
  String get domingo => 'Domingo';

  @override
  String get nuevaCategoria => 'Nueva Categoría';

  @override
  String get nombreCategoria => 'Nombre de la categoría';

  @override
  String get seleccioneCategoria => 'Seleccione una categoría';

  @override
  String get seleccioneOCreeCategoria => 'Seleccione o cree una categoría';

  @override
  String get ingreseMonto => 'Ingrese un monto';

  @override
  String get montoInvalido => 'Monto inválido';

  @override
  String get ingreseConcepto => 'Ingrese un concepto';

  @override
  String get clienteOpcional => 'Cliente (Opcional)';

  @override
  String get ninguno => 'Ninguno';

  @override
  String get ventaFiada => 'Venta Fiada';

  @override
  String get anadirSaldoPendiente => 'Añadir al saldo pendiente del cliente';

  @override
  String get calculadoAutomaticamente => 'Calculado automáticamente';

  @override
  String get sinClienteVentaGeneral => 'Sin cliente (venta general)';

  @override
  String get escribirNombreCliente => 'Escribir nombre del cliente';

  @override
  String get ingreseNombreCliente => 'Ingrese el nombre del cliente';

  @override
  String get ventaCreditoFiado => 'Venta a crédito (Acreedores)';

  @override
  String get aumentaraSaldoPendiente => 'Aumentará el saldo pendiente del cliente';

  @override
  String get noHayProductos => 'No hay productos';

  @override
  String get escaneeOAgregueProductos => 'Escanee o agregue productos del inventario';

  @override
  String get ingreseMontoVenta => 'Ingrese el monto';

  @override
  String get montoMayorCero => 'El monto debe ser mayor a 0';

  @override
  String get precioUnitario => 'Precio unitario';

  @override
  String get escanearNotaRecibo => 'Escanear Nota / Recibo';

  @override
  String get camara => 'Cámara';

  @override
  String get galeria => 'Galería';

  @override
  String get datosDetectados => 'Datos detectados:';

  @override
  String montoDetectado(String amount) {
    return 'Monto: $amount';
  }

  @override
  String clienteDetectado(String name) {
    return 'Cliente: $name';
  }

  @override
  String get noSeDetectaronDatos => 'No se detectaron datos claros. Intente de nuevo.';

  @override
  String get ingreseConceptoVenta => 'Ingrese el concepto';

  @override
  String productoInactivo(String name) {
    return 'El producto \"$name\" está inactivo';
  }

  @override
  String noHaySuficienteStock(String name, int available) {
    return 'No hay suficiente stock de \"$name\". Disponible: $available';
  }

  @override
  String get ventaRegistradaExito => 'Venta registrada con éxito';

  @override
  String get escanear => 'Escanear';

  @override
  String get agregarProductoTitle => 'Agregar Producto';

  @override
  String get buscarProductoPlaceholder => 'Buscar producto';

  @override
  String stockLabel(int stock) {
    return 'Stock: $stock';
  }

  @override
  String get ejemploNombre => 'Ej. Juan Pérez';

  @override
  String get ejemploTelefono => 'Ej. 3001234567';

  @override
  String get ejemploEmail => 'ejemplo@correo.com';

  @override
  String get proveedorOpcional => 'Proveedor (Opcional)';

  @override
  String get clienteOpcionalLabel => 'Cliente (Opcional)';

  @override
  String get ingreseElMonto => 'Ingrese el monto';

  @override
  String get maximoMonto => 'Máximo 999,999,999';

  @override
  String get clienteOpcional2 => 'Cliente (opcional)';

  @override
  String get guardarVenta => 'Guardar venta';

  @override
  String get ventaRegistradaExitoMsg => 'Venta registrada con éxito';

  @override
  String get productoNoEncontrado => 'Producto no encontrado en el inventario';

  @override
  String restockLabel(String name) {
    return 'Restock: $name';
  }

  @override
  String get escanearCodigoTitulo => 'Escanear Código';

  @override
  String get historialMovimientos => 'Historial de Movimientos';

  @override
  String get historialVisitas => 'Historial de Visitas';

  @override
  String get recentRecords => 'Registros Recientes';

  @override
  String get resultadosFiltroTitle => 'Resultados Filtrados';

  @override
  String totalItems(int count) {
    return 'Total: $count';
  }

  @override
  String get limpiarFiltro => 'Limpiar Filtro';

  @override
  String get eliminarRegistro => 'Eliminar Registro';

  @override
  String get confirmarEliminarRegistro => '¿Estás seguro de que deseas eliminar este registro permanentemente?';

  @override
  String get historialVacio => 'Historial vacío';

  @override
  String get noHayRegistros => 'No hay registros de ingresos o egresos todavía.';

  @override
  String get editarRegistro => 'Editar';

  @override
  String get movementHistoryTitle => 'Historial de Movimientos';

  @override
  String get clearFilterBtn => 'Limpiar Filtro';

  @override
  String get emptyHistoryTitle => 'Historial vacío';

  @override
  String get noRecordsYet => 'No hay registros de ingresos o egresos todavía.';

  @override
  String get deleteRecordTitle => 'Eliminar Registro';

  @override
  String get confirmDeleteRecord => '¿Estás seguro de que deseas eliminar este registro permanentemente?';

  @override
  String get password => 'Contraseña';

  @override
  String get signIn => 'Iniciar sesión';

  @override
  String get signInToContinue => 'Inicia sesión para continuar';

  @override
  String get forgotPassword => '¿Olvidaste tu contraseña?';

  @override
  String get dontHaveAccount => '¿No tienes cuenta?';

  @override
  String get signUp => 'Registrarse';

  @override
  String get createAccount => 'Crear cuenta';

  @override
  String get firstUserAdmin => 'El primer usuario será admin';

  @override
  String get fullName => 'Nombre completo';

  @override
  String get confirmPassword => 'Confirmar contraseña';

  @override
  String get alreadyHaveAccount => '¿Ya tienes cuenta?';

  @override
  String get enterYourEmail => 'Ingresa tu correo';

  @override
  String get enterValidEmail => 'Ingresa un correo válido';

  @override
  String get enterYourPassword => 'Ingresa tu contraseña';

  @override
  String get enterYourName => 'Ingresa tu nombre';

  @override
  String get enterAPassword => 'Ingresa una contraseña';

  @override
  String get confirmYourPassword => 'Confirma tu contraseña';

  @override
  String get passwordsDoNotMatch => 'Las contraseñas no coinciden';

  @override
  String get passwordResetSent => 'Correo de restablecimiento enviado';

  @override
  String get failedToSendReset => 'Error al enviar correo';

  @override
  String get loginFailed => 'Error al iniciar sesión';

  @override
  String get passwordHint => 'Mín 8 carac., 1 mayúsc., 3 núm., sin caracteres especiales';

  @override
  String get ingresos => 'Ingresos';

  @override
  String get egresos => 'Egresos';

  @override
  String get acreedores => 'Acreedores';

  @override
  String get ocultar => 'Ocultar';

  @override
  String get ver => 'Ver';

  @override
  String get import => 'Importar';

  @override
  String get importando => 'Importando...';

  @override
  String get importSuccess => 'Importación exitosa';

  @override
  String get importError => 'Error de importación';

  @override
  String get reactivate => 'Reactivar';

  @override
  String get deactivate => 'Desactivar';

  @override
  String get inactive => 'INACTIVO';

  @override
  String get stockBajo => 'Stock Bajo';

  @override
  String get valor => 'Valor';

  @override
  String get sincro => 'Sincro';

  @override
  String get view => 'Ver';

  @override
  String get delete => 'Eliminar';

  @override
  String get registrarPago => 'Registrar pago';

  @override
  String get montoAPagar => 'Monto a pagar';

  @override
  String get codigoProducto => 'Código del producto';

  @override
  String get ean13Colombia => 'EAN-13 Colombia';

  @override
  String get cerrar => 'Cerrar';

  @override
  String get importData => 'Importar datos';

  @override
  String get localConDatos => 'Local con datos';

  @override
  String get queDeseasHacer => '¿Qué deseas hacer?';

  @override
  String get eliminarIgual => 'Eliminar igual';

  @override
  String get todosLosDatosEliminados => 'Todos los datos eliminados';

  @override
  String get ultimasTransacciones => 'Últimas transacciones';

  @override
  String get ventas => 'Ventas';

  @override
  String get gastos => 'Gastos';

  @override
  String get reporteGeneral => 'Reporte general';

  @override
  String tendenciaUltimos(int days) {
    return 'Tendencia (últimos $days días)';
  }

  @override
  String get productoYaExiste => 'Producto ya existe';

  @override
  String productoYaExisteMensaje(String codigo, String nombre) {
    return 'El código de barras "$codigo" pertenece al producto "$nombre". ¿Qué deseas hacer?';
  }

  @override
  String get crearMovimiento => 'Crear movimiento';

  @override
  String get margenGanancia => 'Margen de Ganancia';

  @override
  String get porcentajeGanancia => 'Porcentaje de Ganancia';

  @override
  String get gananciaNeta => 'Ganancia Neta';

  @override
  String get costo => 'Costo';

  @override
  String get ejemploNombreProducto => 'Ej. Tinta negra 50ml';

  @override
  String get ingreseNombreProducto => 'Ingrese el nombre del producto';

  @override
  String get codigoPersonalizado => 'Código personalizado';

  @override
  String get ejemploCodigoPersonalizado => 'Código de cliente/proveedor';

  @override
  String get ayudaCodigoPersonalizado => 'Ej. ZAP-001, PAP-045 (opcional)';

  @override
  String get vincularCodigoBarras => 'Vincular a código de barras';

  @override
  String get vinculadoACodigoPersonalizado => 'Vinculado a código personalizado';

  @override
  String get autoGenerado => 'Auto-generado';

  @override
  String get generar => 'Generar';

  @override
  String get maximo99Unidades => 'Máximo 99 unidades';

  @override
  String get ingreseCantidad => 'Ingrese la cantidad';

  @override
  String get cantidadInvalida => 'Cantidad inválida';

  @override
  String get esPaqueteCaja => 'Es Paquete/Caja';

  @override
  String get ventaPorUnidadesEmpaque => 'Venta por unidades dentro de un empaque';

  @override
  String get unidadesPorPaquete => 'Unidades por Paquete';

  @override
  String get ingreseUnidades => 'Ingrese unidades';

  @override
  String get debeSerMayorACero => 'Debe ser mayor a 0';

  @override
  String get ingresePrecio => 'Ingrese el precio';

  @override
  String get precioInvalido => 'Precio inválido';

  @override
  String get alertaStockBajo => 'Alerta cuando el stock caiga por debajo de este nivel';

  @override
  String get ingreseStockMinimo => 'Ingrese el stock mínimo';

  @override
  String get stockMinimoInvalido => 'Stock mínimo inválido';

  @override
  String get maximo9999 => 'Máximo 9999';

  @override
  String get escribirNombreProveedor => 'Escribir nombre del proveedor';

  @override
  String get seleccioneProveedorOEscribaNombre => 'Seleccione un proveedor o use "Escribir nombre"';

  @override
  String get escribaNombreProveedor => 'Escriba el nombre del proveedor';

  @override
  String get seleccioneUnProveedor => 'Seleccione un proveedor';

  @override
  String get nombreProveedor => 'Nombre del proveedor';

  @override
  String get ejemploProveedor => 'Ej. Distribuidora XYZ';

  @override
  String get ingreseNombreProveedor => 'Ingrese el nombre del proveedor';

  @override
  String get productoActualizado => 'Producto actualizado';

  @override
  String get ingreseCodigoPersonalizadoPrimero => 'Ingrese un código personalizado primero';

  @override
  String get productoYaExisteSimple => 'Ya existe un producto con este código de barras.';

  @override
  String get verProducto => 'Ver producto';

  @override
  String get agregueAlMenosUnProducto => 'Agregue al menos un producto';

  @override
  String get pedidoCreadoCorrectamente => 'Pedido creado correctamente';

  @override
  String get crearPedido => 'Crear pedido';
}
