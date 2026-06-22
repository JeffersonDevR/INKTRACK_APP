// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'InkTrack';

  @override
  String get home => 'Home';

  @override
  String get clientes => 'Clients';

  @override
  String get proveedores => 'Suppliers';

  @override
  String get inventario => 'Inventory';

  @override
  String get stock => 'Stock';

  @override
  String get reportes => 'Reports';

  @override
  String get perfil => 'Profile';

  @override
  String get modoOscuro => 'Dark Mode';

  @override
  String get cerrarSesion => 'Logout';

  @override
  String get email => 'Email';

  @override
  String get cancelar => 'Cancel';

  @override
  String get guardar => 'Save';

  @override
  String get idioma => 'Language';

  @override
  String get usuario => 'User';

  @override
  String get admin => 'Admin';

  @override
  String get userId => 'User ID';

  @override
  String get noDisponible => 'Not available';

  @override
  String get cerrarSesionTitulo => 'Logout';

  @override
  String get cerrarSesionPregunta => 'Are you sure you want to logout?';

  @override
  String get panelDeInicio => 'Home Panel';

  @override
  String get gestionDeClientes => 'Client Management';

  @override
  String get proveedoresHeader => 'Suppliers';

  @override
  String get controlDeInventario => 'Inventory Control';

  @override
  String get reportesDeNegocio => 'Business Reports';

  @override
  String get sinLocal => 'No location selected';

  @override
  String get movimientos => 'Movements';

  @override
  String get productos => 'Products';

  @override
  String get excel => 'Excel';

  @override
  String get pdf => 'PDF';

  @override
  String get egreso => 'Expense';

  @override
  String get ingreso => 'Income';

  @override
  String get ocr => 'OCR';

  @override
  String get codigo => 'Barcode';

  @override
  String get producto => 'Product';

  @override
  String get cliente => 'Client';

  @override
  String get proveedor => 'Supplier';

  @override
  String get nuevoPedido => 'New Order';

  @override
  String get restock => 'Restock';

  @override
  String get clientesTitulo => 'Clients';

  @override
  String get proveedoresTitulo => 'Suppliers';

  @override
  String get inventarioTitulo => 'Inventory';

  @override
  String get reportesTitulo => 'Reports';

  @override
  String pdfExportado(String filename) {
    return 'PDF exported: $filename';
  }

  @override
  String excelExportado(String filename) {
    return 'Excel exported: $filename';
  }

  @override
  String errorAlExportarPdf(String error) {
    return 'Error exporting PDF: $error';
  }

  @override
  String errorAlExportarExcel(String error) {
    return 'Error exporting Excel: $error';
  }

  @override
  String entregasPendientes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pending deliveries',
      one: '1 pending delivery',
    );
    return '$_temp0';
  }

  @override
  String get verPedidos => 'View Orders';

  @override
  String get detalleMovimiento => 'Movement Detail';

  @override
  String get concepto => 'Concept';

  @override
  String get monto => 'Amount';

  @override
  String get fecha => 'Date';

  @override
  String get categoria => 'Category';

  @override
  String get tipo => 'Type';

  @override
  String get resultados => 'Results';

  @override
  String get acumuladoTotal => 'General Report';

  @override
  String get ventasTotales => 'Sales';

  @override
  String get gastosTotales => 'Expenses';

  @override
  String get patrimonio => 'Equity';

  @override
  String get balanceNeto => 'Net Balance';

  @override
  String get tendenciaFlujo => 'Cash Flow Trend';

  @override
  String get actividadReciente => 'Recent Activity';

  @override
  String get resultadosFiltro => 'Filter Results';

  @override
  String get limpiar => 'Clear';

  @override
  String get noHayActividadRegistrada => 'No activity recorded';

  @override
  String get tusMovimientosApareceranAqui => 'Your movements will appear here';

  @override
  String get egresoTipo => 'Expense';

  @override
  String get actividad => 'Activity';

  @override
  String get resumenClientes => 'Clients\nSummary';

  @override
  String get resumenFinanciero => 'Financial\nSummary';

  @override
  String get hoy => 'Today';

  @override
  String get si => 'Yes';

  @override
  String get no => 'No';

  @override
  String get inicio => 'Start';

  @override
  String get fin => 'End';

  @override
  String periodo(String start, String end) {
    return 'Period: $start - $end';
  }

  @override
  String get inventarioHoja => 'Inventory';

  @override
  String get clientesHoja => 'Clients';

  @override
  String get nombre => 'Name';

  @override
  String get precio => 'Price';

  @override
  String get valorTotal => 'Total Value';

  @override
  String get clientesCategoria => 'Clients';

  @override
  String get proveedoresCategoria => 'Suppliers';

  @override
  String get fiado => 'On Credit';

  @override
  String get miercoles => 'Wednesday';

  @override
  String get resumenProveedores => 'Supplier\nSummary';

  @override
  String get total => 'Total';

  @override
  String get listadoProveedores => 'Suppliers List';

  @override
  String get editar => 'Edit';

  @override
  String get eliminar => 'Delete';

  @override
  String get crear => 'Create';

  @override
  String get actualizar => 'Update';

  @override
  String get agregar => 'Add';

  @override
  String get buscar => 'Search';

  @override
  String get filtro => 'Filter';

  @override
  String get catalogoProductos => 'Product Catalog';

  @override
  String get controlDeInventarioTitle => 'Inventory\nControl';

  @override
  String get valorStock => 'Stock Value';

  @override
  String get deudaTotal => 'Total Debt';

  @override
  String get listadoClientes => 'Clients List';

  @override
  String get pedidosProveedores => 'Supplier Orders';

  @override
  String get pedidosPendientes => 'Pending Orders';

  @override
  String get nuevoIngreso => 'New Income';

  @override
  String get nuevoEgreso => 'New Expense';

  @override
  String get montoTotal => 'Total Amount';

  @override
  String get totalProductos => 'Total Products';

  @override
  String get nuevoPedidoProveedor => 'New Supplier Order';

  @override
  String get seleccionarProveedor => 'Select Supplier';

  @override
  String get fechaEntrega => 'Delivery Date';

  @override
  String get estado => 'Status';

  @override
  String get estadoPendiente => 'Pending';

  @override
  String get estadoCompletado => 'Completed';

  @override
  String get estadoCancelado => 'Cancelled';

  @override
  String get noDataAvailable => 'No data available';

  @override
  String get onCredit => 'On Credit';

  @override
  String get cash => 'Cash';

  @override
  String get registrarVenta => 'Register Sale';

  @override
  String get carrito => 'Cart';

  @override
  String get finalizarVenta => 'Finalize Sale';

  @override
  String get cobrar => 'Charge';

  @override
  String get efectivo => 'Cash';

  @override
  String get transferencia => 'Transfer';

  @override
  String get pagoMixto => 'Mixed Payment';

  @override
  String get contenido => 'Content';

  @override
  String get observaciones => 'Observations';

  @override
  String get descripcion => 'Description';

  @override
  String get telefono => 'Phone';

  @override
  String get direccion => 'Address';

  @override
  String get notas => 'Notes';

  @override
  String get bodega => 'Warehouse';

  @override
  String get local => 'Store';

  @override
  String get resetData => 'Reset Data';

  @override
  String get resetearData => 'This will delete ALL app data (products, clients, suppliers, sales, movements, locations).';

  @override
  String get resetDataTitle => 'Reset All Data';

  @override
  String get noLocales => 'No locations registered';

  @override
  String get datosIncorrectos => 'Incorrect data';

  @override
  String get nombreRequerido => 'Name is required';

  @override
  String get camposRequeridos => 'Required fields';

  @override
  String get verificarInformacion => 'Please verify the information';

  @override
  String get seleccionarLocal => 'Select Location';

  @override
  String get ubicacion => 'Location';

  @override
  String get stockMinimo => 'Min Stock';

  @override
  String get stockActual => 'Current Stock';

  @override
  String get codigoBarras => 'Barcode';

  @override
  String get precioVenta => 'Sale Price';

  @override
  String get precioCompra => 'Purchase Price';

  @override
  String get ganancia => 'Profit';

  @override
  String get nuevoProducto => 'New Product';

  @override
  String get nuevoCliente => 'New Client';

  @override
  String get nuevoProveedor => 'New Supplier';

  @override
  String get saldoPendiente => 'Pending Balance';

  @override
  String get abonar => 'Pay';

  @override
  String get abono => 'Payment';

  @override
  String get abonos => 'Payments';

  @override
  String get abonoAgregado => 'Payment added';

  @override
  String get errorAgregarAbono => 'Error adding payment';

  @override
  String get montoAbono => 'Payment Amount';

  @override
  String get deudaPendiente => 'Pending Debt';

  @override
  String get deudaActual => 'Current Debt';

  @override
  String get nuevoMovimiento => 'New Movement';

  @override
  String get conceptoMovimiento => 'Movement Concept';

  @override
  String get movimientoAgregado => 'Movement added';

  @override
  String get errorAgregarMovimiento => 'Error adding movement';

  @override
  String get misLocales => 'My Locations';

  @override
  String get agregarLocal => 'Add Location';

  @override
  String get eliminarTodosLosDatos => 'Delete All Data';

  @override
  String get agregaTuPrimeraTienda => 'Add your first store or location';

  @override
  String get actual => 'Current';

  @override
  String get seleccionar => 'Select';

  @override
  String get nuevoLocal => 'New Location';

  @override
  String get editarLocal => 'Edit Location';

  @override
  String get tienda => 'Store';

  @override
  String get oficina => 'Office';

  @override
  String get noHayPedidos => 'No orders';

  @override
  String get creaUnPedidoProveedor => 'Create a supplier order to receive delivery alerts.';

  @override
  String get pedidosDelProveedor => 'Supplier Orders';

  @override
  String get bajo => 'Low';

  @override
  String get editarProducto => 'Edit Product';

  @override
  String get desactivarProducto => 'Deactivate Product';

  @override
  String get reactivarProducto => 'Reactivate Product';

  @override
  String reactivarEnCatalogo(String name) {
    return 'Reactivate \"$name\" in the catalog?';
  }

  @override
  String get inventarioVacio => 'Empty inventory';

  @override
  String get comienzaAgregandoProductos => 'Start by adding products manually or scanning barcodes.';

  @override
  String get errorAlGuardar => 'Error saving';

  @override
  String get productoGuardado => 'Product saved';

  @override
  String get categoriaProducto => 'Category';

  @override
  String get proveedorProducto => 'Supplier';

  @override
  String get sinProveedor => 'No supplier';

  @override
  String get escanerCodigoBarras => 'Barcode Scanner';

  @override
  String get subiendoCambios => 'Uploading changes...';

  @override
  String get descargandoDeLaNube => 'Downloading from cloud...';

  @override
  String get sincronizandoTodo => 'Syncing everything...';

  @override
  String get subirCambios => 'Upload Changes';

  @override
  String get descargarDeLaNube => 'Download from Cloud';

  @override
  String get sincronizarTodo => 'Sync All';

  @override
  String get reportesFinancieros => 'Financial Reports';

  @override
  String get periodoDeAnalisis => 'ANALYSIS PERIOD';

  @override
  String get seleccionarPeriodo => 'Select Period';

  @override
  String get ingresosTotales => 'TOTAL INCOME';

  @override
  String get egresosTotales => 'TOTAL EXPENSES';

  @override
  String get ventasRealizadas => 'COMPLETED SALES';

  @override
  String get utilidadNeta => 'NET PROFIT';

  @override
  String get ventasVsGastos => 'Sales vs Expenses';

  @override
  String get distribucionGastos => 'Expense Distribution';

  @override
  String get sinCategoria => 'No Category';

  @override
  String semana(int number) {
    return 'WEEK $number';
  }

  @override
  String get sinGastosRegistrados => 'No recorded expenses';

  @override
  String get editarProveedor => 'Edit Supplier';

  @override
  String get editarCliente => 'Edit Client';

  @override
  String get guardarActualizar => 'Update';

  @override
  String get cantidad => 'Quantity';

  @override
  String get agregarProducto => 'Add Product';

  @override
  String get escanearCodigoBarras => 'Scan Barcode';

  @override
  String get buscarProducto => 'Search Product';

  @override
  String get guardadoExitoso => 'Saved successfully';

  @override
  String get ingreseNombre => 'Please enter the name';

  @override
  String get minimo2Caracteres => 'Minimum 2 characters';

  @override
  String get ingreseTelefono => 'Please enter the phone';

  @override
  String get telefono10Digitos => 'The phone must be exactly 10 digits';

  @override
  String get digitos10SinEspacios => '10 digits without spaces';

  @override
  String get ingreseEmail => 'Please enter the email';

  @override
  String get ingreseEmailValido => 'Please enter a valid email';

  @override
  String get diasVisita => 'Visit days';

  @override
  String get lunes => 'Monday';

  @override
  String get martes => 'Tuesday';

  @override
  String get jueves => 'Thursday';

  @override
  String get viernes => 'Friday';

  @override
  String get sabado => 'Saturday';

  @override
  String get domingo => 'Sunday';

  @override
  String get nuevaCategoria => 'New category';

  @override
  String get nombreCategoria => 'Category name';

  @override
  String get seleccioneCategoria => 'Select a category';

  @override
  String get seleccioneOCreeCategoria => 'Select or create a category';

  @override
  String get ingreseMonto => 'Enter an amount';

  @override
  String get montoInvalido => 'Invalid amount';

  @override
  String get ingreseConcepto => 'Enter a concept';

  @override
  String get clienteOpcional => 'Client (Optional)';

  @override
  String get ninguno => 'None';

  @override
  String get ventaFiada => 'Credit Sale';

  @override
  String get anadirSaldoPendiente => 'Add to client\'s pending balance';

  @override
  String get calculadoAutomaticamente => 'Calculated automatically';

  @override
  String get sinClienteVentaGeneral => 'No client (general sale)';

  @override
  String get escribirNombreCliente => 'Write client name';

  @override
  String get ingreseNombreCliente => 'Enter the client name';

  @override
  String get ventaCreditoFiado => 'Credit sale (Creditors)';

  @override
  String get aumentaraSaldoPendiente => 'Will increase the client\'s pending balance';

  @override
  String get noHayProductos => 'No products';

  @override
  String get escaneeOAgregueProductos => 'Scan or add products from inventory';

  @override
  String get ingreseMontoVenta => 'Enter the amount';

  @override
  String get montoMayorCero => 'Amount must be greater than 0';

  @override
  String get precioUnitario => 'Unit price';

  @override
  String get escanearNotaRecibo => 'Scan Note / Receipt';

  @override
  String get camara => 'Camera';

  @override
  String get galeria => 'Gallery';

  @override
  String get datosDetectados => 'Detected data:';

  @override
  String montoDetectado(String amount) {
    return 'Amount: $amount';
  }

  @override
  String clienteDetectado(String name) {
    return 'Client: $name';
  }

  @override
  String get noSeDetectaronDatos => 'No clear data detected. Try again.';

  @override
  String get ingreseConceptoVenta => 'Enter the concept';

  @override
  String productoInactivo(String name) {
    return 'Product \"$name\" is inactive';
  }

  @override
  String noHaySuficienteStock(String name, int available) {
    return 'Not enough stock of \"$name\". Available: $available';
  }

  @override
  String get ventaRegistradaExito => 'Sale registered successfully';

  @override
  String get escanear => 'Scan';

  @override
  String get agregarProductoTitle => 'Add Product';

  @override
  String get buscarProductoPlaceholder => 'Search product';

  @override
  String stockLabel(int stock) {
    return 'Stock: $stock';
  }

  @override
  String get ejemploNombre => 'Ex. John Doe';

  @override
  String get ejemploTelefono => 'Ex. 3001234567';

  @override
  String get ejemploEmail => 'example@email.com';

  @override
  String get proveedorOpcional => 'Supplier (Optional)';

  @override
  String get clienteOpcionalLabel => 'Client (Optional)';

  @override
  String get ingreseElMonto => 'Enter the amount';

  @override
  String get maximoMonto => 'Maximum 999,999,999';

  @override
  String get clienteOpcional2 => 'Client (optional)';

  @override
  String get guardarVenta => 'Save sale';

  @override
  String get ventaRegistradaExitoMsg => 'Sale registered successfully';

  @override
  String get productoNoEncontrado => 'Product not found in inventory';

  @override
  String restockLabel(String name) {
    return 'Restock: $name';
  }

  @override
  String get escanearCodigoTitulo => 'Scan Code';

  @override
  String get historialMovimientos => 'Movement History';

  @override
  String get historialVisitas => 'Visit History';

  @override
  String get recentRecords => 'Recent Records';

  @override
  String get resultadosFiltroTitle => 'Filtered Results';

  @override
  String totalItems(int count) {
    return 'Total: $count';
  }

  @override
  String get limpiarFiltro => 'Clear Filter';

  @override
  String get eliminarRegistro => 'Delete Record';

  @override
  String get confirmarEliminarRegistro => 'Are you sure you want to permanently delete this record?';

  @override
  String get historialVacio => 'Empty history';

  @override
  String get noHayRegistros => 'No income or expense records yet.';

  @override
  String get editarRegistro => 'Edit';

  @override
  String get movementHistoryTitle => 'Movement History';

  @override
  String get clearFilterBtn => 'Clear Filter';

  @override
  String get emptyHistoryTitle => 'Empty history';

  @override
  String get noRecordsYet => 'No income or expense records yet.';

  @override
  String get deleteRecordTitle => 'Delete Record';

  @override
  String get confirmDeleteRecord => 'Are you sure you want to permanently delete this record?';

  @override
  String get password => 'Password';

  @override
  String get signIn => 'Sign In';

  @override
  String get signInToContinue => 'Sign in to continue';

  @override
  String get forgotPassword => 'Forgot Password?';

  @override
  String get dontHaveAccount => 'Don\'t have an account?';

  @override
  String get signUp => 'Sign Up';

  @override
  String get createAccount => 'Create Account';

  @override
  String get firstUserAdmin => 'First user will be admin';

  @override
  String get fullName => 'Full Name';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get alreadyHaveAccount => 'Already have an account?';

  @override
  String get enterYourEmail => 'Enter your email';

  @override
  String get enterValidEmail => 'Enter a valid email';

  @override
  String get enterYourPassword => 'Enter your password';

  @override
  String get enterYourName => 'Enter your name';

  @override
  String get enterAPassword => 'Enter a password';

  @override
  String get confirmYourPassword => 'Confirm your password';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match';

  @override
  String get passwordResetSent => 'Password reset email sent';

  @override
  String get failedToSendReset => 'Failed to send reset email';

  @override
  String get loginFailed => 'Login failed';

  @override
  String get passwordHint => 'Min 8 chars, 1 capital, 3 numbers, no special chars';

  @override
  String get ingresos => 'Income';

  @override
  String get egresos => 'Expenses';

  @override
  String get acreedores => 'Creditors';

  @override
  String get ocultar => 'Hide';

  @override
  String get ver => 'View';

  @override
  String get import => 'Import';

  @override
  String get importando => 'Importing...';

  @override
  String get importSuccess => 'Successful import';

  @override
  String get importError => 'Import error';

  @override
  String get reactivate => 'Reactivate';

  @override
  String get deactivate => 'Deactivate';

  @override
  String get inactive => 'INACTIVE';

  @override
  String get stockBajo => 'Low Stock';

  @override
  String get valor => 'Value';

  @override
  String get sincro => 'Sync';

  @override
  String get view => 'View';

  @override
  String get delete => 'Delete';

  @override
  String get registrarPago => 'Register payment';

  @override
  String get montoAPagar => 'Amount to pay';

  @override
  String get codigoProducto => 'Product Code';

  @override
  String get ean13Colombia => 'EAN-13 Colombia';

  @override
  String get cerrar => 'Close';

  @override
  String get importData => 'Import Data';

  @override
  String get localConDatos => 'Location with data';

  @override
  String get queDeseasHacer => 'What do you want to do?';

  @override
  String get eliminarIgual => 'Delete anyway';

  @override
  String get todosLosDatosEliminados => 'All data deleted';

  @override
  String get ultimasTransacciones => 'Last transactions';

  @override
  String get ventas => 'Sales';

  @override
  String get gastos => 'Expenses';

  @override
  String get reporteGeneral => 'General Report';

  @override
  String tendenciaUltimos(int days) {
    return 'Trend (last $days days)';
  }
}
