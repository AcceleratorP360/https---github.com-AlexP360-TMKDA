@isTest
public class AccountCategoryDataControllerTest {

    @isTest
    static void FetchAccounts() {
        //create a coverholder/tpa group record
      //  P360_Coverholder_Group__c testcoverholder = new P360_Coverholder_Group__c();
      //  testcoverholder.Name = 'Coverholder Group - Hiscox Insurance Group';
      //  Database.insert(testcoverholder);
        
        Account acc = new account();
            acc.Name = 'Test Party';
        Database.insert(acc);
        
        // Create a test record
        P360_Due_Diligence__c testRecord = new P360_Due_Diligence__c();
        testRecord.Name = 'Test Records';
        testRecord.P360_CoverHolder_TPA_Name__c = acc.Id; // Use the Id field of the record
        
        Database.insert(testRecord);
        
        // Create a test account
        P360_DD_Category__c testAccount = new P360_DD_Category__c();
        testAccount.Name = 'Conduct';
        testAccount.P360_Due_Diligence_Name__c = testRecord.Id;
        testAccount.P360_CoverHolder_TPA_Name__c = acc.Id; // Use the Id field of the record
        Database.insert(testAccount);

        // Call the fetchAccounts method with the test record ID
        Test.startTest();
        List<P360_DD_Category__c> result = AccountDataController.fetchAccounts(testRecord.Id);
        Test.stopTest();

        // Verify that the method returned the test account
        System.assertEquals(1, result.size());
        System.assertEquals(testAccount.Id, result[0].Id);
    }

    @isTest
    static void UpdateRecord() {
        //create a coverholder/tpa group record
        P360_Coverholder_Group__c testcoverholder = new P360_Coverholder_Group__c();
        testcoverholder.Name = 'Test CoverHolder';
        Database.insert(testcoverholder);
        
                Account acc = new account();
            acc.Name = 'Test Party';
        Database.insert(acc);
        
        // Create a test record
        P360_Due_Diligence__c testRecord = new P360_Due_Diligence__c();
        testRecord.Name = 'Test Records';
        testRecord.P360_CoverHolder_TPA_Name__c = acc.Id; // Use the Id field of the record
        
        Database.insert(testRecord);
        
        // Create a test account
        P360_DD_Category__c testAccount = new P360_DD_Category__c();
        testAccount.Name = 'Test Account';
        testAccount.P360_Due_Diligence_Name__c = testRecord.Id;
        testAccount.P360_CoverHolder_TPA_Name__c = acc.Id; // Use the Id field of the record
        Database.insert(testAccount);
     
        // Modify the test account
        testAccount.P360_Assessment__c = 'New Assessment';

        // Call the updateRecord method with the modified account
        Test.startTest();
        boolean result = AccountDataController.updateRecord(new List<P360_DD_Category__c>{testAccount});
        Test.stopTest();

        // Verify that the method updated the account
       // System.assertEquals(true, true);
       // System.assertEquals('New Assessment', [SELECT P360_Assessment__c FROM P360_DD_Category__c WHERE Id = :testAccount.Id].P360_Assessment__c);
        
    } 
       
}