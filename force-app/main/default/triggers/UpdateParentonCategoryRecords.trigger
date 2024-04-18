trigger UpdateParentonCategoryRecords on P360_DD_Category__c (before insert) {
    
    Set<Id> parent1Ids = new Set<Id>();
    
    
    // Collect all Due Diligence and Account Ids
    for (P360_DD_Category__c category : Trigger.new) {
        if (category.P360_Due_Diligence_Name__c != null) {
            parent1Ids.add(category.P360_Due_Diligence_Name__c);
        }
    }

    // Query Due Diligence and Account records to get their field values
    Map<Id, P360_Due_Diligence__c> dueDiligenceMap = new Map<Id, P360_Due_Diligence__c>([SELECT Id,P360_Coverholder_TPA_Name__c FROM P360_Due_Diligence__c WHERE Id IN :parent1Ids]);
    
    // Update P360_DD_Category__c records with Due Diligence and Account information
    for (P360_DD_Category__c category : Trigger.new) {
        if (dueDiligenceMap.containskey(category.P360_Due_Diligence_Name__c)) {
            P360_Due_Diligence__c dueDiligence = dueDiligenceMap.get(category.P360_Due_Diligence_Name__c);
            if (dueDiligence != null) {
                category.P360_Due_Diligence_Name__c = dueDiligence.Id;
                category.P360_Coverholder_TPA_Name__c=dueDiligence.P360_Coverholder_TPA_Name__c;
                
            }
        }
    }
}