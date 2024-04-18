@isTest
public class UpdateparentvalueonPRA_Test {
    
    @isTest
    static void testUpdatePRARecords() {
        
        // Create test data for P360_Actions__c
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
        
        P360_Actions__c testPRA = new P360_Actions__c();
            //testPRA.Name = 'Test PRA';
            testPRA.P360_Category_Due_Diligence__c=testCategory.Id;
            testPRA.Due_Diligence__c = dueDiligence.Id;
            testPRA.Party__c = testAccount.Id;
        

        // Start the test by inserting the test record
        Test.startTest();
        insert testPRA;
        Test.stopTest();

    }

}