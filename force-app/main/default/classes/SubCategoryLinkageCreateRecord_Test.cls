@isTest
public class SubCategoryLinkageCreateRecord_Test {
    @isTest
    public static void createRecord(){
        //Create Account and Due Diligence record
       Id coverHolderRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('P360_Coverholder').getRecordTypeId();
       Account accRec = new Account(Name='Test Account',CurrencyIsoCode = 'GBP',RecordTypeId =coverHolderRecordTypeId);
       insert accRec;
       P360_Due_Diligence__c dueDiligenceRec = new P360_Due_Diligence__c(P360_CoverHolder_TPA_Name__c=accRec.Id,Name='Test Due Diligence');
       insert dueDiligenceRec;
        // Create a test P360_DD_Category__c record
        P360_DD_Category__c testCategory = new P360_DD_Category__c(
        P360_Due_Diligence_Name__c = dueDiligenceRec.id,Name = 'Test claim');
        insert testCategory;
         // Create a test P360_DD_Sub_Category__c record
         P360_DD_Sub_Category__c testSubcategory = new P360_DD_Sub_Category__c(
             P360_Due_Diligence_Name__c = dueDiligenceRec.id,P360_Category_Name__c =testCategory.id,Name ='Test Conflict of Interest'
         );
        insert testSubcategory;
        
        // Call the createRecord method with the test record
        List<P360_DD_Sub_Category__c> testSubcategories = new List<P360_DD_Sub_Category__c>();
        testSubcategories.add(testSubcategory);
        Test.startTest();
        SubCategoryLinkageCreateRecord.createRecord(testSubcategories);
        Test.stopTest();
        
         // Verify that a P360_DA_DD_Review_Area_Linkage__c record is created
        List<P360_DA_DD_Sub_Category_Linkage__c> createdLinkages = [SELECT Id FROM P360_DA_DD_Sub_Category_Linkage__c WHERE P360_DA_Sub_Category_Name__c = :testSubcategory.Id];
        System.assertNotEquals(0, createdLinkages.size(), 'No linkage record created');
    }
}