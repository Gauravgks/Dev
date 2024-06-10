trigger AccountTrigger on Account (before insert, after insert) {
    if (Trigger.isBefore && Trigger.isInsert) {
        AccountTriggerHandler.createAccounts(Trigger.new);
    }

    if(Trigger.isAfter && Trigger.isInsert){
        AccountTriggerHandler.createChildAccount(Trigger.newMap);
    }
}