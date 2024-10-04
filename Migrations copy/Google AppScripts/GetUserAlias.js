//Get user's aliases in a Google Workspace domain, based on Domain
//This script will create a new Google Sheet with the user's email and aliases

function getUsersAndAliases() {
  // Replace the value below with your domain
  const domain = 'yourdomain.com';

  // Create a new spreadsheet
  var ss = SpreadsheetApp.create("Users and Email Aliases");
  var sheet = ss.getActiveSheet();

  // Set header row
  sheet.getRange("A1").setValue("User");
  sheet.getRange("B1").setValue("Aliases");

  var pageToken;
  var row = 2;

  do {
    var users = AdminDirectory.Users.list({
      domain: domain,
      maxResults: 100,
      pageToken: pageToken
    });

    if (users.users && users.users.length > 0) {
      users.users.forEach(function(user) {
        // Get email and aliases
        var userEmail = user.primaryEmail;
        var aliases = user.aliases ? user.aliases.join(', ') : 'None';

        // Write data to the sheet
        sheet.getRange(row, 1).setValue(userEmail);
        sheet.getRange(row, 2).setValue(aliases);

        row++;
      });
    }

    pageToken = users.nextPageToken;
  } while (pageToken);
}
