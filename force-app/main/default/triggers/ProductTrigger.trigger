trigger ProductTrigger on Product__c (before insert, before update) {
    if(Trigger.isInsert){
        ProductTriggerHelper.processInsert(Trigger.new);
    }else{
        ProductTriggerHelper.processUpdate(Trigger.new);
    }
}