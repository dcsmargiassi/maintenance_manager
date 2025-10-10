// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Registro de Vehículos';

  @override
  String get createAccount => 'Crear cuenta';

  @override
  String get email => 'Correo electrónico';

  @override
  String get emailVerified => 'Correo verificado';

  @override
  String get yes => 'Sí';

  @override
  String get no => 'No';

  @override
  String get username => 'Nombre de usuario';

  @override
  String get usernameHint => 'Ingrese nombre de usuario';

  @override
  String get password => 'Contraseña';

  @override
  String get firstName => 'Nombre';

  @override
  String get firstNameHint => 'Ingrese nombre';

  @override
  String get lastName => 'Apellido';

  @override
  String get lastNameHint => 'Ingrese apellido';

  @override
  String get enablePrivacyAnalytics => 'Activar análisis de privacidad';

  @override
  String get privacyAnalyticsSubtitle =>
      'Ayuda a mejorar la aplicación compartiendo datos de uso anónimos.';

  @override
  String get genericSuccess => '¡Información actualizada con éxito!';

  @override
  String get genericError => 'Ocurrió un error. Por favor, inténtalo de nuevo.';

  @override
  String genericErrorWithDetail(Object errorDetail) {
    return 'Error: $errorDetail';
  }

  @override
  String welcomeUser(Object username) {
    return '¡Bienvenido, $username! Se envió un correo de verificación.';
  }

  @override
  String get saveChanges => 'Guardar cambios';

  @override
  String get profile => 'Perfil';

  @override
  String get editProfile => 'Editar perfil';

  @override
  String get editVehicle => 'Editar vehículo';

  @override
  String get vehicleDetails => 'Detalles del vehículo';

  @override
  String get financialSummary => 'Resumen financiero';

  @override
  String get vehicleInformationTitle => 'Información del vehículo';

  @override
  String get engineDetails => 'Detalles del motor';

  @override
  String get exteriorDetails => 'Detalles exteriores';

  @override
  String get batteryDetails => 'Detalles de la batería';

  @override
  String get backToHome => 'Volver al inicio';

  @override
  String get resetPassword => 'Restablecer contraseña';

  @override
  String get resetPasswordEmailSent =>
      '¡Correo de restablecimiento enviado! Revisa tu bandeja de entrada.';

  @override
  String get enterEmailMessage =>
      'Ingresa tu correo electrónico para recibir un enlace de restablecimiento.';

  @override
  String get sendResetEmail => 'Enviar correo de restablecimiento';

  @override
  String get sendVerificationEmail => 'Enviar correo de verificación';

  @override
  String get verificationEmailSent =>
      '¡Correo de verificación enviado! Revisa tu bandeja de entrada.';

  @override
  String get fillInAllFields => 'Rellena todos los campos';

  @override
  String get signIn => 'Iniciar sesión';

  @override
  String get fillInTwoFields =>
      'Por favor, completa 2 de los campos anteriores.';

  @override
  String get emptyMessageText => 'Por favor, ingresa texto';

  @override
  String get enterValidNumber => 'Por favor, ingresa un número válido';

  @override
  String get noNegatives => 'Sin números negativos';

  @override
  String get enterRealisticValue => 'Ingresa un valor realista';

  @override
  String maxDecimalPlacesMessage(Object maxDecimalPlaces) {
    return 'Se permiten un máximo de $maxDecimalPlaces decimales';
  }

  @override
  String get fuelAmountLabel => 'Cantidad de combustible';

  @override
  String get fuelAmountLabelHint => 'Ingresa la cantidad de combustible';

  @override
  String get fuelPriceLabel => 'Precio del combustible';

  @override
  String get fuelPriceLabelHint => 'Ingresa el precio del combustible';

  @override
  String get totalFuelCostLabel => 'Costo total';

  @override
  String get totalFuelCostLabelHint => 'Ingresa el costo total';

  @override
  String get odometerLabel => 'Odómetro';

  @override
  String get odometerLabelHint => 'Ingresa el odómetro actual (opcional)';

  @override
  String get calculateMissingFieldLabel => 'Calcular campo faltante';

  @override
  String get dateLabel => 'Fecha';

  @override
  String get enterDateRefuelLabel => 'Ingresa la fecha de recarga';

  @override
  String get enterValidDateMessage => 'Por favor, selecciona una fecha válida';

  @override
  String errorSavingFuelRecordMessage(Object error) {
    return 'Error al guardar el registro de combustible: $error';
  }

  @override
  String get addFuelRecordButton => 'Agregar registro de combustible';

  @override
  String get editFuelRecordButton => 'Editar registro de combustible';

  @override
  String get submitButton => 'Enviar';

  @override
  String get updateButton => 'Actualizar';

  @override
  String get sortButton => 'Ordenar';

  @override
  String get confirmDeleteButton => 'Confirmar eliminación';

  @override
  String get deleteButton => 'Eliminar';

  @override
  String get deleteVehicleButton => 'Eliminar vehículo';

  @override
  String get cancelButton => 'Cancelar';

  @override
  String get unarchiveButton => 'Desarchivar';

  @override
  String get discardChangesButton => 'Descartar cambios';

  @override
  String get discardChangesDescription =>
      'Tienes cambios sin guardar. ¿Estás seguro de que quieres salir?';

  @override
  String get leaveButton => 'Salir';

  @override
  String get sortNewest => 'Más reciente';

  @override
  String get sortOldest => 'Más antiguo';

  @override
  String get sortLowToHigh => 'De menor a mayor';

  @override
  String get sortHighToLow => 'De mayor a menor';

  @override
  String get selectSortTypeLabel => 'Seleccionar tipo de orden';

  @override
  String get fuelRecordsTitle => 'Registros de combustible';

  @override
  String get noRecordsFoundMessage => 'No se encontraron registros';

  @override
  String get confirmFuelRecordDeleteMessage =>
      '¿Estás seguro de que deseas eliminar este registro de combustible?';

  @override
  String get profileButton => 'Perfil';

  @override
  String get homepageButton => 'Página principal';

  @override
  String get settingsButton => 'Configuración';

  @override
  String get signoutButton => 'Cerrar sesión';

  @override
  String get manageDataTitle => 'Gestionar datos';

  @override
  String get deleteAppDataButton => 'Eliminar datos de la app';

  @override
  String get deleteAccountButton => 'Eliminar cuenta';

  @override
  String get confirmAppDataDeletionTitle =>
      'Confirmar eliminación de datos de la app';

  @override
  String get confirmAppDataDeletionContent =>
      'Esto eliminará permanentemente todos tus datos de la app. ¿Continuar?';

  @override
  String get confirmAccountDeletionTitle => 'Confirmar eliminación de cuenta';

  @override
  String get confirmAccountDeletionContent =>
      'Esto eliminará permanentemente tu cuenta. ¿Continuar?';

  @override
  String get reenterPasswordTitle => 'Reingresar contraseña';

  @override
  String get passwordFieldLabel => 'Contraseña';

  @override
  String get confirmButton => 'Confirmar';

  @override
  String get accountDeletedMessage => '¡Cuenta eliminada!';

  @override
  String failedToDeleteAccountMessage(Object error) {
    return 'No se pudo eliminar la cuenta: $error';
  }

  @override
  String get userNotLoggedInMessage => 'Usuario no ha iniciado sesión';

  @override
  String get appDataDeletedMessage => '¡Datos de la app eliminados!';

  @override
  String failedToDeleteAppDataMessage(Object error) {
    return 'No se pudo eliminar los datos de la app: $error';
  }

  @override
  String get settingsTitle => 'Configuración';

  @override
  String get enablePushNotifications => 'Activar notificaciones push';

  @override
  String get privacyAnalytics => 'Análisis de privacidad';

  @override
  String get displayOptions => 'Opciones de visualización';

  @override
  String get privacyPolicy => 'Política de privacidad';

  @override
  String get termsOfService => 'Términos de servicio';

  @override
  String get licenses => 'Licencias';

  @override
  String get manageData => 'Gestionar datos';

  @override
  String get aboutDescription1 =>
      'Esta app te ayuda a registrar tus consumos de combustible.';

  @override
  String get aboutDescription2 =>
      'Para soporte: vehiclerecordtracker@gmail.com';

  @override
  String get applicationLegalese => '© 2025 Registro de Vehículos';

  @override
  String get applicationName => 'Registro de Vehículos';

  @override
  String get myVehiclesButton => 'Mis vehículos';

  @override
  String get archivedVehiclesButton => 'Vehículos archivados';

  @override
  String get addVehicleButton => 'Agregar vehículo';

  @override
  String get seriesTypeLabel => 'Tipo de serie';

  @override
  String get seriesTypeHint => 'Ej. BXT';

  @override
  String get bciGroupSizeLabel => 'Tamaño del grupo BCI';

  @override
  String get bciGroupSizeHint => 'Selecciona tamaño del grupo';

  @override
  String get coldCrankAmpsLabel => 'Amperios de arranque en frío (CCA)';

  @override
  String get coldCrankAmpsHint => 'Ej. 500';

  @override
  String get enterIntegerError => 'Por favor, ingresa un número entero';

  @override
  String get noNegativesError => 'No se permiten números negativos';

  @override
  String get engineSizeLabel => 'Tamaño del motor';

  @override
  String get engineSizeHint => 'Selecciona tamaño del motor';

  @override
  String get cylinderCountLabel => 'Número de cilindros';

  @override
  String get cylinderCountHint => 'Selecciona número y tipo de cilindros';

  @override
  String get cylinderLabel => 'Cilindro ';

  @override
  String get engineTypeLabel => 'Tipo de motor';

  @override
  String get engineTypeHint => 'Selecciona tipo de motor';

  @override
  String get oilWeightLabel => 'Peso del aceite';

  @override
  String get oilWeightHint => 'Ej. 5W-30';

  @override
  String get oilCompositionLabel => 'Composición del aceite';

  @override
  String get oilCompositionHint => 'Selecciona composición del aceite';

  @override
  String get oilClassLabel => 'Clase de aceite';

  @override
  String get oilClassHint => 'Selecciona clase de aceite';

  @override
  String get oilFilterLabel => 'Filtro de aceite';

  @override
  String get oilFilterHint => 'Ej. S7317XL';

  @override
  String get engineFilterLabel => 'Filtro del motor';

  @override
  String get engineFilterHint => 'Ej. FA-1785';

  @override
  String get engineTypeGas => 'Gasolina';

  @override
  String get engineTypeDiesel => 'Diésel';

  @override
  String get engineTypeHybrid => 'Híbrido';

  @override
  String get engineTypeElectric => 'Eléctrico';

  @override
  String get oilCompositionConventional => 'Convencional';

  @override
  String get oilCompositionFullSynthetic => 'Sintético completo';

  @override
  String get oilCompositionMineral => 'Mineral';

  @override
  String get oilCompositionSyntheticBlend => 'Mezcla sintética';

  @override
  String get driverWiperLabel => 'Limpiaparabrisas del conductor';

  @override
  String get driverWiperHint => 'Ej. WW-1801-PF';

  @override
  String get passengerWiperLabel => 'Limpiaparabrisas del pasajero';

  @override
  String get passengerWiperHint => 'Ej. WW-1901-PF';

  @override
  String get rearWiperLabel => 'Limpiaparabrisas trasero';

  @override
  String get rearWiperHint => 'Ej. WW-1701-PF';

  @override
  String get highBeamLabel => 'Luz alta';

  @override
  String get highBeamHint => 'Ej. H7LL';

  @override
  String get lowBeamLabel => 'Luz baja';

  @override
  String get lowBeamHint => 'Ej. H11LL';

  @override
  String get turnLampLabel => 'Luz direccional';

  @override
  String get turnLampHint => 'Ej. T20';

  @override
  String get backupLampLabel => 'Luz de reversa';

  @override
  String get backupLampHint => 'Ej. 921';

  @override
  String get fogLampLabel => 'Luz antiniebla';

  @override
  String get fogLampHint => 'Ej. H11';

  @override
  String get brakeLampLabel => 'Luz de freno';

  @override
  String get brakeLampHint => 'Ej. LED';

  @override
  String get licenseLampLabel => 'Luz de placa';

  @override
  String get licenseLampHint => 'Ej. C5W';

  @override
  String get requiredFieldError => 'Por favor, ingresa algún texto';

  @override
  String get invalidNumberError => 'Por favor, ingresa un número válido';

  @override
  String get negativeNotAllowedError => 'El valor no puede ser negativo';

  @override
  String get tooLargeError => 'Por favor, ingresa un valor realista';

  @override
  String maxDecimalPlacesError(int maxDecimalPlaces) {
    return 'Máximo $maxDecimalPlaces decimales permitidos';
  }

  @override
  String maxLengthError(int maxLength) {
    return 'Máximo $maxLength caracteres permitidos';
  }

  @override
  String get nicknameLabel => 'Apodo';

  @override
  String get nicknameHint => 'Ingresa el apodo del vehículo';

  @override
  String get vinLabel => 'VIN';

  @override
  String get vinHint => 'Ingresa el VIN del vehículo';

  @override
  String get licensePlateLabel => 'Placa';

  @override
  String get licensePlateHint => 'Ingresa la placa del vehículo';

  @override
  String get makeLabel => 'Marca';

  @override
  String get makeHint => 'Busca la marca';

  @override
  String get modelLabel => 'Modelo';

  @override
  String get modelHint => 'Ingresa el modelo del vehículo';

  @override
  String get submodelLabel => 'Submodelo';

  @override
  String get submodelHint => 'Ingresa el submodelo del vehículo';

  @override
  String get yearLabel => 'Año';

  @override
  String get yearHint => 'Selecciona el año del modelo';

  @override
  String get currentMileageLabel => 'Kilometraje actual';

  @override
  String get currentMileageHint => 'Ingresa el kilometraje actual del vehículo';

  @override
  String get mileageLabel => 'Kilometraje';

  @override
  String get selectYear => 'Seleccionar año';

  @override
  String get selectMonth => 'Seleccionar mes';

  @override
  String get noDataText => 'Sin datos';

  @override
  String monthlyFuelCost(int month, int year) {
    return 'Costo de combustible para $month/$year';
  }

  @override
  String yearlyFuelCost(int year) {
    return 'Costo de combustible para $year';
  }

  @override
  String get lifetimeFuelCost => 'Costo total de combustible';

  @override
  String get lifetimeMaintenanceCost => 'Costo total de mantenimiento';

  @override
  String get lifetimeVehicleCost => 'Costo total del vehículo';

  @override
  String get fuelHistoryButton => 'Historial de combustible';

  @override
  String get workHistoryButton => 'Historial de mantenimiento';

  @override
  String get speedometerReadingLabel => 'Lectura del velocímetro';

  @override
  String get purchaseHistoryTitle => 'Historial de compra';

  @override
  String get purchaseDateLabel => 'Fecha de compra';

  @override
  String get purchaseDateHint => 'Ingresa la fecha de compra del vehículo';

  @override
  String get purchasePriceLabel => 'Precio de compra';

  @override
  String get purchasePriceHint => 'Ingresa el precio original';

  @override
  String get originalOdometerLabel => 'Kilometraje original';

  @override
  String get originalOdometerHint =>
      'Ingresa el kilometraje al momento de la compra';

  @override
  String get recalculateFuelTotalsTitle => 'Recalcular totales de combustible';

  @override
  String get recalculateFuelTotalsSubtitle =>
      'Corrige los totales de combustible de todos los vehículos';

  @override
  String get recalculateFuelTotalsDialogTitle =>
      '¿Recalcular costos de combustible?';

  @override
  String get recalculateFuelTotalsDialogBody =>
      'Esto sobrescribirá los totales de combustible con la suma de todos los registros. ¿Continuar?';

  @override
  String get recalculateFuelTotalsCancel => 'Cancelar';

  @override
  String get recalculateFuelTotalsConfirm => 'Recalcular';

  @override
  String get recalculateFuelTotalsSuccess =>
      'Totales de combustible recalculados.';

  @override
  String get addVehicleForm => 'Formulario para agregar vehículo';

  @override
  String get fillDetailsForFutureReference =>
      '¡Completa estos detalles para referencia futura mientras estás en movimiento!';

  @override
  String get buttonAddFuel => 'Agregar combustible';

  @override
  String get buttonAddWork => 'Agregar mantenimiento';

  @override
  String get buttonViewFuel => 'Ver combustible';

  @override
  String get buttonViewWork => 'Ver mantenimiento';

  @override
  String get archivedVehiclesTitle => 'Vehículos archivados';

  @override
  String get selectVehicleHint => 'Seleccionar vehículo';

  @override
  String get archiveButtonLabel => 'Archivar';

  @override
  String get noArchivedVehiclesMessage => 'No hay vehículos archivados';

  @override
  String get confirmDeletionMessage =>
      '¿Seguro que quieres eliminar este vehículo y todos los registros de combustible?';

  @override
  String get deleteSnackBarMessage =>
      '¡Vehículo y registros de combustible eliminados!';

  @override
  String get continueAsGuest => 'Continuar como invitado';

  @override
  String get guestCannotCreateRecords =>
      'Las cuentas de invitado no pueden crear registros. Por favor inicia sesión o regístrate.';

  @override
  String get notificationsDisabledTitle => 'Notificaciones desactivadas';

  @override
  String get notificationsDisabledMessage =>
      'Las notificaciones están desactivadas en la configuración del dispositivo.';

  @override
  String get ok => 'Aceptar';

  @override
  String get january => 'Enero';

  @override
  String get february => 'Febrero';

  @override
  String get march => 'Marzo';

  @override
  String get april => 'Abril';

  @override
  String get may => 'Mayo';

  @override
  String get june => 'Junio';

  @override
  String get july => 'Julio';

  @override
  String get august => 'Agosto';

  @override
  String get september => 'Septiembre';

  @override
  String get october => 'Octubre';

  @override
  String get november => 'Noviembre';

  @override
  String get december => 'Diciembre';
}
