public with sharing class Linked_Review_Area_List {
    @AuraEnabled(cacheable=true)
    public static List<P360_DA_DD_Review_Area_Linkage__c> getReviewLinkageRecords(String categoryId) {
        // Query child records related to the provided parentId
        return [SELECT Id, Name, P360_DA_Linked_Due_Diligence_Name__c, TMKDA_Linked_Category__c , P360_DA_DD_Sub_Category_Linkage__c,
                       P360_DA_Review_Area_Name__c, TMKDA_Connect_To_Primary__c, Review_Point_linkage__c, Completion_Marker_linkage__c,
                       Severity_linkage__c,	Answer__c, 	Pass_Fail_linkage__c, 	P360_DA_Source__c, 	Comment__c
                FROM P360_DA_DD_Review_Area_Linkage__c
                WHERE TMKDA_Linked_Category__c = :categoryId];
    }
}