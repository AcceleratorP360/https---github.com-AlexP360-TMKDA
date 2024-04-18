@isTest
public class DD_Attestation_Scoping_Controller_Test {

    @isTest
    static void testUpload() {
        // Test record
        TMKDA_DD_Attestation_Scoping__c testRecord = new TMKDA_DD_Attestation_Scoping__c();
        insert testRecord;

        PageReference pageRef = Page.ViewAttestationScoping; 
        Test.setCurrentPage(pageRef);
        ApexPages.StandardController stdController = new ApexPages.StandardController(testRecord);
        DD_Attestation_Scoping_Controller controller = new DD_Attestation_Scoping_Controller(stdController);


        controller.fileName = 'TestFile.txt';
        controller.file = Blob.valueOf('Test file content');
        controller.title = 'Test Title';

        Test.startTest();
        PageReference resultPage = controller.upload();
        Test.stopTest();
       // System.assertNotEquals(null, resultPage); 
    }
}