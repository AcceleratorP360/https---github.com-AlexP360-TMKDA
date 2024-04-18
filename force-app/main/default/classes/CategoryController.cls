public with sharing class CategoryController {
    @AuraEnabled(cacheable=true)
   
    public static Id getCategoryDetails(Id recordId) {
        P360_DD_Category__c category;        

     category = [SELECT Id,Name, P360_Due_Diligence_Name__c FROM P360_DD_Category__c WHERE  Name =:recordId LIMIT 1 ];
    
       
        if(category != null) {
            return category.Id;
        }
        return null;
    }
    
    
}