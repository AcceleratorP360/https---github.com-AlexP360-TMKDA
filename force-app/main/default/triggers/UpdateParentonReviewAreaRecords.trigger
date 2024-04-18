trigger UpdateParentonReviewAreaRecords on P360_Review_Area__c (before insert) {
    
    Set<Id> parentId = new Set<Id>();
    
    // Collect all Category ,Due Diligence and Account Ids
    
    for (P360_Review_Area__c Reviewarea : Trigger.new) {
        if (Reviewarea.P360_DD_Sub_Category__c != null) {
            parentId.add(Reviewarea.P360_DD_Sub_Category__c);
        }

    }

    // Query Sub-category, Categgory, Due Diligence and Account records to get their field values
    
    Map<Id, P360_DD_Sub_Category__c> subcategoryMap = new Map<Id, P360_DD_Sub_Category__c>([SELECT Id,P360_Category_Name__c,P360_Due_Diligence_Name__c,P360_Coverholder_TPA_Name__c FROM P360_DD_Sub_Category__c WHERE Id IN :parentId]);
    
    // Update Review Area records with Sub Category, Category, Due Diligence and Account information
    
    for (P360_Review_Area__c Reviearea1 : Trigger.new) {
        if (Reviearea1.P360_DD_Sub_Category__c != null) {
            P360_DD_Sub_Category__c subcategory = subcategoryMap.get(Reviearea1.P360_DD_Sub_Category__c);
            if (subcategory != null) {
                Reviearea1.P360_DD_Sub_Category__c = subcategory.Id;
                Reviearea1.P360_RA_Category__c =subcategory.P360_Category_Name__c;
                Reviearea1.Due_Diligence__c=subcategory.P360_Due_Diligence_Name__c;
                Reviearea1.P360_CoverHolder_Name__c=subcategory.P360_Coverholder_TPA_Name__c;
            }
        }
    }
    
    
    
}