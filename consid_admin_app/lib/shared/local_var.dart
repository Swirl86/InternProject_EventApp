class LocalVar {
  // Sign In
  static String eventAdmin = "EVENT ADMIN";
  static String logIn = 'Log In';
  static String pwCriteria = 'Enter a password 6+ charts long';
  static String noSuchUser = "No such user!";
  static String emailInputHint = "E-mail";
  static String invalidEmail = "invalid Email";
  static String pwInputHint = "Password";

  // Home & General
  static String unknown = "Unknown";
  static String logOut = "Log Out";
  static String listParticipants = "List Participants";
  static String print = "Print Achievements";
  static String manually = "Manually";
  static String editEvent = "Edit event data";

  // Scanning
  static String errorCheckIn = "Error checking in user";
  static String checkIn = " has been checked in";
  static String user = "User";
  static String scan = "Scan";
  static String scanTicket = "Scan Ticket QR";
  static String errorOnScan = "Error upon scanning ticket";
  static String andTicketId = " and ticket ID";
  static String scanned = " scanned!";
  static String invalidQrFormat = "Invalid QR Format";
  static String notExpected = "Something didn't go as expected";
  static String s = "'s ";

  // Participants list
  static String participants = "Participants";
  static String scannedP = "Scanned";
  static String of = "of";

  // Tab bar
  static String everyoneList = "Everyone";
  static String scannedList = "Scanned";
  static String notScannedList = "Not Scanned";

  // Auth service (Login logout)
  static String errorLogin = "Error logging in";
  static String errorLogout = "Error logging out";

  // -------- Super admin --------

  // Create handler for
  static String createHandler = "Create Handler";
  static String pickWhat = "Pick what you want to create";
  static String regular = "Regular";
  static String secret = "Secret";
  static String invites = "Invites";
  static String event = "Event";

  // SuperAdmin home
  static String superadmin = "Super admin";
  static String listUnusedInvites = "List unused Invites";
  static String create = "Create";
  static String listAchievements = "List Achievements";

  // Create achievement
  static String scanQr = 'Scan QR';
  static String createAchiev = "Create Achievement";
  static String infoHere = "Enter information here";

  static const opt1 = 'Scan QR';
  static const opt2 = 'Double Scanned';
  static const opt3 = 'Get Scanned';

  static String hintTitle = "Title";
  static String invalidTitle = "invalid title";
  static String desc = "Description";
  static String invalidDesc = "Invalid description";
  static String send = "Skicka";

  // Create invites
  static String createInvites = "Create Invites";
  static String enterInfo = "Enter invite info here";
  static String nrInvites = "Nr of Invites";
  static String invalidNr = "invalid nr";
  static String serverLocation =
      "* Due to server location being in the US, invite creation can take 2-3 minutes.";
  static String nrSpace = " Nr  ";
  static String justTicket = "Ticket";
  static String nameT = "Name";

  // Manual handler
  static String manualHandler = "Manual handler";
  static String hintInputCode = "Invite code";
  static String ownerCheck = "Check owner";
  static String name = "Name";
  static String email = "E-Mail";
  static String phoneNr = "Phone-nr";
  static String confirmCheckin = "Confirm checkin";
  static String ticketsLeft = "Tickets left";
  static String userNoExist = "User doesn't exist";
  static String needsRegister = "Need to register account first";
  static String ticketsCantUse = "Can't use tickets before user has checked in";
  static String registartionError = "An error occurred while registering";
  static String nameInputHint = "Name";
  static String nameFormatInvalid = "Invalid name format";
  static String emailFormatInvalid = "Invalid e-mail format";
  static String phoneNumberInputHint = "Phone nr";
  static String phoneNumberFormatInvalid = "Invalid format used";
  static String userAlreadyReg = "User already registered";
  static String invalidCode = "Invalid invite code";
  static String submit = "Submit";
  static String save = "Save";
  static String addTicket = "Add ticket";

  // Create Event
  static String createEvent = "Create Event";
  static String eventStart = "Event Start Date";
  static String eventEnd = "Event End Date";

  // Confirm Dialog
  static String cancel = "Cancel";
  static String useTicket = "Use ticket";
  static String alertDialog = "AlertDialog";
  static String confirmTicket = "Please confirm using this ticket";

  static String confirmEvent = "Confirm new event creation!";
  static String event1 = "All event data will be moved to a backup.\n";
  static String event2 = "This cannot be made undone!\n";
  static String event3 = "Please confirm";
  static String confirm = "Confirm";

  // List of Scannable Achievements
  static String listScannable = "List of Scannable Achievements";

  // List unused invite codes
  static String unusedInvites = "Unused invite codes";
  static String downloadCsv = "Download list as CSV";

  // Create Secret Achievements
  static String createSecret = "Create Secret Achievement";
  static String percentSign = " % ";
  static String currentSecret = "Current Secret Achievements";

  // List all achievements
  static String allAchievements = "List All Achievements";
  static String currentAchievements = "Current Regular Achievements";

  // Got Update
  static String ok = "ok";
  static String availableUpdate = "Available update";
  static String current = "Current";
  static String newest = "Newest";

  // Edit event data
  static String editEventData = "Edit current event data";
  static String confirmEditEvent = "Confirm edit of event data";

  // -------- FireBase/Store/Storage ------
  static String achieveCreated = "Achievement created";
  static String achieveUpdated = "Achievement updated";
  static String errorAchieve = "Error on adding Achievement";
  static String uniqueTitle = "Please choose a unique achievement title";
  static String errorUserCheckin = "Error checking in user";
  static String dbManually = "has been checked in";
  static String errorUsingTicket = "Error using ticket";
  static String achievementDeleted = "Achievement deleted";
  static String confirmDeletion = 'Confirm deletion of this:';
  static String invalid = "Invalid";
  static String guestCheckIn = "checked in";
  static String secretCreated = "Secret created";
  static String alreadyExists = "Already exists";
  static String ticketCouldntAdd = "Couldn't add ticket";
  static String noUsersYetInvitesFirst =
      "No users yet. \n Create invites first!";
  static String tickets = "Tickets";
  static String ticket = "Ticket";

  static promptMultiInput(String? userId, String? ticketId) {
    return "User $userId and ticket id $ticketId manually used";
  }

  static promptInputAdded(String word) {
    return "$word added";
  }

  // -----------------------------

}
