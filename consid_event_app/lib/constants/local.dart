class Local {
  // -------- NOT CHECKED IN --------
  // Splash Screen
  static const splashTitle = 'YOU\nHAVE BEEN\nINVITED';
  static const defaultDate = 'Date: TBA';
  static const dateStr = "Date:";

  // RSVP
  static const rsvpTitle = "RSVP";
  static const prompCodeInput = "Enter personal invitation code";
  static const rsvpHint = "Code";
  static const buttonSend = "send";
  static const inputFormatInvalid = "Require 4 length code";

  // RSVP - checks
  static const alertDialogInvalidCode = "Invalid code";

  // Register
  static const prompRegisterInput = "Enter personal information";
  static const nameInputHint = "Name";
  static const emailInputHint = "E-mail";
  static const phoneNumberInputHint = "Phone number";

  static const nameFormatInvalid = "Enter valid name";
  static const emailFormatInvalid = "Enter valid email";
  static const phoneNumberFormatInvalid = "Enter valid number";

  // Count-down
  static const days = "DAYS";
  static const hours = "HOURS";
  static const minutes = "MINUTES";
  static const seconds = "SECONDS";
  static const tba = "TBA";

  // It's Time - countdown is 0
  static const itsTimeTitle = "it's time!";
  static const itsTimeSubTitle = "You must validate your QR.";
  static const itsTimeInformation =
      "Do this by getting it scanned as you attend the event.";

  // -------- CHECKED IN --------
  // Splash Screen
  static const welcomeSplashTitle = 'WE \n WELCOME \n YOU';

  // Main Screen
  static const achievmentsTitle = "ACHIEVEMENTS";
  static const ticketsTitle = "TICKETS";
  static const ofStr = " of ";

  // Tickets list
  static const ticketsListTitle = "TICKETS";
  static const ticketCheers = "CHEERS\n";
  static const ticketThis = "THIS\n";
  static const ticketIsOnUs = "\nIS ON US";
  static const ticketWasOnUs = "\nWAS ON US";

  static const ticketAmount = "1\n";
  static const ticketFree = "FREE\n";

  // Chosen ticket
  static const oneFree = "1 \n FREE \n";
  static const giveTicket = "Give away";
  static const scanGuestQRTitle = "SCAN GUEST QR";

  //Failed screen
  static const failedMessage = "Something didn't go as expected";
  static const buttonTryAgain = "TRY AGAIN";

  // Achievements
  static const achievementsTitle = "ACHIEVEMENTS";
  static const achievementStr = "Achievement";
  static const achievementsStr = "Achievements";
  static const achievedStr = "Achieved";
  static const tapScreen = "Tap to scan";
  static const wrongQrType = "Wrong QR type, try again.";
  static const scanQRTitle = "SCAN QR";
  static const scanQRButtonTitle = "SCAN";
  static const successScanMsg = "Successfully scanned the QR";
  // Double scan promp
  static const getScannedPromp = "Get Scanned!";
  static const prompScanQrFirst =
      "Scan a guest QR first.\nQR image can be found on main page bottom left corner";

  // Secret achievement
  static const secretAchievDone = " Done";
  static const percentAchiev = "%";
  static const achievementsDone = "Achievements done";
  static const ticketsUsed = "Tickets used";
  static const scannedStr = "Scanned";
  static const peopleStr = " People";
  static const socialStr = "You are socialising";

  // Leaderboard
  static const leaderBoardTitle = "LEADERBOARD";
  static const lbHeaderPlace = "Place";
  static const lbHeaderName = "Name";
  static const lbHeaderScore = "Score";

  // --------   UPDATE ALERT MESSAGES  --------
  static const updateAlertTitle = "Available update";
  static updateAlertContent(String currentVersion, String remoteVersion) =>
      "Update available from\nVersion " +
      currentVersion +
      "\nto\nVersion " +
      remoteVersion;
  static const updateAlertBtnText = "Okay";

  // --------   ERROR MESSAGES  --------
  static const registartionError = "An error occurred upon registration";
  static const noDataInFieldErrorMsg = "Error, could not fetch data";
  static const invalidQrFormat = "Invalid QR Format";

  // --------   PERMISSION MESSAGES  --------
  static const permissionTitle = "Camera Permission";
  static const permissionUsage =
      "This application needs access to the camera to scan QR codes";
  static const denie = "Don't allow";
  static const settings = "Settings";
}
