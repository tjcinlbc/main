//This script lists all groups and their members in a tenant-wide scope and create a new Google Sheet containing the information (if the user is a Super Admin).

function listGroupsAndMembersTenantWide() {
  var sheet = SpreadsheetApp.create("Tenant-wide Group Members List");
  var groupsSheet = sheet.getActiveSheet();
  groupsSheet.appendRow(["Group", "Members"]);

  // Fetch all groups (no domain specified, tenant-wide if Super Admin)
  var pageToken, page;
  do {
    page = AdminDirectory.Groups.list({
      customer: "my_customer", // "my_customer" indicates the tenant-wide access
      maxResults: 100,  // Adjust maxResults if needed
      pageToken: pageToken
    });

    var groups = page.groups;
    if (groups && groups.length > 0) {
      groups.forEach(function(group) {
        var groupEmail = group.email;
        var members = AdminDirectory.Members.list(groupEmail).members;
        var memberEmails = members ? members.map(function(member) {
          return member.email;
        }).join(", ") : "No members";
        
        groupsSheet.appendRow([groupEmail, memberEmails]);
      });
    }

    pageToken = page.nextPageToken;
  } while (pageToken);

  Logger.log("Tenant-wide groups and members listed successfully.");
}
