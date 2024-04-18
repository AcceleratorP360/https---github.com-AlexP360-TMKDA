@isTest
public class CustomController_Test {

    @isTest
    public static void getAllParentAccounts_Test(){
        
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
        
        CustomController.getAllParentAccounts(dd.Id);
        CustomController.getChildAccounts(ddCat.Id);
        CustomController intialize = new CustomController();
        intialize.initialize(ddSub.Id);
        
    }
}