public class AccountController {
  public Account account { get; set; }

  public AccountController() {
    String accId = ApexPages.currentPage().getParameters().get('accId');
    if (accId != null) {
      account = [
        SELECT Id, Name, Industry, Type
        FROM Account
        WHERE Id = :accId
        LIMIT 1
      ];
    } else {
      account = new Account(); // Empty account if no accId provided
    }
  }
}
