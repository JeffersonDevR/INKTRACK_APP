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
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
  ];

  /// The application name
  ///
  /// In en, this message translates to:
  /// **'InkTrack'**
  String get appTitle;

  /// Home tab label
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// Clients tab label
  ///
  /// In en, this message translates to:
  /// **'Clients'**
  String get clientes;

  /// Suppliers tab label
  ///
  /// In en, this message translates to:
  /// **'Suppliers'**
  String get proveedores;

  /// Inventory tab label
  ///
  /// In en, this message translates to:
  /// **'Inventory'**
  String get inventario;

  /// Stock label
  ///
  /// In en, this message translates to:
  /// **'Stock'**
  String get stock;

  /// Reports tab label
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get reportes;

  /// Profile page title
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get perfil;

  /// Dark mode toggle label
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get modoOscuro;

  /// Logout button label
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get cerrarSesion;

  /// Email label
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// Cancel button label
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancelar;

  /// Save button label
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get guardar;

  /// Language toggle label
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get idioma;

  /// User label
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get usuario;

  /// Admin role label
  ///
  /// In en, this message translates to:
  /// **'Admin'**
  String get admin;

  /// User ID label
  ///
  /// In en, this message translates to:
  /// **'User ID'**
  String get userId;

  /// Not available text
  ///
  /// In en, this message translates to:
  /// **'Not available'**
  String get noDisponible;

  /// Logout dialog title
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get cerrarSesionTitulo;

  /// Logout confirmation message
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to logout?'**
  String get cerrarSesionPregunta;

  /// Home panel header
  ///
  /// In en, this message translates to:
  /// **'Home Panel'**
  String get panelDeInicio;

  /// Client management header
  ///
  /// In en, this message translates to:
  /// **'Client Management'**
  String get gestionDeClientes;

  /// Suppliers header
  ///
  /// In en, this message translates to:
  /// **'Suppliers'**
  String get proveedoresHeader;

  /// Inventory control header
  ///
  /// In en, this message translates to:
  /// **'Inventory Control'**
  String get controlDeInventario;

  /// Business reports header
  ///
  /// In en, this message translates to:
  /// **'Business Reports'**
  String get reportesDeNegocio;

  /// No local selected text
  ///
  /// In en, this message translates to:
  /// **'No location selected'**
  String get sinLocal;

  /// Movements label
  ///
  /// In en, this message translates to:
  /// **'Movements'**
  String get movimientos;

  /// Products label
  ///
  /// In en, this message translates to:
  /// **'Products'**
  String get productos;

  /// Excel export label
  ///
  /// In en, this message translates to:
  /// **'Excel'**
  String get excel;

  /// PDF export label
  ///
  /// In en, this message translates to:
  /// **'PDF'**
  String get pdf;

  /// Expense type label
  ///
  /// In en, this message translates to:
  /// **'Expense'**
  String get egreso;

  /// Income type label
  ///
  /// In en, this message translates to:
  /// **'Income'**
  String get ingreso;

  /// OCR scan label
  ///
  /// In en, this message translates to:
  /// **'OCR'**
  String get ocr;

  /// Barcode scan label
  ///
  /// In en, this message translates to:
  /// **'Barcode'**
  String get codigo;

  /// Product label
  ///
  /// In en, this message translates to:
  /// **'Product'**
  String get producto;

  /// Client label
  ///
  /// In en, this message translates to:
  /// **'Client'**
  String get cliente;

  /// Supplier label
  ///
  /// In en, this message translates to:
  /// **'Supplier'**
  String get proveedor;

  /// New order label
  ///
  /// In en, this message translates to:
  /// **'New Order'**
  String get nuevoPedido;

  /// Restock label
  ///
  /// In en, this message translates to:
  /// **'Restock'**
  String get restock;

  /// Clients page title
  ///
  /// In en, this message translates to:
  /// **'Clients'**
  String get clientesTitulo;

  /// Suppliers page title
  ///
  /// In en, this message translates to:
  /// **'Suppliers'**
  String get proveedoresTitulo;

  /// Inventory page title
  ///
  /// In en, this message translates to:
  /// **'Inventory'**
  String get inventarioTitulo;

  /// Reports page title
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get reportesTitulo;

  /// PDF export success message
  ///
  /// In en, this message translates to:
  /// **'PDF exported: {filename}'**
  String pdfExportado(String filename);

  /// Excel export success message
  ///
  /// In en, this message translates to:
  /// **'Excel exported: {filename}'**
  String excelExportado(String filename);

  /// PDF export error message
  ///
  /// In en, this message translates to:
  /// **'Error exporting PDF: {error}'**
  String errorAlExportarPdf(String error);

  /// Excel export error message
  ///
  /// In en, this message translates to:
  /// **'Error exporting Excel: {error}'**
  String errorAlExportarExcel(String error);

  /// Pending deliveries message
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 pending delivery} other{{count} pending deliveries}}'**
  String entregasPendientes(int count);

  /// View orders button
  ///
  /// In en, this message translates to:
  /// **'View Orders'**
  String get verPedidos;

  /// Movement detail dialog title
  ///
  /// In en, this message translates to:
  /// **'Movement Detail'**
  String get detalleMovimiento;

  /// Concept label
  ///
  /// In en, this message translates to:
  /// **'Concept'**
  String get concepto;

  /// Amount label
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get monto;

  /// Date label
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get fecha;

  /// Category label
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get categoria;

  /// Type label
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get tipo;

  /// Results title
  ///
  /// In en, this message translates to:
  /// **'Results'**
  String get resultados;

  /// Total accumulated title
  ///
  /// In en, this message translates to:
  /// **'General Report'**
  String get acumuladoTotal;

  /// Total sales label
  ///
  /// In en, this message translates to:
  /// **'Sales'**
  String get ventasTotales;

  /// Total expenses label
  ///
  /// In en, this message translates to:
  /// **'Expenses'**
  String get gastosTotales;

  /// Equity label
  ///
  /// In en, this message translates to:
  /// **'Equity'**
  String get patrimonio;

  /// Net balance label
  ///
  /// In en, this message translates to:
  /// **'Net Balance'**
  String get balanceNeto;

  /// Cash flow trend title
  ///
  /// In en, this message translates to:
  /// **'Cash Flow Trend'**
  String get tendenciaFlujo;

  /// Recent activity title
  ///
  /// In en, this message translates to:
  /// **'Recent Activity'**
  String get actividadReciente;

  /// Filter results title
  ///
  /// In en, this message translates to:
  /// **'Filter Results'**
  String get resultadosFiltro;

  /// Clear button label
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get limpiar;

  /// No activity message
  ///
  /// In en, this message translates to:
  /// **'No activity recorded'**
  String get noHayActividadRegistrada;

  /// Empty state subtitle
  ///
  /// In en, this message translates to:
  /// **'Your movements will appear here'**
  String get tusMovimientosApareceranAqui;

  /// Expense type label
  ///
  /// In en, this message translates to:
  /// **'Expense'**
  String get egresoTipo;

  /// Activity type label
  ///
  /// In en, this message translates to:
  /// **'Activity'**
  String get actividad;

  /// No description provided for @resumenClientes.
  ///
  /// In en, this message translates to:
  /// **'Clients\nSummary'**
  String get resumenClientes;

  /// Financial summary title
  ///
  /// In en, this message translates to:
  /// **'Financial\nSummary'**
  String get resumenFinanciero;

  /// Today label
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get hoy;

  /// Yes label
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get si;

  /// No label
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// Start label
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get inicio;

  /// End label
  ///
  /// In en, this message translates to:
  /// **'End'**
  String get fin;

  /// Period label for exports
  ///
  /// In en, this message translates to:
  /// **'Period: {start} - {end}'**
  String periodo(String start, String end);

  /// Inventory sheet name
  ///
  /// In en, this message translates to:
  /// **'Inventory'**
  String get inventarioHoja;

  /// Clients sheet name
  ///
  /// In en, this message translates to:
  /// **'Clients'**
  String get clientesHoja;

  /// Name label
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get nombre;

  /// Price label
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get precio;

  /// Total value label
  ///
  /// In en, this message translates to:
  /// **'Total Value'**
  String get valorTotal;

  /// Clients category
  ///
  /// In en, this message translates to:
  /// **'Clients'**
  String get clientesCategoria;

  /// Suppliers category
  ///
  /// In en, this message translates to:
  /// **'Suppliers'**
  String get proveedoresCategoria;

  /// On credit label
  ///
  /// In en, this message translates to:
  /// **'On Credit'**
  String get fiado;

  /// Wednesday label
  ///
  /// In en, this message translates to:
  /// **'Wednesday'**
  String get miercoles;

  /// Suppliers summary title
  ///
  /// In en, this message translates to:
  /// **'Supplier\nSummary'**
  String get resumenProveedores;

  /// Total label
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// Suppliers list title
  ///
  /// In en, this message translates to:
  /// **'Suppliers List'**
  String get listadoProveedores;

  /// Edit button
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get editar;

  /// Delete button
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get eliminar;

  /// Create button
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get crear;

  /// Update button
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get actualizar;

  /// Add button
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get agregar;

  /// Search placeholder
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get buscar;

  /// Filter label
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get filtro;

  /// Product catalog title
  ///
  /// In en, this message translates to:
  /// **'Product Catalog'**
  String get catalogoProductos;

  /// Inventory control title
  ///
  /// In en, this message translates to:
  /// **'Inventory\nControl'**
  String get controlDeInventarioTitle;

  /// Stock value label
  ///
  /// In en, this message translates to:
  /// **'Stock Value'**
  String get valorStock;

  /// Total debt label
  ///
  /// In en, this message translates to:
  /// **'Total Debt'**
  String get deudaTotal;

  /// Clients list title
  ///
  /// In en, this message translates to:
  /// **'Clients List'**
  String get listadoClientes;

  /// Supplier orders title
  ///
  /// In en, this message translates to:
  /// **'Supplier Orders'**
  String get pedidosProveedores;

  /// Pending orders title
  ///
  /// In en, this message translates to:
  /// **'Pending Orders'**
  String get pedidosPendientes;

  /// New income title
  ///
  /// In en, this message translates to:
  /// **'New Income'**
  String get nuevoIngreso;

  /// New expense title
  ///
  /// In en, this message translates to:
  /// **'New Expense'**
  String get nuevoEgreso;

  /// Total amount label
  ///
  /// In en, this message translates to:
  /// **'Total Amount'**
  String get montoTotal;

  /// Total products label
  ///
  /// In en, this message translates to:
  /// **'Total Products'**
  String get totalProductos;

  /// New supplier order title
  ///
  /// In en, this message translates to:
  /// **'New Supplier Order'**
  String get nuevoPedidoProveedor;

  /// Select supplier label
  ///
  /// In en, this message translates to:
  /// **'Select Supplier'**
  String get seleccionarProveedor;

  /// Delivery date label
  ///
  /// In en, this message translates to:
  /// **'Delivery Date'**
  String get fechaEntrega;

  /// Status label
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get estado;

  /// Pending status
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get estadoPendiente;

  /// Completed status
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get estadoCompletado;

  /// Cancelled status
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get estadoCancelado;

  /// No data message
  ///
  /// In en, this message translates to:
  /// **'No data available'**
  String get noDataAvailable;

  /// On credit label
  ///
  /// In en, this message translates to:
  /// **'On Credit'**
  String get onCredit;

  /// Cash label
  ///
  /// In en, this message translates to:
  /// **'Cash'**
  String get cash;

  /// Register sale title
  ///
  /// In en, this message translates to:
  /// **'Register Sale'**
  String get registrarVenta;

  /// Cart label
  ///
  /// In en, this message translates to:
  /// **'Cart'**
  String get carrito;

  /// Finalize sale button
  ///
  /// In en, this message translates to:
  /// **'Finalize Sale'**
  String get finalizarVenta;

  /// Charge button
  ///
  /// In en, this message translates to:
  /// **'Charge'**
  String get cobrar;

  /// Cash payment
  ///
  /// In en, this message translates to:
  /// **'Cash'**
  String get efectivo;

  /// Transfer payment
  ///
  /// In en, this message translates to:
  /// **'Transfer'**
  String get transferencia;

  /// Mixed payment
  ///
  /// In en, this message translates to:
  /// **'Mixed Payment'**
  String get pagoMixto;

  /// Content label
  ///
  /// In en, this message translates to:
  /// **'Content'**
  String get contenido;

  /// Observations label
  ///
  /// In en, this message translates to:
  /// **'Observations'**
  String get observaciones;

  /// Description label
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get descripcion;

  /// Phone label
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get telefono;

  /// Address label
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get direccion;

  /// Notes label
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notas;

  /// Warehouse type
  ///
  /// In en, this message translates to:
  /// **'Warehouse'**
  String get bodega;

  /// Store label
  ///
  /// In en, this message translates to:
  /// **'Store'**
  String get local;

  /// Reset data button
  ///
  /// In en, this message translates to:
  /// **'Reset Data'**
  String get resetData;

  /// Reset data confirmation message
  ///
  /// In en, this message translates to:
  /// **'This will delete ALL app data (products, clients, suppliers, sales, movements, locations).'**
  String get resetearData;

  /// Reset data dialog title
  ///
  /// In en, this message translates to:
  /// **'Reset All Data'**
  String get resetDataTitle;

  /// No locations message
  ///
  /// In en, this message translates to:
  /// **'No locations registered'**
  String get noLocales;

  /// Incorrect data message
  ///
  /// In en, this message translates to:
  /// **'Incorrect data'**
  String get datosIncorrectos;

  /// Name required message
  ///
  /// In en, this message translates to:
  /// **'Name is required'**
  String get nombreRequerido;

  /// Required fields message
  ///
  /// In en, this message translates to:
  /// **'Required fields'**
  String get camposRequeridos;

  /// Verify information message
  ///
  /// In en, this message translates to:
  /// **'Please verify the information'**
  String get verificarInformacion;

  /// Select location prompt
  ///
  /// In en, this message translates to:
  /// **'Select Location'**
  String get seleccionarLocal;

  /// Location label
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get ubicacion;

  /// Minimum stock label
  ///
  /// In en, this message translates to:
  /// **'Min Stock'**
  String get stockMinimo;

  /// Current stock label
  ///
  /// In en, this message translates to:
  /// **'Current Stock'**
  String get stockActual;

  /// Barcode label
  ///
  /// In en, this message translates to:
  /// **'Barcode'**
  String get codigoBarras;

  /// Sale price label
  ///
  /// In en, this message translates to:
  /// **'Sale Price'**
  String get precioVenta;

  /// Purchase price label
  ///
  /// In en, this message translates to:
  /// **'Purchase Price'**
  String get precioCompra;

  /// Profit label
  ///
  /// In en, this message translates to:
  /// **'Profit'**
  String get ganancia;

  /// New product title
  ///
  /// In en, this message translates to:
  /// **'New Product'**
  String get nuevoProducto;

  /// New client title
  ///
  /// In en, this message translates to:
  /// **'New Client'**
  String get nuevoCliente;

  /// New supplier title
  ///
  /// In en, this message translates to:
  /// **'New Supplier'**
  String get nuevoProveedor;

  /// Pending balance label
  ///
  /// In en, this message translates to:
  /// **'Pending Balance'**
  String get saldoPendiente;

  /// Pay button
  ///
  /// In en, this message translates to:
  /// **'Pay'**
  String get abonar;

  /// Payment label
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get abono;

  /// Payments label
  ///
  /// In en, this message translates to:
  /// **'Payments'**
  String get abonos;

  /// Payment added message
  ///
  /// In en, this message translates to:
  /// **'Payment added'**
  String get abonoAgregado;

  /// Error adding payment message
  ///
  /// In en, this message translates to:
  /// **'Error adding payment'**
  String get errorAgregarAbono;

  /// Payment amount label
  ///
  /// In en, this message translates to:
  /// **'Payment Amount'**
  String get montoAbono;

  /// Pending debt label
  ///
  /// In en, this message translates to:
  /// **'Pending Debt'**
  String get deudaPendiente;

  /// Current debt label
  ///
  /// In en, this message translates to:
  /// **'Current Debt'**
  String get deudaActual;

  /// New movement title
  ///
  /// In en, this message translates to:
  /// **'New Movement'**
  String get nuevoMovimiento;

  /// Movement concept label
  ///
  /// In en, this message translates to:
  /// **'Movement Concept'**
  String get conceptoMovimiento;

  /// Movement added message
  ///
  /// In en, this message translates to:
  /// **'Movement added'**
  String get movimientoAgregado;

  /// Error adding movement message
  ///
  /// In en, this message translates to:
  /// **'Error adding movement'**
  String get errorAgregarMovimiento;

  /// My locations title
  ///
  /// In en, this message translates to:
  /// **'My Locations'**
  String get misLocales;

  /// Add location button
  ///
  /// In en, this message translates to:
  /// **'Add Location'**
  String get agregarLocal;

  /// Delete all data button
  ///
  /// In en, this message translates to:
  /// **'Delete All Data'**
  String get eliminarTodosLosDatos;

  /// Add first store message
  ///
  /// In en, this message translates to:
  /// **'Add your first store or location'**
  String get agregaTuPrimeraTienda;

  /// Current label
  ///
  /// In en, this message translates to:
  /// **'Current'**
  String get actual;

  /// Select button
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get seleccionar;

  /// New location title
  ///
  /// In en, this message translates to:
  /// **'New Location'**
  String get nuevoLocal;

  /// Edit location title
  ///
  /// In en, this message translates to:
  /// **'Edit Location'**
  String get editarLocal;

  /// Store type
  ///
  /// In en, this message translates to:
  /// **'Store'**
  String get tienda;

  /// Office type
  ///
  /// In en, this message translates to:
  /// **'Office'**
  String get oficina;

  /// No orders message
  ///
  /// In en, this message translates to:
  /// **'No orders'**
  String get noHayPedidos;

  /// Create order message
  ///
  /// In en, this message translates to:
  /// **'Create a supplier order to receive delivery alerts.'**
  String get creaUnPedidoProveedor;

  /// Supplier orders title
  ///
  /// In en, this message translates to:
  /// **'Supplier Orders'**
  String get pedidosDelProveedor;

  /// Low label
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get bajo;

  /// Edit product title
  ///
  /// In en, this message translates to:
  /// **'Edit Product'**
  String get editarProducto;

  /// Deactivate product dialog title
  ///
  /// In en, this message translates to:
  /// **'Deactivate Product'**
  String get desactivarProducto;

  /// Reactivate product dialog title
  ///
  /// In en, this message translates to:
  /// **'Reactivate Product'**
  String get reactivarProducto;

  /// Reactivate product dialog content
  ///
  /// In en, this message translates to:
  /// **'Reactivate \"{name}\" in the catalog?'**
  String reactivarEnCatalogo(String name);

  /// Empty inventory message
  ///
  /// In en, this message translates to:
  /// **'Empty inventory'**
  String get inventarioVacio;

  /// Start adding products message
  ///
  /// In en, this message translates to:
  /// **'Start by adding products manually or scanning barcodes.'**
  String get comienzaAgregandoProductos;

  /// Error saving message
  ///
  /// In en, this message translates to:
  /// **'Error saving'**
  String get errorAlGuardar;

  /// Product saved message
  ///
  /// In en, this message translates to:
  /// **'Product saved'**
  String get productoGuardado;

  /// Category label
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get categoriaProducto;

  /// Supplier label
  ///
  /// In en, this message translates to:
  /// **'Supplier'**
  String get proveedorProducto;

  /// No supplier message
  ///
  /// In en, this message translates to:
  /// **'No supplier'**
  String get sinProveedor;

  /// Barcode scanner title
  ///
  /// In en, this message translates to:
  /// **'Barcode Scanner'**
  String get escanerCodigoBarras;

  /// Uploading message
  ///
  /// In en, this message translates to:
  /// **'Uploading changes...'**
  String get subiendoCambios;

  /// Downloading message
  ///
  /// In en, this message translates to:
  /// **'Downloading from cloud...'**
  String get descargandoDeLaNube;

  /// Syncing message
  ///
  /// In en, this message translates to:
  /// **'Syncing everything...'**
  String get sincronizandoTodo;

  /// Upload changes button
  ///
  /// In en, this message translates to:
  /// **'Upload Changes'**
  String get subirCambios;

  /// Download from cloud button
  ///
  /// In en, this message translates to:
  /// **'Download from Cloud'**
  String get descargarDeLaNube;

  /// Sync all button
  ///
  /// In en, this message translates to:
  /// **'Sync All'**
  String get sincronizarTodo;

  /// Financial reports title
  ///
  /// In en, this message translates to:
  /// **'Financial Reports'**
  String get reportesFinancieros;

  /// Analysis period label
  ///
  /// In en, this message translates to:
  /// **'ANALYSIS PERIOD'**
  String get periodoDeAnalisis;

  /// Select period button
  ///
  /// In en, this message translates to:
  /// **'Select Period'**
  String get seleccionarPeriodo;

  /// Total income label
  ///
  /// In en, this message translates to:
  /// **'TOTAL INCOME'**
  String get ingresosTotales;

  /// Total expenses label
  ///
  /// In en, this message translates to:
  /// **'TOTAL EXPENSES'**
  String get egresosTotales;

  /// Completed sales label
  ///
  /// In en, this message translates to:
  /// **'COMPLETED SALES'**
  String get ventasRealizadas;

  /// Net profit label
  ///
  /// In en, this message translates to:
  /// **'NET PROFIT'**
  String get utilidadNeta;

  /// Sales vs expenses chart title
  ///
  /// In en, this message translates to:
  /// **'Sales vs Expenses'**
  String get ventasVsGastos;

  /// Expense distribution chart title
  ///
  /// In en, this message translates to:
  /// **'Expense Distribution'**
  String get distribucionGastos;

  /// No category label
  ///
  /// In en, this message translates to:
  /// **'No Category'**
  String get sinCategoria;

  /// Week label
  ///
  /// In en, this message translates to:
  /// **'WEEK {number}'**
  String semana(int number);

  /// No recorded expenses message
  ///
  /// In en, this message translates to:
  /// **'No recorded expenses'**
  String get sinGastosRegistrados;

  /// Edit supplier title
  ///
  /// In en, this message translates to:
  /// **'Edit Supplier'**
  String get editarProveedor;

  /// Edit client title
  ///
  /// In en, this message translates to:
  /// **'Edit Client'**
  String get editarCliente;

  /// Save/Update button
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get guardarActualizar;

  /// Quantity label
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get cantidad;

  /// Add product button
  ///
  /// In en, this message translates to:
  /// **'Add Product'**
  String get agregarProducto;

  /// Scan barcode button
  ///
  /// In en, this message translates to:
  /// **'Scan Barcode'**
  String get escanearCodigoBarras;

  /// Search product placeholder
  ///
  /// In en, this message translates to:
  /// **'Search Product'**
  String get buscarProducto;

  /// Saved successfully message
  ///
  /// In en, this message translates to:
  /// **'Saved successfully'**
  String get guardadoExitoso;

  /// Please enter name message
  ///
  /// In en, this message translates to:
  /// **'Please enter the name'**
  String get ingreseNombre;

  /// Minimum 2 characters message
  ///
  /// In en, this message translates to:
  /// **'Minimum 2 characters'**
  String get minimo2Caracteres;

  /// Please enter phone message
  ///
  /// In en, this message translates to:
  /// **'Please enter the phone'**
  String get ingreseTelefono;

  /// Phone 10 digits message
  ///
  /// In en, this message translates to:
  /// **'The phone must be exactly 10 digits'**
  String get telefono10Digitos;

  /// 10 digits no spaces hint
  ///
  /// In en, this message translates to:
  /// **'10 digits without spaces'**
  String get digitos10SinEspacios;

  /// Please enter email message
  ///
  /// In en, this message translates to:
  /// **'Please enter the email'**
  String get ingreseEmail;

  /// Please enter valid email message
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get ingreseEmailValido;

  /// Visit days label
  ///
  /// In en, this message translates to:
  /// **'Visit days'**
  String get diasVisita;

  /// Monday label
  ///
  /// In en, this message translates to:
  /// **'Monday'**
  String get lunes;

  /// Tuesday label
  ///
  /// In en, this message translates to:
  /// **'Tuesday'**
  String get martes;

  /// Thursday label
  ///
  /// In en, this message translates to:
  /// **'Thursday'**
  String get jueves;

  /// Friday label
  ///
  /// In en, this message translates to:
  /// **'Friday'**
  String get viernes;

  /// Saturday label
  ///
  /// In en, this message translates to:
  /// **'Saturday'**
  String get sabado;

  /// Sunday label
  ///
  /// In en, this message translates to:
  /// **'Sunday'**
  String get domingo;

  /// New category label
  ///
  /// In en, this message translates to:
  /// **'New category'**
  String get nuevaCategoria;

  /// Category name label
  ///
  /// In en, this message translates to:
  /// **'Category name'**
  String get nombreCategoria;

  /// Select category hint
  ///
  /// In en, this message translates to:
  /// **'Select a category'**
  String get seleccioneCategoria;

  /// Select or create category message
  ///
  /// In en, this message translates to:
  /// **'Select or create a category'**
  String get seleccioneOCreeCategoria;

  /// Enter amount message
  ///
  /// In en, this message translates to:
  /// **'Enter an amount'**
  String get ingreseMonto;

  /// Invalid amount message
  ///
  /// In en, this message translates to:
  /// **'Invalid amount'**
  String get montoInvalido;

  /// Enter concept message
  ///
  /// In en, this message translates to:
  /// **'Enter a concept'**
  String get ingreseConcepto;

  /// Client optional label
  ///
  /// In en, this message translates to:
  /// **'Client (Optional)'**
  String get clienteOpcional;

  /// None label
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get ninguno;

  /// Credit sale label
  ///
  /// In en, this message translates to:
  /// **'Credit Sale'**
  String get ventaFiada;

  /// Add to pending balance message
  ///
  /// In en, this message translates to:
  /// **'Add to client\'s pending balance'**
  String get anadirSaldoPendiente;

  /// Calculated automatically hint
  ///
  /// In en, this message translates to:
  /// **'Calculated automatically'**
  String get calculadoAutomaticamente;

  /// No client general sale label
  ///
  /// In en, this message translates to:
  /// **'No client (general sale)'**
  String get sinClienteVentaGeneral;

  /// Write client name label
  ///
  /// In en, this message translates to:
  /// **'Write client name'**
  String get escribirNombreCliente;

  /// Enter client name message
  ///
  /// In en, this message translates to:
  /// **'Enter the client name'**
  String get ingreseNombreCliente;

  /// Credit sale creditors label
  ///
  /// In en, this message translates to:
  /// **'Credit sale (Creditors)'**
  String get ventaCreditoFiado;

  /// Will increase pending balance message
  ///
  /// In en, this message translates to:
  /// **'Will increase the client\'s pending balance'**
  String get aumentaraSaldoPendiente;

  /// No products message
  ///
  /// In en, this message translates to:
  /// **'No products'**
  String get noHayProductos;

  /// Scan or add products message
  ///
  /// In en, this message translates to:
  /// **'Scan or add products from inventory'**
  String get escaneeOAgregueProductos;

  /// Enter sale amount message
  ///
  /// In en, this message translates to:
  /// **'Enter the amount'**
  String get ingreseMontoVenta;

  /// Amount must be greater than 0 message
  ///
  /// In en, this message translates to:
  /// **'Amount must be greater than 0'**
  String get montoMayorCero;

  /// Unit price label
  ///
  /// In en, this message translates to:
  /// **'Unit price'**
  String get precioUnitario;

  /// Scan note receipt title
  ///
  /// In en, this message translates to:
  /// **'Scan Note / Receipt'**
  String get escanearNotaRecibo;

  /// Camera label
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get camara;

  /// Gallery label
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get galeria;

  /// Detected data message
  ///
  /// In en, this message translates to:
  /// **'Detected data:'**
  String get datosDetectados;

  /// Detected amount message
  ///
  /// In en, this message translates to:
  /// **'Amount: {amount}'**
  String montoDetectado(String amount);

  /// Detected client message
  ///
  /// In en, this message translates to:
  /// **'Client: {name}'**
  String clienteDetectado(String name);

  /// No data detected message
  ///
  /// In en, this message translates to:
  /// **'No clear data detected. Try again.'**
  String get noSeDetectaronDatos;

  /// Enter sale concept message
  ///
  /// In en, this message translates to:
  /// **'Enter the concept'**
  String get ingreseConceptoVenta;

  /// Product inactive message
  ///
  /// In en, this message translates to:
  /// **'Product \"{name}\" is inactive'**
  String productoInactivo(String name);

  /// Not enough stock message
  ///
  /// In en, this message translates to:
  /// **'Not enough stock of \"{name}\". Available: {available}'**
  String noHaySuficienteStock(String name, int available);

  /// Sale registered successfully message
  ///
  /// In en, this message translates to:
  /// **'Sale registered successfully'**
  String get ventaRegistradaExito;

  /// Scan button label
  ///
  /// In en, this message translates to:
  /// **'Scan'**
  String get escanear;

  /// Add product sheet title
  ///
  /// In en, this message translates to:
  /// **'Add Product'**
  String get agregarProductoTitle;

  /// Search product placeholder
  ///
  /// In en, this message translates to:
  /// **'Search product'**
  String get buscarProductoPlaceholder;

  /// Stock label with value
  ///
  /// In en, this message translates to:
  /// **'Stock: {stock}'**
  String stockLabel(int stock);

  /// Example name hint
  ///
  /// In en, this message translates to:
  /// **'Ex. John Doe'**
  String get ejemploNombre;

  /// Example phone hint
  ///
  /// In en, this message translates to:
  /// **'Ex. 3001234567'**
  String get ejemploTelefono;

  /// Example email hint
  ///
  /// In en, this message translates to:
  /// **'example@email.com'**
  String get ejemploEmail;

  /// Supplier optional label
  ///
  /// In en, this message translates to:
  /// **'Supplier (Optional)'**
  String get proveedorOpcional;

  /// Client optional label
  ///
  /// In en, this message translates to:
  /// **'Client (Optional)'**
  String get clienteOpcionalLabel;

  /// Enter the amount message
  ///
  /// In en, this message translates to:
  /// **'Enter the amount'**
  String get ingreseElMonto;

  /// Maximum amount message
  ///
  /// In en, this message translates to:
  /// **'Maximum 999,999,999'**
  String get maximoMonto;

  /// Client optional label
  ///
  /// In en, this message translates to:
  /// **'Client (optional)'**
  String get clienteOpcional2;

  /// Save sale button label
  ///
  /// In en, this message translates to:
  /// **'Save sale'**
  String get guardarVenta;

  /// Sale registered successfully message
  ///
  /// In en, this message translates to:
  /// **'Sale registered successfully'**
  String get ventaRegistradaExitoMsg;

  /// Product not found message
  ///
  /// In en, this message translates to:
  /// **'Product not found in inventory'**
  String get productoNoEncontrado;

  /// Restock label
  ///
  /// In en, this message translates to:
  /// **'Restock: {name}'**
  String restockLabel(String name);

  /// Scan code title
  ///
  /// In en, this message translates to:
  /// **'Scan Code'**
  String get escanearCodigoTitulo;

  /// Movement history title
  ///
  /// In en, this message translates to:
  /// **'Movement History'**
  String get historialMovimientos;

  /// Recent records label
  ///
  /// In en, this message translates to:
  /// **'Recent Records'**
  String get recentRecords;

  /// Filtered results label
  ///
  /// In en, this message translates to:
  /// **'Filtered Results'**
  String get resultadosFiltroTitle;

  /// Total items label
  ///
  /// In en, this message translates to:
  /// **'Total: {count}'**
  String totalItems(int count);

  /// Clear filter button
  ///
  /// In en, this message translates to:
  /// **'Clear Filter'**
  String get limpiarFiltro;

  /// Delete record dialog title
  ///
  /// In en, this message translates to:
  /// **'Delete Record'**
  String get eliminarRegistro;

  /// Delete record confirmation message
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to permanently delete this record?'**
  String get confirmarEliminarRegistro;

  /// Empty history title
  ///
  /// In en, this message translates to:
  /// **'Empty history'**
  String get historialVacio;

  /// No records message
  ///
  /// In en, this message translates to:
  /// **'No income or expense records yet.'**
  String get noHayRegistros;

  /// Edit record label
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get editarRegistro;

  /// Movement history title
  ///
  /// In en, this message translates to:
  /// **'Movement History'**
  String get movementHistoryTitle;

  /// Clear filter button label
  ///
  /// In en, this message translates to:
  /// **'Clear Filter'**
  String get clearFilterBtn;

  /// Empty history title
  ///
  /// In en, this message translates to:
  /// **'Empty history'**
  String get emptyHistoryTitle;

  /// No records yet message
  ///
  /// In en, this message translates to:
  /// **'No income or expense records yet.'**
  String get noRecordsYet;

  /// Delete record dialog title
  ///
  /// In en, this message translates to:
  /// **'Delete Record'**
  String get deleteRecordTitle;

  /// Delete record confirmation message
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to permanently delete this record?'**
  String get confirmDeleteRecord;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
