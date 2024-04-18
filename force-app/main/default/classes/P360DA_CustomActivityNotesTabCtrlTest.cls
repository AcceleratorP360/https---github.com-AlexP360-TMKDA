@isTest
public class P360DA_CustomActivityNotesTabCtrlTest {

    @isTest
    static void testFetchNotes() {
        // Create a test record for LinkedEntityId
        Account testAccount = new Account(Name = 'Test Account');
        testAccount.P360_Syndicate_Number__c = '2355';
        insert testAccount;

        // Create ContentNote records
        ContentNote testNote1 = new ContentNote(
            Title = 'Test Note 1',
            Content = Blob.valueOf('Test Content 1')
        );
        ContentNote testNote2 = new ContentNote(
            Title = 'Test Note 2',
            Content = Blob.valueOf('Test Content 2')
        );
        insert new List<ContentNote>{testNote1, testNote2};

        // Link ContentNotes to the test record
        ContentDocumentLink link1 = new ContentDocumentLink(
            ContentDocumentId = [SELECT Id FROM ContentDocument WHERE Title = 'Test Note 1' LIMIT 1].Id,
            LinkedEntityId = testAccount.Id,
            ShareType = 'V',
            Visibility = 'AllUsers'
        );
        ContentDocumentLink link2 = new ContentDocumentLink(
            ContentDocumentId = [SELECT Id FROM ContentDocument WHERE Title = 'Test Note 2' LIMIT 1].Id,
            LinkedEntityId = testAccount.Id,
            ShareType = 'V',
            Visibility = 'AllUsers'
        );
        insert new List<ContentDocumentLink>{link1, link2};

        Test.startTest();
        // Call the fetchNotes method
        List<P360DA_CustomActivityNotesTabCtrl.NoteWrapper> result = P360DA_CustomActivityNotesTabCtrl.fatchNotes(testAccount.Id);
        Test.stopTest();

        // Assert the result
        System.assertEquals(2, result.size(), 'Expected two notes');
    }

    @isTest
    static void testInsertNote() {
        // Create a test record for LinkedEntityId
        Account testAccount = new Account(Name = 'Test Account');
        testAccount.P360_Syndicate_Number__c = '2355';
        insert testAccount;

        Test.startTest();
        // Call the insertNote method to insert a new note
        String resultInsert = P360DA_CustomActivityNotesTabCtrl.insertNote(
            testAccount.Id,
            'Test Note Insert',
            'Test Content Insert',
            null
        );

        // Assert the result of the insert operation
        System.assertEquals('isInserted', resultInsert, 'Insert operation failed');
        Test.stopTest();

        // Query the inserted note and assert its existence
        ContentNote insertedNote = [SELECT Id, Title, Content FROM ContentNote WHERE Title = 'Test Note Insert' LIMIT 1];
        System.assertNotEquals(null, insertedNote, 'Inserted note not found');
    }

    @isTest
    static void testUpdateNote() {
        // Create a test record for LinkedEntityId
        Account testAccount = new Account(Name = 'Test Account');
        testAccount.P360_Syndicate_Number__c = '2355';
        insert testAccount;

        // Create a ContentNote record to be updated
        ContentNote testNote = new ContentNote(
            Title = 'Test Note Update',
            Content = Blob.valueOf('Test Content Update')
        );
        insert testNote;

        Test.startTest();
        // Call the insertNote method to update the existing note
        String resultUpdate = P360DA_CustomActivityNotesTabCtrl.insertNote(
            testAccount.Id,
            'Test Note Update',
            'Test Content Update',
            testNote.Id
        );

        // Assert the result of the update operation
        System.assertEquals('isUpdated', resultUpdate, 'Update operation failed');
        Test.stopTest();

        // Query the updated note and assert its changes
        ContentNote updatedNote = [SELECT Id, Title, Content FROM ContentNote WHERE Id = :testNote.Id LIMIT 1];
        System.assertEquals('Test Note Update', updatedNote.Title, 'Note title not updated');
        System.assertEquals('Test Content Update', updatedNote.Content.toString(), 'Note content not updated');
    }

    @isTest
    static void testFetchNote() {
        // Create a test record for LinkedEntityId
        Account testAccount = new Account(Name = 'Test Account');
        testAccount.P360_Syndicate_Number__c = '2355';
        insert testAccount;

        // Create ContentNote record
        ContentNote testNote = new ContentNote(
            Title = 'Test Note Fetch',
            Content = Blob.valueOf('Test Content Fetch')
        );
        insert testNote;

        // Link ContentNote to the test record
        ContentDocumentLink link = new ContentDocumentLink(
            ContentDocumentId = [SELECT Id FROM ContentDocument WHERE Title = 'Test Note Fetch' LIMIT 1].Id,
            LinkedEntityId = testAccount.Id,
            ShareType = 'V',
            Visibility = 'AllUsers'
        );
        insert link;

        Test.startTest();
        // Call the fatchNote method
        P360DA_CustomActivityNotesTabCtrl.NoteWrapper result = P360DA_CustomActivityNotesTabCtrl.fatchNote(testNote.Id);
        Test.stopTest();

        // Assert the result
        System.assertNotEquals(null, result, 'Note not found');
        System.assertEquals('Test Note Fetch', result.title, 'Incorrect note title');
        System.assertEquals('Test Content Fetch', result.content, 'Incorrect note content');
    }

    @isTest
    static void testDeleteNote() {
        // Create a test ContentNote
        ContentNote testNote = new ContentNote(
            Title = 'Test Note Delete',
            Content = Blob.valueOf('Test Content Delete')
        );
        insert testNote;

        // Call the deleteNote method
        Test.startTest();
        String result = P360DA_CustomActivityNotesTabCtrl.deleteNote(testNote.Id);
        Test.stopTest();

        // Assert the result
        System.assertEquals('isDeleted', result, 'Note should be deleted');

        // Verify that the note is actually deleted
        List<ContentNote> deletedNotes = [SELECT Id FROM ContentNote WHERE Id = :testNote.Id];
        System.assertEquals(0, deletedNotes.size(), 'Note should be deleted');
    }
}