@isTest
public class ConnectDDToPrimary_ConnectHelper_Test {
    
    @testSetup
    public Static void setupMethod(){
        
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
        
        
        P360_Due_Diligence__c ddPrimary = new P360_Due_Diligence__c();
        ddPrimary.Name = 'TestPrimary';
        ddPrimary.P360_CoverHolder_TPA_Name__c = testAccount.Id;
        insert ddPrimary;
        
        P360_DA_DD_Category_Master__c catMaster = new P360_DA_DD_Category_Master__c();
        catMaster.Name = 'Test';
        catMaster.P360_DA_CA_Active__c = 'Yes';
        catMaster.P360_DA_Category_Name__c = 'Test';
        insert catMaster;
        
        List<P360_DD_Category__c> catList = new List<P360_DD_Category__c>();
        P360_DD_Category__c ddCatPrimaryLinked = new P360_DD_Category__c();
        ddCatPrimaryLinked.Name = 'Linked';
        ddCatPrimaryLinked.P360_Due_Diligence_Name__c = ddPrimary.Id;
        ddCatPrimaryLinked.P360_DA_Category_ID__c = catMaster.Id;
        catList.add(ddCatPrimaryLinked);
        
        P360_DD_Category__c ddCatPrimaryCopied = new P360_DD_Category__c();
        ddCatPrimaryCopied.Name = 'Copied';
        ddCatPrimaryCopied.P360_Due_Diligence_Name__c = ddPrimary.Id;
        ddCatPrimaryCopied.P360_DA_Category_ID__c = catMaster.Id;
        catList.add(ddCatPrimaryCopied);
        
        insert catList;
        
        List<P360_DD_Sub_Category__c> ddSubCatList = new List<P360_DD_Sub_Category__c>();
        P360_DD_Sub_Category__c ddSub = new P360_DD_Sub_Category__c();
        ddSub.Name = 'Linked';
        ddSub.P360_Category_Name__c = ddCatPrimaryLinked.Id;
        ddSubCatList.add(ddSub);
        
        P360_DD_Sub_Category__c ddSubCopied = new P360_DD_Sub_Category__c();
        ddSubCopied.Name = 'Copied';
        ddSubCopied.P360_Category_Name__c = ddCatPrimaryCopied.Id;
        ddSubCatList.add(ddSubCopied);
        
        insert ddSubCatList;
        
        List< P360_Review_Area__c > reviewList = new List< P360_Review_Area__c >(); 
        P360_Review_Area__c ddRew = new P360_Review_Area__c();
        ddRew.Name = 'Linked';
        ddRew.P360_DD_Sub_Category__c = ddSub.Id;
        ddRew.P360_Review_Point__c = 'test'; 
        reviewList.add(ddRew);
        
        P360_Review_Area__c ddRewCopied = new P360_Review_Area__c();
        ddRewCopied.Name = 'Copied';
        ddRewCopied.P360_DD_Sub_Category__c = ddSubCopied.Id;
        ddRewCopied.P360_Review_Point__c = 'test'; 
        reviewList.add(ddRewCopied);
        
        insert reviewList;
        
        P360_Due_Diligence__c dd = new P360_Due_Diligence__c();
        dd.Name = 'Test';
        dd.P360_CoverHolder_TPA_Name__c = acc.Id;
        insert dd;
        
        P360_DD_Category__c ddCat = new P360_DD_Category__c();
        ddCat.Name = 'Test';
        ddCat.P360_Due_Diligence_Name__c = dd.Id;
        ddCat.P360_DA_Category_ID__c = catMaster.Id;
        insert ddCat;
        
    }
    
    @isTest
    public Static void getConnectedCatgory_records_Test(){
        
        List<P360_DD_Category__c> catRecrdList = [ SELECT Id, P360_Due_Diligence_Name__c FROM P360_DD_Category__c WHERE P360_Due_Diligence_Name__r.P360_CoverHolder_TPA_Name__r.P360_Connection_Type__c = 'Primary' ];        
        List<P360_DD_Sub_Category__c> subCatList = [ SELECT Id, P360_Due_Diligence_Name__c FROM P360_DD_Sub_Category__c WHERE P360_Due_Diligence_Name__r.P360_CoverHolder_TPA_Name__r.P360_Connection_Type__c = 'Primary' ];
        List<P360_Review_Area__c> subReviewList = [ SELECT Id, Due_Diligence__c FROM P360_Review_Area__c WHERE P360_CoverHolder_Name__r.P360_Connection_Type__c = 'Primary' ];
        
        Map<Id, String> primaryMap = new Map<Id, String>();
        primaryMap.put(catRecrdList[0].Id, 'Linked');   
        
        Map<Id, String> primarySubMap = new Map<Id, String>();
        primarySubMap.put(subCatList[0].Id, 'Linked');   
        
        Map<Id, String> primaryReviewMap = new Map<Id, String>();
        primaryReviewMap.put(subReviewList[0].Id, 'Linked');   
        
        P360_Due_Diligence__c currentDueDiligence = [ SELECT Id FROM P360_Due_Diligence__c WHERE Name = 'Test' ];
        P360_Due_Diligence__c primaryDueDiligence = [ SELECT Id FROM P360_Due_Diligence__c WHERE Name = 'TestPrimary' ];
        ConnectDDToPrimaryGroup_ConnectHelper.getConnectedCatgory_records(currentDueDiligence.Id, primaryDueDiligence.Id, primaryMap);
        ConnectDDToPrimaryGroup_ConnectHelper.getConnectedSubCatgory_records(currentDueDiligence.Id, primaryDueDiligence.Id, primarySubMap);
        ConnectDDToPrimaryGroup_ConnectHelper.getConnectedReviewArea_records(currentDueDiligence.Id, primaryDueDiligence.Id, primaryReviewMap); 
    }
    
    @isTest
    public Static void getConnectedCatgory_records_Test_Copied(){
        
        List<P360_DD_Category__c> catRecrdList = [ SELECT Id, P360_Due_Diligence_Name__c FROM P360_DD_Category__c WHERE P360_Due_Diligence_Name__r.P360_CoverHolder_TPA_Name__r.P360_Connection_Type__c = 'Primary' ];        
        List<P360_DD_Sub_Category__c> subCatList = [ SELECT Id, P360_Due_Diligence_Name__c FROM P360_DD_Sub_Category__c WHERE P360_Due_Diligence_Name__r.P360_CoverHolder_TPA_Name__r.P360_Connection_Type__c = 'Primary' ];
        List<P360_Review_Area__c> subReviewList = [ SELECT Id, Due_Diligence__c FROM P360_Review_Area__c WHERE P360_CoverHolder_Name__r.P360_Connection_Type__c = 'Primary' ];
        
        Map<Id, String> primaryMap = new Map<Id, String>();
        primaryMap.put(catRecrdList[1].Id, 'Copied');
        
        Map<Id, String> primarySubMap = new Map<Id, String>();
        primarySubMap.put(subCatList[1].Id, 'Copied');
        
        Map<Id, String> primaryReviewMap = new Map<Id, String>();
        primaryReviewMap.put(subReviewList[1].Id, 'Copied');
        
        P360_Due_Diligence__c currentDueDiligence = [ SELECT Id FROM P360_Due_Diligence__c WHERE Name = 'Test' ];
        P360_Due_Diligence__c primaryDueDiligence = [ SELECT Id FROM P360_Due_Diligence__c WHERE Name = 'TestPrimary' ];
        ConnectDDToPrimaryGroup_ConnectHelper.getConnectedCatgory_records(currentDueDiligence.Id, primaryDueDiligence.Id, primaryMap);
        ConnectDDToPrimaryGroup_ConnectHelper.getConnectedSubCatgory_records(currentDueDiligence.Id, primaryDueDiligence.Id, primarySubMap);
        ConnectDDToPrimaryGroup_ConnectHelper.getConnectedReviewArea_records(currentDueDiligence.Id, primaryDueDiligence.Id, primaryReviewMap);
        
    }
    
    @isTest
    public Static void getConnectedCatgory_records_Test_Create(){
        
        List<P360_DD_Category__c> catRecrdList = [ SELECT Id, P360_Due_Diligence_Name__c FROM P360_DD_Category__c WHERE P360_Due_Diligence_Name__r.P360_CoverHolder_TPA_Name__r.P360_Connection_Type__c = 'Primary' ];        
        List<P360_DD_Sub_Category__c> subCatList = [ SELECT Id, P360_Due_Diligence_Name__c FROM P360_DD_Sub_Category__c WHERE P360_Due_Diligence_Name__r.P360_CoverHolder_TPA_Name__r.P360_Connection_Type__c = 'Primary' ];
        List<P360_Review_Area__c> subReviewList = [ SELECT Id, Due_Diligence__c FROM P360_Review_Area__c WHERE P360_CoverHolder_Name__r.P360_Connection_Type__c = 'Primary' ];
        
        Map<Id, String> primaryMap = new Map<Id, String>();
        primaryMap.put(catRecrdList[1].Id, 'Create');
        
        Map<Id, String> primarySubMap = new Map<Id, String>();
        primarySubMap.put(subCatList[1].Id, 'Create');
        
        Map<Id, String> primaryReviewMap = new Map<Id, String>();
        primaryReviewMap.put(subReviewList[1].Id, 'Create');
        
        P360_Due_Diligence__c currentDueDiligence = [ SELECT Id FROM P360_Due_Diligence__c WHERE Name = 'Test' ];
        P360_Due_Diligence__c primaryDueDiligence = [ SELECT Id FROM P360_Due_Diligence__c WHERE Name = 'TestPrimary' ];
        ConnectDDToPrimaryGroup_ConnectHelper.getConnectedCatgory_records(currentDueDiligence.Id, primaryDueDiligence.Id, primaryMap);
        ConnectDDToPrimaryGroup_ConnectHelper.getConnectedSubCatgory_records(currentDueDiligence.Id, primaryDueDiligence.Id, primarySubMap);
        ConnectDDToPrimaryGroup_ConnectHelper.getConnectedReviewArea_records(currentDueDiligence.Id, primaryDueDiligence.Id, primaryReviewMap);
        
    }
}