trigger UpdateParentDate on TMKDA_DD_Attestation_Scoping__c (after insert, after update) {
    Set<Id> parentIds = new Set<Id>();
    for (TMKDA_DD_Attestation_Scoping__c childRecord : Trigger.new) {
        parentIds.add(childRecord.TMKDA_Due_Diligence__c);
    }
    
    Map<Id, P360_Due_Diligence__c> parentMap = new Map<Id, P360_Due_Diligence__c>(
        [SELECT Id, TMKDA_Attestation_Issued_Date__c FROM P360_Due_Diligence__c WHERE Id IN :parentIds]
    );

    for (TMKDA_DD_Attestation_Scoping__c childRecord : Trigger.new) {
        P360_Due_Diligence__c parentRecord = parentMap.get(childRecord.TMKDA_Due_Diligence__c);
        if (parentRecord != null && childRecord.TMKDA_Scoping_Date__c != null) {
            parentRecord.TMKDA_Attestation_Issued_Date__c = childRecord.TMKDA_Scoping_Date__c;
        }
    }

    update parentMap.values();
}