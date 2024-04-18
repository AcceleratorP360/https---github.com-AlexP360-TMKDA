trigger CAUpdatecommentonnotes on P360_DD_Category__c (after insert, after update) {
    
    if (Trigger.isAfter) {
    //Collection so you can insert your notes in bulk
    List<Note> notes = new List<Note>();
    for(P360_DD_Category__c CA: Trigger.new) {
      //check the reviewer comment field 
      if((Trigger.isInsert && CA.TMKDA_Reviewer_Comment__c != null) || Trigger.oldMap.get(CA.Id).TMKDA_Reviewer_Comment__c != CA.TMKDA_Reviewer_Comment__c) {
        notes.add(new Note(
          Title = 'New Reviewer Comment',
          Body = CA.TMKDA_Reviewer_Comment__c, 
          ParentId = CA.Id));   
      }
    }
      insert notes;
    
  }
}