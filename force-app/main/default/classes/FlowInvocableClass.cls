public with sharing class FlowInvocableClass {

    @InvocableMethod(label='Get Account Names' description='Returns the list of account' category='Account')
    public static List<String> invokeMe(List<OtherValue> value){
        List<Id> accountIds = new List<Id>();
        String name = value[0].name;
        String value2 = value.get(0).value2;
        List<Account> accounts = [SELECT Id FROM Account WHERE Name = : name];//NOPMD
        for (Account account : accounts) {
            accountIds.add(account.Id);
        }
        return accountIds;
    }

    public class OtherValue{
        
        @InvocableVariable(Label = 'Account Name' description = 'Account Name')
        public String name;
        @InvocableVariable(Label = 'Value2' description = 'Value2')
        public String value2;
    }
}