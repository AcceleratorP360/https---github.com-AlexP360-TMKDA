public with sharing class CustomController {
    public List<P360_DD_Category__c> allParentAccounts { get; set; }
    
    @AuraEnabled(cacheable=true)
    public static List<P360_DD_Category__c> getAllParentAccounts(String recordId) {
        return [SELECT Id, Name, P360_Assessment__c, P360_Commentary__c, Progress__c,
            (SELECT Id, Name, P360_Assessment__c, P360_Completion_Marker__c, P360_Inherent_Risk__c, P360_Summary_Final_Assessment__c
             FROM DD_sub_categories__r),
            P360_Completion_Marker__c, P360_Coverholder_TPA_Name__c, P360_Due_Diligence_Name__c, P360_Inherent_Risk__c, P360_Summary_Final_Assessment__c 
        FROM P360_DD_Category__c WHERE P360_Due_Diligence_Name__c = :recordId];
    }
    
    @AuraEnabled(cacheable=true)
    public static List<P360_DD_Sub_Category__c> getChildAccounts(Id recordId) {
        return [
            SELECT Name, P360_Assessment__c,
            (SELECT Name, P360_Assessment__c, P360_Completion_Marker__c, P360_Inherent_Risk__c 
            FROM DD_Sub_Category_Review_Areas__r)
            P360_Summary_Final_Assessment__c, P360_Completion_Marker__c, P360_Inherent_Risk__c
            FROM P360_DD_Sub_Category__c
            WHERE P360_Category_Name__c = :recordId
        ];
    }
    
    public void initialize(String recordId) {
        allParentAccounts = getAllParentAccounts(recordId);
    }
}