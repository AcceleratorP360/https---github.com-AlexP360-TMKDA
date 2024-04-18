trigger DDRenewalcreationTrigger on P360_Due_Diligence__c (after insert, after update) {
    // Check if the trigger context is after insert or after update
    if (Trigger.isAfter && (Trigger.isInsert || Trigger.isUpdate)) {
        // List to store records that need to be created
        for (P360_Due_Diligence__c dueDiligence : Trigger.new) {
        if (dueDiligence.TMKDA_New_Renewal_start_date__c == Date.today()) {
        renewalduediligencecnrtl.renewalcloneRecords(dueDiligence.Id);
        }
        }
    }
}