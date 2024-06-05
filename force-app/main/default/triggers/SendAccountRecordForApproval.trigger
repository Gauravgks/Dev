trigger SendAccountRecordForApproval on Account (before update) {
    
    if(trigger.isBefore && trigger.isUpdate){
        List<Id> accIds = new List<Id>();
        for(Account acc : trigger.New){
            if(acc.Send_for_Approval__c == true){
                accIds.add(acc.Id);
            }
        }
        if(accIds.size() != Null){
          Recordlock.lock(accIds);
        }
    }

}