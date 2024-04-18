@IsTest
public class SubcategoryControllerTest {

    @IsTest
    static void testFetchAccounts() {
         try{
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
            
             //Create Test Sub Category
        P360_DD_Sub_Category__c subCategory = new P360_DD_Sub_Category__c();
            subCategory.Name = 'Company Details';
            subCategory.P360_Category_Name__c = testAccount.Id;
        Insert subCategory;
        
        // Call the method being tested
        Test.startTest();
        List<P360_DD_Sub_Category__c> subCategoryList = SubcategoryController.fetchAccounts(testAccount.Id);
        Test.stopTest();

        // Assert that the correct records were returned
        System.assertEquals(1, subCategoryList.size());
        P360_DD_Sub_Category__c returnedSubCategory = subCategoryList[0];
        System.assertEquals(subCategory.Id, returnedSubCategory.Id);
        System.assertEquals(subCategory.Name, returnedSubCategory.Name);
              }catch (AuraHandledException ex) {
            // Assert that the exception was caught and re-thrown
            System.assertEquals('Exception message', ex.getMessage());
        }
    }

    @IsTest
    static void testUpdateRecord() {
        
        //Create Test Account 
        Account acc = new account();
            acc.Name = 'Test Party';
        Database.insert(acc);
        
        // Create a test DD
        P360_Due_Diligence__c testRecord = new P360_Due_Diligence__c();
        testRecord.Name = 'Test Records';
        testRecord.P360_CoverHolder_TPA_Name__c = acc.Id; // Use the Id field of the record
        
        Database.insert(testRecord);
        
        // Create a test Category
        P360_DD_Category__c testAccount = new P360_DD_Category__c();
        testAccount.Name = 'Conduct';
        testAccount.P360_Due_Diligence_Name__c = testRecord.Id;
        testAccount.P360_CoverHolder_TPA_Name__c = acc.Id; // Use the Id field of the record
        Database.insert(testAccount);  
        
        //Create test Sub Category
        P360_DD_Sub_Category__c subCategory = new P360_DD_Sub_Category__c();
            subCategory.P360_Category_Name__c = testAccount.Id;
            subCategory.Name = 'Company Details';
        Insert subCategory;
        
        List<P360_DD_Category__c> categoryList = new List<P360_DD_Category__c>{testAccount};

        // Call the method being tested
        Test.startTest();
        Boolean result = SubcategoryController.updateRecord(categoryList);
        Test.stopTest();

        // Assert that the records were updated successfully
        System.assertEquals(true, result);
        P360_DD_Category__c updatedCategory = [SELECT Id FROM P360_DD_Category__c WHERE Id = :testAccount.Id];
         
    }

    @IsTest
    static void testUpdateRecord_Exception() {
        try{
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
        P360_DD_Sub_Category__c subCategory = new P360_DD_Sub_Category__c();
            subCategory.P360_Category_Name__c = testAccount.Id;
            subCategory.Name = 'Company Details';
        
        Insert subCategory;
          List<P360_DD_Category__c> categoryList = new List<P360_DD_Category__c>{ testAccount };
        // Call the method being tested
        Test.startTest();
        Boolean result = SubcategoryController.updateRecord(categoryList);
        Test.stopTest();

        // Assert that the records were not updated
        System.assertEquals(True, result);
              }catch (AuraHandledException ex) {
            // Assert that the exception was caught and re-thrown
            System.assertEquals('Exception message', ex.getMessage());
        }
    }
        
}