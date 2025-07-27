public with sharing class ProductTriggerHelper {
    public static void processInsert(List<Product__c> products) {
        for(Product__c product : products){
            if(product.AddedDate__c == null){
                product.AddedDate__c = System.now();
            }
            formatDescription(product);
        }
    }

    public static void processUpdate(List<Product__c> products){
        for(Product__c product : products){
            formatDescription(product);
        }
    }

    private static void formatDescription(Product__c product){
        String description = product.Description__c;
        if(String.isNotBlank(description)){
            product.Description__c = description.normalizeSpace().abbreviate(200);
        }
    }
}