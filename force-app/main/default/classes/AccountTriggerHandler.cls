public with sharing class AccountTriggerHandler {
  public static void createAccounts(List<Account> accList) {
    for (Account acc : accList) {
      if (acc.ShippingState != acc.BillingState) {
        acc.ShippingState = acc.BillingState;
      }
    }
  }

  public static void createChildAccount(Map<Id, Account> accMap) {
    List<Account> finalList = new List<Account>();

    //List<Account> accList = [SELECT Id, Type, ParentId FROM Account where Id IN :accMap.keySet() WITH USER_MODE];
    List<Account> accList = accMap.values();

    for (Account acc : accList) {
      if (acc.Type == 'Prospect') {
        Account account = new Account();
        account.ParentId = acc.Id;
        account.Name = 'Account Created through Trigger' + acc.Id;
        finalList.add(account);
      }
    }
    if (finalList.size() != 0) {
      insert as user finalList;
    }
  }

  public static void createUser(Map<Id, Account> accMap) {
    Set<Id> accListId = accMap.keySet();
    //     AccountTriggerHandler.createUserFuture(accListId);
    // }

    // @future
    // public static void createUserFuture(Set<Id> accListId){

    //List<Account> accValue = [Select Id, name from Account where Id IN :accListId WITH User_Mode];
    List<Account> accValue = accMap.values();
    Profile p = [
      SELECT Id, Name
      FROM Profile
      WHERE Name = 'Chatter Free User'
      WITH User_Mode
    ];
    List<User> userList = new List<User>();
    for (Account acc : accValue) {
      if (acc.Account_User_Email__c != null) {
        user u = new User();
        u.LastName = acc.Name;
        u.Alias = 'trig';
        u.Email = acc.Account_User_Email__c;
        u.UserName = acc.name + acc.Id + '@triggeruser.com';
        u.ProfileId = p.Id;
        u.CommunityNickname = acc.Name;
        u.LanguageLocaleKey = 'en_US';
        u.TimeZoneSidKey = 'Asia/Colombo';
        u.LocaleSidKey = 'en_US';
        u.EmailEncodingKey = 'UTF-8';

        userList.add(u);
      } else {
        acc.addError('Check for Unique Fields to Create a User');
      }
    }

    if (userList.size() != 0) {
      Request reqInfo = Request.getCurrent();
      String currentRequestId = reqInfo.getRequestId();
      system.debug('Req ID' + currentRequestId);
      insert as user userList;
    }
  }
}
