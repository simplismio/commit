class LanguageModel {
  // AppBar titles
  static Map<String, String>? mainScreenAppBarTitle = {
    'English': 'Contracts',
    'Dutch': 'Contracten'
  };
  static Map<String, String>? newContractScreenAppBarTitle = {
    'English': 'New contract',
    'Dutch': 'Nieuw contract'
  };
  static Map<String, String>? newCommitmentScreenAppBarTitle = {
    'English': 'New commitment',
    'Dutch': 'Nieuw commitment'
  };
  static Map<String, String>? editContractScreenAppBarTitle = {
    'English': 'Edit contract',
    'Dutch': 'Wijzig contract'
  };
  static Map<String, String>? editCommitmentScreenAppBarTitle = {
    'English': 'Edit commitment',
    'Dutch': 'Wijzig commitment'
  };
  static Map<String, String>? resetPasswordScreenAppBarTitle = {
    'English': 'Reset password',
    'Dutch': 'Reset wachtwoord'
  };
  static Map<String, String>? editProfileScreenAppBarTitle = {
    'English': 'Edit profile',
    'Dutch': 'Wijzig profiel'
  };
  static Map<String, String>? signInScreenAppBarTitle = {
    'English': 'Sign in',
    'Dutch': 'Log in'
  };
  static Map<String, String>? signUpScreenAppBarTitle = {
    'English': 'Sign up',
    'Dutch': 'Registreer'
  };

  // Buttons
  static Map<String, String>? newContractScreenButtonText = {
    'English': 'Save contract',
    'Dutch': 'Contract opslaan'
  };
  static Map<String, String>? newCommitmentScreenButtonText = {
    'English': 'Save commitment',
    'Dutch': 'Commitment opslaan'
  };
  static Map<String, String>? editContractScreenButtonText = {
    'English': 'Save changes',
    'Dutch': 'Wijzigingn opslaan'
  };
  static Map<String, String>? editCommitmentScreenButtonText = {
    'English': 'Save changes',
    'Dutch': 'Wijzigingn opslaan'
  };
  static Map<String, String>? resetPasswordScreenButtonText = {
    'English': 'Email reset link',
    'Dutch': 'Email reset link'
  };
  static Map<String, String>? editProfileScreenButtonText = {
    'English': 'Save changes ',
    'Dutch': 'Wijzingen opslaan'
  };
  static Map<String, String>? editContractScreenDeleteContractButtonText = {
    'English': 'Save changes ',
    'Dutch': 'Wijzingen opslaan'
  };
  static Map<String, String>? signInScreenButtonText = {
    'English': 'Sign in',
    'Dutch': 'Log in'
  };
  static Map<String, String>? signUpScreenButtonText = {
    'English': 'Sign up',
    'Dutch': 'Registreer'
  };
  static Map<String, String>? mainScreenSettingsLogoutButton = {
    'English': 'Log out',
    'Dutch': 'Uitloggen'
  };

  // Placeholders
  static Map<String, String>? newContractScreenContractTitlePlaceholder = {
    'English': 'Contract title',
    'Dutch': 'Titel van het contract'
  };
  static Map<String, String>? newCommitmentScreenCommitmentPlaceholder = {
    'English': 'Commitment',
    'Dutch': 'Commitment'
  };
  static Map<String, String>? editContractScreenContractTitlePlaceholder = {
    'English': 'Contract title',
    'Dutch': 'Titel van het contract'
  };
  static Map<String, String>? editCommitmentScreenCommitmentPlaceholder = {
    'English': 'Commitment',
    'Dutch': 'Commitment'
  };
  static Map<String, String>? resetPasswordScreenEmailPlaceholder = {
    'English': 'Email',
    'Dutch': 'Email'
  };
  static Map<String, String>? editProfileScreenUsernamePlaceholder = {
    'English': 'Username',
    'Dutch': 'Gebruikersnaam'
  };
  static Map<String, String>? editProfileScreenEmailPlaceholder = {
    'English': 'Email',
    'Dutch': 'Email'
  };
  static Map<String, String>? signUpScreenUsernamePlaceholder = {
    'English': 'Username',
    'Dutch': 'Gebruikersnaam'
  };
  static Map<String, String>? signInUpScreenEmailPlaceholder = {
    'English': 'Email',
    'Dutch': 'Email'
  };
  static Map<String, String>? signInUpScreenPasswordPlaceholder = {
    'English': 'Password',
    'Dutch': 'Wachtwoord'
  };

  // Error Messages
  static Map<String, String>? newContractScreenContractTitleErrorMessage = {
    'English': 'Please provide a valid contract title',
    'Dutch': 'De ingegeven contract titel is incorrect'
  };
  static Map<String, String>? newCommitmentScreenCommitmentErrorMessage = {
    'English': 'Please provide a valid commitment',
    'Dutch': 'Het ingegeven commitment is incorrect'
  };
  static Map<String, String>? editContractScreenContractTitleErrorMessage = {
    'English': 'Please provide a valid contract title',
    'Dutch': 'De ingegeven contract title is incorrect'
  };
  static Map<String, String>? editCommitmentScreenCommitmentErrorMessage = {
    'English': 'Please provide a valid commitment',
    'Dutch': 'Het ingegeven commitment is incorrect'
  };
  static Map<String, String>? resetPasswordScreenEmailErrorMessage = {
    'English': 'Please provide a valid email address',
    'Dutch': 'Het ingegeven email adres is incorrect'
  };
  static Map<String, String>? editProfileScreenUsernameErrorMessage = {
    'English': 'Please provide a valid username',
    'Dutch': 'De ingegeven gebruikersnaam is incorrect'
  };
  static Map<String, String>? signUpScreenUsernameErrorMessage = {
    'English': 'Please provide a valid username',
    'Dutch': 'Het ingegeven wachtwoord is incorrect'
  };
  static Map<String, String>? signInUpScreenEmailErrorMessage = {
    'English': 'Please provide a valid email address',
    'Dutch': 'De ingegeven gebruikersnaam is incorrect'
  };
  static Map<String, String>? signInUpScreenPasswordErrorMessage = {
    'English': 'testEN',
    'Dutch': 'Er zijn nog geen commitments gemaakt'
  };
  static Map<String, String>? mainScreenNoContractsErrorMessage = {
    'English': 'There are no contracts yet',
    'Dutch': 'Er zijn nog geen contracten'
  };
  static Map<String, String>? mainScreenNoCommitmentsErrorMessage = {
    'English': 'There are no commitments yet',
    'Dutch': 'Er zijn nog geen commitments gemaakt'
  };
  static Map<String, String>? mainScreenNoNotificationsErrorMessage = {
    'English': 'There are no notifications yet',
    'Dutch': 'Er zijn nog geen notificaties'
  };
  static Map<String, String>? genericAuthErrorMessage = {
    'English': 'Email address or password is incorrect',
    'Dutch': 'Email adres of wachtwoord is incorrect'
  };
  static Map<String, String>? genericFirebaseErrorMessage = {
    'English': 'Something went wrong. Please try again',
    'Dutch': 'Er is iets verkeerd gegaan. Probeert u het s.v.p. opnieuw'
  };

  // Links
  static Map<String, String>? signInScreenResetPasswordLink = {
    'English': 'I forgot my password',
    'Dutch': 'Ik ben mijn wachtwoord vergeten'
  };
  static Map<String, String>? signInScreenSignUpUsingEmailLink = {
    'English': 'Sign up using email',
    'Dutch': 'Registreer met een email adres'
  };
  static Map<String, String>? signInScreengoBackToSignInLink = {
    'English': 'Go back to sign in',
    'Dutch': 'Ga terug naar log in'
  };
  static Map<String, String>? mainScreenDismissebleEditCommitmentLink = {
    'English': 'Edit commitment',
    'Dutch': 'Wijzig commitment'
  };
  static Map<String, String>? mainScreenDismissebleDeleteCommitmentLink = {
    'English': 'Delete commitment',
    'Dutch': 'Verwijder commitment'
  };
  static Map<String, String>? mainScreenDismissebleMarkNotificationReadLink = {
    'English': 'Mark as read',
    'Dutch': 'Markeren als gelezen'
  };

  // Labels
  static Map<String, String>? mainScreenSettingEditProfileLabel = {
    'English': 'Edit profile',
    'Dutch': 'Wijzig profiel'
  };
  static Map<String, String>? mainScreenSettingsLanguageLabel = {
    'English': 'Language',
    'Dutch': 'Taal'
  };
  static Map<String, String>? mainScreenSettingsThemeLabel = {
    'English': 'Dark theme',
    'Dutch': 'Donker thema'
  };
  static Map<String, String>? mainScreenSettingsBiometricsLabel = {
    'English': 'Biometric unlock',
    'Dutch': 'Unlock met biometrie'
  };
  static Map<String, String>? mainScreenSettingsAnalyticsLabel = {
    'English': 'Share analytics',
    'Dutch': 'Deel gebruiksgegevens'
  };

  // Headers
  static Map<String, String>? mainScreenNotificationHeader = {
    'English': 'Notifications',
    'Dutch': 'Notificaties'
  };

  // Push notifications titles
  static Map<String, String>? activateContractNotificationTitle = {
    'English': 'Contract activated',
    'Dutch': 'Contract geactiveerd'
  };

  // Push notifications bodies
  static Map<String, String>? activateContractNotificationBody = {
    'English': 'Click to add commitment to the contract',
    'Dutch': 'Contract geactiveerd'
  };

  // Email titles
  static Map<String, String>? welcomeEmailTitle = {
    'English': 'Welcome to Commit',
    'Dutch': 'Welkom bij Commit'
  };
  static Map<String, String>? addContractEmailTitle = {
    'English': 'You have been added to a new contract',
    'Dutch': 'Je bent toegevoegd aan een contract'
  };

  // Email bodies
  static Map<String, String>? welcomeEmailBody = {
    'English': 'You have made the right decision to commit',
    'Dutch': 'Je hebt het juiste besluit genomen om je te commiteren'
  };
  static Map<String, String>? addContractEmailBody = {
    'English': 'You have been added as a participant in a new contract',
    'Dutch': 'Je bent toegevoegd aan een contract'
  };
}
