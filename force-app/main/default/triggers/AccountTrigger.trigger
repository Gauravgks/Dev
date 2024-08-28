trigger AccountTrigger on Account (before insert, after insert) {
    if (Trigger.isBefore && Trigger.isInsert) {
        AccountTriggerHandler.CreateAccounts(Trigger.new);
    }

    if(Trigger.isAfter && Trigger.isInsert){
        AccountTriggerHandler.CreateChildAccount(Trigger.newMap);
        AccountTriggerHandler.createUser(Trigger.newMap);
    }

}