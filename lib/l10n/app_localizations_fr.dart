// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Suivi des véhicules';

  @override
  String get createAccount => 'Créer un compte';

  @override
  String get email => 'E-mail';

  @override
  String get emailVerified => 'E-mail vérifié';

  @override
  String get yes => 'Oui';

  @override
  String get no => 'Non';

  @override
  String get username => 'Nom d\'utilisateur';

  @override
  String get usernameHint => 'Entrez le nom d\'utilisateur';

  @override
  String get password => 'Mot de passe';

  @override
  String get firstName => 'Prénom';

  @override
  String get firstNameHint => 'Entrez le prénom';

  @override
  String get lastName => 'Nom de famille';

  @override
  String get lastNameHint => 'Entrez le nom de famille';

  @override
  String get enablePrivacyAnalytics => 'Activer l\'analyse de confidentialité';

  @override
  String get privacyAnalyticsSubtitle =>
      'Aidez à améliorer l\'application en partageant des données d\'utilisation anonymes.';

  @override
  String get genericSuccess => 'Informations mises à jour avec succès !';

  @override
  String get genericError => 'Une erreur s\'est produite. Veuillez réessayer.';

  @override
  String genericErrorWithDetail(Object errorDetail) {
    return 'Erreur : $errorDetail';
  }

  @override
  String welcomeUser(Object username) {
    return 'Bienvenue, $username ! Un e-mail de vérification a été envoyé.';
  }

  @override
  String get saveChanges => 'Enregistrer les modifications';

  @override
  String get profile => 'Profil';

  @override
  String get editProfile => 'Modifier le profil';

  @override
  String get editVehicle => 'Modifier le véhicule';

  @override
  String get vehicleDetails => 'Détails du véhicule';

  @override
  String get financialSummary => 'Résumé financier';

  @override
  String get vehicleInformationTitle => 'Informations sur le véhicule';

  @override
  String get engineDetails => 'Détails du moteur';

  @override
  String get exteriorDetails => 'Détails extérieurs';

  @override
  String get batteryDetails => 'Détails de la batterie';

  @override
  String get backToHome => 'Retour à l\'accueil';

  @override
  String get resetPassword => 'Réinitialiser le mot de passe';

  @override
  String get resetPasswordEmailSent =>
      'E-mail de réinitialisation du mot de passe envoyé ! Vérifiez votre boîte de réception.';

  @override
  String get enterEmailMessage =>
      'Entrez votre e-mail pour recevoir un lien de réinitialisation.';

  @override
  String get sendResetEmail => 'Envoyer l’e-mail de réinitialisation';

  @override
  String get sendVerificationEmail => 'Envoyer l’e-mail de vérification';

  @override
  String get verificationEmailSent =>
      'E-mail de vérification envoyé ! Vérifiez votre boîte de réception.';

  @override
  String get fillInAllFields => 'Remplissez tous les champs';

  @override
  String get signIn => 'Se connecter';

  @override
  String get fillInTwoFields => 'Veuillez remplir 2 des champs ci-dessus.';

  @override
  String get emptyMessageText => 'Veuillez entrer du texte';

  @override
  String get enterValidNumber => 'Veuillez entrer un nombre valide';

  @override
  String get noNegatives => 'Pas de nombres négatifs';

  @override
  String get enterRealisticValue => 'Entrez une valeur réaliste';

  @override
  String maxDecimalPlacesMessage(Object maxDecimalPlaces) {
    return 'Maximum $maxDecimalPlaces décimales autorisées';
  }

  @override
  String get fuelAmountLabel => 'Quantité de carburant';

  @override
  String get fuelAmountLabelHint => 'Entrez la quantité de carburant';

  @override
  String get fuelPriceLabel => 'Prix du carburant';

  @override
  String get fuelPriceLabelHint => 'Entrez le prix du carburant';

  @override
  String get totalFuelCostLabel => 'Coût total';

  @override
  String get totalFuelCostLabelHint => 'Entrez le coût total';

  @override
  String get odometerLabel => 'Compteur kilométrique';

  @override
  String get odometerLabelHint =>
      'Entrez le numéro actuel du compteur (facultatif)';

  @override
  String get calculateMissingFieldLabel => 'Calculer le champ manquant';

  @override
  String get dateLabel => 'Date';

  @override
  String get enterDateRefuelLabel => 'Entrez la date du ravitaillement';

  @override
  String get enterValidDateMessage => 'Veuillez sélectionner une date valide';

  @override
  String errorSavingFuelRecordMessage(Object error) {
    return 'Erreur lors de l\'enregistrement du ravitaillement : $error';
  }

  @override
  String get addFuelRecordButton => 'Ajouter un ravitaillement';

  @override
  String get editFuelRecordButton => 'Modifier le ravitaillement';

  @override
  String get submitButton => 'Soumettre';

  @override
  String get updateButton => 'Mettre à jour';

  @override
  String get sortButton => 'Trier';

  @override
  String get confirmDeleteButton => 'Confirmer la suppression';

  @override
  String get deleteButton => 'Supprimer';

  @override
  String get deleteVehicleButton => 'Supprimer le véhicule';

  @override
  String get cancelButton => 'Annuler';

  @override
  String get unarchiveButton => 'Désarchiver';

  @override
  String get discardChangesButton => 'Ignorer les modifications';

  @override
  String get discardChangesDescription =>
      'Vous avez des modifications non enregistrées. Êtes-vous sûr de vouloir quitter ?';

  @override
  String get leaveButton => 'Quitter';

  @override
  String get sortNewest => 'Le plus récent';

  @override
  String get sortOldest => 'Le plus ancien';

  @override
  String get sortLowToHigh => 'Croissant';

  @override
  String get sortHighToLow => 'Décroissant';

  @override
  String get selectSortTypeLabel => 'Sélectionner le type de tri';

  @override
  String get fuelRecordsTitle => 'Enregistrements de carburant';

  @override
  String get noRecordsFoundMessage => 'Aucun enregistrement trouvé';

  @override
  String get confirmFuelRecordDeleteMessage =>
      'Êtes-vous sûr de vouloir supprimer cet enregistrement de carburant ?';

  @override
  String get profileButton => 'Profil';

  @override
  String get homepageButton => 'Accueil';

  @override
  String get settingsButton => 'Paramètres';

  @override
  String get signoutButton => 'Déconnexion';

  @override
  String get manageDataTitle => 'Gérer les données';

  @override
  String get deleteAppDataButton => 'Supprimer les données';

  @override
  String get deleteAccountButton => 'Supprimer le compte';

  @override
  String get confirmAppDataDeletionTitle =>
      'Confirmer la suppression des données';

  @override
  String get confirmAppDataDeletionContent =>
      'Cela supprimera définitivement toutes vos données. Continuer ?';

  @override
  String get confirmAccountDeletionTitle =>
      'Confirmer la suppression du compte';

  @override
  String get confirmAccountDeletionContent =>
      'Cela supprimera définitivement votre compte. Continuer ?';

  @override
  String get reenterPasswordTitle => 'Ressaisir le mot de passe';

  @override
  String get passwordFieldLabel => 'Mot de passe';

  @override
  String get confirmButton => 'Confirmer';

  @override
  String get accountDeletedMessage => 'Compte supprimé !';

  @override
  String failedToDeleteAccountMessage(Object error) {
    return 'Échec de la suppression du compte : $error';
  }

  @override
  String get userNotLoggedInMessage => 'Utilisateur non connecté';

  @override
  String get appDataDeletedMessage => 'Données supprimées !';

  @override
  String failedToDeleteAppDataMessage(Object error) {
    return 'Échec de la suppression des données : $error';
  }

  @override
  String get settingsTitle => 'Paramètres';

  @override
  String get enablePushNotifications => 'Activer les notifications push';

  @override
  String get privacyAnalytics => 'Analyse de la confidentialité';

  @override
  String get displayOptions => 'Options d\'affichage';

  @override
  String get privacyPolicy => 'Politique de confidentialité';

  @override
  String get termsOfService => 'Conditions d\'utilisation';

  @override
  String get licenses => 'Licences';

  @override
  String get manageData => 'Gérer les données';

  @override
  String get aboutDescription1 =>
      'Cette application vous aide à suivre vos enregistrements de carburant.';

  @override
  String get aboutDescription2 =>
      'Pour le support : vehiclerecordtracker@gmail.com';

  @override
  String get applicationLegalese => '© 2025 Vehicle Record Tracker';

  @override
  String get applicationName => 'Vehicle Record Tracker';

  @override
  String get myVehiclesButton => 'Mes véhicules';

  @override
  String get archivedVehiclesButton => 'Véhicules archivés';

  @override
  String get addVehicleButton => 'Ajouter un véhicule';

  @override
  String get seriesTypeLabel => 'Type de série';

  @override
  String get seriesTypeHint => 'Ex : BXT';

  @override
  String get bciGroupSizeLabel => 'Taille du groupe BCI';

  @override
  String get bciGroupSizeHint => 'Sélectionnez la taille du groupe';

  @override
  String get coldCrankAmpsLabel => 'Ampérage au démarrage à froid - CCA';

  @override
  String get coldCrankAmpsHint => 'Ex : 500';

  @override
  String get enterIntegerError => 'Veuillez entrer un entier';

  @override
  String get noNegativesError => 'Pas de valeurs négatives';

  @override
  String get engineSizeLabel => 'Taille du moteur';

  @override
  String get engineSizeHint => 'Sélectionnez la taille du moteur';

  @override
  String get cylinderCountLabel => 'Nombre de cylindres';

  @override
  String get cylinderCountHint => 'Sélectionnez le nombre de cylindres';

  @override
  String get cylinderLabel => 'Cylindre ';

  @override
  String get engineTypeLabel => 'Type de moteur';

  @override
  String get engineTypeHint => 'Sélectionnez le type de moteur';

  @override
  String get oilWeightLabel => 'Viscosité de l\'huile';

  @override
  String get oilWeightHint => 'Ex : 5W-30';

  @override
  String get oilCompositionLabel => 'Composition de l\'huile';

  @override
  String get oilCompositionHint => 'Sélectionnez la composition';

  @override
  String get oilClassLabel => 'Classe de l\'huile';

  @override
  String get oilClassHint => 'Sélectionnez la classe d\'huile';

  @override
  String get oilFilterLabel => 'Filtre à huile';

  @override
  String get oilFilterHint => 'Ex S7317XL';

  @override
  String get engineFilterLabel => 'Filtre moteur';

  @override
  String get engineFilterHint => 'Ex FA-1785';

  @override
  String get engineTypeGas => 'Essence';

  @override
  String get engineTypeDiesel => 'Diesel';

  @override
  String get engineTypeHybrid => 'Hybride';

  @override
  String get engineTypeElectric => 'Électrique';

  @override
  String get oilCompositionConventional => 'Conventionnelle';

  @override
  String get oilCompositionFullSynthetic => 'Entièrement synthétique';

  @override
  String get oilCompositionMineral => 'Minérale';

  @override
  String get oilCompositionSyntheticBlend => 'Mélange synthétique';

  @override
  String get driverWiperLabel => 'Essuie-glace côté conducteur';

  @override
  String get driverWiperHint => 'Ex WW-1801-PF';

  @override
  String get passengerWiperLabel => 'Essuie-glace côté passager';

  @override
  String get passengerWiperHint => 'Ex WW-1901-PF';

  @override
  String get rearWiperLabel => 'Essuie-glace arrière';

  @override
  String get rearWiperHint => 'Ex WW-1701-PF';

  @override
  String get highBeamLabel => 'Feux de route';

  @override
  String get highBeamHint => 'Ex H7LL';

  @override
  String get lowBeamLabel => 'Feux de croisement';

  @override
  String get lowBeamHint => 'Ex H11LL';

  @override
  String get turnLampLabel => 'Clignotant';

  @override
  String get turnLampHint => 'Ex T20';

  @override
  String get backupLampLabel => 'Feu de recul';

  @override
  String get backupLampHint => 'Ex 921';

  @override
  String get fogLampLabel => 'Feu antibrouillard';

  @override
  String get fogLampHint => 'Ex H11';

  @override
  String get brakeLampLabel => 'Feu de frein';

  @override
  String get brakeLampHint => 'Ex LED';

  @override
  String get licenseLampLabel => 'Éclairage plaque d\'immatriculation';

  @override
  String get licenseLampHint => 'Ex C5W';

  @override
  String get requiredFieldError => 'Veuillez entrer du texte';

  @override
  String get invalidNumberError => 'Veuillez entrer un nombre valide';

  @override
  String get negativeNotAllowedError => 'La valeur ne peut pas être négative';

  @override
  String get tooLargeError => 'Veuillez entrer une valeur réaliste';

  @override
  String maxDecimalPlacesError(int maxDecimalPlaces) {
    return 'Maximum $maxDecimalPlaces décimales autorisées';
  }

  @override
  String maxLengthError(int maxLength) {
    return 'Maximum $maxLength caractères autorisés';
  }

  @override
  String get nicknameLabel => 'Surnom';

  @override
  String get nicknameHint => 'Entrez le surnom de la voiture';

  @override
  String get vinLabel => 'VIN';

  @override
  String get vinHint => 'Entrez le VIN de la voiture';

  @override
  String get licensePlateLabel => 'Plaque d\'immatriculation';

  @override
  String get licensePlateHint =>
      'Entrez la plaque d\'immatriculation de la voiture';

  @override
  String get makeLabel => 'Marque';

  @override
  String get makeHint => 'Rechercher une marque';

  @override
  String get modelLabel => 'Modèle';

  @override
  String get modelHint => 'Entrez le modèle de la voiture';

  @override
  String get submodelLabel => 'Sous-modèle';

  @override
  String get submodelHint => 'Entrez le sous-modèle de la voiture';

  @override
  String get yearLabel => 'Année';

  @override
  String get yearHint => 'Sélectionnez l\'année du modèle';

  @override
  String get currentMileageLabel => 'Kilométrage actuel';

  @override
  String get currentMileageHint => 'Entrez le kilométrage actuel de la voiture';

  @override
  String get mileageLabel => 'Kilométrage';

  @override
  String get selectYear => 'Sélectionnez l\'année';

  @override
  String get selectMonth => 'Sélectionnez le mois';

  @override
  String get noDataText => 'Pas de données';

  @override
  String monthlyFuelCost(int month, int year) {
    return 'Coût du carburant pour $month/$year';
  }

  @override
  String yearlyFuelCost(int year) {
    return 'Coût du carburant pour $year';
  }

  @override
  String get lifetimeFuelCost => 'Coût total du carburant';

  @override
  String get lifetimeMaintenanceCost => 'Coût total de maintenance';

  @override
  String get lifetimeVehicleCost => 'Coût total du véhicule';

  @override
  String get fuelHistoryButton => 'Historique du carburant';

  @override
  String get workHistoryButton => 'Historique des travaux';

  @override
  String get speedometerReadingLabel => 'Lecture du compteur';

  @override
  String get purchaseHistoryTitle => 'Historique des achats';

  @override
  String get purchaseDateLabel => 'Date d\'achat';

  @override
  String get purchaseDateHint => 'Entrez la date d\'achat de la voiture';

  @override
  String get purchasePriceLabel => 'Prix d\'achat';

  @override
  String get purchasePriceHint => 'Entrez le prix d\'origine';

  @override
  String get originalOdometerLabel => 'Nombre au compteur d\'origine';

  @override
  String get originalOdometerHint => 'Entrez le kilométrage à l\'achat';

  @override
  String get recalculateFuelTotalsTitle =>
      'Recalculer tous les totaux de carburant';

  @override
  String get recalculateFuelTotalsSubtitle =>
      'Corrige les totaux de carburant à vie pour tous les véhicules';

  @override
  String get recalculateFuelTotalsDialogTitle =>
      'Recalculer les coûts de carburant ?';

  @override
  String get recalculateFuelTotalsDialogBody =>
      'Cela écrasera les totaux de carburant à vie avec la somme de tous les enregistrements de carburant. Continuer ?';

  @override
  String get recalculateFuelTotalsCancel => 'Annuler';

  @override
  String get recalculateFuelTotalsConfirm => 'Recalculer';

  @override
  String get recalculateFuelTotalsSuccess =>
      'Tous les totaux de carburant ont été recalculés.';

  @override
  String get addVehicleForm => 'Formulaire d\'ajout de véhicule';

  @override
  String get fillDetailsForFutureReference =>
      'Remplissez ces détails pour référence future en déplacement !';

  @override
  String get buttonAddFuel => 'Ajouter du carburant';

  @override
  String get buttonAddWork => 'Ajouter une intervention';

  @override
  String get buttonViewFuel => 'Voir le carburant';

  @override
  String get buttonViewWork => 'Voir les interventions';

  @override
  String get archivedVehiclesTitle => 'Véhicules archivés';

  @override
  String get selectVehicleHint => 'Sélectionner un véhicule';

  @override
  String get archiveButtonLabel => 'Archiver';

  @override
  String get noArchivedVehiclesMessage => 'Aucun véhicule archivé';

  @override
  String get confirmDeletionMessage =>
      'Êtes-vous sûr de vouloir supprimer ce véhicule et tous les enregistrements de carburant ?';

  @override
  String get deleteSnackBarMessage =>
      'Véhicule et enregistrements de carburant supprimés !';

  @override
  String get continueAsGuest => 'Continuer en tant qu\'invité';

  @override
  String get guestCannotCreateRecords =>
      'Les comptes invités ne peuvent pas créer d\'enregistrements. Veuillez vous connecter ou vous inscrire.';

  @override
  String get january => 'Janvier';

  @override
  String get february => 'Février';

  @override
  String get march => 'Mars';

  @override
  String get april => 'Avril';

  @override
  String get may => 'Mai';

  @override
  String get june => 'Juin';

  @override
  String get july => 'Juillet';

  @override
  String get august => 'Août';

  @override
  String get september => 'Septembre';

  @override
  String get october => 'Octobre';

  @override
  String get november => 'Novembre';

  @override
  String get december => 'Décembre';
}
