public with sharing class Category_Linkage {
    @AuraEnabled(cacheable=true)
    public static List<P360_DA_DD_Categories_Linkage__c> getCategoryLinkageRecords() {
        // Query parent records here
        return [SELECT Id, Name,P360_DA_Linked_Due_Diligence_Name__c,P360_DA_Category_Name__c FROM P360_DA_DD_Categories_Linkage__c];
    }
}