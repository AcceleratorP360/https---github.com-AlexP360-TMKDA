/*
* Trigger: ReviewAreaLinkageCreateRecord
* Description: Trigger to handle the creation of records in ObjectDD Review Areas Linkage when record is created in object Review Areas.
* Created Date: 13/11/2023 
* Last Modified: 14/11/2023
*/
trigger CreateReviewAreaLinkageRecord on P360_Review_Area__c (after insert, before delete, before insert) {
    if (Trigger.isAfter && Trigger.isInsert) {
        ReviewAreaLinkageCreateRecord.createRecord(Trigger.new);
    }
    
    if (Trigger.isBefore && Trigger.isDelete) {
        DeleteDuplicateReviewLinkageCtrl.deleteReviwAreaLinkage(Trigger.old);
    }
    
    if (Trigger.isBefore && Trigger.isInsert) {
        ReviewAreaLinkageCreateRecord.updateExternalId(Trigger.new);
    }
}