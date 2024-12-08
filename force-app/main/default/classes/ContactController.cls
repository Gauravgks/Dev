public class ContactController {
  public Contact contact { get; set; }

  public ContactController() {
    // Get the contact record by ID from the URL parameter
    String contactId = ApexPages.currentPage().getParameters().get('id');
    if (contactId != null) {
      contact = [
        SELECT Name, Email, Phone
        FROM Contact
        WHERE Id = :contactId
        LIMIT 1
      ];
    }
  }
}
