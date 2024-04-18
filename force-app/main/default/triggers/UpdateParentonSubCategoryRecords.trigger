trigger UpdateParentonSubCategoryRecords on P360_DD_Sub_Category__c (before insert) {
    
    Set<Id> parentIds = new Set<Id>();
    
        
    // Collect all Category ,Due Diligence and Account Ids
    for (P360_DD_Sub_Category__c Subcategory : Trigger.new) {
        if (Subcategory.P360_Category_Name__c != null) {
            parentIds.add(Subcategory.P360_Category_Name__c);
        }
        
    }

    // Query Categgory, Due Diligence and Account records to get their field values
    Map<Id, P360_DD_Category__c> categoryMap = new Map<Id, P360_DD_Category__c>([SELECT Id ,P360_Due_Diligence_Name__c,P360_Coverholder_TPA_Name__c FROM P360_DD_Category__c WHERE Id IN :parentIds]); 
    
    // Update Sub Category records with Category, Due Diligence and Account information
    for (P360_DD_Sub_Category__c Subcategory1 : Trigger.new) {
        if (Subcategory1.P360_Category_Name__c != null) {
            P360_DD_Category__c category = categoryMap.get(Subcategory1.P360_Category_Name__c);
            if (category != null) {
                Subcategory1.P360_Category_Name__c = category.Id;
                Subcategory1.P360_Due_Diligence_Name__c = category.P360_Due_Diligence_Name__c;
                Subcategory1.P360_Coverholder_TPA_Name__c = category.P360_Coverholder_TPA_Name__c;
            }
        }
    }
}