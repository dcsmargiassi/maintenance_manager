// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Vehicle Record Tracker';

  @override
  String get createAccount => 'Create Account';

  @override
  String get email => 'Email';

  @override
  String get emailVerified => 'Email Verified';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get username => 'Username';

  @override
  String get usernameHint => 'Enter username';

  @override
  String get password => 'Password';

  @override
  String get firstName => 'First Name';

  @override
  String get firstNameHint => 'Enter first name';

  @override
  String get lastName => 'Last Name';

  @override
  String get lastNameHint => 'Enter last Name';

  @override
  String get enablePrivacyAnalytics => 'Enable Privacy Analytics';

  @override
  String get privacyAnalyticsSubtitle =>
      'Help improve the app by sharing anonymous usage data.';

  @override
  String get genericSuccess => 'Information updated successfully!';

  @override
  String get genericError => 'An error occurred. Please try again.';

  @override
  String genericErrorWithDetail(Object errorDetail) {
    return 'Error: $errorDetail';
  }

  @override
  String welcomeUser(Object username) {
    return 'Welcome, $username! A verification email was sent.';
  }

  @override
  String get saveChanges => 'Save Changes';

  @override
  String get profile => 'Profile';

  @override
  String get editProfile => 'Edit Profile';

  @override
  String get editVehicle => 'Edit Vehicle';

  @override
  String get vehicleDetails => 'Vehicle Details';

  @override
  String get financialSummary => 'Financial Summary';

  @override
  String get vehicleInformationTitle => 'Vehicle Information';

  @override
  String get engineDetails => 'Engine Details';

  @override
  String get exteriorDetails => 'Exterior Details';

  @override
  String get batteryDetails => 'Battery Details';

  @override
  String get backToHome => 'Back to Home';

  @override
  String get resetPassword => 'Reset Password';

  @override
  String get resetPasswordEmailSent =>
      'Password reset email sent! Check your inbox.';

  @override
  String get enterEmailMessage => 'Enter your email to receive a reset link.';

  @override
  String get sendResetEmail => 'Send Reset Email';

  @override
  String get sendVerificationEmail => 'Send Verification Email';

  @override
  String get verificationEmailSent =>
      'Verification email sent! Please check your inbox.';

  @override
  String get fillInAllFields => 'Fill in all fields';

  @override
  String get signIn => 'Sign In';

  @override
  String get fillInTwoFields => 'Please fill 2 of the fields above.';

  @override
  String get emptyMessageText => 'Please enter some text';

  @override
  String get enterValidNumber => 'Please enter valid number';

  @override
  String get noNegatives => 'No negatives';

  @override
  String get enterRealisticValue => 'Enter a realistic value';

  @override
  String maxDecimalPlacesMessage(Object maxDecimalPlaces) {
    return 'Max $maxDecimalPlaces decimal places allowed';
  }

  @override
  String get fuelAmountLabel => 'Fuel Amount';

  @override
  String get fuelAmountLabelHint => 'Enter amount of fuel';

  @override
  String get fuelPriceLabel => 'Fuel Price';

  @override
  String get fuelPriceLabelHint => 'Enter amount of fuel';

  @override
  String get totalFuelCostLabel => 'Total Cost';

  @override
  String get totalFuelCostLabelHint => 'Enter total cost';

  @override
  String get odometerLabel => 'Odometer';

  @override
  String get odometerLabelHint => 'Enter current odometer number (Optional)';

  @override
  String get calculateMissingFieldLabel => 'Calculate Missing Field';

  @override
  String get dateLabel => 'Date';

  @override
  String get enterDateRefuelLabel => 'Enter date of refuel';

  @override
  String get enterValidDateMessage => 'Please select a valid date';

  @override
  String errorSavingFuelRecordMessage(Object error) {
    return 'Error saving fuel record: $error';
  }

  @override
  String get addFuelRecordButton => 'Add Fuel Record';

  @override
  String get editFuelRecordButton => 'Edit Fuel Record';

  @override
  String get submitButton => 'Submit';

  @override
  String get updateButton => 'Update';

  @override
  String get sortButton => 'Sort';

  @override
  String get confirmDeleteButton => 'Confirm Deletion';

  @override
  String get deleteButton => 'Delete';

  @override
  String get deleteVehicleButton => 'Delete Vehicle';

  @override
  String get cancelButton => 'Cancel';

  @override
  String get unarchiveButton => 'Unarchive';

  @override
  String get discardChangesButton => 'Discard Changes';

  @override
  String get discardChangesDescription =>
      'You have unsaved changes. Are you sure you want to leave?';

  @override
  String get leaveButton => 'Leave';

  @override
  String get sortNewest => 'Newest';

  @override
  String get sortOldest => 'Oldest';

  @override
  String get sortLowToHigh => 'Low to High';

  @override
  String get sortHighToLow => 'High to Low';

  @override
  String get selectSortTypeLabel => 'Select Sort Type';

  @override
  String get fuelRecordsTitle => 'Fuel Records';

  @override
  String get noRecordsFoundMessage => 'No records found';

  @override
  String get confirmFuelRecordDeleteMessage =>
      'Are you sure you want to delete this fuel record?';

  @override
  String get profileButton => 'Profile';

  @override
  String get homepageButton => 'Homepage';

  @override
  String get settingsButton => 'Settings';

  @override
  String get signoutButton => 'Signout';

  @override
  String get manageDataTitle => 'Manage Data';

  @override
  String get deleteAppDataButton => 'Delete App Data';

  @override
  String get deleteAccountButton => 'Delete Account';

  @override
  String get confirmAppDataDeletionTitle => 'Confirm App Data Deletion';

  @override
  String get confirmAppDataDeletionContent =>
      'This will delete all your app data permanently. Continue?';

  @override
  String get confirmAccountDeletionTitle => 'Confirm Account Deletion';

  @override
  String get confirmAccountDeletionContent =>
      'This will delete your account permanently. Continue?';

  @override
  String get reenterPasswordTitle => 'Re-enter Password';

  @override
  String get passwordFieldLabel => 'Password';

  @override
  String get confirmButton => 'Confirm';

  @override
  String get accountDeletedMessage => 'Account deleted!';

  @override
  String failedToDeleteAccountMessage(Object error) {
    return 'Failed to delete account: $error';
  }

  @override
  String get userNotLoggedInMessage => 'User not logged in';

  @override
  String get appDataDeletedMessage => 'App data deleted!';

  @override
  String failedToDeleteAppDataMessage(Object error) {
    return 'Failed to delete app data: $error';
  }

  @override
  String get settingsTitle => 'Settings';

  @override
  String get enablePushNotifications => 'Enable Push Notifications';

  @override
  String get privacyAnalytics => 'Privacy Analytics';

  @override
  String get displayOptions => 'Display Options';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get termsOfService => 'Terms of Service';

  @override
  String get licenses => 'Licenses';

  @override
  String get manageData => 'Manage Data';

  @override
  String get aboutDescription1 => 'This app helps you track your fuel records.';

  @override
  String get aboutDescription2 => 'For support: vehiclerecordtracker@gmail.com';

  @override
  String get applicationLegalese => '© 2025 Vehicle Record Tracker';

  @override
  String get applicationName => 'Vehicle Record Tracker';

  @override
  String get myVehiclesButton => 'My Vehicles';

  @override
  String get archivedVehiclesButton => 'Archived Vehicles';

  @override
  String get addVehicleButton => 'Add Vehicle';

  @override
  String get seriesTypeLabel => 'Series Type';

  @override
  String get seriesTypeHint => 'Ex BXT';

  @override
  String get bciGroupSizeLabel => 'BCI Group Size';

  @override
  String get bciGroupSizeHint => 'Select group size';

  @override
  String get coldCrankAmpsLabel => 'Cold Crank Amps - CCA';

  @override
  String get coldCrankAmpsHint => 'Ex 500';

  @override
  String get enterIntegerError => 'Please enter an integer';

  @override
  String get noNegativesError => 'No negatives';

  @override
  String get engineSizeLabel => 'Engine Size';

  @override
  String get engineSizeHint => 'Select engine size';

  @override
  String get cylinderCountLabel => 'Cylinder Count';

  @override
  String get cylinderCountHint => 'Select cylinder count plus type';

  @override
  String get cylinderLabel => 'Cylinder ';

  @override
  String get engineTypeLabel => 'Engine Type';

  @override
  String get engineTypeHint => 'Select engine type';

  @override
  String get oilWeightLabel => 'Oil Weight';

  @override
  String get oilWeightHint => 'Ex 5W-30';

  @override
  String get oilCompositionLabel => 'Oil Composition';

  @override
  String get oilCompositionHint => 'Select oil composition';

  @override
  String get oilClassLabel => 'Oil Class';

  @override
  String get oilClassHint => 'Select oil class';

  @override
  String get oilFilterLabel => 'Oil Filter';

  @override
  String get oilFilterHint => 'Ex S7317XL';

  @override
  String get engineFilterLabel => 'Engine Filter';

  @override
  String get engineFilterHint => 'Ex FA-1785';

  @override
  String get engineTypeGas => 'Gas';

  @override
  String get engineTypeDiesel => 'Diesel';

  @override
  String get engineTypeHybrid => 'Hybrid';

  @override
  String get engineTypeElectric => 'Electric';

  @override
  String get oilCompositionConventional => 'Conventional';

  @override
  String get oilCompositionFullSynthetic => 'Full Synthetic';

  @override
  String get oilCompositionMineral => 'Mineral';

  @override
  String get oilCompositionSyntheticBlend => 'Synthetic Blend';

  @override
  String get driverWiperLabel => 'Driver Side Windshield Wiper';

  @override
  String get driverWiperHint => 'Ex WW-1801-PF';

  @override
  String get passengerWiperLabel => 'Passenger Side Windshield Wiper';

  @override
  String get passengerWiperHint => 'Ex WW-1901-PF';

  @override
  String get rearWiperLabel => 'Rear Windshield Wiper';

  @override
  String get rearWiperHint => 'Ex WW-1701-PF';

  @override
  String get highBeamLabel => 'Headlamp High Beam';

  @override
  String get highBeamHint => 'Ex H7LL';

  @override
  String get lowBeamLabel => 'Headlamp Low Beam';

  @override
  String get lowBeamHint => 'Ex H11LL';

  @override
  String get turnLampLabel => 'Turn Lamp';

  @override
  String get turnLampHint => 'Ex T20';

  @override
  String get backupLampLabel => 'Backup Lamp';

  @override
  String get backupLampHint => 'Ex 921';

  @override
  String get fogLampLabel => 'Fog Lamp';

  @override
  String get fogLampHint => 'Ex H11';

  @override
  String get brakeLampLabel => 'Brake Lamp';

  @override
  String get brakeLampHint => 'Ex LED';

  @override
  String get licenseLampLabel => 'License Plate Lamp';

  @override
  String get licenseLampHint => 'Ex C5W';

  @override
  String get requiredFieldError => 'Please enter some text';

  @override
  String get invalidNumberError => 'Please enter a valid number';

  @override
  String get negativeNotAllowedError => 'Value cannot be negative';

  @override
  String get tooLargeError => 'Please enter a realistic value';

  @override
  String maxDecimalPlacesError(int maxDecimalPlaces) {
    return 'Max $maxDecimalPlaces decimal places allowed';
  }

  @override
  String maxLengthError(int maxLength) {
    return 'Max $maxLength characters allowed';
  }

  @override
  String get nicknameLabel => 'Nickname';

  @override
  String get nicknameHint => 'Enter nickname of car';

  @override
  String get vinLabel => 'VIN';

  @override
  String get vinHint => 'Enter VIN of car';

  @override
  String get licensePlateLabel => 'License Plate';

  @override
  String get licensePlateHint => 'Enter license plate of car';

  @override
  String get makeLabel => 'Make';

  @override
  String get makeHint => 'Search make';

  @override
  String get modelLabel => 'Model';

  @override
  String get modelHint => 'Enter model of car';

  @override
  String get submodelLabel => 'Submodel';

  @override
  String get submodelHint => 'Enter submodel of car';

  @override
  String get yearLabel => 'Year';

  @override
  String get yearHint => 'Select Model Year';

  @override
  String get currentMileageLabel => 'Current Mileage';

  @override
  String get currentMileageHint => 'Enter current mileage of car';

  @override
  String get mileageLabel => 'Mileage';

  @override
  String get selectYear => 'Select Year';

  @override
  String get selectMonth => 'Select Month';

  @override
  String get noDataText => 'No Data';

  @override
  String monthlyFuelCost(int month, int year) {
    return 'Fuel Cost for $month/$year';
  }

  @override
  String yearlyFuelCost(int year) {
    return 'Fuel Cost for $year';
  }

  @override
  String get lifetimeFuelCost => 'Lifetime Fuel Cost';

  @override
  String get lifetimeMaintenanceCost => 'Lifetime Maintenance Cost';

  @override
  String get lifetimeVehicleCost => 'Lifetime Vehicle Cost';

  @override
  String get fuelHistoryButton => 'Fuel History';

  @override
  String get workHistoryButton => 'Work History';

  @override
  String get speedometerReadingLabel => 'Speedometer Reading';

  @override
  String get purchaseHistoryTitle => 'Purchase History';

  @override
  String get purchaseDateLabel => 'Purchase Date';

  @override
  String get purchaseDateHint => 'Enter purchase date of car';

  @override
  String get purchasePriceLabel => 'Purchase Price';

  @override
  String get purchasePriceHint => 'Enter Original Price';

  @override
  String get originalOdometerLabel => 'Original Odometer Number';

  @override
  String get originalOdometerHint => 'Enter odometer number when purchased';

  @override
  String get recalculateFuelTotalsTitle => 'Recalculate All Fuel Totals';

  @override
  String get recalculateFuelTotalsSubtitle =>
      'Corrects lifetime fuel totals for all vehicles';

  @override
  String get recalculateFuelTotalsDialogTitle => 'Recalculate Fuel Costs?';

  @override
  String get recalculateFuelTotalsDialogBody =>
      'This will overwrite lifetime fuel totals with the sum of all fuel records. Continue?';

  @override
  String get recalculateFuelTotalsCancel => 'Cancel';

  @override
  String get recalculateFuelTotalsConfirm => 'Recalculate';

  @override
  String get recalculateFuelTotalsSuccess => 'All fuel totals recalculated.';

  @override
  String get addVehicleForm => 'Add Vehicle Form';

  @override
  String get fillDetailsForFutureReference =>
      'Fill these details for future reference on the go!';

  @override
  String get buttonAddFuel => 'Add Fuel';

  @override
  String get buttonAddWork => 'Add Work';

  @override
  String get buttonViewFuel => 'View Fuel';

  @override
  String get buttonViewWork => 'View Work';

  @override
  String get archivedVehiclesTitle => 'Archived Vehicles';

  @override
  String get selectVehicleHint => 'Select Vehicle';

  @override
  String get archiveButtonLabel => 'Archive';

  @override
  String get noArchivedVehiclesMessage => 'No Archived Vehicles';

  @override
  String get confirmDeletionMessage =>
      'Are you sure you want to delete this vehicle and all Fuel Records?';

  @override
  String get deleteSnackBarMessage => 'Vehicle and Fuel records deleted!';

  @override
  String get continueAsGuest => 'Continue as Guest';

  @override
  String get guestCannotCreateRecords =>
      'Guest accounts cannot create records. Please sign in or register.';

  @override
  String get january => 'January';

  @override
  String get february => 'February';

  @override
  String get march => 'March';

  @override
  String get april => 'April';

  @override
  String get may => 'May';

  @override
  String get june => 'June';

  @override
  String get july => 'July';

  @override
  String get august => 'August';

  @override
  String get september => 'September';

  @override
  String get october => 'October';

  @override
  String get november => 'November';

  @override
  String get december => 'December';
}
