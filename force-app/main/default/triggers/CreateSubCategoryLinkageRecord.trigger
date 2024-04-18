/*
* Trigger: CategoryLinkageCreateRecord
* Description: Trigger to handle the creation of records in Object DD Sub-Categories when record is created in object Sub-Categories.
* Created Date: 13/11/2023 
* Last Modified: 14/11/2023
*/
trigger CreateSubCategoryLinkageRecord on P360_DD_Sub_Category__c (after insert, before insert) {
    if (Trigger.isAfter && Trigger.isInsert) {
        SubCategoryLinkageCreateRecord.createRecord(Trigger.new);
    }
    
    if(Trigger.isBefore && Trigger.isInsert){
        SubCategoryLinkageCreateRecord.updateExternalId(Trigger.new);
    }
    
}