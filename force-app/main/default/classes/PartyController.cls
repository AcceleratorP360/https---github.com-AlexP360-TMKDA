public class PartyController {
    @AuraEnabled
    public static void oppyStageUpdate(String stageName , String recordId){
        Account opp = [Select Id ,P360_DA_TPA_Stages__c from Account where Id=:recordId] ; 
        opp.P360_DA_TPA_Stages__c =stageName ; 
        update opp ;
        
    }

}