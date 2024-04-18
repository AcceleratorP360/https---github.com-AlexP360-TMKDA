@isTest
public class P360DA_CustomDueDiligenceCtrlTest {
 @isTest   
    public static void getDDRecordsTest(){
        Account acc = new Account();
        acc.Name = 'Testacc';
        acc.P360_Syndicate_Number__c = '2355';
        insert acc;
        
        P360_Due_Diligence__c dueDili = new P360_Due_Diligence__c();
        dueDili.P360_Approval_Status__c = 'Pending';
        dueDili.P360_Due_Diligence_Type__c = 'Annual';
        dueDili.P360_CoverHolder_TPA_Name__c = acc.Id;
        dueDili.p360_Planned_Assessment_Start_Date__c =  System.today() + 1;
        dueDili.P360_DD_Actual_Assessment_End_Date__c =  System.today() + 5;  
        insert dueDili;
        
        P360_DD_Category__c ddCatego1 = new P360_DD_Category__c();
        ddCatego1.Name = 'Test';
        ddCatego1.P360_Due_Diligence_Name__c = dueDili.Id;
        insert ddCatego1;
        
        P360_DA_DD_Categories_Linkage__c ddCatego = new P360_DA_DD_Categories_Linkage__c();
        ddCatego.Name = 'Test1';
        ddCatego.P360_DA_Linked_Due_Diligence_Name__c = dueDili.Id;
        ddCatego.P360_DA_CA_Linked_Status__c = 'Cloned';
        ddCatego.P360_DA_Category_Name__c = ddCatego1.Id;
        insert ddCatego;
        
        P360_DA_DD_Categories_Linkage__c ddCatLinkage = new P360_DA_DD_Categories_Linkage__c();
        ddCatLinkage.Name = 'Test DD Cat Linkage';
        ddCatLinkage.P360_DA_Linked_Due_Diligence_Name__c = dueDili.Id;
        ddCatLinkage.P360_DA_CA_Linked_Status__c = 'Cloned';
        ddCatLinkage.P360_DA_Category_Name__c = ddCatego1.Id;
        insert ddCatLinkage;
        
        P360_DD_Sub_Category__c suCatgo1 = new P360_DD_Sub_Category__c();
        suCatgo1.Name = 'Test Sub';
        suCatgo1.P360_Category_Name__c = ddCatego1.Id;
        insert suCatgo1;
        
        P360_DA_DD_Sub_Category_Linkage__c subCatego = new P360_DA_DD_Sub_Category_Linkage__c();
        subCatego.Name = 'Test Sub Cate';
        subCatego.P360_DA_Linked_Due_Diligence_Name__c = dueDili.Id;
        subCatego.P360_DA_Sub_Category_Name__c = suCatgo1.Id;
        subCatego.P360_DA_DD_Category_Linkage__c = ddCatego.Id;
        insert subCatego;
        
        P360_Review_Area__c reviewArea = new P360_Review_Area__c();
        reviewArea.Name = 'Test Review';
        reviewArea.P360_DD_Sub_Category__c = suCatgo1.Id;
        insert reviewArea;
        
        P360_DA_DD_Review_Area_Linkage__c reAreaLink = new P360_DA_DD_Review_Area_Linkage__c();
        reAreaLink.Name = 'Test Review 1';
        reAreaLink.P360_DA_Linked_Due_Diligence_Name__c = dueDili.Id;
        insert reAreaLink;
        
        P360_Actions__c action = new P360_Actions__c();
        action.P360_Action__c = 'Test Action';
        insert action;
        
        P360_Binder__c binder = new P360_Binder__c();
        binder.Name = 'Test Binder';
        insert binder;
        
        TMKDA_DAMO_PUGC__c demoPugc = new TMKDA_DAMO_PUGC__c();
        demoPugc.Name = 'Test Demo';
        insert demoPugc;
        
        TMKDA_BPA_Summary_Header__c bpasummart = new TMKDA_BPA_Summary_Header__c();
        bpasummart.Name = 'Test Summery';
        insert bpasummart;
        
        TMKDA_Attestation__c attest = new TMKDA_Attestation__c();
       	attest.Name = 'Test Attest';
        insert attest;
        
        P360_Review_Area__c revAre = new P360_Review_Area__c();
        revAre.Name = 'Test Area';
        revAre.P360_DD_Sub_Category__c = suCatgo1.Id;
        insert revAre; 
        
        P360_DA_DD_Review_Area_Linkage__c reviewarea1 = new P360_DA_DD_Review_Area_Linkage__c();
        reviewarea1.Name = 'Test Review';
        reviewarea1.P360_DA_Linked_Due_Diligence_Name__c = dueDili.Id;
        insert reviewarea1;
        
       
        List<P360DA_CustomDueDiligenceCtrl.sectionWithFieldsWrapper> result2 = P360DA_CustomDueDiligenceCtrl.getLayoutMetadata('P360_DD_Category__c');
        List<P360DA_CustomDueDiligenceCtrl.sectionWithFieldsWrapper> result3 = P360DA_CustomDueDiligenceCtrl.getLayoutMetadata('P360_DD_Sub_Category__c');
        List<P360DA_CustomDueDiligenceCtrl.sectionWithFieldsWrapper> result4 = P360DA_CustomDueDiligenceCtrl.getLayoutMetadata('P360_Review_Area__c');
       

        Test.startTest();
        try{
            P360DA_CustomDueDiligenceCtrl.getDDRecords(acc.Id);
        	P360DA_CustomDueDiligenceCtrl.getDDRelatedRecord(dueDili.Id);
        	P360DA_CustomDueDiligenceCtrl.getDDCatRelatedRecord(dueDili.Id,ddCatego.Id);
        	P360DA_CustomDueDiligenceCtrl.getDdSubCatRelatedRecord(dueDili.Id,suCatgo1.Id);
            P360DA_CustomDueDiligenceCtrl.getDDRelatedActionRecord(dueDili.Id);
         	P360DA_CustomDueDiligenceCtrl.getDDRelatedBindersRecord(dueDili.Id);
        	P360DA_CustomDueDiligenceCtrl.getDDRelatedDamoRecord(dueDili.Id);
        	P360DA_CustomDueDiligenceCtrl.getDDRelatedSummaryRecord(dueDili.Id);
        	P360DA_CustomDueDiligenceCtrl.getDDRelatedAttestationsRecord(dueDili.Id);
            P360DA_CustomDueDiligenceCtrl.getDdSubCategoriesLinkage(dueDili.Id,suCatgo1.Id);
        	P360DA_CustomDueDiligenceCtrl.getDdCategoriesLinkage(dueDili.Id,ddCatego1.Id);
         	P360DA_CustomDueDiligenceCtrl.getReviewLinkage(dueDili.Id,revAre.Id);
            P360DA_CustomDueDiligenceCtrl.getRecordsName(dueDili.Id);
            P360DA_CustomDueDiligenceCtrl.getDueDiligenceRecord(acc.Id);
            List<P360DA_CustomDueDiligenceCtrl.sectionWithFieldsWrapper> result = P360DA_CustomDueDiligenceCtrl.getLayoutMetadata('P360_Due_Diligence__c');

        }catch(Exception ex){
            return;
        }
        
         try{
            P360DA_CustomDueDiligenceCtrl.getDDRecords(null);
        	P360DA_CustomDueDiligenceCtrl.getDDRelatedRecord(null);
        	P360DA_CustomDueDiligenceCtrl.getDDCatRelatedRecord(null,null);
        	P360DA_CustomDueDiligenceCtrl.getDdSubCatRelatedRecord(null,null);
            P360DA_CustomDueDiligenceCtrl.getDDRelatedActionRecord(null);
         	P360DA_CustomDueDiligenceCtrl.getDDRelatedBindersRecord(null);
        	P360DA_CustomDueDiligenceCtrl.getDDRelatedDamoRecord(null);
        	P360DA_CustomDueDiligenceCtrl.getDDRelatedSummaryRecord(null);
        	P360DA_CustomDueDiligenceCtrl.getDDRelatedAttestationsRecord(null);
            P360DA_CustomDueDiligenceCtrl.getDdSubCategoriesLinkage(null,null);
        	P360DA_CustomDueDiligenceCtrl.getDdCategoriesLinkage(null,null);
         	P360DA_CustomDueDiligenceCtrl.getReviewLinkage(null,null);
            P360DA_CustomDueDiligenceCtrl.getRecordsName(null);
            P360DA_CustomDueDiligenceCtrl.getDueDiligenceRecord(acc.Id);
           
				
        }catch(Exception ex){
            return;
        }
         
        Test.stopTest();
    } 
    
    

}