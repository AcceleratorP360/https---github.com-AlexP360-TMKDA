trigger Clearoverriddenvalues on P360_Due_Diligence__c (before Update) {
    //check if checkbox is unchecked it will delete the Overriden Assessment and reason filed values.
    try {
        for (P360_Due_Diligence__c DD : Trigger.new) {
            if (!DD.P360_wouldyouliketooverride_assessment__c && (DD.P360_DD_Override_assessment__c != null || DD.P360_DD_Override_reason__c != null)) {
                DD.P360_DD_Override_assessment__c = null;
                DD.P360_DD_Override_reason__c = null;
            }
        }
    } catch (Exception e) {
        System.debug('An error occurred while executing the Clearoverriddenvalues trigger: ' + e.getMessage());//It will show this error.
    }
}