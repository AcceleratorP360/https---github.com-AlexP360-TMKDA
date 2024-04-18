/**
* Trigger: CreateCategoryLinkageRecord
* Description:creation of records in DDCategoriesLinkage object when new record is created in Categories object.
* Created Date: 14/11/2023 
* Last Modified: 14/11/2023
*/
trigger CreateCategoryLinkageRecord on P360_DD_Category__c (after insert, before insert) {
    if (Trigger.isAfter && Trigger.isInsert) {
        CategoryLinkageCreateRecord.handleAfterInsert(Trigger.new);
    }   
    
    if(Trigger.isBefore && Trigger.isInsert){
        CategoryLinkageCreateRecord.updateExternalId(Trigger.new);
    }
}