/**
* Class: ReviewAreaLinkageCreateRecord
* Description: Apex class to handle the creation of records in ObjectDD Review Areas Linkage  when record is created in object ObjectDD Review Areas Linkage.
* Created Date: 13/11/2023 
* Last Modified: 14/11/2023
*/
/* Comment: 
*/

public class ReviewAreaLinkageCreateRecord {
    /*
* Method: handleAfterInsert to create a record in P360_DA_DD_Review_Area_Linkage__c when record is created in object P360_Review_Area__c.
* Parameters:
*   List < P360_Review_Area__c > reviewAreaId The list of newly inserted P360_Review_Area__c records.
*/
    public static void createRecord(List<P360_Review_Area__c> reviewAreaId) {
        
        
        List<P360_Review_Area__c> reviewAreaList = [ SELECT Id, P360_DA_Review_Area_ID__r.Name, P360_DD_Sub_Category__c, P360_RA_Category__c, Due_Diligence__c FROM P360_Review_Area__c WHERE Id =: reviewAreaId ];
        Set<Id> setOfReviewAreaIds = new Set<Id>();
        for(P360_Review_Area__c reviewArea : reviewAreaList){
            setOfReviewAreaIds.add(reviewArea.P360_DD_Sub_Category__c);
        }
        
        List<P360_DA_DD_Sub_Category_Linkage__c> subCategoryLinkage = [ SELECT Id, P360_DA_Sub_Category_Name__c, P360_DA_DD_Category_Linkage__c FROM P360_DA_DD_Sub_Category_Linkage__c 
                                                                       WHERE P360_DA_Sub_Category_Name__c =: setOfReviewAreaIds ]; 
        
        Map< Id, P360_DA_DD_Sub_Category_Linkage__c > subCategoryLinkageMap = new Map< Id, P360_DA_DD_Sub_Category_Linkage__c >();
        for(P360_DA_DD_Sub_Category_Linkage__c subCatLink : subCategoryLinkage){
            subCategoryLinkageMap.put(subCatLink.P360_DA_Sub_Category_Name__c, subCatLink);
        }
        
        List < P360_DA_DD_Review_Area_Linkage__c > reviewAreaLinkageList = new List < P360_DA_DD_Review_Area_Linkage__c > ();
        // Logic to create records in P360_DA_DD_Review_Area_Linkage__c
        for (P360_Review_Area__c reviewArea : reviewAreaList) {
            if(subCategoryLinkageMap.containsKey(reviewArea.P360_DD_Sub_Category__c)){
            P360_DA_DD_Review_Area_Linkage__c ReviewLinkageArea = new  P360_DA_DD_Review_Area_Linkage__c();
            //Mapping field mappings of P360_DA_DD_Review_Area_Linkage__c with P360_Review_Area__c 
            ReviewLinkageArea.P360_DA_Review_Area_Name__c =reviewArea.Id;
            ReviewLinkageArea.P360_DA_Linked_Due_Diligence_Name__c = reviewArea.Due_Diligence__c;
            ReviewLinkageArea.P360_DA_DD_Sub_Category_Linkage__c = subCategoryLinkageMap.get(reviewArea.P360_DD_Sub_Category__c).Id;
            ReviewLinkageArea.TMKDA_Linked_Category__c = subCategoryLinkageMap.get(reviewArea.P360_DD_Sub_Category__c).P360_DA_DD_Category_Linkage__c;
            if(reviewArea.P360_DA_Review_Area_ID__r.Name != NULL){
                if(reviewArea.P360_DA_Review_Area_ID__r.Name.length() >= 80){
                    ReviewLinkageArea.Name = reviewArea.P360_DA_Review_Area_ID__r.Name.substring(0, 80);
                }else{
                    ReviewLinkageArea.Name = reviewArea.P360_DA_Review_Area_ID__r.Name;
                }
            }
            //ReviewLinkageArea.P360_DA_RA_Linked_Status__c = '';	
            reviewAreaLinkageList.add(ReviewLinkageArea);
        }
        }
        if (!reviewAreaLinkageList.isEmpty()) {
            try{
                // Insert the created records
                insert reviewAreaLinkageList;
                System.debug('P360_DA_DD_Review_Area_Linkage__c Created Record Succesfully');
            }catch (Exception e) {  
                system.debug('Error===>>>'+e.getMessage());
                // Handle any exceptions during record insertion
                throw new AuraHandledException(e.getMessage());
            }   
        } 
    }
    
    public Static void updateExternalId(List<P360_Review_Area__c> reviewList){
        for(P360_Review_Area__c review : reviewList){
            if(review.P360_Primary_External_ID__c == NULL){
                review.P360_Primary_External_ID__c = String.valueOf(review.P360_DA_Review_Area_ID__c) + String.valueOf(review.Due_Diligence__c);
            }
        }
    }    
}