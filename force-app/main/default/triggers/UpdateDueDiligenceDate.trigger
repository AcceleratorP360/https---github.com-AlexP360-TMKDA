trigger UpdateDueDiligenceDate on TMKDA_DAMO_PUGC__c (after insert, after update) {
    Set<Id> ddIds = new Set<Id>();
    for (TMKDA_DAMO_PUGC__c damo : Trigger.new) {
        if (Trigger.isInsert || (Trigger.isUpdate && damo.TMKDA_DD_completed_Date__c != Trigger.oldMap.get(damo.Id).TMKDA_DD_completed_Date__c)) {
            ddIds.add(damo.Id);
        }
    }

    if (!ddIds.isEmpty()) {
        List<P360_Due_Diligence__c> dueDiligences = [SELECT Id, RecordTypeId FROM P360_Due_Diligence__c WHERE TMKDA_DAMO_PUGC__c IN :ddIds AND RecordType.DeveloperName = 'TMKDA_Renewal'];
        for (P360_Due_Diligence__c dueDiligence : dueDiligences) {
            dueDiligence.P360_Due_Diligence_Date__c = Trigger.newMap.get(dueDiligence.TMKDA_DAMO_PUGC__c).TMKDA_DD_completed_Date__c;
        }
        update dueDiligences;
    }
}