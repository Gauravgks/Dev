@isTest
private class AccountTriggerHandlerTest {
  @isTest
  public static void createUserTest() {
    List<Account> accList = new List<Account>();
    User testUser = [
      SELECT Id
      FROM User
      WHERE Email = 'g.gaurav@salesforce.com'
      WITH USER_MODE
      LIMIT 1
    ];
    System.runAs(testUser) {
      for (Integer i = 0; i < 10; i++) {
        Account acc = new Account();
        acc.Name = 'test' + i;
        acc.Account_User_Email__c = 'g.gaurav@salesforce.com';
        accList.add(acc);
      }
      insert accList;
    }

    test.startTest();
    Map<Id, Account> accMap = new Map<Id, Account>(
      [
        SELECT Id, name, Account_User_Email__c
        FROM Account
        WHERE Name IN :accList AND Account_User_Email__c != NULL
        WITH USER_MODE
      ]
    );
    AccountTriggerHandler.createUser(accMap);
    test.stopTest();
    List<User> userList = [
      SELECT Id, Name
      FROM User
      WHERE Name IN :accList
      WITH USER_MODE
    ];
    System.assertEquals(accList.size(), userList.size());
  }
}
