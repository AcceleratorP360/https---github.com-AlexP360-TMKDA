@isTest
public class ReviewAreaLinkageCreateRecord_Test {
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
         P360_DD_Sub_Category__c testSubcategory = new P360_DD_Sub_Category__c(P360_Due_Diligence_Name__c = dueDiligenceRec.id,
                                                                               P360_Category_Name__c =testCategory.id,Name ='Test Conflict of Interest');
        insert testSubcategory;
        
        P360_Review_Area__c testReviewArea = new P360_Review_Area__c(Due_Diligence__c = dueDiligenceRec.id,	P360_RA_Category__c =testCategory.id,
                                                                     P360_DD_Sub_Category__c =testSubcategory.id,Name = 'Test Review area');
        insert testReviewArea;
        
        // Call the createRecord method with the test record
        List<P360_Review_Area__c> testReviewAreas = new List<P360_Review_Area__c>();
        testReviewAreas.add(testReviewArea);
        Test.startTest();
        ReviewAreaLinkageCreateRecord.createRecord(testReviewAreas);
        Test.stopTest();
         // Verify that a P360_DA_DD_Review_Area_Linkage__c record is created
        List<P360_DA_DD_Review_Area_Linkage__c> createdLinkages = [SELECT Id FROM P360_DA_DD_Review_Area_Linkage__c WHERE P360_DA_Review_Area_Name__c = :testReviewArea.Id];
        System.assertNotEquals(0, createdLinkages.size(), 'No linkage record created');
        delete testReviewArea;
    }

}