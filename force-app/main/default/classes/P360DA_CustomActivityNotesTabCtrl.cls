public with sharing class P360DA_CustomActivityNotesTabCtrl {
    @AuraEnabled
    public static List<NoteWrapper> fatchNotes(String recordId){
        List<NoteWrapper> notes = new List<NoteWrapper>();
        try {
            System.debug('recordId ::: >'+recordId);
            
            if(String.isBlank(recordId)) return null;
            
            List<ContentDocumentLink> documentLinks = [SELECT ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId = :recordId];
            System.debug('documentLinks ::: >' +documentLinks);
            
            if(documentLinks == null && documentLinks.isEmpty()) return null;
            
            Set<Id> setOfConDocId = new Set<Id>();
            for (ContentDocumentLink link : documentLinks) {
                setOfConDocId.add(link.ContentDocumentId);
            }  
            System.debug('setOfConDocId ::: >' +setOfConDocId);
            
            List<ContentNote> listOfNote = [SELECT Id, Title, Content, CreatedById, CreatedDate,LastModifiedBy.Name,LastModifiedById FROM ContentNote WHERE Id IN :setOfConDocId ORDER BY CreatedDate DESC];
            if(listOfNote == null && listOfNote.isEmpty()) return null;
            
            for(ContentNote conNote : listOfNote){
                System.debug('conNote ::: >' +conNote);

                NoteWrapper noteWrapper = new NoteWrapper();
                noteWrapper.id = conNote.Id;
                noteWrapper.title = conNote.Title;
                noteWrapper.content = EncodingUtil.base64Decode(EncodingUtil.base64Encode(conNote.Content)).toString();
                noteWrapper.createdDate = conNote.CreatedDate.format('dd/MM/yyyy, hh:mm a');
                noteWrapper.modifiedByName = conNote.LastModifiedBy.Name;
                noteWrapper.modifiedById = conNote.LastModifiedById;

                notes.add(noteWrapper);
                System.debug('noteWrapper ::: >' +noteWrapper);
            }

        } catch (Exception e) {
            System.debug('Line Number : ' + e.getLineNumber() + 'Message : '+ e.getMessage());
        }
        return notes;
    }

    @AuraEnabled(cacheable=false)
    public static String insertNote(String recordId, String title, String content, String notesId) {

        System.debug('=====notesId====='+notesId);
        
        try{
            // Check if noteId is provided for update
            if (String.isNotBlank(notesId)) {
                // Retrieve the existing ContentNote
                ContentNote existingNote = [SELECT Id, Title, Content FROM ContentNote WHERE Id = :notesId LIMIT 1];

                // Update existing ContentNote
                existingNote.Title = title;
                existingNote.Content = Blob.valueOf(content);
                update existingNote;

                // Return the updated noteId
                return 'isUpdated';
            }else {
                // Create ContentNote
                ContentNote contentNote = new ContentNote();
                contentNote.Title = title;
                contentNote.Content = Blob.valueOf(content); // Replace with your content
                insert contentNote;

                // Create ContentDocumentLink to link the ContentNote to the Account
                ContentDocumentLink contentLink = new ContentDocumentLink();
                contentLink.ContentDocumentId = [SELECT Id FROM ContentDocument WHERE Title = :title LIMIT 1].Id;
                contentLink.LinkedEntityId = recordId;
                contentLink.ShareType = 'V'; // 'V' indicates that the note is linked to the record, but not shared
                contentLink.Visibility = 'AllUsers'; // 'AllUsers' makes the note visible to all users
                insert contentLink;

                return 'isInserted';
            }
        }
        catch (Exception e) {
            System.debug('Line Number : ' + e.getLineNumber() + 'Message : '+ e.getMessage());
            return null;
        }
    }

    @AuraEnabled
    public static NoteWrapper fatchNote(String recordId){
        ContentNote cn= [SELECT Id, Title, Content, CreatedById, CreatedDate,LastModifiedBy.Name,LastModifiedById FROM ContentNote WHERE Id =: recordId ];
        NoteWrapper noteWrappers = new NoteWrapper();

        if(cn != null){
            noteWrappers.id = cn.Id;
            noteWrappers.title = cn.Title;
            noteWrappers.content = EncodingUtil.base64Decode(EncodingUtil.base64Encode(cn.Content)).toString();
            noteWrappers.createdDate = cn.CreatedDate.format('dd/MM/yyyy, hh:mm a');
            noteWrappers.modifiedByName = cn.LastModifiedBy.Name;
            noteWrappers.modifiedById = cn.LastModifiedById;
        }
        return noteWrappers;
    }

    @AuraEnabled
    public static String deleteNote(String noteId) {
        try {
            ContentNote existingNote = [SELECT Id FROM ContentNote WHERE Id = :noteId LIMIT 1];

            if (existingNote != null) {
                // Delete the ContentNote
                delete existingNote;
                // Return success message or any other indication
                return 'isDeleted';
            } else {
                // Return a message indicating that the note was not found
                return 'Note not found';
            }
        } catch (Exception e) {
            System.debug('Line Number : ' + e.getLineNumber() + 'Message : ' + e.getMessage());
            return null;
        }
    }

    public class NoteWrapper {
        @AuraEnabled
        public String id { get; set; }
        @AuraEnabled
        public String title { get; set; }
        @AuraEnabled
        public String content { get; set; }
        @AuraEnabled
        public String createdDate { get; set; }
        @AuraEnabled
        public String modifiedByName { get; set; }
        @AuraEnabled
        public Id modifiedById { get; set; }
    }

}