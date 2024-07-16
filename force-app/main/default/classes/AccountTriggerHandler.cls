public with sharing class AccountTriggerHandler {
    public static void createAccounts (List<Account> accList)
     {
         for(Account acc : accList)
         {
             if(acc.ShippingState!=acc.BillingState)
             {
                 acc.ShippingState = acc.BillingState;
             }
         }
     }


     public static void createChildAccount(Map<Id,Account> accMap){
        List<Account> finalList = new List<Account>();

       List<Account> accList = [SELECT Id, Type, ParentId FROM Account where Id IN :accMap.keySet() WITH USER_MODE];
        for(Account acc : accList){
            if(acc.Type == 'Prospect'){
                Account account = new Account();
                account.ParentId = acc.Id;
                account.Type = 'Prospect';
                account.Name = 'Account Created through Trigger'+ acc.Id;
                finalList.add(account);
            }
        }
        if(finalList.size() != 0){
            INSERT as user finalList;
        }
     }

}