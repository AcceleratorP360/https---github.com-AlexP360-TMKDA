@isTest
public class ConnectDDToPrimaryGroup_Controller_Test {

    
    public static testMethod void handler(){
        
       Id coverHolderRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('P360_Broker').getRecordTypeId();
       Account accRec = new Account(Name='Test Account',CurrencyIsoCode = 'GBP',
                                    
                                    RecordTypeId =coverHolderRecordTypeId);
       insert accRec;
        
        Account testAccount = new Account(
        Name = 'Sample Test Coverholder Primary',
        P360_Syndicate_Number__c ='TS12',
            P360_Connection_Type__c	= 'Primary',
        P360_Europe_Syndicate_Number__c = 'TA12',
        P360_Sponsoring_Service_Provider_MGA__c=accRec.Id,
        P360_Lloyd_PIN__c ='WA1234567');
        insert testAccount;
        
        Account acc = new Account();
        acc.name = 'Sample Test Coverholder secondary';
        acc.P360_Primary_Connected__c = testAccount.Id;
        acc.RecordTypeId =coverHolderRecordTypeId;
        insert acc;
        
            
        P360_Due_Diligence__c dd= new P360_Due_Diligence__c();
        dd.P360_CoverHolder_TPA_Name__c = testAccount.Id;
        dd.P360_Approval_Status__c = 'Approved';
        insert dd;
        
        P360_Due_Diligence__c dd1= new P360_Due_Diligence__c();
        dd1.P360_CoverHolder_TPA_Name__c = testAccount.Id;
        dd1.P360_Approval_Status__c = 'Approved';
        insert dd1;
        
        P360_DD_Category__c cat = new P360_DD_Category__c();
        cat.P360_Due_Diligence_Name__c = dd.Id;
        cat.P360_Company_Type__c = 'Coverholder';
        cat.Connect_Copy_Options__c = 'Link';
        cat.P360_Summary_Final_Assessment__c ='Test Summary';
        cat.P360_Completion_Marker__c = 'Completed';
        insert cat;
        
        P360_DD_Sub_Category__c scat = new P360_DD_Sub_Category__c();
        scat.P360_Category_Name__c = cat.Id;
        scat.P360_Completion_Marker__c = 'Completed';
        scat.P360_Due_Diligence_Name__c = dd.Id;
        scat.P360_Is_Connection_Enable__c = True;
        scat.P360_Connect_Copy_Options__c = 'Link';
        insert scat;
        
        P360_Review_Area__c rarea = new P360_Review_Area__c();
        rarea.P360_DD_Sub_Category__c = scat.Id;
        rarea.P360_RA_Category__c = cat.Id;
        rarea.Due_Diligence__c = dd.Id;
        rarea.Connect_Copy_Options__c = 'Link';
        rarea.TMKDA_Severity__c = 'High';
        rarea.P360_DD_Scope_of_DD_review__c = 'text area';
        rarea.P360_Pass_Fail__c = 'Pass';
        rarea.P360_Comment__c = 'sample comment';
        rarea.TMKDA_Answer__c = 'Yes';
        rarea.P360_Contained_in_Policy__c = 'Yes';
        rarea.P360_Is_Connection_Enable__c = True;
        rarea.P360_Review_Point__c = 'sample review point';
        rarea.P360_Assessment__c = 'Green';
        rarea.P360_Completion_Marker__c = 'Completed';
        insert rarea;
        
        List<ConnectDDToPrimaryGroup_Controller.getRelatedRecordsWrapper> wrapList = new List<ConnectDDToPrimaryGroup_Controller.getRelatedRecordsWrapper>();
        ConnectDDToPrimaryGroup_Controller.getRelatedRecordsWrapper wrapTest = new ConnectDDToPrimaryGroup_Controller.getRelatedRecordsWrapper();
        wrapTest.cat = cat;
        wrapTest.subCatList = new List<P360_DD_Sub_Category__c>{scat};
            wrapTest.reviewAreaList = new List<P360_Review_Area__c>{rarea};
                wrapList.add(wrapTest);
        Test.startTest();
        ConnectDDToPrimaryGroup_Controller.getRelatedRecords(dd.id);
        ConnectDDToPrimaryGroup_Controller.updateParentRecords(wrapList, dd1.Id, dd.Id);
        ConnectDDToPrimaryGroup_Controller.getAllPartyRecords(testAccount.Id);
        Test.stopTest();
    }
}