@Istest
public class PrepopulateDueDiligenceLookupClass_Test {
    
     @isTest
    public static void getDueDiligence() {
        
        Account acc = new Account();
        acc.Name = 'Test';
        insert acc;
        
        P360_Due_Diligence__c dd = new P360_Due_Diligence__c();
        dd.Name = 'Test';
        dd.P360_CoverHolder_TPA_Name__c = acc.Id;
        insert dd;
        
        List<P360_DD_Category__c> ddCatList = new List<P360_DD_Category__c>();
        P360_DD_Category__c ddCat = new P360_DD_Category__c();
        ddCat.Name = 'Test';
        ddCat.P360_Due_Diligence_Name__c = dd.Id;
        ddCatList.add(ddCat);
        insert ddCatList;
        
        Test.startTest();
        PrepopulateDueDiligenceLookupClass.prepopulateDueDiligenceLookup(dd.Id,ddCatList);
        Test.stopTest();

        

}
}