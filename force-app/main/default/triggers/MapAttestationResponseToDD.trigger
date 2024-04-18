//NOT IN USE - DY - 21/1/24
trigger MapAttestationResponseToDD on SurveyQuestionResponse (after insert) {
    
    if (Trigger.isAfter && Trigger.isInsert) {
        
        //get invitationIds of current record
        Set<Id> invitationIds = new Set<Id>();
        for (SurveyQuestionResponse sqr : Trigger.new) {
            invitationIds.add(sqr.InvitationId);
        }
      SurveyResponseHandler.updateSurveyResponses(invitationIds);
    }
}