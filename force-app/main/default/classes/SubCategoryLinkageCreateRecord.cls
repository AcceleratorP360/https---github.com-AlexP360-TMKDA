/**
* Class: SubCategoryLinkageCreateRecord
* Description: Apex class to handle the creation of records in Object DD Sub-Categories Linkage  when record is created in object Sub-Categories.
* Created Date: 13/11/2023 
* Last Modified: 14/11/2023
* Created By : Vardhani 
*/
/* Comment: 
*/
public class SubCategoryLinkageCreateRecord {
    /* Method: createRecord to create a record in P360_DA_DD_Sub_Category_Linkage__c when record is created in object Sub-Categories.
* Parameters:-List < P360_DD_Sub_Category__c > subCategoryId: The list of newly inserted P360_DD_Sub_Category__c records.
*/
    public static void createRecord(List <P360_DD_Sub_Category__c> subCategoryId) {
        List<P360_DD_Sub_Category__c> subCategoryList = [ SELECT Id, P360_DA_Sub_Category_ID__r.P360_DA_Sub_Category_Name__c, P360_Category_Name__c, P360_Due_Diligence_Name__c FROM P360_DD_Sub_Category__c WHERE Id =: subCategoryId ];
        Set<Id> setOfSubCategoryIds = new Set<Id>();
        
        for(P360_DD_Sub_Category__c subCategory : subCategoryList){
            setOfSubCategoryIds.add(subCategory.P360_Category_Name__c);
        }   
        List<P360_DA_DD_Categories_Linkage__c> categoryLinkage = [ SELECT Id, P360_DA_Category_Name__c FROM P360_DA_DD_Categories_Linkage__c 
                                                                  WHERE P360_DA_Category_Name__c =: setOfSubCategoryIds ]; 
        
        Map< Id, Id > categoryLinkageMap = new Map< Id, Id >();
        for(P360_DA_DD_Categories_Linkage__c catLink : categoryLinkage){
            categoryLinkageMap.put(catLink.P360_DA_Category_Name__c, catLink.Id);
        }
        
        List < P360_DA_DD_Sub_Category_Linkage__c > subCategoryLinkageList = new List < P360_DA_DD_Sub_Category_Linkage__c > ();
        // Logic to create records in P360_DA_DD_Sub_Category_Linkage__c
        for (P360_DD_Sub_Category__c newSubCategory : subCategoryList) {
            P360_DA_DD_Sub_Category_Linkage__c ddSubCategoryLinkage = new P360_DA_DD_Sub_Category_Linkage__c();
            //Mapping field mappings of P360_DA_DD_Sub_Category_Linkage__c with P360_DD_Sub_Category__c 
            ddSubCategoryLinkage.P360_DA_Sub_Category_Name__c = newSubCategory.Id;
            ddSubCategoryLinkage.P360_DA_Linked_Due_Diligence_Name__c=newSubCategory.P360_Due_Diligence_Name__c;
            ddSubCategoryLinkage.P360_DA_DD_Category_Linkage__c = categoryLinkageMap.get(newSubCategory.P360_Category_Name__c);
            if(newSubCategory.P360_DA_Sub_Category_ID__r.P360_DA_Sub_Category_Name__c != NULL){
                if(newSubCategory.P360_DA_Sub_Category_ID__r.P360_DA_Sub_Category_Name__c.length() >= 80){
                    ddSubCategoryLinkage.Name = newSubCategory.P360_DA_Sub_Category_ID__r.P360_DA_Sub_Category_Name__c.substring(0, 80);
                }else{
                    ddSubCategoryLinkage.Name = newSubCategory.P360_DA_Sub_Category_ID__r.P360_DA_Sub_Category_Name__c;
                }
            }
            //ddSubCategoryLinkage.P360_DA_SC_Linked_Status__c = 'Cloned';
            subCategoryLinkageList.add(ddSubCategoryLinkage);
        }
        System.debug('subCategoryLinkageList' + subCategoryLinkageList);
        
        if (!subCategoryLinkageList.isEmpty()) {
            try{
                // Insert the created records
                insert subCategoryLinkageList;
                System.debug('P360_DA_DD_Sub_Category_Linkage__c Created Record Succesfully');
            }catch (Exception e) {
                system.debug('Error' +e);
                // Handle any exceptions during record insertion
                throw new AuraHandledException(e.getMessage());
            }
        }       
    }
    
    public Static void updateExternalId(List<P360_DD_Sub_Category__c> subCatList){
        for(P360_DD_Sub_Category__c subCat : subCatList){
            if(subCat.P360_Primary_External_ID__c == NULL){
                subCat.P360_Primary_External_ID__c = String.valueOf(subCat.P360_DA_Sub_Category_ID__c) + String.valueOf(subCat.P360_Due_Diligence_Name__c);
            }
        }
    }
}