trigger restrictbindertoclouser on P360_Binder__c (before update) {
    for (P360_Binder__c obj : Trigger.new) {
        // If the old and new status is "Successful"
        if (obj.Stages__c == 'Successful' && Trigger.oldMap.get(obj.Id).Stages__c == 'Successful') {
            // Check if the new stage is "Closure" or "Rejected"
            if (obj.Stages__c == 'Closure / Rejected') {
                // Throw a custom exception to prevent the record from being saved
                obj.addError('A record with "Successful" status cannot be moved to "Closure / Rejected" stage.');
            }
        }
    }
}