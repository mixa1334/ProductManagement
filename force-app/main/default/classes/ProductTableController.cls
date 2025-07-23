public with sharing class ProductTableController {
    @AuraEnabled
    public static List<Product__c> getProducts() {
        return [SELECT Id, Name, ImageURL__c, Description__c, UnitPrice__c, UnitsAvailable__c
            FROM Product__c
            ORDER BY AddedDate__c DESC
        ];
    }
}