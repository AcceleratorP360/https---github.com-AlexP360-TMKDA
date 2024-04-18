@isTest
public class DueDiligenceCloneCtrl_Test {

    @isTest
    public Static void getDueDiligenceRecrd_Test(){
        
        Account acc = new Account();
        acc.Name = 'Test';
        insert acc;
        
        P360_Due_Diligence__c dd = new P360_Due_Diligence__c();
        dd.Name = 'Test';
        dd.P360_CoverHolder_TPA_Name__c = acc.Id;
        insert dd;
        
        P360_DD_Category__c ddCat = new P360_DD_Category__c();
        ddCat.Name = 'Test';
        ddCat.P360_Due_Diligence_Name__c = dd.Id;
        insert ddCat;
        
        P360_DD_Sub_Category__c ddSub = new P360_DD_Sub_Category__c();
        ddSub.Name = 'Test';
        ddSub.P360_Category_Name__c = ddCat.Id;
        insert ddSub;
        
        P360_Review_Area__c ddRew = new P360_Review_Area__c();
        ddRew.Name = 'Test';
        ddRew.P360_DD_Sub_Category__c = ddSub.Id;
        ddRew.P360_Review_Point__c = 'test'; 
        insert ddRew;
        
        DueDiligenceCloneCtrl.getDueDiligenceRecrd(dd.Id);
        DueDiligenceCloneCtrl.cloneRecords(dd.Id, dd.name, system.today(), system.today()+1, acc.Id);
    }
}