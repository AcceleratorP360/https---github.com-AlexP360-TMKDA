/*
* Class: CategoryLinkageCreateRecord
* Description: Apex class to handle the creation of records in P360_DA_DD_Categories_Linkage__c when record is created in object Categories
* Created Date: 13/11/2023 
* Last Modified: 14/11/2023
* CreatedBy : Vardhani
*/
/* Comment: Setting the Linked Status to 'Cloned'
*/

public class CategoryLinkageCreateRecord {
    /*
* Method: handleAfterInsert to create a record in P360_DA_DD_Categories_Linkage__c when record is created in object Categories.
* Parameters:
*   - List<String> categoriesId: The list of  inserted P360_DD_Category__c records.
*/
    public static void handleAfterInsert(List<P360_DD_Category__c> categoriesId) {
        
        List<P360_DD_Category__c> categoryList = [ SELECT Id, P360_DA_Category_ID__r.P360_DA_Category_Name__c, P360_Due_Diligence_Name__c FROM P360_DD_Category__c WHERE Id =:categoriesId];
        
        List<P360_DA_DD_Categories_Linkage__c> categoryLinkageList = new List<P360_DA_DD_Categories_Linkage__c>();  
        
        // Logic to create records in P360_DA_DD_Categories_Linkage__c
        
        for (P360_DD_Category__c category : categoryList) {
            
            P360_DA_DD_Categories_Linkage__c linkage = new P360_DA_DD_Categories_Linkage__c();
            
            //Mapping field mappings of P360_DA_DD_Categories_Linkage__c with P360_DD_Category__c 
            linkage.P360_DA_Category_Name__c = category.Id;
            linkage.P360_DA_Linked_Due_Diligence_Name__c = category.P360_Due_Diligence_Name__c;  
          //  linkage.P360_DA_CA_Linked_Status__c = 'Copied';     // In Categories object not having reference fields to map Linked Status in DD Categories Linkage    
           // linkage.TMKDA_Connect_To_Primary__c = 'Copied';
            if(category.P360_DA_Category_ID__r.P360_DA_Category_Name__c != NULL && category.P360_DA_Category_ID__r.P360_DA_Category_Name__c.length() >= 80){
                linkage.Name = category.P360_DA_Category_ID__r.P360_DA_Category_Name__c.substring(0, 80);   
            }else{
                //linkage.Name = category.P360_DA_Category_ID__c != null ? category.P360_DA_Category_ID__r.P360_DA_Category_Name__c : linkage.Name;
                linkage.Name = category.P360_DA_Category_ID__r.P360_DA_Category_Name__c;
            }
            
            
            categoryLinkageList.add(linkage);
        }
        if (!categoryLinkageList.isEmpty()) {
            try{
                // Insert the created records
                insert categoryLinkageList ;                
                system.debug('DDCategoriesLinkage Record created Successfully');
                
            } catch (Exception e) {
                // Handle any exceptions during record insertion
                throw new AuraHandledException(e.getMessage());
            }
        }
    }
    
    public Static void updateExternalId(List<P360_DD_Category__c> catList){    
        for(P360_DD_Category__c cat : catList){
            if(cat.P360_Primary_External_ID__c == NULL){
                cat.P360_Primary_External_ID__c = String.valueOf(cat.P360_DA_Category_ID__c) + String.valueOf(cat.P360_Due_Diligence_Name__c);
            }
        }
    }
}