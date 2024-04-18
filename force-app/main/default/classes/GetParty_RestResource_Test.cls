@isTest
public class GetParty_RestResource_Test {
    
    @isTest
    static void testGetParties() {
        
        Id coverHolderRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('P360_Broker').getRecordTypeId();
        Account accRec = new Account(Name='Test Account',CurrencyIsoCode = 'GBP',
                                     
                                     RecordTypeId =coverHolderRecordTypeId);
        insert accRec;
        
        Test.startTest();
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();

        request.requestURI = '/services/apexrest/partyEntityId?';
        request.addParameter('EntityId', accRec.Coverholder_Id__c);

        RestContext.request = request;
        RestContext.response = response;

        GetParty_RestResource.getParty();
        Test.stopTest();
    }
}