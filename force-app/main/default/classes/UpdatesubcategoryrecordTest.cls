@isTest
public class UpdatesubcategoryrecordTest {
    
    @isTest
    static void testUpdatesubCategoryRecords() {
        
        // Create test data for P360_DD_Category__c
        Account testAccount = new Account();
            testAccount.Name = 'Test Account';
        insert testAccount;
        
        P360_Due_Diligence__c dueDiligence = new P360_Due_Diligence__c();
            dueDiligence.Name = 'Test Due Diligence';
        dueDiligence.P360_CoverHolder_TPA_Name__c = testAccount.id;
        
        insert dueDiligence;

        P360_DD_Category__c testCategory = new P360_DD_Category__c();
            testCategory.Name = 'Test Category';
            testCategory.P360_Due_Diligence_Name__c = dueDiligence.Id;
            testCategory.P360_Coverholder_TPA_Name__c = testAccount.Id;
        insert testCategory;
        
        P360_DD_Sub_Category__c testsubCategory = new P360_DD_Sub_Category__c();
            testsubCategory.Name = 'Test subCategory';
            testsubCategory.P360_Category_Name__c=testCategory.Id;
            testsubCategory.P360_Due_Diligence_Name__c = dueDiligence.Id;
            testsubCategory.P360_Coverholder_TPA_Name__c = testAccount.Id;
        

        // Start the test by inserting the test record
        Test.startTest();
        insert testsubCategory;
        Test.stopTest();

    }
}