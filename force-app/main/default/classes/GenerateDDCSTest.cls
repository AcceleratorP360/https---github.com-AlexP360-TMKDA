@isTest
public class GenerateDDCSTest {

    @isTest
    static void testGenerateDDCS() {
       Id coverHolderRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('P360_Broker').getRecordTypeId();
        Account acc = new Account(Name='Test Account',CurrencyIsoCode = 'GBP',
                                     
                                     RecordTypeId =coverHolderRecordTypeId);
        insert acc;

        // Create test data for P360_Due_Diligence__c object
        P360_Due_Diligence__c testduediligence = new P360_Due_Diligence__c();
        testduediligence.Name = 'Test DD Name';
        testduediligence.P360_CoverHolder_TPA_Name__c = acc.Id;
        insert testduediligence;
		
        P360_DD_Category__c testCat = new 	P360_DD_Category__c();
        testCat.P360_Due_Diligence_Name__c = testduediligence.Id;
        testCat.Name = 'Claims';
        testCat.Status__c = 14;
        
        insert testCat;
        
        
        
        // Create test data for P360_DD_Category__c object
        P360_DA_DD_Categories_Linkage__c testCategory = new P360_DA_DD_Categories_Linkage__c();
        testCategory.Name = 'Test Category';
        testCategory.P360_DA_Linked_Due_Diligence_Name__c = testduediligence.Id;
        
        testCategory.P360_DA_Category_Name__c = testCat.Id;
        testCategory.P360_DA_CA_Linked_Status__c = 'Linked';
        insert testCategory;

        P360_DD_Sub_Category__c testSub = new P360_DD_Sub_Category__c();
        testSub.Name = 'Test Sub';
        testSub.P360_Due_Diligence_Name__c = testduediligence.Id;
        testSub.P360_Category_Name__c = testCat.id;
        insert testSub;  
        
        // Create test data for P360_DD_Sub_Category__c object
        P360_DA_DD_Sub_Category_Linkage__c testSubCategory = new P360_DA_DD_Sub_Category_Linkage__c();
        
        testSubCategory.P360_DA_Sub_Category_Name__c = testSub.Id;
        testSubCategory.P360_DA_Linked_Due_Diligence_Name__c = testduediligence.Id;
        testSubCategory.Name = 'Test Subcategory';
        testSubCategory.P360_DA_DD_Category_Linkage__c = testCategory.Id; // Assigning Id instead of related record
        insert testSubCategory;

        // Create test data for P360_Review_Area__c object
        P360_DA_DD_Review_Area_Linkage__c testReviewArea = new P360_DA_DD_Review_Area_Linkage__c();
        testReviewArea.Name = 'Test Review Area';
        testReviewArea.P360_DA_DD_Sub_Category_Linkage__c = testSubCategory.Id;
        testReviewArea.P360_DA_Linked_Due_Diligence_Name__c = testduediligence.Id ; 
        insert testReviewArea; 
        
        // Create a new standard controller for the testDueDiligence record
        ApexPages.StandardController sc = new ApexPages.StandardController(testduediligence);

        // Create a new GenerateDD object and call the constructor within a test method
        Test.startTest();
        GenerateDDCS generateDDCS = new GenerateDDCS(sc);
        // Perform further testing or assertions if needed
        Test.stopTest();
    }
}