trigger PreventStageChange on P360_Binder__c (before update) {
    for (P360_Binder__c binder : Trigger.new) {
        if (binder.Stages__c == 'Successful' && Trigger.oldMap.get(binder.Id).Stages__c != 'Successful') {
            if (binder.Stages__c == 'Closure/Rejected') {
                binder.Stages__c.addError('Cannot move from Successful to Closure/Rejected stage.');
            }
        }
    }
}