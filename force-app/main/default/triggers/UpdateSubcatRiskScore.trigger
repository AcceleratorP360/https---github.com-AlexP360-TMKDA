trigger UpdateSubcatRiskScore on P360_Review_Area__c (after insert, after update, after delete, after undelete) {
    /*Set<Id> subcatIds = new Set<Id>();
    Map<Id, P360_DD_Sub_Category__c> subcatsToUpdate = new Map<Id, P360_DD_Sub_Category__c>();
    
    // Collect all Sub Category IDs for the affected Review Area records
    for (P360_Review_Area__c reviewArea : Trigger.new) {
        subcatIds.add(reviewArea.P360_DD_Sub_Category__c);
    }
    for (P360_Review_Area__c reviewArea : Trigger.old) {
        subcatIds.add(reviewArea.P360_DD_Sub_Category__c);
    }
    
    // Query for the Sub Category records and aggregate the RiskScore values
    List<AggregateResult> results = [SELECT P360_DD_Sub_Category__c, SUM(P30_RA_DD_Risk_Score__c) sumRiskScore FROM P360_Review_Area__c WHERE P360_DD_Sub_Category__c IN :subcatIds GROUP BY P360_DD_Sub_Category__c];
    
    // Update the Sub Category records with the aggregated RiskScore values
    for (AggregateResult result : results) {
        Id subcatId = (Id)result.get('P360_DD_Sub_Category__c');
        Decimal sumRiskScore = (Decimal)result.get('sumRiskScore');
        P360_DD_Sub_Category__c subcat = new P360_DD_Sub_Category__c(Id = subcatId, P360_DD_SCT_Risk_Score__c = sumRiskScore);
        subcatsToUpdate.put(subcatId, subcat);
    }
    update subcatsToUpdate.values();*/
}