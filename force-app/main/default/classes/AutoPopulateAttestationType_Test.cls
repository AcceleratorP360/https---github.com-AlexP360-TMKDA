@isTest
public class AutoPopulateAttestationType_Test {
       
  @isTest
    static void testAutoPopulateAttestationType() {
        // Create test data
        Account testAcc = new Account(        
            P360_Syndicate_Number__c = '546',
            P360_Lloyd_PIN__c = '569874'
        );       
        // Call the method to be tested
        Autopopulate_Attestation_Type_value.autoPopulateAttestationType(testAcc);

      // Verify that the attestation type is set to 'Light'       
        System.assertEquals('Light', testAcc.P360_Attestation_Type__c);
        
                
        // Create another test account with different conditions
        Account testAcc2 = new Account(          
            P360_Syndicate_Number__c = '256'
            // No Lloyd PIN provided
        );
         
        // Call the method again
        Autopopulate_Attestation_Type_value.autoPopulateAttestationType(testAcc2);

        // Verify that the attestation type is set to 'Full'       
        System.assertEquals('Full', testAcc2.P360_Attestation_Type__c);
        
        
        // Create another test account with different conditions
        Account testAcc3 = new Account(
           
            P360_Europe_Syndicate_Number__c = '4578'
            // No Lloyd PIN provided
        );
              

        // Call the method again
       Autopopulate_Attestation_Type_value.autoPopulateAttestationType(testAcc3);
        
       // Verify that the attestation type is set to 'Light EU'        
        System.assertEquals('Light EU', testAcc3.P360_Attestation_Type__c);       
        

        // Create another test account with no conditions met       
        Account testAcc4 = new Account(           
            // No Syndicate Number or Lloyd PIN provided
        );
          

        // Call the method again
       Autopopulate_Attestation_Type_value.autoPopulateAttestationType(testAcc4);

     // Verify that the attestation type is null (or another default value)        
        System.assertEquals(' ',testAcc4.P360_Attestation_Type__c);
                  
    }
    
    
   @isTest
    static void testLightAttestationType() {
        // Create a test account with P360_Syndicate_Number__c and P360_Lloyd_PIN__c not null
        Account testAccount = new Account(
            Name = 'Test Account',
            P360_Syndicate_Number__c = '1880',
            P360_Lloyd_PIN__c = '4587236'
        );

        Test.startTest();
        insert testAccount;
        Test.stopTest();

        // Verify that the attestation type is set to 'Light'
        testAccount = [SELECT P360_Attestation_Type__c FROM Account WHERE Id = :testAccount.Id];
        System.assertEquals('Light', testAccount.P360_Attestation_Type__c);
    }
    
    @isTest
    static void testFullAttestationType() {
        // Create a test account with P360_Syndicate_Number__c not null and P360_Lloyd_PIN__c null
        Account testAccount = new Account(
            P360_Syndicate_Number__c = '1880');          
            // P360_Lloyd_PIN__c is intentionally left null
        

        Test.startTest();
        insert testAccount;
        Test.stopTest();

        // Verify that the attestation type is set to 'Full'
        testAccount = [SELECT P360_Attestation_Type__c FROM Account WHERE Id = :testAccount.Id];
        System.assertEquals('Full', testAccount.P360_Attestation_Type__c);
    }
    
    @isTest
    static void testLightEUAttestationType() {
        // Create a test account with P360_Europe_Syndicate_Number__c not null and P360_Lloyd_PIN__c null
        Account testAccount = new Account(
            P360_Europe_Syndicate_Number__c = '5332'
            // P360_Lloyd_PIN__c is intentionally left null
        );

        Test.startTest();
        insert testAccount;
        Test.stopTest();

        // Verify that the attestation type is set to 'Light EU'
        testAccount = [SELECT P360_Attestation_Type__c FROM Account WHERE Id = :testAccount.Id];
        System.assertEquals('Light EU', testAccount.P360_Attestation_Type__c);
    }
    
    @isTest
    static void testNullAttestationType() {
        // Create a test account without setting any values
        Account testAccount = new Account();
        // P360_Europe_Syndicate_Number__c = ' ',P360_Syndicate_Number__c = ' ',P360_Lloyd_PIN__c =' ');

        Test.startTest();
        insert testAccount;
        Test.stopTest();

        // Verify that the attestation type is null (or another default value)
        testAccount = [SELECT P360_Attestation_Type__c FROM Account WHERE Id = :testAccount.Id];
        System.assertEquals(' ',testAccount.P360_Attestation_Type__c);
        // You can replace System.assertNull with System.assertEquals('YourDefaultValue', testAccount.P360_Attestation_Type__c);
    }
    
     @isTest
    static void testUpdateAttestationType() {
        // Create a test account with initial attestation type 'Light'
        Account testAccount = new Account(
            P360_Syndicate_Number__c = '510',
            P360_Lloyd_PIN__c = '5689234',
            P360_Attestation_Type__c = 'Light'
        );

        Test.startTest();
        insert testAccount;

        // Update the attestation type to 'Full'
        testAccount.P360_Attestation_Type__c = 'Full';
        update testAccount;
        Test.stopTest();

        // Verify that the attestation type remains 'Full' after update
        testAccount = [SELECT P360_Attestation_Type__c FROM Account WHERE Id = :testAccount.Id];
        System.assertEquals('Full', testAccount.P360_Attestation_Type__c);
    }
    
}