trigger ProductTrigger on Product__c (before insert, before update) {
    if(Trigger.isBefore){
       if(Trigger.isInsert){
            ProductTriggerHelper.processInsert(Trigger.new);
        }
        if(Trigger.isUpdate){
            ProductTriggerHelper.processUpdate(Trigger.new, Trigger.oldMap);
        }
    }
}