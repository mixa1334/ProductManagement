/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an org are executed whenever Apex code is deployed
 * to a production org to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production org. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the org size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class TestProductApplication {
    static final String LONG_DESCRIPTION = 'abc123-abc123-abc123-abc123-abc123-abc123-abc123-abc123-abc123-abc123-abc123-abc123-abc123-abc123-abc123-abc123-abc123-abc123-abc123-abc123-abc123-abc123-abc123-abc123-abc123-abc123-abc123-abc123-abc123-abc123-abc123-abc123-abc123-abc123-abc123-abc123-abc1';

    @TestSetup
    static void insertData(){
        List<Product__c> testData = new List<Product__c>();
        testData.add(createProduct('Product_1', 'image_1', 'description_1', 1, 2, Date.newInstance(2025, 7, 25)));
        testData.add(createProduct('Product_2', 'image_2', 'description_2', 2, 2, Date.newInstance(2025, 7, 26)));
        testData.add(createProduct('Product_3', 'image_3', 'description_3', 3, 6, Date.newInstance(2025, 7, 27)));
        insert testData;
    }

    static Product__c createProduct(String name, String image, String description, Integer price, Integer available, Datetime addedDate){
        return new Product__c(
            Name = name,
            ImageURL__c = image,
            Description__c = description,
            UnitPrice__c = price,
            UnitsAvailable__c = available,
            AddedDate__c = addedDate
        );
    }

    @isTest
    static void test_positive_ProductTrigger_dateInsertion_insert() {
        Product__c product = createProduct('name', 'image', 'description', 6, 45, null);

        Test.startTest();
        insert product;
        Test.stopTest();

        Assert.areEqual(Date.today(), [SELECT AddedDate__c FROM Product__c WHERE Id = :product.Id].AddedDate__c.date());
    }

    @isTest
    static void test_positive_ProduceTrigger_dateInsertion_batchInsert(){
        List<Product__c> data = new List<Product__c>();
        data.add(createProduct('Product_5', 'image_1', 'description_1', 1, 2, null));
        Datetime expectedDate = Datetime.newInstance(2024, 12, 10, 12, 0, 0);
        data.add(createProduct('Product_6', 'image_2', 'description_2', 2, 2, expectedDate));
        

        Test.startTest();
        insert data;
        Test.stopTest();

        Assert.isNotNull([SELECT AddedDate__c FROM Product__c WHERE Name = 'Product_5'].AddedDate__c.date());
        Assert.areEqual(expectedDate.date(), [SELECT AddedDate__c FROM Product__c WHERE Name = 'Product_6'].AddedDate__c.date());
    }

    @isTest
    static void test_positive_ProductTrigger_dateInsertion_update() {
        Product__c product = [SELECT Id, AddedDate__c FROM Product__c WHERE Name = 'Product_1'];
        product.AddedDate__c = null;
        
        Test.startTest();
        update product;
        Test.stopTest();

        Assert.isNull([SELECT AddedDate__c FROM Product__c WHERE Id = :product.Id].AddedDate__c);
    }

    @isTest
    static void test_positive_ProductTrigger_dateInsertion_batchUpdate() {
        List<Product__c> products = [SELECT Id, AddedDate__c FROM Product__c];
        for(Product__c p : products){
            p.AddedDate__c = null;
        }
        
        Test.startTest();
        update products;
        Test.stopTest();

        for(Product__c p : [SELECT AddedDate__c FROM Product__c]){
            Assert.isNull(p.AddedDate__c);
        }
    }

    @isTest
    static void test_positive_ProductTrigger_descriptionReduction_insert(){
        Product__c product = createProduct('Product_1', 'image_1', LONG_DESCRIPTION, 1, 2, null);

        Test.startTest();
        insert product;
        Test.stopTest();

        String actualDesc = [SELECT Description__c FROM Product__c WHERE Id = :product.Id].Description__c;
        Assert.areNotEqual(LONG_DESCRIPTION, actualDesc);
        Assert.areEqual(200, actualDesc.length());
    }

    @isTest
    static void test_positive_ProductTrigger_descriptionReduction_update(){
        Product__c product =  [SELECT Id, Description__c FROM Product__c WHERE Name = 'Product_1'];
        product.Description__c = LONG_DESCRIPTION;

        Test.startTest();
        update product;
        Test.stopTest();

        String actualDesc = [SELECT Description__c FROM Product__c WHERE Id = :product.Id].Description__c;
        Assert.areNotEqual(LONG_DESCRIPTION, actualDesc);
        Assert.areEqual(200, actualDesc.length());
    }

    @isTest
    static void test_positive_ProductTrigger_descriptionReduction_insertBatch(){
        List<Product__c> products = new List<Product__c>();
        for(Integer i = 0; i < 5; i++){
            products.add(createProduct('Product_' + i, 'image_1', LONG_DESCRIPTION, 1, 2, null));
        }

        Test.startTest();
        insert products;
        Test.stopTest();

        for(Product__c p : products){
            String actualDesc = [SELECT Description__c FROM Product__c WHERE Id = :p.Id].Description__c;
            Assert.areNotEqual(LONG_DESCRIPTION, actualDesc);
            Assert.areEqual(200, actualDesc.length());
        }
    }

    @isTest
    static void test_positive_ProductTrigger_descriptionReduction_updateBatch(){
        List<Product__c> products =  [SELECT Id, Description__c FROM Product__c];
        for(Product__c p : products){
            p.Description__c = LONG_DESCRIPTION;
        }

        Test.startTest();
        update products;
        Test.stopTest();

        for(Product__c p : [SELECT Description__c FROM Product__c]){
            String actualDesc = p.Description__c;
            Assert.areNotEqual(LONG_DESCRIPTION, actualDesc);
            Assert.areEqual(200, actualDesc.length());
        }
    }

    @isTest
    static void test_ProductTableController_createProduct_valid() {
        Product__c product = createProduct('Product_1', 'image_1', LONG_DESCRIPTION, 1, 2, null);

        Test.startTest();
        Product__c result = ProductTableController.createProduct(product);
        Test.stopTest();

        Assert.areNotEqual(null, result);
        Assert.areNotEqual(null, result.Id);
        Assert.areEqual('Product_1', result.Name);
        Assert.areEqual(1, result.UnitPrice__c);
    }

    @isTest
    static void test_ProductTableController_createProduct_null() {
        Test.startTest();
        try {
            ProductTableController.createProduct(null);
            Assert.isTrue(false, 'null save!');
        } catch (AuraHandledException e) {
            Assert.isNotNull(e.getMessage());
        } finally{
            Test.stopTest();
        }
    }

    @isTest
    static void test_ProductTableController_createProduct_blankName() {
        Product__c product = new Product__c(Name = '', UnitPrice__c = 100);

        Test.startTest();
        try {
            ProductTableController.createProduct(product);
            Assert.isTrue(false, 'invalid data save!');
        } catch (AuraHandledException e) {
            Assert.isNotNull(e.getMessage());
        } finally{
            Test.stopTest();
        }
    }

    @isTest
    static void test_ProductTableController_createProduct_nullPrice() {
        Product__c product = new Product__c(Name = 'no price');

        Test.startTest();
        try {
            ProductTableController.createProduct(product);
            Assert.isTrue(false, 'invalid data save!');
        } catch (AuraHandledException e) {
            Assert.isNotNull(e.getMessage());
        } finally{
            Test.stopTest();
        }
    }

    @isTest
    static void test_ProductTableController_createProduct_negativePrice() {
        Product__c product = new Product__c(Name = 'negative price', UnitPrice__c = -100);

        Test.startTest();
        try {
            ProductTableController.createProduct(product);
            Assert.isTrue(false, 'invalid data save!');
        } catch (AuraHandledException e) {
            Assert.isNotNull(e.getMessage());
        } finally{
            Test.stopTest();
        }
    }

    @isTest
    static void test_ProductTableController_getProducts(){
        Test.startTest();
        List<Product__c> products = ProductTableController.getProducts();
        Test.stopTest();

        Assert.isNotNull(products);
        Assert.areEqual(3, products.size());
        Assert.areEqual('Product_3', products.get(0).Name);
    }

}