public class SurveyResponseHandler {
    public static void updateSurveyResponses(Set<Id> invitationIds) {
        
        List<P360_DD_Category__c> categoriesToUpdate = new List<P360_DD_Category__c>();
        
        List<SurveyQuestionResponse> questionResponses = [SELECT Id, Question.Name, ResponseValue, Invitation.Due_Diligence__c 
                                                          FROM SurveyQuestionResponse 
                                                          WHERE InvitationId = :invitationIds];  
        
        Map<Id,List<SurveyQuestionResponse>> sqrMap = new Map<Id,List<SurveyQuestionResponse>>();
        for (SurveyQuestionResponse questionResponse : questionResponses) {
            //     questionNames.add(questionResponse.Question.Name);
            if(sqrMap.containsKey(questionResponse.Invitation.Due_Diligence__c)){
                sqrMap.get(questionResponse.Invitation.Due_Diligence__c).add(questionResponse);
            }else{
                sqrMap.put(questionResponse.Invitation.Due_Diligence__c,new List<SurveyQuestionResponse>{questionResponse});
            }    
        }
        
        List<P360_DD_Category__c> ddCategory = [Select Id, Name,TMKDA_Has_a_new_Complaints_policy__c,TMKDA_attestationconfirm_a_new_Complaint__c,TMKDA_Attestation_new_Succession_plan__c,TMKDA_Does_attestation_confirm_a_new_BCP__c,TMKDA_Does_attestation_confirm_a_new_DRP__c,TMKDA_attestationconfirmnew_Outsourci__c,TMKDA_Has_a_new_whistleblowing_policy__c,TMKDA_Has_a_new_Info_Security_policy__c,TMKDA_Has_a_new_Data_Protection_policy__c,TMKDA_Has_a_new_Claims_Procedure__c,TMKDA_Has_a_new_Accounting_Procedure__c,P360_Due_Diligence_Name__c  
                                                from P360_DD_Category__c WHERE P360_Due_Diligence_Name__c =: sqrMap.keySet()];
        
        List<P360_DD_Category__c> ddCategoryToUpdate = new List<P360_DD_Category__c>();
        
        for(P360_DD_Category__c categories : ddCategory){
            if(sqrMap.ContainsKey(categories.P360_Due_Diligence_Name__c)){
                List<SurveyQuestionResponse> sqrList = sqrMap.get(categories.P360_Due_Diligence_Name__c);
                for(SurveyQuestionResponse sqr : sqrList){
                    if(sqr.Question.Name == categories.Name){
                        categories.TMKDA_Does_attestation_confirm_a_new_TCF__c = sqr.ResponseValue;
                        categories.TMKDA_attestationconfirm_a_new_Complaint__c = sqr.ResponseValue;
                    //  categories.TMKDA_AtTMKDA_Attestation_Fin_Crime_policy__c = sqr.ResponseValue;
                    //  categories.TMKDA_Hasnew_Conflictsof_Interest_policy__ctestation_Fin_Crime_policy__c = sqr.ResponseValue;
                        categories.TMKDA_Attestation_new_Succession_plan__c = sqr.ResponseValue;
                        categories.TMKDA_Does_attestation_confirm_a_new_BCP__c = sqr.ResponseValue;
                        categories.TMKDA_Does_attestation_confirm_a_new_DRP__c = sqr.ResponseValue;
                        categories.TMKDA_attestationconfirmnew_Outsourci__c = sqr.ResponseValue;
                        categories.TMKDA_Has_a_new_whistleblowing_policy__c = sqr.ResponseValue;
                        categories.TMKDA_Has_a_new_Info_Security_policy__c = sqr.ResponseValue;
                        categories.TMKDA_Has_a_new_Data_Protection_policy__c = sqr.ResponseValue;
                        categories.TMKDA_Has_a_new_Claims_Procedure__c = sqr.ResponseValue;
                    //  categories.P360_Review_Point__c = sqr.ResponseValue;
                        categories.TMKDA_Has_a_new_Accounting_Procedure__c = sqr.ResponseValue;
                    //   Categories.P360_Review_Area__c = sqr.ResponseValue;
                        ddCategoryToUpdate.add(categories);
                    }
                }
            }
        }
        if(!ddCategoryToUpdate.isEmpty()){
            update ddCategoryToUpdate;
        }
    }
}