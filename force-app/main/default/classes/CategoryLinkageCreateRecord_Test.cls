@isTest
public class CategoryLinkageCreateRecord_Test {
  @isTest
   public static void testHandleAfterInsert() {
         
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

        // Call the handleAfterInsert method with the test record
        List<P360_DD_Category__c> testCategories = new List<P360_DD_Category__c>();
        testCategories.add(testCategory);
        Test.startTest();
        CategoryLinkageCreateRecord.handleAfterInsert(testCategories);
        Test.stopTest();

        // Verify that a P360_DA_DD_Categories_Linkage__c record is created
        List<P360_DA_DD_Categories_Linkage__c> createdLinkages = [SELECT Id FROM P360_DA_DD_Categories_Linkage__c WHERE P360_DA_Category_Name__c = :testCategory.Id];
        System.assertNotEquals(0, createdLinkages.size(), 'No linkage record created');
    }
}