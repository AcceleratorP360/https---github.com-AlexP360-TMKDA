@isTest
public class P360DA_CustomLookUpCtrlTest {

    @isTest
    Public static void fetchLookupData(){
        Account acc = new Account();
        acc.Name = 'acc Test';
        acc.P360_Syndicate_Number__c = '2355';
        insert acc;
        
        Test.startTest();
        List<sObject> result = P360DA_CustomLookUpCtrl.searchLookupData('Test', 'Account');
        P360DA_CustomLookUpCtrl.searchDefaultRecord(acc.Id,'Account');
         P360DA_CustomLookUpCtrl.getLookupObjectList('Account','Name');
        Test.stopTest();
    }
}