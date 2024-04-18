public class Updateparent_Inlinereviewarea {
    public static void updateReviewAreaRecords(List<P360_Review_Area__c> reviewAreas) {
        Set<Id> parentIds = new Set<Id>();
        
        // Collect all Category, Due Diligence, and Account Ids
        for (P360_Review_Area__c reviewArea : reviewAreas) {
            if (reviewArea.P360_DD_Sub_Category__c != null) {
                parentIds.add(reviewArea.P360_DD_Sub_Category__c);
            }
        }
       // if (!parentIds.isEmpty()) {
        // Query Sub-category, Category, Due Diligence, and Account records to get their field values
        Map<Id, P360_DD_Sub_Category__c> subcategoryMap = new Map<Id, P360_DD_Sub_Category__c>([
            SELECT Id, P360_Category_Name__c, P360_Due_Diligence_Name__c, P360_Coverholder_TPA_Name__c
            FROM P360_DD_Sub_Category__c
            WHERE Id IN :parentIds
        ]);
        
        // Update Review Area records with Sub Category, Category, Due Diligence, and Account information
        for (P360_Review_Area__c reviewArea : reviewAreas) {
            if (reviewArea.P360_DD_Sub_Category__c != null) {
                P360_DD_Sub_Category__c subcategory = subcategoryMap.get(reviewArea.P360_DD_Sub_Category__c);
                if (subcategory != null) {
                    reviewArea.P360_DD_Sub_Category__c = subcategory.Id;
                    reviewArea.P360_RA_Category__c = subcategory.P360_Category_Name__c;
                    reviewArea.Due_Diligence__c = subcategory.P360_Due_Diligence_Name__c;
                    reviewArea.P360_CoverHolder_Name__c = subcategory.P360_Coverholder_TPA_Name__c;
                }
            }
        }
   // }
    }

}