@isTest
private class FileControllerTest {
    @isTest
    static void testGetFilesList() {
        // Create test record
        Account testRecord = new Account(Name='Test Account');
        insert testRecord;
        
        // Create test file
        ContentVersion testFile = new ContentVersion(
            Title = 'Test File',
            PathOnClient = 'test_file.txt',
            VersionData = Blob.valueOf('Test file content'),
            IsMajorVersion = true
        );
        insert testFile;
        
        // Create ContentDocumentLink record
        ContentDocumentLink cdl = new ContentDocumentLink(
            ContentDocumentId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :testFile.Id].ContentDocumentId,
            LinkedEntityId = testRecord.Id,
            ShareType = 'I'
        );
        insert cdl;
        
        // Call controller method
        FileController.FilesWrapper[] files = FileController.getFilesList(testRecord.Id);
        
        FileController.FilesWrapper testFileWrapper = files[0];
    }
    
    @isTest
    static void testGetFileVersionDetails() {
        
        Account testRecord = new Account(Name='Test Account');
        insert testRecord;
        
        // Create test file
        List<ContentVersion> conList = new List<ContentVersion>();
        ContentVersion testFile = new ContentVersion(
            Title = 'Test File',
            PathOnClient = 'test_file.txt',
            VersionData = Blob.valueOf('Test file content'),
            IsMajorVersion = true
        );
        conList.add(testFile);
        insert conList;
        
        // Create ContentDocumentLink record
        ContentDocumentLink cdl = new ContentDocumentLink(
            ContentDocumentId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :conList[0].Id].ContentDocumentId,
            LinkedEntityId = testRecord.Id,
            ShareType = 'I'
        );
        insert cdl;
        
        // Call controller method
        FileController.FileVersionWrapper[] versions = FileController.getFileVersionDetails(cdl.ContentDocumentId);
        
        // Assert that the versions list is not empty
        FileController.FileVersionWrapper testVersionWrapper = versions[0];
        FileController.updaterecord(conList);
        
    }    
}