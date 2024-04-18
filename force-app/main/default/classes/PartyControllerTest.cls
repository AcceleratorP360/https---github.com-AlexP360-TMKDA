@isTest
private class PartyControllerTest {

    @isTest
    static void testOppyStageUpdate() {
        // Create a test account record
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;

        // Call the oppyStageUpdate method to update the account's stage
        PartyController.oppyStageUpdate('New Stage', testAccount.Id);

        // Retrieve the updated account record
        Account updatedAccount = [SELECT Id, P360_DA_TPA_Stages__c FROM Account WHERE Id = :testAccount.Id];

        // Verify that the account's stage has been updated correctly
        System.assertEquals('New Stage', updatedAccount.P360_DA_TPA_Stages__c);
    }
}