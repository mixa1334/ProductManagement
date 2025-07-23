trigger ProductTrigger on Product__c (before insert, before update) {
    ProductTriggerHelper.process(Trigger.new, Trigger.isInsert);
}