@isTest
public class ReusableLookupController_Test {
    
    @isTest
    public static void fetchRecords_Test(){
        RecordType rType = [ SELECT Id, Name, DeveloperName FROM RecordType WHERE Name = 'Coverholder'];
        Account acc = new Account();
        acc.Name = 'Test';
        acc.RecordTypeId = rType.Id;
        insert acc;
        
        ReusableLookupController.SearchWrapper wrap = new ReusableLookupController.SearchWrapper();
        wrap.fieldApiName = 'Name';
        wrap.objectApiName = 'Account';
        wrap.searchString = 't';
        wrap.selectedRecordId = acc.Id;
        wrap.otherFieldApiName = 'Industry';
        
        ReusableLookupController.fetchRecords(wrap);
    }
    
    @isTest
    public static void fetchRecords_Test_Else_1(){
        RecordType rType = [ SELECT Id, Name, DeveloperName FROM RecordType WHERE Name = 'Coverholder'];
        Account acc = new Account();
        acc.Name = 'Test';
        acc.RecordTypeId = rType.Id;
        insert acc;
        
        ReusableLookupController.SearchWrapper wrap = new ReusableLookupController.SearchWrapper();
        wrap.fieldApiName = 'Name';
        wrap.objectApiName = 'Account';
        wrap.searchString = 't';
        wrap.parentFieldApiName = 'Name';
        wrap.parentRecordId = acc.Id;
        
        ReusableLookupController.fetchRecords(wrap);
    }
    
    @isTest
    public static void fetchRecords_Test_Else_2(){
        RecordType rType = [ SELECT Id, Name, DeveloperName FROM RecordType WHERE Name = 'Coverholder'];
        Account acc = new Account();
        acc.Name = 'Test';
        acc.RecordTypeId = rType.Id;
        insert acc;
        
        ReusableLookupController.SearchWrapper wrap = new ReusableLookupController.SearchWrapper();
        wrap.fieldApiName = 'Name';
        wrap.objectApiName = 'Account';
        wrap.searchString = 't';
        wrap.otherFieldApiName = 'Industry';
        // wrap.parentFieldApiName = 'Name';
        // wrap.parentRecordId = acc.Id;
        
        ReusableLookupController.fetchRecords(wrap);
    }
    
}