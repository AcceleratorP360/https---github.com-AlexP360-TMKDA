trigger DDUpdatecommentinnotes on P360_Due_Diligence__c (after insert, after update) {
       
    if (Trigger.isAfter) {
    //Collection so you can insert your notes in bulk
    List<Note> notes = new List<Note>();
    for(P360_Due_Diligence__c DD: Trigger.new) {
      //check the reviewer comment field 
      if((Trigger.isInsert && DD.TMKDA_Reviewer_Comment__c != null) || Trigger.oldMap.get(DD.Id).TMKDA_Reviewer_Comment__c != DD.TMKDA_Reviewer_Comment__c) {
        notes.add(new Note(
          Title = 'New Reviewer Comment',
          Body = DD.TMKDA_Reviewer_Comment__c, 
          ParentId = DD.Id));   
      }
    }
      insert notes;
    
  }
}