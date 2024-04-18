trigger UpdateparentvalueonPRA on P360_Actions__c (before insert) {
    
    Set<Id> parentIds = new Set<Id>();
    
        
    // Collect all Category ,Due Diligence and Account Ids
    for (P360_Actions__c PRA : Trigger.new) {
        if (PRA.P360_Category_Due_Diligence__c != null) {
            parentIds.add(PRA.P360_Category_Due_Diligence__c);
        }
        
    }

    // Query Categgory, Due Diligence and Account records to get their field values
    Map<Id, P360_DD_Category__c> categoryMap = new Map<Id, P360_DD_Category__c>([SELECT Id ,P360_Due_Diligence_Name__c,P360_Coverholder_TPA_Name__c FROM P360_DD_Category__c WHERE Id IN :parentIds]); 
    
    // Update Sub Category records with Category, Due Diligence and Account information
    for (P360_Actions__c PRA1 : Trigger.new) {
        if (PRA1.P360_Category_Due_Diligence__c != null) {
            P360_DD_Category__c category = categoryMap.get(PRA1.P360_Category_Due_Diligence__c);
            if (category != null) {
                PRA1.P360_Category_Due_Diligence__c = category.Id;
                PRA1.Due_Diligence__c = category.P360_Due_Diligence_Name__c;
                PRA1.Party__c = category.P360_Coverholder_TPA_Name__c;
            }
        }
    }

}