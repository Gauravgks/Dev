public with sharing class ChildParentUpdate {
  // Contact trigger to check Title of each contact and update Account tickerSymbol field with ABC
  public static void updateParent(Map<Id, Contact> value) {
    // for loop to read the data
    // Error: Line: 11, Column: 1
    //System.DmlException: Insert failed. First exception on row 0; first error: CANNOT_INSERT_UPDATE_ACTIVATE_ENTITY, ContactTrigger: execution of AfterInsert caused by: //System.QueryException: List has more than 1 row for assignment to SObject Class.ChildParentUpdate.updateParent: line 4, column 1 Trigger.ContactTrigger: line 3, column 1: []

    if (value.values().AccountId != null) {
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

      List<Contact> contacts = [
        SELECT Id, Title, Name, LastName
        FROM Contact
        WHERE AccountId IN :accIds
      ]; //NOPMD
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

  // Contact trigger to add contact name in Account Description field (Parent + Child SOQL to update the field. Not Optimized)
  // It's working as expected.
  public static void addChild(List<Contact> value) {
    Set<Id> accIds = new Set<Id>();
    for (Contact con : value) {
      accIds.add(con.AccountId);
    }

    List<Account> accValues = [
      SELECT id, description, (SELECT id, name FROM contacts)
      FROM Account
      WHERE id IN :accIds
    ]; //NOPMD

    for (Account acc : accValues) {
      for (Contact con : acc.contacts) {
        if (con.Name != null) {
          acc.Description = acc.Description + con.Name + ' ';
        }
      }
    }
    update accValues; //NOPMD
  }

  // Trying to implement a optimized code using Map. Above code is working fine with SOQL of parent+child
  public static void addChild2(Map<Id, Contact> value) {
    // Prepare a MAP to store the related contacts for each accountId
    Map<Id, List<String>> accConMap = new Map<Id, List<String>>();

    //Populate the map with accId and contact associated with each other
    for (Contact con : value.values()) {
      if (!accConMap.containsKey(con.AccountId)) {
        accConMap.put(con.AccountId, new List<String>());
      }
      accConMap.get(con.AccountId).add(con.LastName);
    }

    List<Account> accList = [
      SELECT Id, Description
      FROM AccoUnt
      WHERE Id IN :accConMap.keySet()
      WITH USER_MODE
    ];
    for (Account acc : accList) {
      List<String> stringList = accConMap.get(acc.Id);
      if (acc.Description != null) {
        acc.Description = acc.Description + stringList;
      } else {
        acc.Description = String.join(stringList, '');
      }
    }

    update accList; //NOPMD
  }
}