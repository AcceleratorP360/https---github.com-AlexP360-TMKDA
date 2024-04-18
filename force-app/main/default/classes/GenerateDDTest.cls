@isTest
public class GenerateDDTest {
    
    @testSetup static void setupTestData() {
        Account acc = new Account();
        acc.Name = 'Test Account';
        insert acc;
        
        // Create test data for P360_Due_Diligence__c object
        P360_Due_Diligence__c testInvoice = new P360_Due_Diligence__c();
            testInvoice.Name = 'Test DD Name';
            testInvoice.P360_CoverHolder_TPA_Name__c = acc.Id;
        insert testInvoice;
        
        // Create test data for P360_DD_Category__c object
        P360_DD_Category__c testCategory = new P360_DD_Category__c();
            testCategory.Name = 'Test Category';
            testCategory.P360_Due_Diligence_Name__c = testInvoice.Id;
        
        insert testCategory;
        
        // Create test data for P360_DD_Sub_Category__c object
        P360_DD_Sub_Category__c testSubCategory = new P360_DD_Sub_Category__c();
            testSubCategory.Name = 'Test Subcategory';
            testSubCategory.P360_Category_Name__c = testCategory.Id;
        insert testSubCategory;
        
        // Create test data for P360_Review_Area__c object
        P360_Review_Area__c testReviewArea = new P360_Review_Area__c();
            testReviewArea.Name = 'Test Review Area';
            testReviewArea.P360_DD_Sub_Category__c = testSubCategory.Id;
        
        insert testReviewArea;
    }
    
    @isTest static void testGenerateDD() {
        Account acc = new Account();
        acc.Name = 'Test Account';
        insert acc;
        
        // Create test data for P360_Due_Diligence__c object
        P360_Due_Diligence__c testInvoice = new P360_Due_Diligence__c();
            testInvoice.Name = 'Test DD Name';
            testInvoice.P360_CoverHolder_TPA_Name__c = acc.Id;
        insert testInvoice;
        
        // Create test data for P360_DD_Category__c object
        P360_DD_Category__c testCategory = new P360_DD_Category__c();
            testCategory.Name = 'Test Category';
            testCategory.P360_Due_Diligence_Name__c = testInvoice.Id;
        
        insert testCategory;
        
        // Create test data for P360_DD_Sub_Category__c object
        P360_DD_Sub_Category__c testSubCategory = new P360_DD_Sub_Category__c();
            testSubCategory.Name = 'Test Subcategory';
            testSubCategory.P360_Category_Name__c = testCategory.Id;
        insert testSubCategory;
        
        // Create test data for P360_Review_Area__c object
        P360_Review_Area__c testReviewArea = new P360_Review_Area__c();
            testReviewArea.Name = 'Test Review Area';
            testReviewArea.P360_DD_Sub_Category__c = testSubCategory.Id;
        
        insert testReviewArea;
        // Get the test invoice record
        //P360_Due_Diligence__c testDD = [SELECT Id FROM P360_Due_Diligence__c WHERE Name = 'Test Invoice' LIMIT 1];
        
        // Create a new standard controller for the test invoice record
        ApexPages.StandardController sc = new ApexPages.StandardController(testInvoice);
        
        // Create a new GenerateDD object and call the constructor
        GenerateDD generateDD = new GenerateDD(sc);
        
        // Verify that the properties were set correctly
        System.assertEquals(testInvoice.Id, generateDD.invoice.Id);
        System.assertEquals(1, generateDD.invoiceLineItemList.size());
        System.assertEquals(1, generateDD.SubCategoryList.size());
        System.assertEquals(1, generateDD.ReviewAreaList.size());
        System.assertNotEquals(null, generateDD.generateddate);
    }
}