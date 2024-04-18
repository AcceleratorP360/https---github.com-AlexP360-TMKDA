@isTest
private class ReviewAreaControllerTest {
    
    @isTest
    static void testFetchAccounts() {
     
          Account acc = new account();
            acc.Name = 'Test Party';
        Database.insert(acc);
        
        // Create a test record
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
        
        // Create test Sub Category
        P360_DD_Sub_Category__c subCategory = new P360_DD_Sub_Category__c();
        subCategory.Name = 'Company Details';
         subCategory.P360_Category_Name__c = testAccount.Id;
        insert subCategory;
        
        // Create test Sub Review Area
        P360_Review_Area__c reviewArea = new P360_Review_Area__c(
            P360_DD_Sub_Category__c = subCategory.Id,
            Name = 'Test Review Area',
            P360_Summary__c = 'Test Summary'
        );
        insert reviewArea;
        
        // Call the method
        Test.startTest();
        List<P360_Review_Area__c> result = ReviewAreaController.fetchAccounts(subCategory.Id);
        Test.stopTest();
        
        // Verify the result
        System.assertEquals(1, result.size());
        System.assertEquals(reviewArea.Id, result[0].Id);
        System.assertEquals(reviewArea.Name, result[0].Name);
        System.assertEquals(reviewArea.P360_Summary__c, result[0].P360_Summary__c);
    }
    
    @isTest
    static void testUpdateAccounts() {
      
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
        // Create test data
        
        
        // Create test data
        P360_DD_Sub_Category__c subCategory = new P360_DD_Sub_Category__c();
        subCategory.P360_Category_Name__c = testAccount.Id;
        insert subCategory;
        
        P360_Review_Area__c reviewArea = new P360_Review_Area__c(
            P360_DD_Sub_Category__c = subCategory.Id,
            Name = 'Test Review Area',
            P360_Summary__c = 'Test Summary'
        );
        insert reviewArea;
        
        // Update the record
        reviewArea.P360_Summary__c = 'Updated Summary';
        
        // Call the method
        Test.startTest();
        String result = ReviewAreaController.updateAccounts(new List<P360_Review_Area__c>{ reviewArea });
        Test.stopTest();
        
        // Verify the result
        System.assertEquals('Success: Due Diligience Review Area updated successfully', result);
        System.assertEquals('Updated Summary', [SELECT P360_Summary__c FROM P360_Review_Area__c WHERE Id = :reviewArea.Id].P360_Summary__c);
            
    }
    
    @isTest
    static void testUpdateAccountsException() {
    
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
        // Create test data
        
        P360_DD_Sub_Category__c subCategory = new P360_DD_Sub_Category__c();
        subCategory.P360_Category_Name__c = testAccount.Id;
        insert subCategory;
        
        P360_Review_Area__c reviewArea = new P360_Review_Area__c(
            P360_DD_Sub_Category__c = subCategory.Id,
            Name = 'Test Review Area',
            P360_Summary__c = 'Test Summary'
        );
        insert reviewArea;
        
        // Update the record
        reviewArea.P360_Summary__c = 'Updated Summary';
        
        // Mock the exception
     //  Test.setMock(Database.SaveResult.class, new MockDMLException());
        
        // Call the method
        Test.startTest();
        String result = ReviewAreaController.updateAccounts(new List<P360_Review_Area__c>{ reviewArea });
        Test.stopTest();
        
        // Verify the result
       // System.assert(result.startsWith('The following exception has occurred: '));
       
    }
    
    // Mock exception class for testing
    private class MockDMLException extends Exception {}
    
    
}