public with sharing class AccountTriggerHandler {
    public static void CreateAccounts (List<Account> accList)
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

       List<Account> accList = [SELECT Id FROM Account where Id IN :accMap.keySet() ];
        for(Account acc : accList){
            if(acc.Type == 'Prospect'){
                Account account = new Account();
                account.ParentId = acc.Id;
                account.Name = 'Account Created through Trigger';
                finalList.add(account);
            }
        }
        if(finalList.size() != 0){
            INSERT finalList;
        }
     }

}