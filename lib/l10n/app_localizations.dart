import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';

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
    Locale('fr'),
  ];

  /// App store name of the application
  ///
  /// In en, this message translates to:
  /// **'Vehicle Record Tracker'**
  String get appTitle;

  /// Title for the create account page and submission button
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// Label for email field
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// Label for whether email is verified or not
  ///
  /// In en, this message translates to:
  /// **'Email Verified'**
  String get emailVerified;

  /// Simple yes text
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// Simple No text
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// Label for username field
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// Label hint for username field
  ///
  /// In en, this message translates to:
  /// **'Enter username'**
  String get usernameHint;

  /// Label for password field
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// Label for first name field
  ///
  /// In en, this message translates to:
  /// **'First Name'**
  String get firstName;

  /// Label hintfor first name field
  ///
  /// In en, this message translates to:
  /// **'Enter first name'**
  String get firstNameHint;

  /// Label for last name field
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get lastName;

  /// Label hint for last name field
  ///
  /// In en, this message translates to:
  /// **'Enter last Name'**
  String get lastNameHint;

  /// Switch title for enabling privacy analytics
  ///
  /// In en, this message translates to:
  /// **'Enable Privacy Analytics'**
  String get enablePrivacyAnalytics;

  /// Subtitle explaining what privacy analytics means
  ///
  /// In en, this message translates to:
  /// **'Help improve the app by sharing anonymous usage data.'**
  String get privacyAnalyticsSubtitle;

  /// Generic Success message
  ///
  /// In en, this message translates to:
  /// **'Information updated successfully!'**
  String get genericSuccess;

  /// Generic error message for catching exceptions
  ///
  /// In en, this message translates to:
  /// **'An error occurred. Please try again.'**
  String get genericError;

  /// Error message for catching exceptions with generated details
  ///
  /// In en, this message translates to:
  /// **'Error: {errorDetail}'**
  String genericErrorWithDetail(Object errorDetail);

  /// Welcome message with the user's name
  ///
  /// In en, this message translates to:
  /// **'Welcome, {username}! A verification email was sent.'**
  String welcomeUser(Object username);

  /// Button text to save document changes
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// Profile title
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// Edit Profile page title
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// Edit Vehicle button title
  ///
  /// In en, this message translates to:
  /// **'Edit Vehicle'**
  String get editVehicle;

  /// Vehicle details sub-heading
  ///
  /// In en, this message translates to:
  /// **'Vehicle Details'**
  String get vehicleDetails;

  /// Financial Summary sub-heading
  ///
  /// In en, this message translates to:
  /// **'Financial Summary'**
  String get financialSummary;

  /// Vehicle Information heading
  ///
  /// In en, this message translates to:
  /// **'Vehicle Information'**
  String get vehicleInformationTitle;

  /// Engine Details sub-heading
  ///
  /// In en, this message translates to:
  /// **'Engine Details'**
  String get engineDetails;

  /// Exterior Details sub-heading
  ///
  /// In en, this message translates to:
  /// **'Exterior Details'**
  String get exteriorDetails;

  /// Battery Details sub-heading
  ///
  /// In en, this message translates to:
  /// **'Battery Details'**
  String get batteryDetails;

  /// Back to home button text
  ///
  /// In en, this message translates to:
  /// **'Back to Home'**
  String get backToHome;

  /// Reset Password text
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get resetPassword;

  /// Message to state password reset email has been sent. Check inbox
  ///
  /// In en, this message translates to:
  /// **'Password reset email sent! Check your inbox.'**
  String get resetPasswordEmailSent;

  /// Message to prompt user to enter email for receiving reset link in inbox
  ///
  /// In en, this message translates to:
  /// **'Enter your email to receive a reset link.'**
  String get enterEmailMessage;

  /// Send reset email in context of password reset
  ///
  /// In en, this message translates to:
  /// **'Send Reset Email'**
  String get sendResetEmail;

  /// Button to send verification email
  ///
  /// In en, this message translates to:
  /// **'Send Verification Email'**
  String get sendVerificationEmail;

  /// Message to state verification email was sent and to check inbox.
  ///
  /// In en, this message translates to:
  /// **'Verification email sent! Please check your inbox.'**
  String get verificationEmailSent;

  /// message to alert user to fill in all fields
  ///
  /// In en, this message translates to:
  /// **'Fill in all fields'**
  String get fillInAllFields;

  /// Button text allowing user to sign in to the app
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// Message alerting user two fields above must be filled in.
  ///
  /// In en, this message translates to:
  /// **'Please fill 2 of the fields above.'**
  String get fillInTwoFields;

  /// Message alerting user text must be entered.
  ///
  /// In en, this message translates to:
  /// **'Please enter some text'**
  String get emptyMessageText;

  /// Message alerting user text must be a valid number.
  ///
  /// In en, this message translates to:
  /// **'Please enter valid number'**
  String get enterValidNumber;

  /// Message alerting user no negative numbers allowed
  ///
  /// In en, this message translates to:
  /// **'No negatives'**
  String get noNegatives;

  /// Message alerting user number must be a realistic value
  ///
  /// In en, this message translates to:
  /// **'Enter a realistic value'**
  String get enterRealisticValue;

  /// Error message shown when the number of decimal places exceeds allowed maximum.
  ///
  /// In en, this message translates to:
  /// **'Max {maxDecimalPlaces} decimal places allowed'**
  String maxDecimalPlacesMessage(Object maxDecimalPlaces);

  /// Fuel amount label
  ///
  /// In en, this message translates to:
  /// **'Fuel Amount'**
  String get fuelAmountLabel;

  /// Fuel amount label hint
  ///
  /// In en, this message translates to:
  /// **'Enter amount of fuel'**
  String get fuelAmountLabelHint;

  /// Fuel price label
  ///
  /// In en, this message translates to:
  /// **'Fuel Price'**
  String get fuelPriceLabel;

  /// Fuel price label hint
  ///
  /// In en, this message translates to:
  /// **'Enter amount of fuel'**
  String get fuelPriceLabelHint;

  /// Total fuel cost label
  ///
  /// In en, this message translates to:
  /// **'Total Cost'**
  String get totalFuelCostLabel;

  /// Total fuel cost label hint
  ///
  /// In en, this message translates to:
  /// **'Enter total cost'**
  String get totalFuelCostLabelHint;

  /// Odometer label
  ///
  /// In en, this message translates to:
  /// **'Odometer'**
  String get odometerLabel;

  /// Enter current odometer number label hint
  ///
  /// In en, this message translates to:
  /// **'Enter current odometer number (Optional)'**
  String get odometerLabelHint;

  /// Calculate missing field button for 2 of the 3 fuel fields displayed above
  ///
  /// In en, this message translates to:
  /// **'Calculate Missing Field'**
  String get calculateMissingFieldLabel;

  /// Date label text for collecting current days date
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get dateLabel;

  /// Date label hint text for collecting current days date of refuel
  ///
  /// In en, this message translates to:
  /// **'Enter date of refuel'**
  String get enterDateRefuelLabel;

  /// Date label hint text for requesting user to select a valid date.
  ///
  /// In en, this message translates to:
  /// **'Please select a valid date'**
  String get enterValidDateMessage;

  /// Date label hint text for requesting user to select a valid date.
  ///
  /// In en, this message translates to:
  /// **'Error saving fuel record: {error}'**
  String errorSavingFuelRecordMessage(Object error);

  /// Title label for adding fuel record
  ///
  /// In en, this message translates to:
  /// **'Add Fuel Record'**
  String get addFuelRecordButton;

  /// Title label for editing fuel record
  ///
  /// In en, this message translates to:
  /// **'Edit Fuel Record'**
  String get editFuelRecordButton;

  /// Button text for submitting various forms.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submitButton;

  /// Button text for updating various forms.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get updateButton;

  /// Button text for sorting.
  ///
  /// In en, this message translates to:
  /// **'Sort'**
  String get sortButton;

  /// Button text for confirming delete
  ///
  /// In en, this message translates to:
  /// **'Confirm Deletion'**
  String get confirmDeleteButton;

  /// Button text for delete
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deleteButton;

  /// Button text for delete vehicle
  ///
  /// In en, this message translates to:
  /// **'Delete Vehicle'**
  String get deleteVehicleButton;

  /// Button text for cancelling an action
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancelButton;

  /// Button text for unarchiving a vehicle
  ///
  /// In en, this message translates to:
  /// **'Unarchive'**
  String get unarchiveButton;

  /// Button text for discarding changes and leaving the page without saving
  ///
  /// In en, this message translates to:
  /// **'Discard Changes'**
  String get discardChangesButton;

  /// Button text for discarding changes and leaving the page without saving description
  ///
  /// In en, this message translates to:
  /// **'You have unsaved changes. Are you sure you want to leave?'**
  String get discardChangesDescription;

  /// Button text for leaving various forms.
  ///
  /// In en, this message translates to:
  /// **'Leave'**
  String get leaveButton;

  /// Button text for sorting based on newest entry.
  ///
  /// In en, this message translates to:
  /// **'Newest'**
  String get sortNewest;

  /// Button text for sorting based on oldest entry.
  ///
  /// In en, this message translates to:
  /// **'Oldest'**
  String get sortOldest;

  /// Button text for sorting based on lowest value entry.
  ///
  /// In en, this message translates to:
  /// **'Low to High'**
  String get sortLowToHigh;

  /// Button text for sorting based on highest value entry.
  ///
  /// In en, this message translates to:
  /// **'High to Low'**
  String get sortHighToLow;

  /// Button text for choosing sorting type based on prior selection or default choice
  ///
  /// In en, this message translates to:
  /// **'Select Sort Type'**
  String get selectSortTypeLabel;

  /// Title text for fuel records page
  ///
  /// In en, this message translates to:
  /// **'Fuel Records'**
  String get fuelRecordsTitle;

  /// Message text displaying no records of various types have been found
  ///
  /// In en, this message translates to:
  /// **'No records found'**
  String get noRecordsFoundMessage;

  /// Message text displaying no records of various types have been found
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this fuel record?'**
  String get confirmFuelRecordDeleteMessage;

  /// profile button in navigation menu
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileButton;

  /// Homepage button in navigation menu
  ///
  /// In en, this message translates to:
  /// **'Homepage'**
  String get homepageButton;

  /// Settings button in navigation menu
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsButton;

  /// Signout button in navigation menu
  ///
  /// In en, this message translates to:
  /// **'Signout'**
  String get signoutButton;

  /// App bar title for Manage Data screen
  ///
  /// In en, this message translates to:
  /// **'Manage Data'**
  String get manageDataTitle;

  /// Button text to delete all app data
  ///
  /// In en, this message translates to:
  /// **'Delete App Data'**
  String get deleteAppDataButton;

  /// Button text to delete the user account
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get deleteAccountButton;

  /// Dialog title for confirming deletion of app data
  ///
  /// In en, this message translates to:
  /// **'Confirm App Data Deletion'**
  String get confirmAppDataDeletionTitle;

  /// Dialog message warning user about app data deletion
  ///
  /// In en, this message translates to:
  /// **'This will delete all your app data permanently. Continue?'**
  String get confirmAppDataDeletionContent;

  /// Dialog title for confirming deletion of user account
  ///
  /// In en, this message translates to:
  /// **'Confirm Account Deletion'**
  String get confirmAccountDeletionTitle;

  /// Dialog message warning user about account deletion
  ///
  /// In en, this message translates to:
  /// **'This will delete your account permanently. Continue?'**
  String get confirmAccountDeletionContent;

  /// Dialog title asking user to re-enter their password
  ///
  /// In en, this message translates to:
  /// **'Re-enter Password'**
  String get reenterPasswordTitle;

  /// Label for password field in password prompt
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordFieldLabel;

  /// Label for confirm button in dialogs
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirmButton;

  /// Snackbar message confirming account deletion
  ///
  /// In en, this message translates to:
  /// **'Account deleted!'**
  String get accountDeletedMessage;

  /// Snackbar message for failure to delete account with error message
  ///
  /// In en, this message translates to:
  /// **'Failed to delete account: {error}'**
  String failedToDeleteAccountMessage(Object error);

  /// Snackbar message for unauthenticated user
  ///
  /// In en, this message translates to:
  /// **'User not logged in'**
  String get userNotLoggedInMessage;

  /// Snackbar message confirming app data deletion
  ///
  /// In en, this message translates to:
  /// **'App data deleted!'**
  String get appDataDeletedMessage;

  /// Snackbar message for failure to delete app data with error message
  ///
  /// In en, this message translates to:
  /// **'Failed to delete app data: {error}'**
  String failedToDeleteAppDataMessage(Object error);

  /// Title for the Settings page
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// Switch title to enable push notifications
  ///
  /// In en, this message translates to:
  /// **'Enable Push Notifications'**
  String get enablePushNotifications;

  /// Switch title for privacy analytics setting
  ///
  /// In en, this message translates to:
  /// **'Privacy Analytics'**
  String get privacyAnalytics;

  /// Navigate to display options page
  ///
  /// In en, this message translates to:
  /// **'Display Options'**
  String get displayOptions;

  /// Navigate to privacy policy page
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// Navigate to terms of service page
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get termsOfService;

  /// Navigate to licenses page
  ///
  /// In en, this message translates to:
  /// **'Licenses'**
  String get licenses;

  /// Navigate to manage data page
  ///
  /// In en, this message translates to:
  /// **'Manage Data'**
  String get manageData;

  /// First line in the About box
  ///
  /// In en, this message translates to:
  /// **'This app helps you track your fuel records.'**
  String get aboutDescription1;

  /// Second line in the About box with support email
  ///
  /// In en, this message translates to:
  /// **'For support: vehiclerecordtracker@gmail.com'**
  String get aboutDescription2;

  /// Legal text for the About box
  ///
  /// In en, this message translates to:
  /// **'© 2025 Vehicle Record Tracker'**
  String get applicationLegalese;

  /// Name of the app shown in the About box
  ///
  /// In en, this message translates to:
  /// **'Vehicle Record Tracker'**
  String get applicationName;

  /// Button label to show user's vehicles
  ///
  /// In en, this message translates to:
  /// **'My Vehicles'**
  String get myVehiclesButton;

  /// Button label to show archived vehicles
  ///
  /// In en, this message translates to:
  /// **'Archived Vehicles'**
  String get archivedVehiclesButton;

  /// Button label to add a new vehicle
  ///
  /// In en, this message translates to:
  /// **'Add Vehicle'**
  String get addVehicleButton;

  /// Label for battery series type field
  ///
  /// In en, this message translates to:
  /// **'Series Type'**
  String get seriesTypeLabel;

  /// Hint for battery series type field
  ///
  /// In en, this message translates to:
  /// **'Ex BXT'**
  String get seriesTypeHint;

  /// Label for BCI group size dropdown
  ///
  /// In en, this message translates to:
  /// **'BCI Group Size'**
  String get bciGroupSizeLabel;

  /// Hint for BCI group size dropdown
  ///
  /// In en, this message translates to:
  /// **'Select group size'**
  String get bciGroupSizeHint;

  /// Label for cold crank amps field
  ///
  /// In en, this message translates to:
  /// **'Cold Crank Amps - CCA'**
  String get coldCrankAmpsLabel;

  /// Hint for cold crank amps field
  ///
  /// In en, this message translates to:
  /// **'Ex 500'**
  String get coldCrankAmpsHint;

  /// Validation error for non-integer input
  ///
  /// In en, this message translates to:
  /// **'Please enter an integer'**
  String get enterIntegerError;

  /// Validation error for negative numbers
  ///
  /// In en, this message translates to:
  /// **'No negatives'**
  String get noNegativesError;

  /// Label for engine size dropdown
  ///
  /// In en, this message translates to:
  /// **'Engine Size'**
  String get engineSizeLabel;

  /// Hint for engine size dropdown
  ///
  /// In en, this message translates to:
  /// **'Select engine size'**
  String get engineSizeHint;

  /// Label for cylinder count dropdown
  ///
  /// In en, this message translates to:
  /// **'Cylinder Count'**
  String get cylinderCountLabel;

  /// Hint for cylinder count dropdown
  ///
  /// In en, this message translates to:
  /// **'Select cylinder count plus type'**
  String get cylinderCountHint;

  /// Label for cylinder count dropdown
  ///
  /// In en, this message translates to:
  /// **'Cylinder '**
  String get cylinderLabel;

  /// Label for engine type dropdown
  ///
  /// In en, this message translates to:
  /// **'Engine Type'**
  String get engineTypeLabel;

  /// Hint for engine type dropdown
  ///
  /// In en, this message translates to:
  /// **'Select engine type'**
  String get engineTypeHint;

  /// Label for oil weight field
  ///
  /// In en, this message translates to:
  /// **'Oil Weight'**
  String get oilWeightLabel;

  /// Hint for oil weight field
  ///
  /// In en, this message translates to:
  /// **'Ex 5W-30'**
  String get oilWeightHint;

  /// Label for oil composition dropdown
  ///
  /// In en, this message translates to:
  /// **'Oil Composition'**
  String get oilCompositionLabel;

  /// Hint for oil composition dropdown
  ///
  /// In en, this message translates to:
  /// **'Select oil composition'**
  String get oilCompositionHint;

  /// Label for oil class dropdown
  ///
  /// In en, this message translates to:
  /// **'Oil Class'**
  String get oilClassLabel;

  /// Hint for oil class dropdown
  ///
  /// In en, this message translates to:
  /// **'Select oil class'**
  String get oilClassHint;

  /// Label for oil filter field
  ///
  /// In en, this message translates to:
  /// **'Oil Filter'**
  String get oilFilterLabel;

  /// Hint for oil filter field
  ///
  /// In en, this message translates to:
  /// **'Ex S7317XL'**
  String get oilFilterHint;

  /// Label for engine filter field
  ///
  /// In en, this message translates to:
  /// **'Engine Filter'**
  String get engineFilterLabel;

  /// Hint for engine filter field
  ///
  /// In en, this message translates to:
  /// **'Ex FA-1785'**
  String get engineFilterHint;

  /// Engine type option: Gas
  ///
  /// In en, this message translates to:
  /// **'Gas'**
  String get engineTypeGas;

  /// Engine type option: Diesel
  ///
  /// In en, this message translates to:
  /// **'Diesel'**
  String get engineTypeDiesel;

  /// Engine type option: Hybrid
  ///
  /// In en, this message translates to:
  /// **'Hybrid'**
  String get engineTypeHybrid;

  /// Engine type option: Electric
  ///
  /// In en, this message translates to:
  /// **'Electric'**
  String get engineTypeElectric;

  /// Oil composition option: Conventional
  ///
  /// In en, this message translates to:
  /// **'Conventional'**
  String get oilCompositionConventional;

  /// Oil composition option: Full Synthetic
  ///
  /// In en, this message translates to:
  /// **'Full Synthetic'**
  String get oilCompositionFullSynthetic;

  /// Oil composition option: Mineral
  ///
  /// In en, this message translates to:
  /// **'Mineral'**
  String get oilCompositionMineral;

  /// Oil composition option: Synthetic Blend
  ///
  /// In en, this message translates to:
  /// **'Synthetic Blend'**
  String get oilCompositionSyntheticBlend;

  /// Label for driver windshield wiper field
  ///
  /// In en, this message translates to:
  /// **'Driver Side Windshield Wiper'**
  String get driverWiperLabel;

  /// Hint for driver windshield wiper field
  ///
  /// In en, this message translates to:
  /// **'Ex WW-1801-PF'**
  String get driverWiperHint;

  /// Label for passenger windshield wiper field
  ///
  /// In en, this message translates to:
  /// **'Passenger Side Windshield Wiper'**
  String get passengerWiperLabel;

  /// Hint for passenger windshield wiper field
  ///
  /// In en, this message translates to:
  /// **'Ex WW-1901-PF'**
  String get passengerWiperHint;

  /// Label for rear windshield wiper field
  ///
  /// In en, this message translates to:
  /// **'Rear Windshield Wiper'**
  String get rearWiperLabel;

  /// Hint for rear windshield wiper field
  ///
  /// In en, this message translates to:
  /// **'Ex WW-1701-PF'**
  String get rearWiperHint;

  /// Label for high beam field
  ///
  /// In en, this message translates to:
  /// **'Headlamp High Beam'**
  String get highBeamLabel;

  /// Hint for high beam field
  ///
  /// In en, this message translates to:
  /// **'Ex H7LL'**
  String get highBeamHint;

  /// Label for low beam field
  ///
  /// In en, this message translates to:
  /// **'Headlamp Low Beam'**
  String get lowBeamLabel;

  /// Hint for low beam field
  ///
  /// In en, this message translates to:
  /// **'Ex H11LL'**
  String get lowBeamHint;

  /// Label for turn lamp field
  ///
  /// In en, this message translates to:
  /// **'Turn Lamp'**
  String get turnLampLabel;

  /// Hint for turn lamp field
  ///
  /// In en, this message translates to:
  /// **'Ex T20'**
  String get turnLampHint;

  /// Label for backup lamp field
  ///
  /// In en, this message translates to:
  /// **'Backup Lamp'**
  String get backupLampLabel;

  /// Hint for backup lamp field
  ///
  /// In en, this message translates to:
  /// **'Ex 921'**
  String get backupLampHint;

  /// Label for fog lamp field
  ///
  /// In en, this message translates to:
  /// **'Fog Lamp'**
  String get fogLampLabel;

  /// Hint for fog lamp field
  ///
  /// In en, this message translates to:
  /// **'Ex H11'**
  String get fogLampHint;

  /// Label for brake lamp field
  ///
  /// In en, this message translates to:
  /// **'Brake Lamp'**
  String get brakeLampLabel;

  /// Hint for brake lamp field
  ///
  /// In en, this message translates to:
  /// **'Ex LED'**
  String get brakeLampHint;

  /// Label for license plate lamp field
  ///
  /// In en, this message translates to:
  /// **'License Plate Lamp'**
  String get licenseLampLabel;

  /// Hint for license plate lamp field
  ///
  /// In en, this message translates to:
  /// **'Ex C5W'**
  String get licenseLampHint;

  /// Shown when a required field is left empty
  ///
  /// In en, this message translates to:
  /// **'Please enter some text'**
  String get requiredFieldError;

  /// Shown when input is not a valid number
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid number'**
  String get invalidNumberError;

  /// Shown when a negative number is entered but only positive is allowed
  ///
  /// In en, this message translates to:
  /// **'Value cannot be negative'**
  String get negativeNotAllowedError;

  /// Shown when the input number is excessively large
  ///
  /// In en, this message translates to:
  /// **'Please enter a realistic value'**
  String get tooLargeError;

  /// Shown when a number exceeds allowed decimal places
  ///
  /// In en, this message translates to:
  /// **'Max {maxDecimalPlaces} decimal places allowed'**
  String maxDecimalPlacesError(int maxDecimalPlaces);

  /// Generic error message for a maximum character limit in form fields.
  ///
  /// In en, this message translates to:
  /// **'Max {maxLength} characters allowed'**
  String maxLengthError(int maxLength);

  /// Label for car nickname input field
  ///
  /// In en, this message translates to:
  /// **'Nickname'**
  String get nicknameLabel;

  /// Hint for car nickname input field
  ///
  /// In en, this message translates to:
  /// **'Enter nickname of car'**
  String get nicknameHint;

  /// Label for VIN input field
  ///
  /// In en, this message translates to:
  /// **'VIN'**
  String get vinLabel;

  /// Hint for VIN input field
  ///
  /// In en, this message translates to:
  /// **'Enter VIN of car'**
  String get vinHint;

  /// Label for license plate input field
  ///
  /// In en, this message translates to:
  /// **'License Plate'**
  String get licensePlateLabel;

  /// Hint for license plate input field
  ///
  /// In en, this message translates to:
  /// **'Enter license plate of car'**
  String get licensePlateHint;

  /// Label for car make dropdown
  ///
  /// In en, this message translates to:
  /// **'Make'**
  String get makeLabel;

  /// Hint for car make dropdown
  ///
  /// In en, this message translates to:
  /// **'Search make'**
  String get makeHint;

  /// Label for car model input field
  ///
  /// In en, this message translates to:
  /// **'Model'**
  String get modelLabel;

  /// Hint for car model input field
  ///
  /// In en, this message translates to:
  /// **'Enter model of car'**
  String get modelHint;

  /// Label for car submodel input field
  ///
  /// In en, this message translates to:
  /// **'Submodel'**
  String get submodelLabel;

  /// Hint for car submodel input field
  ///
  /// In en, this message translates to:
  /// **'Enter submodel of car'**
  String get submodelHint;

  /// Label for car year dropdown
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get yearLabel;

  /// Hint for car year dropdown
  ///
  /// In en, this message translates to:
  /// **'Select Model Year'**
  String get yearHint;

  /// Label for current mileage input field
  ///
  /// In en, this message translates to:
  /// **'Current Mileage'**
  String get currentMileageLabel;

  /// Hint for current mileage input field
  ///
  /// In en, this message translates to:
  /// **'Enter current mileage of car'**
  String get currentMileageHint;

  /// Label for vehicle mileage
  ///
  /// In en, this message translates to:
  /// **'Mileage'**
  String get mileageLabel;

  /// Label for year dropdown
  ///
  /// In en, this message translates to:
  /// **'Select Year'**
  String get selectYear;

  /// Label for month dropdown
  ///
  /// In en, this message translates to:
  /// **'Select Month'**
  String get selectMonth;

  /// Label for missing data
  ///
  /// In en, this message translates to:
  /// **'No Data'**
  String get noDataText;

  /// Fuel cost for the selected month and year
  ///
  /// In en, this message translates to:
  /// **'Fuel Cost for {month}/{year}'**
  String monthlyFuelCost(int month, int year);

  /// Fuel cost for the selected year
  ///
  /// In en, this message translates to:
  /// **'Fuel Cost for {year}'**
  String yearlyFuelCost(int year);

  /// Total fuel cost for vehicle lifetime
  ///
  /// In en, this message translates to:
  /// **'Lifetime Fuel Cost'**
  String get lifetimeFuelCost;

  /// Total maintenance cost for vehicle lifetime
  ///
  /// In en, this message translates to:
  /// **'Lifetime Maintenance Cost'**
  String get lifetimeMaintenanceCost;

  /// Total cost of owning the vehicle including purchase, fuel, and maintenance
  ///
  /// In en, this message translates to:
  /// **'Lifetime Vehicle Cost'**
  String get lifetimeVehicleCost;

  /// Button to view fuel history
  ///
  /// In en, this message translates to:
  /// **'Fuel History'**
  String get fuelHistoryButton;

  /// Button to view maintenance/work history
  ///
  /// In en, this message translates to:
  /// **'Work History'**
  String get workHistoryButton;

  /// Label for speedometer reading dropdown
  ///
  /// In en, this message translates to:
  /// **'Speedometer Reading'**
  String get speedometerReadingLabel;

  /// Title for purchase history section
  ///
  /// In en, this message translates to:
  /// **'Purchase History'**
  String get purchaseHistoryTitle;

  /// Label for purchase date field
  ///
  /// In en, this message translates to:
  /// **'Purchase Date'**
  String get purchaseDateLabel;

  /// Hint for purchase date field
  ///
  /// In en, this message translates to:
  /// **'Enter purchase date of car'**
  String get purchaseDateHint;

  /// Label for purchase price field
  ///
  /// In en, this message translates to:
  /// **'Purchase Price'**
  String get purchasePriceLabel;

  /// Hint for purchase price field
  ///
  /// In en, this message translates to:
  /// **'Enter Original Price'**
  String get purchasePriceHint;

  /// Label for original odometer field
  ///
  /// In en, this message translates to:
  /// **'Original Odometer Number'**
  String get originalOdometerLabel;

  /// Hint for original odometer field
  ///
  /// In en, this message translates to:
  /// **'Enter odometer number when purchased'**
  String get originalOdometerHint;

  /// Title for button in settings to recalculate all fuel totals
  ///
  /// In en, this message translates to:
  /// **'Recalculate All Fuel Totals'**
  String get recalculateFuelTotalsTitle;

  /// Subtitle explaining that this fixes fuel totals for all vehicles
  ///
  /// In en, this message translates to:
  /// **'Corrects lifetime fuel totals for all vehicles'**
  String get recalculateFuelTotalsSubtitle;

  /// Title of confirmation dialog before recalculating fuel totals
  ///
  /// In en, this message translates to:
  /// **'Recalculate Fuel Costs?'**
  String get recalculateFuelTotalsDialogTitle;

  /// Body text warning about overwriting old fuel totals
  ///
  /// In en, this message translates to:
  /// **'This will overwrite lifetime fuel totals with the sum of all fuel records. Continue?'**
  String get recalculateFuelTotalsDialogBody;

  /// Cancel button text in the recalculate dialog
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get recalculateFuelTotalsCancel;

  /// Confirm button text in the recalculate dialog
  ///
  /// In en, this message translates to:
  /// **'Recalculate'**
  String get recalculateFuelTotalsConfirm;

  /// SnackBar message shown after fuel totals are recalculated
  ///
  /// In en, this message translates to:
  /// **'All fuel totals recalculated.'**
  String get recalculateFuelTotalsSuccess;

  /// Add vehicle form title
  ///
  /// In en, this message translates to:
  /// **'Add Vehicle Form'**
  String get addVehicleForm;

  /// Fill these details for future reference on the go! message
  ///
  /// In en, this message translates to:
  /// **'Fill these details for future reference on the go!'**
  String get fillDetailsForFutureReference;

  /// Label for button that navigates to add a new fuel record
  ///
  /// In en, this message translates to:
  /// **'Add Fuel'**
  String get buttonAddFuel;

  /// Label for button that navigates to add a new work/maintenance record
  ///
  /// In en, this message translates to:
  /// **'Add Work'**
  String get buttonAddWork;

  /// Label for button that navigates to view existing fuel records
  ///
  /// In en, this message translates to:
  /// **'View Fuel'**
  String get buttonViewFuel;

  /// Label for button that navigates to view existing work/maintenance records
  ///
  /// In en, this message translates to:
  /// **'View Work'**
  String get buttonViewWork;

  /// Title of the page that displays archived vehicles
  ///
  /// In en, this message translates to:
  /// **'Archived Vehicles'**
  String get archivedVehiclesTitle;

  /// Hint text for the dropdown menu used to select a vehicle
  ///
  /// In en, this message translates to:
  /// **'Select Vehicle'**
  String get selectVehicleHint;

  /// Label for the button that archives the selected vehicle
  ///
  /// In en, this message translates to:
  /// **'Archive'**
  String get archiveButtonLabel;

  /// Displayed when there are no archived vehicles to show
  ///
  /// In en, this message translates to:
  /// **'No Archived Vehicles'**
  String get noArchivedVehiclesMessage;

  /// Message in confirmation dialog for deleting vehicle and associated records
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this vehicle and all Fuel Records?'**
  String get confirmDeletionMessage;

  /// Snack bar message shown after a vehicle and its fuel records are deleted
  ///
  /// In en, this message translates to:
  /// **'Vehicle and Fuel records deleted!'**
  String get deleteSnackBarMessage;

  /// Button label for continuing into the app without creating an account
  ///
  /// In en, this message translates to:
  /// **'Continue as Guest'**
  String get continueAsGuest;

  /// Label for when guest account attempts to create record.
  ///
  /// In en, this message translates to:
  /// **'Guest accounts cannot create records. Please sign in or register.'**
  String get guestCannotCreateRecords;

  /// Message to state Notifications are disabled by system settings
  ///
  /// In en, this message translates to:
  /// **'Notifications Disabled'**
  String get notificationsDisabledTitle;

  /// No description provided for @notificationsDisabledMessage.
  ///
  /// In en, this message translates to:
  /// **'Notifications are disabled by device settings.'**
  String get notificationsDisabledMessage;

  /// Message to click Ok and proceed
  ///
  /// In en, this message translates to:
  /// **'Ok'**
  String get ok;

  /// Month of January
  ///
  /// In en, this message translates to:
  /// **'January'**
  String get january;

  /// Month of February
  ///
  /// In en, this message translates to:
  /// **'February'**
  String get february;

  /// Month of March
  ///
  /// In en, this message translates to:
  /// **'March'**
  String get march;

  /// Month of April
  ///
  /// In en, this message translates to:
  /// **'April'**
  String get april;

  /// Month of May
  ///
  /// In en, this message translates to:
  /// **'May'**
  String get may;

  /// Month of June
  ///
  /// In en, this message translates to:
  /// **'June'**
  String get june;

  /// Month of July
  ///
  /// In en, this message translates to:
  /// **'July'**
  String get july;

  /// Month of August
  ///
  /// In en, this message translates to:
  /// **'August'**
  String get august;

  /// Month of September
  ///
  /// In en, this message translates to:
  /// **'September'**
  String get september;

  /// Month of October
  ///
  /// In en, this message translates to:
  /// **'October'**
  String get october;

  /// Month of November
  ///
  /// In en, this message translates to:
  /// **'November'**
  String get november;

  /// Month of December
  ///
  /// In en, this message translates to:
  /// **'December'**
  String get december;
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
      <String>['en', 'es', 'fr'].contains(locale.languageCode);

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
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
