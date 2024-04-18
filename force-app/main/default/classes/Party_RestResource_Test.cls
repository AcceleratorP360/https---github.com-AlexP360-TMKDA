@isTest
public class Party_RestResource_Test {
    
    @isTest
    static void testGetParties() {
        
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
        
        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/getParties';
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        Party_RestResource.getParties();
        Test.stopTest();
        
        /* List<Party_RestResource.partyWrapper> responseList = (List<Party_RestResource.partyWrapper>)
JSON.deserialize(res.responseBody.toString(), List<Party_RestResource.partyWrapper>.class);

Party_RestResource.partyWrapper responseWrapper = responseList[0];*/
    }
}