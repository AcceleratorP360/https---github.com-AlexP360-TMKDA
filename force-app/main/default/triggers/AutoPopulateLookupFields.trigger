trigger AutoPopulateLookupFields on P360_Actions__c (before insert, before update) {
    // Collect the Due_Diligence__c and Party__c field values from TMKDA_DAMO_PUGC__c records
    Map<Id, TMKDA_DAMO_PUGC__c> dueDiligencePartyMap = new Map<Id, TMKDA_DAMO_PUGC__c>();
    for (P360_Actions__c action : Trigger.new) {
        if (action.Due_Diligence__c != null && action.Party__c != null) {
            dueDiligencePartyMap.put(action.Due_Diligence__c, null); // Placeholder value
        }
    }

    // Query TMKDA_DAMO_PUGC__c records related to the Due_Diligence__c and Party__c values
    Map<Id, TMKDA_DAMO_PUGC__c> parentRecords = new Map<Id, TMKDA_DAMO_PUGC__c>(
        [SELECT Id, TMKDA_Party__c, TMKDA_Due_Diligence__c FROM TMKDA_DAMO_PUGC__c WHERE TMKDA_Due_Diligence__c IN :dueDiligencePartyMap.keySet()]
    );

    // Populate Due_Diligence__c and Party__c fields in P360_Actions__c records
    for (P360_Actions__c action : Trigger.new) {
        if (parentRecords.containsKey(action.Due_Diligence__c)) {
            TMKDA_DAMO_PUGC__c parentRecord = parentRecords.get(action.Due_Diligence__c);
            system.debug('parent id=='+parentRecord.TMKDA_Due_Diligence__c+'==party=='+parentRecord.TMKDA_Party__c);
            action.Due_Diligence__c = parentRecord.TMKDA_Due_Diligence__c;
            action.Party__c = parentRecord.TMKDA_Party__c;
        }
    }
}