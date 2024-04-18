public class SIController {
    @AuraEnabled(cacheable=true)
    public static List<SurveyInvitation> getSurveysForDueDiligence(String dueDiligenceId) {
        return [SELECT CommunityId, Contact.Name, Due_Diligence__c, Id, InvitationLink, Name, OwnerId, P360_DD_Coverholder_Name__c, Survey.Name, UserId, UUID,P360_Party__c,P360_DD_record_Id__c
                FROM SurveyInvitation
                WHERE Due_Diligence__c = :dueDiligenceId];
    }
}