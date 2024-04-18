@isTest
public class S3_BucketDocumentCtrl_Test {
    
    @testSetup
    public static void setupTestData() {
        // Insert custom setting record
        P360_S3__c s3 = new P360_S3__c();
        s3.P360_SD1_DCOM_Coverholder__c = true;
        s3.P360_SD3a_DCOM_High_COB_Max_limit__c = true;
        s3.P360_SD3_DCOM_Authorized_COB__c = true;
        s3.P360_SD4_DCOM_Territorial_Limits__c = true;
        s3.P360_SD8_DCOM_Claims_Complaints__c = true;
        s3.P360_SD10a_DCOM_Section_Leads__c = true;
        s3.P360_KDR__c = true;
        s3.P360_PDT__c = true;
        s3.P360_BDX__c = true;
        insert s3;
        
        ContentVersion contentVersion = new ContentVersion(
            Title = 'Document_SD1_',
            PathOnClient = 'Document_SD1_.csv',
            VersionData = Blob.valueOf('Unique Market Reference Number, Contract Unique Identifier, Section Name, Section Unique ID, Participant Type,Participant Company Name, Participant Trading Name(s), Participant PIN, Participant Trading Address, Participant Postal Address, Participant Domicile, Participant Approval Status, \n B123024AWS1000, DA-CH-230801-0005, Section 1 - Deductible Buy Back, 1, Coverholder, AmWINS Special Risk Underwriters LLC, -, 109417GNX, 4725 Piedmont Row Drive, Suite 600, , Charlotte, North Carolina, U.S.A, , 28210"4725 Piedmont Row Drive, Suite 600, , Charlotte, North Carolina, U.S.A, , 28210", "4725 Piedmont Row Drive, Suite 600, , Charlotte, North Carolina, U.S.A, , 28210", U.S.A, Approved'),
            IsMajorVersion = true
        );
        insert contentVersion;
    }
    
    @isTest
    public Static void getDocumentFile_Test(){
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        S3_BucketDocumentCtrl.getDocumentFile();
        Test.stopTest();
    }
    
    public class MockHttpResponseGenerator implements HttpCalloutMock {
        // Implement the callout response generator
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setBody('<?xml version="1.0" encoding="UTF-8"?>' +
                        '<Response>' +
                        '    <Name>DCOM</Name>' +
                        '    <Contents>' +
                        '        <Key>DCOM/Document_SD1_.csv</Key>' +
                        '    </Contents>' +
                        '</Response>');
            res.setStatusCode(200);
            return res;
        }
    }
}