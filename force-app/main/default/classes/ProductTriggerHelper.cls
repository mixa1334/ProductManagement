public with sharing class ProductTriggerHelper {
    public static void process(List<Product__c> products, Boolean isNew) {
        for(Product__c product : products){
            if(isNew && product.AddedDate__c == null){
                product.AddedDate__c = System.now();
            }
            if(product.Description__c.length() > 200){
                product.Description__c = product.Description__c.substring(0, 197) + '...';
            }
        }
    }
}