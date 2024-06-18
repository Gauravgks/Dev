trigger ContactTrigger on Contact(after insert, after update) { //NOPMD
  
  // Removing the Trigger as it is impacting current testing/implementation (Code is working fine)
  /*if (Trigger.isAfter && (Trigger.isInsert || Trigger.isUpdate)) {
    ChildParentUpdate.updateParent(Trigger.newMap);
  }*/
}