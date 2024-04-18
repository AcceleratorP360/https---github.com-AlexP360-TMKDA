@isTest
public class UpdatecategoryrecordTest {
               
   @isTest
    static void testUpdateCategoryRecords() {
        
        // Create test data for P360_DD_Category__c
        Account testAccount = new Account();
            testAccount.Name = 'Test Account';
        insert testAccount;
        
        P360_Due_Diligence__c dueDiligence = new P360_Due_Diligence__c();
            dueDiligence.Name = 'Test Due Diligence';
        dueDiligence.P360_CoverHolder_TPA_Name__c = testAccount.id;
        
        insert dueDiligence;

        

        P360_DD_Category__c testCategory = new P360_DD_Category__c(
            Name = 'Test Category',
            P360_Due_Diligence_Name__c = dueDiligence.Id,
            P360_Coverholder_TPA_Name__c = testAccount.Id
        );

        // Start the test by inserting the test record
        Test.startTest();
        insert testCategory;
        Test.stopTest();

        // Query the updated record
       // P360_DD_Category__c updatedCategory = [SELECT Id, P360_Due_Diligence_Name__c, P360_Coverholder_TPA_Name__c FROM P360_DD_Category__c WHERE Id = :testCategory.Id LIMIT 1];

        // Perform assertions to verify the update
        //System.assertEquals(dueDiligence.Id, updatedCategory.P360_Due_Diligence_Name__c, 'Due Diligence Id not updated correctly');
        //System.assertEquals(testAccount.Id, updatedCategory.P360_Coverholder_TPA_Name__c, 'Account Id not updated correctly');
    }
}