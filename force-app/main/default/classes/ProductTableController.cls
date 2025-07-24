public with sharing class ProductTableController {
    @AuraEnabled
    public static List<Product__c> getProducts() {
        return [SELECT Id, Name, ImageURL__c, Description__c, UnitPrice__c, UnitsAvailable__c
            FROM Product__c
            ORDER BY AddedDate__c DESC
        ];
    }

    @AuraEnabled
    public static List<Product__c> createProduct(Product__c newProduct) {
        if (newProduct == null || String.isBlank(newProduct.Name) || newProduct.UnitPrice__c == null || newProduct.UnitPrice__c <= 0) {
            throw new AuraHandledException('Invalid product data: ' + newProduct);
        }
        insert newProduct;
        return getProducts();
    }
}