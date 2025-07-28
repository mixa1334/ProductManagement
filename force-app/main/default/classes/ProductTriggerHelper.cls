public with sharing class ProductTriggerHelper {
    public static void processInsert(List<Product__c> products) {
        for(Product__c product : products){
            if(product.AddedDate__c == null){
                product.AddedDate__c = System.now();
            }
            formatDescription(product);
        }
    }

    public static void processUpdate(List<Product__c> newProducts, Map<Id, Product__c> oldProducts){
        for(Product__c product : newProducts){
            Product__c oldProduct = oldProducts.get(product.Id);
            if(product.Description__c != oldProduct.Description__c){
                formatDescription(product);
            }
        }
    }

    private static void formatDescription(Product__c product){
        String description = product.Description__c;
        if(String.isNotBlank(description) && description.normalizeSpace().length() > 200){
            product.Description__c = description.abbreviate(200);
        }
    }
}