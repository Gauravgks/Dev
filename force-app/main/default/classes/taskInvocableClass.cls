public with sharing class taskInvocableClass { //NOPMD
  @InvocableMethod(label='Get Task RecordId' description='Returns the task ID')
  public static void taskFlow(List<taskValue> value) {
    List<Id> taskIds = new List<Id>();
    String Id = value[0].Id; //NOPMD
    System.debug('Task Record ID' + Id);
    taskInvocableClass.sendTaskRecordToLwc(Id);
  }

  public class taskValue { //NOPMD
    @InvocableVariable(Label='Task ID' description='Task ID')
    public String Id; //NOPMD
  }

  @AuraEnabled(Cacheable=true)
  public static string sendTaskRecordToLwc(String Id) {
    //NOPMD
    try {
      system.debug('#######ID' + Id);
      return Id;
    } catch (Exception e) {
      throw new AuraHandledException(e.getMessage());
    }
  }
}
// This class is not used anywhere. I'm using platform event to achieve the desired functionality. I'm keeping this the class just in case if I have to make some changes in the future.