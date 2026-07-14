import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'InkTrack'**
  String get appTitle;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @clientes.
  ///
  /// In en, this message translates to:
  /// **'Clients'**
  String get clientes;

  /// No description provided for @proveedores.
  ///
  /// In en, this message translates to:
  /// **'Suppliers'**
  String get proveedores;

  /// No description provided for @inventario.
  ///
  /// In en, this message translates to:
  /// **'Inventory'**
  String get inventario;

  /// No description provided for @stock.
  ///
  /// In en, this message translates to:
  /// **'Stock'**
  String get stock;

  /// No description provided for @reportes.
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get reportes;

  /// No description provided for @perfil.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get perfil;

  /// No description provided for @modoOscuro.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get modoOscuro;

  /// No description provided for @cerrarSesion.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get cerrarSesion;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @cancelar.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancelar;

  /// No description provided for @guardar.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get guardar;

  /// No description provided for @idioma.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get idioma;

  /// No description provided for @usuario.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get usuario;

  /// No description provided for @admin.
  ///
  /// In en, this message translates to:
  /// **'Admin'**
  String get admin;

  /// No description provided for @userId.
  ///
  /// In en, this message translates to:
  /// **'User ID'**
  String get userId;

  /// No description provided for @noDisponible.
  ///
  /// In en, this message translates to:
  /// **'Not available'**
  String get noDisponible;

  /// No description provided for @cerrarSesionTitulo.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get cerrarSesionTitulo;

  /// No description provided for @cerrarSesionPregunta.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to logout?'**
  String get cerrarSesionPregunta;

  /// No description provided for @panelDeInicio.
  ///
  /// In en, this message translates to:
  /// **'Home Panel'**
  String get panelDeInicio;

  /// No description provided for @gestionDeClientes.
  ///
  /// In en, this message translates to:
  /// **'Client Management'**
  String get gestionDeClientes;

  /// No description provided for @proveedoresHeader.
  ///
  /// In en, this message translates to:
  /// **'Suppliers'**
  String get proveedoresHeader;

  /// No description provided for @controlDeInventario.
  ///
  /// In en, this message translates to:
  /// **'Inventory Control'**
  String get controlDeInventario;

  /// No description provided for @reportesDeNegocio.
  ///
  /// In en, this message translates to:
  /// **'Business Reports'**
  String get reportesDeNegocio;

  /// No description provided for @sinLocal.
  ///
  /// In en, this message translates to:
  /// **'No location selected'**
  String get sinLocal;

  /// No description provided for @movimientos.
  ///
  /// In en, this message translates to:
  /// **'Movements'**
  String get movimientos;

  /// No description provided for @productos.
  ///
  /// In en, this message translates to:
  /// **'Products'**
  String get productos;

  /// No description provided for @excel.
  ///
  /// In en, this message translates to:
  /// **'Excel'**
  String get excel;

  /// No description provided for @pdf.
  ///
  /// In en, this message translates to:
  /// **'PDF'**
  String get pdf;

  /// No description provided for @egreso.
  ///
  /// In en, this message translates to:
  /// **'Expense'**
  String get egreso;

  /// No description provided for @ingreso.
  ///
  /// In en, this message translates to:
  /// **'Income'**
  String get ingreso;

  /// No description provided for @ocr.
  ///
  /// In en, this message translates to:
  /// **'OCR'**
  String get ocr;

  /// No description provided for @codigo.
  ///
  /// In en, this message translates to:
  /// **'Barcode'**
  String get codigo;

  /// No description provided for @producto.
  ///
  /// In en, this message translates to:
  /// **'Product'**
  String get producto;

  /// No description provided for @cliente.
  ///
  /// In en, this message translates to:
  /// **'Client'**
  String get cliente;

  /// No description provided for @proveedor.
  ///
  /// In en, this message translates to:
  /// **'Supplier'**
  String get proveedor;

  /// No description provided for @nuevoPedido.
  ///
  /// In en, this message translates to:
  /// **'New Order'**
  String get nuevoPedido;

  /// No description provided for @restock.
  ///
  /// In en, this message translates to:
  /// **'Restock'**
  String get restock;

  /// No description provided for @clientesTitulo.
  ///
  /// In en, this message translates to:
  /// **'Clients'**
  String get clientesTitulo;

  /// No description provided for @proveedoresTitulo.
  ///
  /// In en, this message translates to:
  /// **'Suppliers'**
  String get proveedoresTitulo;

  /// No description provided for @inventarioTitulo.
  ///
  /// In en, this message translates to:
  /// **'Inventory'**
  String get inventarioTitulo;

  /// No description provided for @reportesTitulo.
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get reportesTitulo;

  /// No description provided for @pdfExportado.
  ///
  /// In en, this message translates to:
  /// **'PDF exported: {filename}'**
  String pdfExportado(Object filename);

  /// No description provided for @excelExportado.
  ///
  /// In en, this message translates to:
  /// **'Excel exported: {filename}'**
  String excelExportado(Object filename);

  /// No description provided for @errorAlExportarPdf.
  ///
  /// In en, this message translates to:
  /// **'Error exporting PDF: {error}'**
  String errorAlExportarPdf(Object error);

  /// No description provided for @errorAlExportarExcel.
  ///
  /// In en, this message translates to:
  /// **'Error exporting Excel: {error}'**
  String errorAlExportarExcel(Object error);

  /// No description provided for @entregasPendientes.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 pending delivery} other{{count} pending deliveries}}'**
  String entregasPendientes(num count);

  /// No description provided for @verPedidos.
  ///
  /// In en, this message translates to:
  /// **'View Orders'**
  String get verPedidos;

  /// No description provided for @detalleMovimiento.
  ///
  /// In en, this message translates to:
  /// **'Movement Detail'**
  String get detalleMovimiento;

  /// No description provided for @concepto.
  ///
  /// In en, this message translates to:
  /// **'Concept'**
  String get concepto;

  /// No description provided for @monto.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get monto;

  /// No description provided for @fecha.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get fecha;

  /// No description provided for @categoria.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get categoria;

  /// No description provided for @tipo.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get tipo;

  /// No description provided for @resultados.
  ///
  /// In en, this message translates to:
  /// **'Results'**
  String get resultados;

  /// No description provided for @acumuladoTotal.
  ///
  /// In en, this message translates to:
  /// **'General Report'**
  String get acumuladoTotal;

  /// No description provided for @ventasTotales.
  ///
  /// In en, this message translates to:
  /// **'Sales'**
  String get ventasTotales;

  /// No description provided for @gastosTotales.
  ///
  /// In en, this message translates to:
  /// **'Expenses'**
  String get gastosTotales;

  /// No description provided for @patrimonio.
  ///
  /// In en, this message translates to:
  /// **'Equity'**
  String get patrimonio;

  /// No description provided for @balanceNeto.
  ///
  /// In en, this message translates to:
  /// **'Net Balance'**
  String get balanceNeto;

  /// No description provided for @tendenciaFlujo.
  ///
  /// In en, this message translates to:
  /// **'Cash Flow Trend'**
  String get tendenciaFlujo;

  /// No description provided for @actividadReciente.
  ///
  /// In en, this message translates to:
  /// **'Recent Activity'**
  String get actividadReciente;

  /// No description provided for @resultadosFiltro.
  ///
  /// In en, this message translates to:
  /// **'Filter Results'**
  String get resultadosFiltro;

  /// No description provided for @limpiar.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get limpiar;

  /// No description provided for @noHayActividadRegistrada.
  ///
  /// In en, this message translates to:
  /// **'No activity recorded'**
  String get noHayActividadRegistrada;

  /// No description provided for @tusMovimientosApareceranAqui.
  ///
  /// In en, this message translates to:
  /// **'Your movements will appear here'**
  String get tusMovimientosApareceranAqui;

  /// No description provided for @egresoTipo.
  ///
  /// In en, this message translates to:
  /// **'Expense'**
  String get egresoTipo;

  /// No description provided for @actividad.
  ///
  /// In en, this message translates to:
  /// **'Activity'**
  String get actividad;

  /// No description provided for @resumenClientes.
  ///
  /// In en, this message translates to:
  /// **'Clients\nSummary'**
  String get resumenClientes;

  /// No description provided for @resumenFinanciero.
  ///
  /// In en, this message translates to:
  /// **'Financial\nSummary'**
  String get resumenFinanciero;

  /// No description provided for @hoy.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get hoy;

  /// No description provided for @si.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get si;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @inicio.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get inicio;

  /// No description provided for @fin.
  ///
  /// In en, this message translates to:
  /// **'End'**
  String get fin;

  /// No description provided for @periodo.
  ///
  /// In en, this message translates to:
  /// **'Period: {start} - {end}'**
  String periodo(Object end, Object start);

  /// No description provided for @inventarioHoja.
  ///
  /// In en, this message translates to:
  /// **'Inventory'**
  String get inventarioHoja;

  /// No description provided for @clientesHoja.
  ///
  /// In en, this message translates to:
  /// **'Clients'**
  String get clientesHoja;

  /// No description provided for @nombre.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get nombre;

  /// No description provided for @precio.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get precio;

  /// No description provided for @valorTotal.
  ///
  /// In en, this message translates to:
  /// **'Total Value'**
  String get valorTotal;

  /// No description provided for @clientesCategoria.
  ///
  /// In en, this message translates to:
  /// **'Clients'**
  String get clientesCategoria;

  /// No description provided for @proveedoresCategoria.
  ///
  /// In en, this message translates to:
  /// **'Suppliers'**
  String get proveedoresCategoria;

  /// No description provided for @fiado.
  ///
  /// In en, this message translates to:
  /// **'On Credit'**
  String get fiado;

  /// No description provided for @miercoles.
  ///
  /// In en, this message translates to:
  /// **'Wednesday'**
  String get miercoles;

  /// No description provided for @resumenProveedores.
  ///
  /// In en, this message translates to:
  /// **'Suppliers\nSummary'**
  String get resumenProveedores;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @listadoProveedores.
  ///
  /// In en, this message translates to:
  /// **'Suppliers List'**
  String get listadoProveedores;

  /// No description provided for @editar.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get editar;

  /// No description provided for @eliminar.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get eliminar;

  /// No description provided for @crear.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get crear;

  /// No description provided for @actualizar.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get actualizar;

  /// No description provided for @agregar.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get agregar;

  /// No description provided for @buscar.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get buscar;

  /// No description provided for @filtro.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get filtro;

  /// No description provided for @catalogoProductos.
  ///
  /// In en, this message translates to:
  /// **'Product Catalog'**
  String get catalogoProductos;

  /// No description provided for @controlDeInventarioTitle.
  ///
  /// In en, this message translates to:
  /// **'Inventory\nControl'**
  String get controlDeInventarioTitle;

  /// No description provided for @valorStock.
  ///
  /// In en, this message translates to:
  /// **'Stock Value'**
  String get valorStock;

  /// No description provided for @deudaTotal.
  ///
  /// In en, this message translates to:
  /// **'Total Debt'**
  String get deudaTotal;

  /// No description provided for @listadoClientes.
  ///
  /// In en, this message translates to:
  /// **'Clients List'**
  String get listadoClientes;

  /// No description provided for @pedidosProveedores.
  ///
  /// In en, this message translates to:
  /// **'Supplier Orders'**
  String get pedidosProveedores;

  /// No description provided for @pedidosPendientes.
  ///
  /// In en, this message translates to:
  /// **'Pending Orders'**
  String get pedidosPendientes;

  /// No description provided for @nuevoIngreso.
  ///
  /// In en, this message translates to:
  /// **'New Income'**
  String get nuevoIngreso;

  /// No description provided for @nuevoEgreso.
  ///
  /// In en, this message translates to:
  /// **'New Expense'**
  String get nuevoEgreso;

  /// No description provided for @montoTotal.
  ///
  /// In en, this message translates to:
  /// **'Total Amount'**
  String get montoTotal;

  /// No description provided for @totalProductos.
  ///
  /// In en, this message translates to:
  /// **'Total Products'**
  String get totalProductos;

  /// No description provided for @nuevoPedidoProveedor.
  ///
  /// In en, this message translates to:
  /// **'New Supplier Order'**
  String get nuevoPedidoProveedor;

  /// No description provided for @seleccionarProveedor.
  ///
  /// In en, this message translates to:
  /// **'Select Supplier'**
  String get seleccionarProveedor;

  /// No description provided for @fechaEntrega.
  ///
  /// In en, this message translates to:
  /// **'Delivery Date'**
  String get fechaEntrega;

  /// No description provided for @estado.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get estado;

  /// No description provided for @estadoPendiente.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get estadoPendiente;

  /// No description provided for @estadoCompletado.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get estadoCompletado;

  /// No description provided for @estadoCancelado.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get estadoCancelado;

  /// No description provided for @noDataAvailable.
  ///
  /// In en, this message translates to:
  /// **'No data available'**
  String get noDataAvailable;

  /// No description provided for @onCredit.
  ///
  /// In en, this message translates to:
  /// **'On Credit'**
  String get onCredit;

  /// No description provided for @cash.
  ///
  /// In en, this message translates to:
  /// **'Cash'**
  String get cash;

  /// No description provided for @registrarVenta.
  ///
  /// In en, this message translates to:
  /// **'Register Sale'**
  String get registrarVenta;

  /// No description provided for @carrito.
  ///
  /// In en, this message translates to:
  /// **'Cart'**
  String get carrito;

  /// No description provided for @finalizarVenta.
  ///
  /// In en, this message translates to:
  /// **'Finalize Sale'**
  String get finalizarVenta;

  /// No description provided for @cobrar.
  ///
  /// In en, this message translates to:
  /// **'Charge'**
  String get cobrar;

  /// No description provided for @efectivo.
  ///
  /// In en, this message translates to:
  /// **'Cash'**
  String get efectivo;

  /// No description provided for @transferencia.
  ///
  /// In en, this message translates to:
  /// **'Transfer'**
  String get transferencia;

  /// No description provided for @pagoMixto.
  ///
  /// In en, this message translates to:
  /// **'Mixed Payment'**
  String get pagoMixto;

  /// No description provided for @contenido.
  ///
  /// In en, this message translates to:
  /// **'Content'**
  String get contenido;

  /// No description provided for @observaciones.
  ///
  /// In en, this message translates to:
  /// **'Observations'**
  String get observaciones;

  /// No description provided for @descripcion.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get descripcion;

  /// No description provided for @telefono.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get telefono;

  /// No description provided for @direccion.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get direccion;

  /// No description provided for @notas.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notas;

  /// No description provided for @bodega.
  ///
  /// In en, this message translates to:
  /// **'Warehouse'**
  String get bodega;

  /// No description provided for @local.
  ///
  /// In en, this message translates to:
  /// **'Store'**
  String get local;

  /// No description provided for @resetData.
  ///
  /// In en, this message translates to:
  /// **'Reset Data'**
  String get resetData;

  /// No description provided for @resetearData.
  ///
  /// In en, this message translates to:
  /// **'This will delete ALL app data (products, customers, suppliers, sales, movements, locations).'**
  String get resetearData;

  /// No description provided for @resetDataTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset All Data'**
  String get resetDataTitle;

  /// No description provided for @noLocales.
  ///
  /// In en, this message translates to:
  /// **'No locations registered'**
  String get noLocales;

  /// No description provided for @datosIncorrectos.
  ///
  /// In en, this message translates to:
  /// **'Incorrect data'**
  String get datosIncorrectos;

  /// No description provided for @nombreRequerido.
  ///
  /// In en, this message translates to:
  /// **'Name is required'**
  String get nombreRequerido;

  /// No description provided for @camposRequeridos.
  ///
  /// In en, this message translates to:
  /// **'Required fields'**
  String get camposRequeridos;

  /// No description provided for @verificarInformacion.
  ///
  /// In en, this message translates to:
  /// **'Please verify the information'**
  String get verificarInformacion;

  /// No description provided for @seleccionarLocal.
  ///
  /// In en, this message translates to:
  /// **'Select Location'**
  String get seleccionarLocal;

  /// No description provided for @ubicacion.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get ubicacion;

  /// No description provided for @stockMinimo.
  ///
  /// In en, this message translates to:
  /// **'Min Stock'**
  String get stockMinimo;

  /// No description provided for @stockActual.
  ///
  /// In en, this message translates to:
  /// **'Current Stock'**
  String get stockActual;

  /// No description provided for @codigoBarras.
  ///
  /// In en, this message translates to:
  /// **'Barcode'**
  String get codigoBarras;

  /// No description provided for @precioVenta.
  ///
  /// In en, this message translates to:
  /// **'Sale Price'**
  String get precioVenta;

  /// No description provided for @precioCompra.
  ///
  /// In en, this message translates to:
  /// **'Purchase Price'**
  String get precioCompra;

  /// No description provided for @ganancia.
  ///
  /// In en, this message translates to:
  /// **'Profit'**
  String get ganancia;

  /// No description provided for @nuevoProducto.
  ///
  /// In en, this message translates to:
  /// **'New Product'**
  String get nuevoProducto;

  /// No description provided for @nuevoCliente.
  ///
  /// In en, this message translates to:
  /// **'New Client'**
  String get nuevoCliente;

  /// No description provided for @nuevoProveedor.
  ///
  /// In en, this message translates to:
  /// **'New Supplier'**
  String get nuevoProveedor;

  /// No description provided for @saldoPendiente.
  ///
  /// In en, this message translates to:
  /// **'Pending Balance'**
  String get saldoPendiente;

  /// No description provided for @abonar.
  ///
  /// In en, this message translates to:
  /// **'Pay'**
  String get abonar;

  /// No description provided for @abono.
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get abono;

  /// No description provided for @abonos.
  ///
  /// In en, this message translates to:
  /// **'Payments'**
  String get abonos;

  /// No description provided for @abonoAgregado.
  ///
  /// In en, this message translates to:
  /// **'Payment added'**
  String get abonoAgregado;

  /// No description provided for @errorAgregarAbono.
  ///
  /// In en, this message translates to:
  /// **'Error adding payment'**
  String get errorAgregarAbono;

  /// No description provided for @montoAbono.
  ///
  /// In en, this message translates to:
  /// **'Payment Amount'**
  String get montoAbono;

  /// No description provided for @deudaPendiente.
  ///
  /// In en, this message translates to:
  /// **'Pending Debt'**
  String get deudaPendiente;

  /// No description provided for @deudaActual.
  ///
  /// In en, this message translates to:
  /// **'Current Debt'**
  String get deudaActual;

  /// No description provided for @nuevoMovimiento.
  ///
  /// In en, this message translates to:
  /// **'New Movement'**
  String get nuevoMovimiento;

  /// No description provided for @conceptoMovimiento.
  ///
  /// In en, this message translates to:
  /// **'Movement Concept'**
  String get conceptoMovimiento;

  /// No description provided for @movimientoAgregado.
  ///
  /// In en, this message translates to:
  /// **'Movement added'**
  String get movimientoAgregado;

  /// No description provided for @errorAgregarMovimiento.
  ///
  /// In en, this message translates to:
  /// **'Error adding movement'**
  String get errorAgregarMovimiento;

  /// No description provided for @misLocales.
  ///
  /// In en, this message translates to:
  /// **'My Locations'**
  String get misLocales;

  /// No description provided for @agregarLocal.
  ///
  /// In en, this message translates to:
  /// **'Add Location'**
  String get agregarLocal;

  /// No description provided for @eliminarTodosLosDatos.
  ///
  /// In en, this message translates to:
  /// **'Delete All Data'**
  String get eliminarTodosLosDatos;

  /// No description provided for @agregaTuPrimeraTienda.
  ///
  /// In en, this message translates to:
  /// **'Add your first store or location'**
  String get agregaTuPrimeraTienda;

  /// No description provided for @actual.
  ///
  /// In en, this message translates to:
  /// **'Current'**
  String get actual;

  /// No description provided for @seleccionar.
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get seleccionar;

  /// No description provided for @nuevoLocal.
  ///
  /// In en, this message translates to:
  /// **'New Location'**
  String get nuevoLocal;

  /// No description provided for @editarLocal.
  ///
  /// In en, this message translates to:
  /// **'Edit Location'**
  String get editarLocal;

  /// No description provided for @tienda.
  ///
  /// In en, this message translates to:
  /// **'Store'**
  String get tienda;

  /// No description provided for @oficina.
  ///
  /// In en, this message translates to:
  /// **'Office'**
  String get oficina;

  /// No description provided for @noHayPedidos.
  ///
  /// In en, this message translates to:
  /// **'No orders'**
  String get noHayPedidos;

  /// No description provided for @creaUnPedidoProveedor.
  ///
  /// In en, this message translates to:
  /// **'Create a supplier order to receive delivery alerts.'**
  String get creaUnPedidoProveedor;

  /// No description provided for @pedidosDelProveedor.
  ///
  /// In en, this message translates to:
  /// **'Supplier Orders'**
  String get pedidosDelProveedor;

  /// No description provided for @bajo.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get bajo;

  /// No description provided for @editarProducto.
  ///
  /// In en, this message translates to:
  /// **'Edit Product'**
  String get editarProducto;

  /// No description provided for @desactivarProducto.
  ///
  /// In en, this message translates to:
  /// **'Deactivate Product'**
  String get desactivarProducto;

  /// No description provided for @reactivarProducto.
  ///
  /// In en, this message translates to:
  /// **'Reactivate Product'**
  String get reactivarProducto;

  /// No description provided for @reactivarEnCatalogo.
  ///
  /// In en, this message translates to:
  /// **'Reactivate \"{name}\" in the catalog?'**
  String reactivarEnCatalogo(Object name);

  /// No description provided for @inventarioVacio.
  ///
  /// In en, this message translates to:
  /// **'Empty inventory'**
  String get inventarioVacio;

  /// No description provided for @comienzaAgregandoProductos.
  ///
  /// In en, this message translates to:
  /// **'Start by adding products manually or scanning barcodes.'**
  String get comienzaAgregandoProductos;

  /// No description provided for @errorAlGuardar.
  ///
  /// In en, this message translates to:
  /// **'Error saving'**
  String get errorAlGuardar;

  /// No description provided for @productoGuardado.
  ///
  /// In en, this message translates to:
  /// **'Product saved'**
  String get productoGuardado;

  /// No description provided for @categoriaProducto.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get categoriaProducto;

  /// No description provided for @proveedorProducto.
  ///
  /// In en, this message translates to:
  /// **'Supplier'**
  String get proveedorProducto;

  /// No description provided for @sinProveedor.
  ///
  /// In en, this message translates to:
  /// **'No supplier'**
  String get sinProveedor;

  /// No description provided for @escanerCodigoBarras.
  ///
  /// In en, this message translates to:
  /// **'Barcode Scanner'**
  String get escanerCodigoBarras;

  /// No description provided for @subiendoCambios.
  ///
  /// In en, this message translates to:
  /// **'Uploading changes...'**
  String get subiendoCambios;

  /// No description provided for @descargandoDeLaNube.
  ///
  /// In en, this message translates to:
  /// **'Downloading from cloud...'**
  String get descargandoDeLaNube;

  /// No description provided for @sincronizandoTodo.
  ///
  /// In en, this message translates to:
  /// **'Syncing everything...'**
  String get sincronizandoTodo;

  /// No description provided for @subirCambios.
  ///
  /// In en, this message translates to:
  /// **'Upload Changes'**
  String get subirCambios;

  /// No description provided for @descargarDeLaNube.
  ///
  /// In en, this message translates to:
  /// **'Download from Cloud'**
  String get descargarDeLaNube;

  /// No description provided for @sincronizarTodo.
  ///
  /// In en, this message translates to:
  /// **'Sync All'**
  String get sincronizarTodo;

  /// No description provided for @reportesFinancieros.
  ///
  /// In en, this message translates to:
  /// **'Financial Reports'**
  String get reportesFinancieros;

  /// No description provided for @periodoDeAnalisis.
  ///
  /// In en, this message translates to:
  /// **'ANALYSIS PERIOD'**
  String get periodoDeAnalisis;

  /// No description provided for @seleccionarPeriodo.
  ///
  /// In en, this message translates to:
  /// **'Select Period'**
  String get seleccionarPeriodo;

  /// No description provided for @ingresosTotales.
  ///
  /// In en, this message translates to:
  /// **'TOTAL INCOME'**
  String get ingresosTotales;

  /// No description provided for @egresosTotales.
  ///
  /// In en, this message translates to:
  /// **'TOTAL EXPENSES'**
  String get egresosTotales;

  /// No description provided for @ventasRealizadas.
  ///
  /// In en, this message translates to:
  /// **'COMPLETED SALES'**
  String get ventasRealizadas;

  /// No description provided for @utilidadNeta.
  ///
  /// In en, this message translates to:
  /// **'NET PROFIT'**
  String get utilidadNeta;

  /// No description provided for @ventasVsGastos.
  ///
  /// In en, this message translates to:
  /// **'Sales vs Expenses'**
  String get ventasVsGastos;

  /// No description provided for @distribucionGastos.
  ///
  /// In en, this message translates to:
  /// **'Expense Distribution'**
  String get distribucionGastos;

  /// No description provided for @sinCategoria.
  ///
  /// In en, this message translates to:
  /// **'No Category'**
  String get sinCategoria;

  /// No description provided for @otros.
  ///
  /// In en, this message translates to:
  /// **'Others'**
  String get otros;

  /// No description provided for @semana.
  ///
  /// In en, this message translates to:
  /// **'WEEK {number}'**
  String semana(Object number);

  /// No description provided for @sinGastosRegistrados.
  ///
  /// In en, this message translates to:
  /// **'No recorded expenses'**
  String get sinGastosRegistrados;

  /// No description provided for @editarProveedor.
  ///
  /// In en, this message translates to:
  /// **'Edit Supplier'**
  String get editarProveedor;

  /// No description provided for @editarCliente.
  ///
  /// In en, this message translates to:
  /// **'Edit Client'**
  String get editarCliente;

  /// No description provided for @guardarActualizar.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get guardarActualizar;

  /// No description provided for @cantidad.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get cantidad;

  /// No description provided for @agregarProducto.
  ///
  /// In en, this message translates to:
  /// **'Add Product'**
  String get agregarProducto;

  /// No description provided for @escanearCodigoBarras.
  ///
  /// In en, this message translates to:
  /// **'Scan Barcode'**
  String get escanearCodigoBarras;

  /// No description provided for @buscarProducto.
  ///
  /// In en, this message translates to:
  /// **'Search Product'**
  String get buscarProducto;

  /// No description provided for @guardadoExitoso.
  ///
  /// In en, this message translates to:
  /// **'Saved successfully'**
  String get guardadoExitoso;

  /// No description provided for @ingreseNombre.
  ///
  /// In en, this message translates to:
  /// **'Please enter the name'**
  String get ingreseNombre;

  /// No description provided for @minimo2Caracteres.
  ///
  /// In en, this message translates to:
  /// **'Minimum 2 characters'**
  String get minimo2Caracteres;

  /// No description provided for @ingreseTelefono.
  ///
  /// In en, this message translates to:
  /// **'Please enter the phone'**
  String get ingreseTelefono;

  /// No description provided for @telefono10Digitos.
  ///
  /// In en, this message translates to:
  /// **'Phone must be exactly 10 digits'**
  String get telefono10Digitos;

  /// No description provided for @digitos10SinEspacios.
  ///
  /// In en, this message translates to:
  /// **'10 digits without spaces'**
  String get digitos10SinEspacios;

  /// No description provided for @ingreseEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter the email'**
  String get ingreseEmail;

  /// No description provided for @ingreseEmailValido.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get ingreseEmailValido;

  /// No description provided for @diasVisita.
  ///
  /// In en, this message translates to:
  /// **'Visit days'**
  String get diasVisita;

  /// No description provided for @lunes.
  ///
  /// In en, this message translates to:
  /// **'Monday'**
  String get lunes;

  /// No description provided for @martes.
  ///
  /// In en, this message translates to:
  /// **'Tuesday'**
  String get martes;

  /// No description provided for @jueves.
  ///
  /// In en, this message translates to:
  /// **'Thursday'**
  String get jueves;

  /// No description provided for @viernes.
  ///
  /// In en, this message translates to:
  /// **'Friday'**
  String get viernes;

  /// No description provided for @sabado.
  ///
  /// In en, this message translates to:
  /// **'Saturday'**
  String get sabado;

  /// No description provided for @domingo.
  ///
  /// In en, this message translates to:
  /// **'Sunday'**
  String get domingo;

  /// No description provided for @nuevaCategoria.
  ///
  /// In en, this message translates to:
  /// **'New category'**
  String get nuevaCategoria;

  /// No description provided for @nombreCategoria.
  ///
  /// In en, this message translates to:
  /// **'Category name'**
  String get nombreCategoria;

  /// No description provided for @seleccioneCategoria.
  ///
  /// In en, this message translates to:
  /// **'Select a category'**
  String get seleccioneCategoria;

  /// No description provided for @seleccioneOCreeCategoria.
  ///
  /// In en, this message translates to:
  /// **'Select or create a category'**
  String get seleccioneOCreeCategoria;

  /// No description provided for @ingreseMonto.
  ///
  /// In en, this message translates to:
  /// **'Enter an amount'**
  String get ingreseMonto;

  /// No description provided for @montoInvalido.
  ///
  /// In en, this message translates to:
  /// **'Invalid amount'**
  String get montoInvalido;

  /// No description provided for @ingreseConcepto.
  ///
  /// In en, this message translates to:
  /// **'Enter a concept'**
  String get ingreseConcepto;

  /// No description provided for @clienteOpcional.
  ///
  /// In en, this message translates to:
  /// **'Client (Optional)'**
  String get clienteOpcional;

  /// No description provided for @ninguno.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get ninguno;

  /// No description provided for @ventaFiada.
  ///
  /// In en, this message translates to:
  /// **'Credit Sale'**
  String get ventaFiada;

  /// No description provided for @anadirSaldoPendiente.
  ///
  /// In en, this message translates to:
  /// **'Add to client pending balance'**
  String get anadirSaldoPendiente;

  /// No description provided for @calculadoAutomaticamente.
  ///
  /// In en, this message translates to:
  /// **'Calculated automatically'**
  String get calculadoAutomaticamente;

  /// No description provided for @sinClienteVentaGeneral.
  ///
  /// In en, this message translates to:
  /// **'No client (general sale)'**
  String get sinClienteVentaGeneral;

  /// No description provided for @escribirNombreCliente.
  ///
  /// In en, this message translates to:
  /// **'Write client name'**
  String get escribirNombreCliente;

  /// No description provided for @ingreseNombreCliente.
  ///
  /// In en, this message translates to:
  /// **'Enter the client name'**
  String get ingreseNombreCliente;

  /// No description provided for @ventaCreditoFiado.
  ///
  /// In en, this message translates to:
  /// **'Credit sale (Creditors)'**
  String get ventaCreditoFiado;

  /// No description provided for @aumentaraSaldoPendiente.
  ///
  /// In en, this message translates to:
  /// **'Will increase the client pending balance'**
  String get aumentaraSaldoPendiente;

  /// No description provided for @noHayProductos.
  ///
  /// In en, this message translates to:
  /// **'No products'**
  String get noHayProductos;

  /// No description provided for @escaneeOAgregueProductos.
  ///
  /// In en, this message translates to:
  /// **'Scan or add products from inventory'**
  String get escaneeOAgregueProductos;

  /// No description provided for @ingreseMontoVenta.
  ///
  /// In en, this message translates to:
  /// **'Enter the amount'**
  String get ingreseMontoVenta;

  /// No description provided for @montoMayorCero.
  ///
  /// In en, this message translates to:
  /// **'Amount must be greater than 0'**
  String get montoMayorCero;

  /// No description provided for @precioUnitario.
  ///
  /// In en, this message translates to:
  /// **'Unit price'**
  String get precioUnitario;

  /// No description provided for @escanearNotaRecibo.
  ///
  /// In en, this message translates to:
  /// **'Scan Note / Receipt'**
  String get escanearNotaRecibo;

  /// No description provided for @camara.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get camara;

  /// No description provided for @galeria.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get galeria;

  /// No description provided for @datosDetectados.
  ///
  /// In en, this message translates to:
  /// **'Detected data:'**
  String get datosDetectados;

  /// No description provided for @montoDetectado.
  ///
  /// In en, this message translates to:
  /// **'Amount: {amount}'**
  String montoDetectado(Object amount);

  /// No description provided for @clienteDetectado.
  ///
  /// In en, this message translates to:
  /// **'Client: {name}'**
  String clienteDetectado(Object name);

  /// No description provided for @noSeDetectaronDatos.
  ///
  /// In en, this message translates to:
  /// **'No clear data detected. Try again.'**
  String get noSeDetectaronDatos;

  /// No description provided for @ingreseConceptoVenta.
  ///
  /// In en, this message translates to:
  /// **'Enter the concept'**
  String get ingreseConceptoVenta;

  /// No description provided for @productoInactivo.
  ///
  /// In en, this message translates to:
  /// **'Product \"{name}\" is inactive'**
  String productoInactivo(Object name);

  /// No description provided for @noHaySuficienteStock.
  ///
  /// In en, this message translates to:
  /// **'Not enough stock of \"{name}\". Available: {available}'**
  String noHaySuficienteStock(Object available, Object name);

  /// No description provided for @ventaRegistradaExito.
  ///
  /// In en, this message translates to:
  /// **'Sale registered successfully'**
  String get ventaRegistradaExito;

  /// No description provided for @escanear.
  ///
  /// In en, this message translates to:
  /// **'Scan'**
  String get escanear;

  /// No description provided for @agregarProductoTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Product'**
  String get agregarProductoTitle;

  /// No description provided for @buscarProductoPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Search product'**
  String get buscarProductoPlaceholder;

  /// No description provided for @stockLabel.
  ///
  /// In en, this message translates to:
  /// **'Stock: {stock}'**
  String stockLabel(Object stock);

  /// No description provided for @ejemploNombre.
  ///
  /// In en, this message translates to:
  /// **'Ex. John Doe'**
  String get ejemploNombre;

  /// No description provided for @ejemploTelefono.
  ///
  /// In en, this message translates to:
  /// **'Ex. 3001234567'**
  String get ejemploTelefono;

  /// No description provided for @ejemploEmail.
  ///
  /// In en, this message translates to:
  /// **'example@email.com'**
  String get ejemploEmail;

  /// No description provided for @proveedorOpcional.
  ///
  /// In en, this message translates to:
  /// **'Supplier (Optional)'**
  String get proveedorOpcional;

  /// No description provided for @clienteOpcionalLabel.
  ///
  /// In en, this message translates to:
  /// **'Client (Optional)'**
  String get clienteOpcionalLabel;

  /// No description provided for @ingreseElMonto.
  ///
  /// In en, this message translates to:
  /// **'Enter the amount'**
  String get ingreseElMonto;

  /// No description provided for @maximoMonto.
  ///
  /// In en, this message translates to:
  /// **'Maximum 999,999,999'**
  String get maximoMonto;

  /// No description provided for @clienteOpcional2.
  ///
  /// In en, this message translates to:
  /// **'Client (optional)'**
  String get clienteOpcional2;

  /// No description provided for @guardarVenta.
  ///
  /// In en, this message translates to:
  /// **'Save sale'**
  String get guardarVenta;

  /// No description provided for @ventaRegistradaExitoMsg.
  ///
  /// In en, this message translates to:
  /// **'Sale registered successfully'**
  String get ventaRegistradaExitoMsg;

  /// No description provided for @productoNoEncontrado.
  ///
  /// In en, this message translates to:
  /// **'Product not found in inventory'**
  String get productoNoEncontrado;

  /// No description provided for @restockLabel.
  ///
  /// In en, this message translates to:
  /// **'Restock: {name}'**
  String restockLabel(Object name);

  /// No description provided for @escanearCodigoTitulo.
  ///
  /// In en, this message translates to:
  /// **'Scan Code'**
  String get escanearCodigoTitulo;

  /// No description provided for @historialMovimientos.
  ///
  /// In en, this message translates to:
  /// **'Movement History'**
  String get historialMovimientos;

  /// No description provided for @historialVisitas.
  ///
  /// In en, this message translates to:
  /// **'Visit History'**
  String get historialVisitas;

  /// No description provided for @recentRecords.
  ///
  /// In en, this message translates to:
  /// **'Recent Records'**
  String get recentRecords;

  /// No description provided for @resultadosFiltroTitle.
  ///
  /// In en, this message translates to:
  /// **'Filtered Results'**
  String get resultadosFiltroTitle;

  /// No description provided for @totalItems.
  ///
  /// In en, this message translates to:
  /// **'Total: {count}'**
  String totalItems(Object count);

  /// No description provided for @limpiarFiltro.
  ///
  /// In en, this message translates to:
  /// **'Clear Filter'**
  String get limpiarFiltro;

  /// No description provided for @eliminarRegistro.
  ///
  /// In en, this message translates to:
  /// **'Delete Record'**
  String get eliminarRegistro;

  /// No description provided for @confirmarEliminarRegistro.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to permanently delete this record?'**
  String get confirmarEliminarRegistro;

  /// No description provided for @historialVacio.
  ///
  /// In en, this message translates to:
  /// **'Empty history'**
  String get historialVacio;

  /// No description provided for @noHayRegistros.
  ///
  /// In en, this message translates to:
  /// **'No income or expense records yet.'**
  String get noHayRegistros;

  /// No description provided for @editarRegistro.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get editarRegistro;

  /// No description provided for @movementHistoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Movement History'**
  String get movementHistoryTitle;

  /// No description provided for @clearFilterBtn.
  ///
  /// In en, this message translates to:
  /// **'Clear Filter'**
  String get clearFilterBtn;

  /// No description provided for @emptyHistoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Empty history'**
  String get emptyHistoryTitle;

  /// No description provided for @noRecordsYet.
  ///
  /// In en, this message translates to:
  /// **'No income or expense records yet.'**
  String get noRecordsYet;

  /// No description provided for @deleteRecordTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Record'**
  String get deleteRecordTitle;

  /// No description provided for @confirmDeleteRecord.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to permanently delete this record?'**
  String get confirmDeleteRecord;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// No description provided for @signInToContinue.
  ///
  /// In en, this message translates to:
  /// **'Sign in to continue'**
  String get signInToContinue;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get dontHaveAccount;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// No description provided for @firstUserAdmin.
  ///
  /// In en, this message translates to:
  /// **'First user will be admin'**
  String get firstUserAdmin;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccount;

  /// No description provided for @enterYourEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get enterYourEmail;

  /// No description provided for @enterValidEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email'**
  String get enterValidEmail;

  /// No description provided for @enterYourPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get enterYourPassword;

  /// No description provided for @enterYourName.
  ///
  /// In en, this message translates to:
  /// **'Enter your name'**
  String get enterYourName;

  /// No description provided for @enterAPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter a password'**
  String get enterAPassword;

  /// No description provided for @confirmYourPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm your password'**
  String get confirmYourPassword;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// No description provided for @passwordResetSent.
  ///
  /// In en, this message translates to:
  /// **'Password reset email sent'**
  String get passwordResetSent;

  /// No description provided for @failedToSendReset.
  ///
  /// In en, this message translates to:
  /// **'Failed to send reset email'**
  String get failedToSendReset;

  /// No description provided for @loginFailed.
  ///
  /// In en, this message translates to:
  /// **'Login failed'**
  String get loginFailed;

  /// No description provided for @passwordHint.
  ///
  /// In en, this message translates to:
  /// **'Min 8 chars, 1 uppercase, 3 numbers, no special characters'**
  String get passwordHint;

  /// No description provided for @ingresos.
  ///
  /// In en, this message translates to:
  /// **'Income'**
  String get ingresos;

  /// No description provided for @egresos.
  ///
  /// In en, this message translates to:
  /// **'Expenses'**
  String get egresos;

  /// No description provided for @acreedores.
  ///
  /// In en, this message translates to:
  /// **'Creditors'**
  String get acreedores;

  /// No description provided for @ocultar.
  ///
  /// In en, this message translates to:
  /// **'Hide'**
  String get ocultar;

  /// No description provided for @ver.
  ///
  /// In en, this message translates to:
  /// **'View'**
  String get ver;

  /// No description provided for @import.
  ///
  /// In en, this message translates to:
  /// **'Import'**
  String get import;

  /// No description provided for @importando.
  ///
  /// In en, this message translates to:
  /// **'Importing...'**
  String get importando;

  /// No description provided for @importSuccess.
  ///
  /// In en, this message translates to:
  /// **'Import successful'**
  String get importSuccess;

  /// No description provided for @importError.
  ///
  /// In en, this message translates to:
  /// **'Import error'**
  String get importError;

  /// No description provided for @reactivate.
  ///
  /// In en, this message translates to:
  /// **'Reactivate'**
  String get reactivate;

  /// No description provided for @deactivate.
  ///
  /// In en, this message translates to:
  /// **'Deactivate'**
  String get deactivate;

  /// No description provided for @inactive.
  ///
  /// In en, this message translates to:
  /// **'INACTIVE'**
  String get inactive;

  /// No description provided for @stockBajo.
  ///
  /// In en, this message translates to:
  /// **'Low Stock'**
  String get stockBajo;

  /// No description provided for @valor.
  ///
  /// In en, this message translates to:
  /// **'Value'**
  String get valor;

  /// No description provided for @sincro.
  ///
  /// In en, this message translates to:
  /// **'Sync'**
  String get sincro;

  /// No description provided for @view.
  ///
  /// In en, this message translates to:
  /// **'View'**
  String get view;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @registrarPago.
  ///
  /// In en, this message translates to:
  /// **'Register payment'**
  String get registrarPago;

  /// No description provided for @montoAPagar.
  ///
  /// In en, this message translates to:
  /// **'Amount to pay'**
  String get montoAPagar;

  /// No description provided for @codigoProducto.
  ///
  /// In en, this message translates to:
  /// **'Product code'**
  String get codigoProducto;

  /// No description provided for @ean13Colombia.
  ///
  /// In en, this message translates to:
  /// **'EAN-13 Colombia'**
  String get ean13Colombia;

  /// No description provided for @cerrar.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get cerrar;

  /// No description provided for @importData.
  ///
  /// In en, this message translates to:
  /// **'Import data'**
  String get importData;

  /// No description provided for @localConDatos.
  ///
  /// In en, this message translates to:
  /// **'Location with data'**
  String get localConDatos;

  /// No description provided for @queDeseasHacer.
  ///
  /// In en, this message translates to:
  /// **'What do you want to do?'**
  String get queDeseasHacer;

  /// No description provided for @eliminarIgual.
  ///
  /// In en, this message translates to:
  /// **'Delete anyway'**
  String get eliminarIgual;

  /// No description provided for @todosLosDatosEliminados.
  ///
  /// In en, this message translates to:
  /// **'All data deleted'**
  String get todosLosDatosEliminados;

  /// No description provided for @ultimasTransacciones.
  ///
  /// In en, this message translates to:
  /// **'Last transactions'**
  String get ultimasTransacciones;

  /// No description provided for @ventas.
  ///
  /// In en, this message translates to:
  /// **'Sales'**
  String get ventas;

  /// No description provided for @gastos.
  ///
  /// In en, this message translates to:
  /// **'Expenses'**
  String get gastos;

  /// No description provided for @reporteGeneral.
  ///
  /// In en, this message translates to:
  /// **'General report'**
  String get reporteGeneral;

  /// Trend label with day count
  ///
  /// In en, this message translates to:
  /// **'Trend (last {days} days)'**
  String tendenciaUltimos(int days);

  /// No description provided for @productoYaExiste.
  ///
  /// In en, this message translates to:
  /// **'Product already exists'**
  String get productoYaExiste;

  /// Message of the dialog shown when a scanned barcode already exists
  ///
  /// In en, this message translates to:
  /// **'Barcode \"{codigo}\" belongs to product \"{nombre}\". What do you want to do?'**
  String productoYaExisteMensaje(String codigo, String nombre);

  /// No description provided for @crearMovimiento.
  ///
  /// In en, this message translates to:
  /// **'Create movement'**
  String get crearMovimiento;

  /// No description provided for @margenGanancia.
  ///
  /// In en, this message translates to:
  /// **'Profit Margin'**
  String get margenGanancia;

  /// No description provided for @porcentajeGanancia.
  ///
  /// In en, this message translates to:
  /// **'Profit Percentage'**
  String get porcentajeGanancia;

  /// No description provided for @gananciaNeta.
  ///
  /// In en, this message translates to:
  /// **'Net Profit'**
  String get gananciaNeta;

  /// No description provided for @costo.
  ///
  /// In en, this message translates to:
  /// **'Cost'**
  String get costo;

  /// No description provided for @ejemploNombreProducto.
  ///
  /// In en, this message translates to:
  /// **'Ex. Black ink 50ml'**
  String get ejemploNombreProducto;

  /// No description provided for @ingreseNombreProducto.
  ///
  /// In en, this message translates to:
  /// **'Enter the product name'**
  String get ingreseNombreProducto;

  /// No description provided for @codigoPersonalizado.
  ///
  /// In en, this message translates to:
  /// **'Custom code'**
  String get codigoPersonalizado;

  /// No description provided for @ejemploCodigoPersonalizado.
  ///
  /// In en, this message translates to:
  /// **'Client/Supplier code'**
  String get ejemploCodigoPersonalizado;

  /// No description provided for @ayudaCodigoPersonalizado.
  ///
  /// In en, this message translates to:
  /// **'Ex. ZAP-001, PAP-045 (optional)'**
  String get ayudaCodigoPersonalizado;

  /// No description provided for @vincularCodigoBarras.
  ///
  /// In en, this message translates to:
  /// **'Link to barcode'**
  String get vincularCodigoBarras;

  /// No description provided for @vinculadoACodigoPersonalizado.
  ///
  /// In en, this message translates to:
  /// **'Linked to custom code'**
  String get vinculadoACodigoPersonalizado;

  /// No description provided for @autoGenerado.
  ///
  /// In en, this message translates to:
  /// **'Auto-generated'**
  String get autoGenerado;

  /// No description provided for @generar.
  ///
  /// In en, this message translates to:
  /// **'Generate'**
  String get generar;

  /// No description provided for @maximo99Unidades.
  ///
  /// In en, this message translates to:
  /// **'Maximum 99 units'**
  String get maximo99Unidades;

  /// No description provided for @ingreseCantidad.
  ///
  /// In en, this message translates to:
  /// **'Enter the quantity'**
  String get ingreseCantidad;

  /// No description provided for @cantidadInvalida.
  ///
  /// In en, this message translates to:
  /// **'Invalid quantity'**
  String get cantidadInvalida;

  /// No description provided for @esPaqueteCaja.
  ///
  /// In en, this message translates to:
  /// **'Is Package/Box'**
  String get esPaqueteCaja;

  /// No description provided for @ventaPorUnidadesEmpaque.
  ///
  /// In en, this message translates to:
  /// **'Sale by units within a package'**
  String get ventaPorUnidadesEmpaque;

  /// No description provided for @unidadesPorPaquete.
  ///
  /// In en, this message translates to:
  /// **'Units per Package'**
  String get unidadesPorPaquete;

  /// No description provided for @ingreseUnidades.
  ///
  /// In en, this message translates to:
  /// **'Enter units'**
  String get ingreseUnidades;

  /// No description provided for @debeSerMayorACero.
  ///
  /// In en, this message translates to:
  /// **'Must be greater than 0'**
  String get debeSerMayorACero;

  /// No description provided for @ingresePrecio.
  ///
  /// In en, this message translates to:
  /// **'Enter the price'**
  String get ingresePrecio;

  /// No description provided for @precioInvalido.
  ///
  /// In en, this message translates to:
  /// **'Invalid price'**
  String get precioInvalido;

  /// No description provided for @alertaStockBajo.
  ///
  /// In en, this message translates to:
  /// **'Alert when stock falls below this level'**
  String get alertaStockBajo;

  /// No description provided for @ingreseStockMinimo.
  ///
  /// In en, this message translates to:
  /// **'Enter minimum stock'**
  String get ingreseStockMinimo;

  /// No description provided for @stockMinimoInvalido.
  ///
  /// In en, this message translates to:
  /// **'Invalid minimum stock'**
  String get stockMinimoInvalido;

  /// No description provided for @maximo9999.
  ///
  /// In en, this message translates to:
  /// **'Maximum 9999'**
  String get maximo9999;

  /// No description provided for @escribirNombreProveedor.
  ///
  /// In en, this message translates to:
  /// **'Write supplier name'**
  String get escribirNombreProveedor;

  /// No description provided for @seleccioneProveedorOEscribaNombre.
  ///
  /// In en, this message translates to:
  /// **'Select a supplier or use \"Write name\"'**
  String get seleccioneProveedorOEscribaNombre;

  /// No description provided for @escribaNombreProveedor.
  ///
  /// In en, this message translates to:
  /// **'Write the supplier name'**
  String get escribaNombreProveedor;

  /// No description provided for @seleccioneUnProveedor.
  ///
  /// In en, this message translates to:
  /// **'Select a supplier'**
  String get seleccioneUnProveedor;

  /// No description provided for @nombreProveedor.
  ///
  /// In en, this message translates to:
  /// **'Supplier name'**
  String get nombreProveedor;

  /// No description provided for @ejemploProveedor.
  ///
  /// In en, this message translates to:
  /// **'Ex. Distributor XYZ'**
  String get ejemploProveedor;

  /// No description provided for @ingreseNombreProveedor.
  ///
  /// In en, this message translates to:
  /// **'Enter the supplier name'**
  String get ingreseNombreProveedor;

  /// No description provided for @productoActualizado.
  ///
  /// In en, this message translates to:
  /// **'Product updated'**
  String get productoActualizado;

  /// No description provided for @ingreseCodigoPersonalizadoPrimero.
  ///
  /// In en, this message translates to:
  /// **'Enter a custom code first'**
  String get ingreseCodigoPersonalizadoPrimero;

  /// No description provided for @productoYaExisteSimple.
  ///
  /// In en, this message translates to:
  /// **'A product with this barcode already exists.'**
  String get productoYaExisteSimple;

  /// No description provided for @verProducto.
  ///
  /// In en, this message translates to:
  /// **'View product'**
  String get verProducto;

  /// No description provided for @agregueAlMenosUnProducto.
  ///
  /// In en, this message translates to:
  /// **'Add at least one product'**
  String get agregueAlMenosUnProducto;

  /// No description provided for @pedidoCreadoCorrectamente.
  ///
  /// In en, this message translates to:
  /// **'Order created successfully'**
  String get pedidoCreadoCorrectamente;

  /// No description provided for @crearPedido.
  ///
  /// In en, this message translates to:
  /// **'Create order'**
  String get crearPedido;

  /// No description provided for @gs1InvalidWeightCode.
  ///
  /// In en, this message translates to:
  /// **'Invalid weight/price code'**
  String get gs1InvalidWeightCode;

  /// No description provided for @gs1ParseError.
  ///
  /// In en, this message translates to:
  /// **'Could not parse the variable-weight code'**
  String get gs1ParseError;

  /// No description provided for @orphanCodeTitle.
  ///
  /// In en, this message translates to:
  /// **'Unregistered code'**
  String get orphanCodeTitle;

  /// Message of the orphan code assignment dialog
  ///
  /// In en, this message translates to:
  /// **'Code {codigo} does not belong to any product. Do you want to assign it to an existing product or create a new one?'**
  String orphanCodeMessage(String codigo);

  /// No description provided for @orphanAssignExistingAction.
  ///
  /// In en, this message translates to:
  /// **'Assign to existing product'**
  String get orphanAssignExistingAction;

  /// No description provided for @orphanCreateNewAction.
  ///
  /// In en, this message translates to:
  /// **'Create new product'**
  String get orphanCreateNewAction;

  /// No description provided for @actionCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get actionCancel;

  /// No description provided for @burstModeLabel.
  ///
  /// In en, this message translates to:
  /// **'Burst mode'**
  String get burstModeLabel;

  /// Snackbar shown when a product is added to the sale via burst scan
  ///
  /// In en, this message translates to:
  /// **'{producto} added (x{n})'**
  String productAddedCountSnackbar(String producto, int n);

  /// No description provided for @databaseMigrationErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Database error'**
  String get databaseMigrationErrorTitle;

  /// No description provided for @databaseMigrationErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'An error occurred while updating the database. Contact support.'**
  String get databaseMigrationErrorMessage;

  /// No description provided for @syncStateSyncing.
  ///
  /// In en, this message translates to:
  /// **'Syncing...'**
  String get syncStateSyncing;

  /// Badge text showing pending change count
  ///
  /// In en, this message translates to:
  /// **'{n} pending'**
  String syncStatePendingCount(int n);

  /// No description provided for @syncStateOffline.
  ///
  /// In en, this message translates to:
  /// **'Local safe mode'**
  String get syncStateOffline;

  /// No description provided for @syncStateSynced.
  ///
  /// In en, this message translates to:
  /// **'Synced'**
  String get syncStateSynced;

  /// No description provided for @syncStateError.
  ///
  /// In en, this message translates to:
  /// **'Sync error'**
  String get syncStateError;

  /// No description provided for @syncRetryAction.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get syncRetryAction;

  /// Offline banner text with pending count
  ///
  /// In en, this message translates to:
  /// **'Offline mode — {n} pending change(s)'**
  String offlineBannerPending(int n);

  /// No description provided for @creditLimitExceededTitle.
  ///
  /// In en, this message translates to:
  /// **'Credit Limit Exceeded'**
  String get creditLimitExceededTitle;

  /// Message for credit limit dialog
  ///
  /// In en, this message translates to:
  /// **'The client balance ({actual}) plus the new amount ({nuevo}) exceeds their credit limit ({limite}).'**
  String creditLimitExceededMessage(String actual, String nuevo, String limite);

  /// No description provided for @creditLimitContinueAnyway.
  ///
  /// In en, this message translates to:
  /// **'Do you want to continue anyway?'**
  String get creditLimitContinueAnyway;

  /// No description provided for @abonoHistoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Payment History'**
  String get abonoHistoryTitle;

  /// No description provided for @registerAbonoTitle.
  ///
  /// In en, this message translates to:
  /// **'Register Payment'**
  String get registerAbonoTitle;

  /// No description provided for @abonoAmountLabel.
  ///
  /// In en, this message translates to:
  /// **'Payment Amount'**
  String get abonoAmountLabel;

  /// No description provided for @remainingBalanceLabel.
  ///
  /// In en, this message translates to:
  /// **'Remaining Balance'**
  String get remainingBalanceLabel;

  /// No description provided for @saveAbonoAction.
  ///
  /// In en, this message translates to:
  /// **'Register Payment'**
  String get saveAbonoAction;

  /// No description provided for @debtorStatusUpToDate.
  ///
  /// In en, this message translates to:
  /// **'Up to date'**
  String get debtorStatusUpToDate;

  /// No description provided for @debtorStatusDueSoon.
  ///
  /// In en, this message translates to:
  /// **'Due soon'**
  String get debtorStatusDueSoon;

  /// No description provided for @debtorStatusOverdue.
  ///
  /// In en, this message translates to:
  /// **'Overdue'**
  String get debtorStatusOverdue;

  /// No description provided for @paymentPromiseDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Payment Promise Date'**
  String get paymentPromiseDateLabel;

  /// No description provided for @orderReceptionTitle.
  ///
  /// In en, this message translates to:
  /// **'Order Reception'**
  String get orderReceptionTitle;

  /// No description provided for @scanReceivedProductsHint.
  ///
  /// In en, this message translates to:
  /// **'Scan received products'**
  String get scanReceivedProductsHint;

  /// No description provided for @requestedCountLabel.
  ///
  /// In en, this message translates to:
  /// **'Requested'**
  String get requestedCountLabel;

  /// No description provided for @receivedCountLabel.
  ///
  /// In en, this message translates to:
  /// **'Received'**
  String get receivedCountLabel;

  /// No description provided for @discrepancyLabel.
  ///
  /// In en, this message translates to:
  /// **'Discrepancy'**
  String get discrepancyLabel;

  /// Summary message showing received vs. requested unit discrepancy
  ///
  /// In en, this message translates to:
  /// **'Discrepancy: received {received} of {requested} units'**
  String discrepancySummaryMessage(int received, int requested);

  /// No description provided for @receptionCompleteMessage.
  ///
  /// In en, this message translates to:
  /// **'Reception complete'**
  String get receptionCompleteMessage;

  /// No description provided for @receptionPartialMessage.
  ///
  /// In en, this message translates to:
  /// **'Partial reception'**
  String get receptionPartialMessage;

  /// No description provided for @reorderSuggestionTitle.
  ///
  /// In en, this message translates to:
  /// **'Reorder Suggestion'**
  String get reorderSuggestionTitle;

  /// No description provided for @productsBelowMinimumMessage.
  ///
  /// In en, this message translates to:
  /// **'Products below minimum stock'**
  String get productsBelowMinimumMessage;

  /// Line format for each product in a reorder suggestion
  ///
  /// In en, this message translates to:
  /// **'{producto} — Current: {actual}, Minimum: {minimo}'**
  String reorderProductLineLabel(String producto, int actual, int minimo);

  /// No description provided for @createSuggestedOrderAction.
  ///
  /// In en, this message translates to:
  /// **'Create Suggested Order'**
  String get createSuggestedOrderAction;

  /// No description provided for @confirmPartialReceptionAction.
  ///
  /// In en, this message translates to:
  /// **'Confirm Partial Reception'**
  String get confirmPartialReceptionAction;

  /// No description provided for @markDeliveredAction.
  ///
  /// In en, this message translates to:
  /// **'Mark as Delivered'**
  String get markDeliveredAction;

  /// No description provided for @reportFiltersTitle.
  ///
  /// In en, this message translates to:
  /// **'Report Filters'**
  String get reportFiltersTitle;

  /// No description provided for @filterOnlyDebtors.
  ///
  /// In en, this message translates to:
  /// **'Only debtors'**
  String get filterOnlyDebtors;

  /// No description provided for @filterAbonosOfMonth.
  ///
  /// In en, this message translates to:
  /// **'Payments of the month'**
  String get filterAbonosOfMonth;

  /// No description provided for @filterTopSold.
  ///
  /// In en, this message translates to:
  /// **'Top sold'**
  String get filterTopSold;

  /// No description provided for @filterCriticalInventoryValorized.
  ///
  /// In en, this message translates to:
  /// **'Critical inventoried value'**
  String get filterCriticalInventoryValorized;

  /// Label for selecting top N items
  ///
  /// In en, this message translates to:
  /// **'Top {n}'**
  String filterTopN(int n);

  /// No description provided for @filterIncludeCost.
  ///
  /// In en, this message translates to:
  /// **'Include cost'**
  String get filterIncludeCost;

  /// No description provided for @filterDateRange.
  ///
  /// In en, this message translates to:
  /// **'Date range'**
  String get filterDateRange;

  /// No description provided for @filterCustomer.
  ///
  /// In en, this message translates to:
  /// **'Customer'**
  String get filterCustomer;

  /// No description provided for @filterProduct.
  ///
  /// In en, this message translates to:
  /// **'Product'**
  String get filterProduct;

  /// No description provided for @movementsReportTitle.
  ///
  /// In en, this message translates to:
  /// **'Movements Report'**
  String get movementsReportTitle;

  /// No description provided for @inventoryReportTitle.
  ///
  /// In en, this message translates to:
  /// **'Inventory Report'**
  String get inventoryReportTitle;

  /// No description provided for @debtorsReportTitle.
  ///
  /// In en, this message translates to:
  /// **'Debtors Report'**
  String get debtorsReportTitle;

  /// No description provided for @criticalInventoryValorizedTitle.
  ///
  /// In en, this message translates to:
  /// **'Critical Inventory Valued'**
  String get criticalInventoryValorizedTitle;

  /// No description provided for @pdfPreviewAction.
  ///
  /// In en, this message translates to:
  /// **'PDF Preview'**
  String get pdfPreviewAction;

  /// No description provided for @shareAction.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get shareAction;

  /// No description provided for @closeAction.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get closeAction;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'es': return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
