public with sharing class PrepopulateDueDiligenceLookupClass {
    @AuraEnabled
    public static void prepopulateDueDiligenceLookup(Id dueDiligenceId, List<P360_DD_Category__c> categories) {
        // Set the DueDiligence__c field on each Category__c record
        for (P360_DD_Category__c categoryRecord : categories) {
            categoryRecord.P360_Due_Diligence_Name__c = dueDiligenceId;
        }
        
        // Update the records in the database
        update categories;
    }
}