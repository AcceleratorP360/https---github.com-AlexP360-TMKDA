public with sharing class AttestationResponse {
    @AuraEnabled(cacheable=true)
    public static List<SurveyQuestionResponse> getSurveyResponses(String responseId) {
        return [SELECT Question.Name, ResponseValue
                FROM SurveyQuestionResponse
                WHERE ResponseId =:responseId WITH SECURITY_ENFORCED]; 
    }
    @AuraEnabled(cacheable=true)
    public static List<SurveyInvitationWrapper> getSurveyInvitations() {
        List<SurveyInvitationWrapper> surveyInvitations = new List<SurveyInvitationWrapper>();

        List<SurveyInvitation> surveyInvitationRecords = [SELECT Name, P360_DD_Coverholder_Name__c, P360_DD_record_Id__c, 
                                                         ParticipantId, SurveyId, Survey_Invitation_Link__c, 
                                                         ResponseStatus, CommunityId
                                                         FROM SurveyInvitation];

        for (SurveyInvitation record : surveyInvitationRecords) {
            surveyInvitations.add(new SurveyInvitationWrapper(record));
        }

        return surveyInvitations;
    }

    public class SurveyInvitationWrapper {
        public String name;
        public String coverholderName;
        public String recordId;
        public String participantId;
        public String surveyId;
        public String surveyInvitationLink;
        public String responseStatus;
        public String communityId;

        public SurveyInvitationWrapper(SurveyInvitation record) {
            this.name = record.Name;
            this.coverholderName = record.P360_DD_Coverholder_Name__c;
            this.recordId = record.P360_DD_record_Id__c;
            this.participantId = record.ParticipantId;
            this.surveyId = record.SurveyId;
            this.surveyInvitationLink = record.Survey_Invitation_Link__c;
            this.responseStatus = record.ResponseStatus;
            this.communityId = record.CommunityId;
        }
    }
}