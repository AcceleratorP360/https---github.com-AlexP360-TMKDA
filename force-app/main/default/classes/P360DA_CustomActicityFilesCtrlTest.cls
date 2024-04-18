@isTest
public class P360DA_CustomActicityFilesCtrlTest {
    
    @isTest
    Public static void getRelatedFilesRecord(){
        Account acc = new Account();
        acc.Name = 'Test Acc';
        acc.P360_Syndicate_Number__c = '2355';
        insert acc;

        ContentVersion testVersion1 = new ContentVersion(
            Title = 'Test Document 1',
            PathOnClient = 'testdocument1.txt',
            VersionData = Blob.valueOf('Test content 1')
        );
        insert testVersion1;
        
        ContentVersion testVersion2 = new ContentVersion(
            Title = 'Test Document 2',
            PathOnClient = 'testdocument2.pdf',
            VersionData = Blob.valueOf('Test content 2')
        );
        insert testVersion2;
        
        Id contentDocumentId1 = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :testVersion1.Id].ContentDocumentId;
        Id contentDocumentId2 = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :testVersion2.Id].ContentDocumentId;
        
        ContentDocumentLink link1 = new ContentDocumentLink(
            LinkedEntityId = acc.Id,
            ContentDocumentId = contentDocumentId1
        );
        insert link1;
        
        ContentDocumentLink link2 = new ContentDocumentLink(
            LinkedEntityId = acc.Id,
            ContentDocumentId = contentDocumentId2
        );
        insert link2;
        List<P360DA_CustomActicityFilesCtrl.FilesWrapper> filesList = new List<P360DA_CustomActicityFilesCtrl.FilesWrapper>();
        P360DA_CustomActicityFilesCtrl.FilesWrapper files = new P360DA_CustomActicityFilesCtrl.FilesWrapper();
        files.base64 = 'Test File Body';
        files.filename = 'Test.Pdf';
        filesList.add(files);
        String recordId = acc.Id;
        
        Test.startTest();
        List<ContentDocument> result = P360DA_CustomActicityFilesCtrl.getRelatedFilesRecord(acc.Id);
        String result1 = P360DA_CustomActicityFilesCtrl.uploadFiles(filesList, recordId);
        Test.stopTest();
    }
}