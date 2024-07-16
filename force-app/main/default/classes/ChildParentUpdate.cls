public with sharing class ChildParentUpdate {
  // Contact trigger to check Title of each contact and update Account tickerSymbol field with ABC
  public static void updateParent(Map<Id, Contact> value) {

    if(value.values().AccountId != null){
    Set<Id> accIds = new Set<Id>();
    accIds.add(value.values().AccountId);
    
    //? Tried to avoid SOQL to fetch the contacts for size check, but did not work
    //? SOQL is still the slowest part of the trigger, so any help will be appreciated
    //? Please let me know if there is a better way to do this
    // List<Contact> cons = new List<Contact>();
    // for (Contact con : value.values()) {
      //   if(con.AccountId == accIds[0]){  
        //     cons.add(con);
        //   }
        // }
        
        
    List<Contact> contacts = [ SELECT Id, Title, Name, LastName FROM Contact WHERE AccountId IN : accIds ]; //NOPMD
    Account acc = [SELECT Id, TickerSymbol FROM Account WHERE Id = :accIds]; //NOPMD

    //List<Account> acclist = [Select Id, TickerSymbol, (Select Id, Title FROM contacts) FROM Account where ID IN : accIds]; 

     List<Contact> contactData = new List<Contact>();
     List<Account> finalList = new List<Account>();
    for (Contact contact : contacts) {
      if (
        contact.Title != null &&
        contact.Title != '' &&
        contact.Title == 'Hello'
      ) {
        contactData.add(contact);
      }
    }

    // Comparing the size of the account child contacts with the number of contacts list, if they are equal then add ABC to the tickerSymbol
    // else remove ABC from the tickerSymbol
    if (contactData.size() == contacts.size()) {
      acc.TickerSymbol = 'ABC';
      finalList.add(acc);
    } else {
      acc.TickerSymbol = '';
      finalList.add(acc);
    }
    
    if (finalList.size() != 0) {
      update finalList; //NOPMD
    }
  }
  }
}