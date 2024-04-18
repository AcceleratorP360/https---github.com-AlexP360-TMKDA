@isTest
private class GenerateAttestationTest {

    @isTest
    static void testGenerateAttestation() {

        Account testAccount = new Account(
        Name = 'Test Account',
        P360_Syndicate_Number__c ='3412'
        //P360_Europe_Syndicate_Number__c = 'TA12',
       // P360_Sponsoring_Service_Provider_MGA__c='Test Service provider',
       // P360_Lloyd_PIN__c ='WA1234567'
       );
        insert testAccount;

        PageReference pageRef = Page.Download_Lloyds_Attestation_Paper; 
        Test.setCurrentPage(pageRef);

     
        Test.setCurrentPageReference(pageRef);
        ApexPages.StandardController stdController = new ApexPages.StandardController(testAccount);

   
        GenerateAttestation attest = new GenerateAttestation(stdController);

     
        System.assertEquals(testAccount.Id, attest.account.Id, '022g000000hb2d');
     

    }
}