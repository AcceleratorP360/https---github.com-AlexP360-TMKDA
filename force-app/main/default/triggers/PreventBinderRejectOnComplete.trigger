trigger PreventBinderRejectOnComplete on P360_Binder__c (before update) {
    for(P360_Binder__c binder : Trigger.new) {
        P360_Binder__c oldBinder = Trigger.oldMap.get(binder.Id);
        if (oldBinder.Stages__c == 'Successful' && binder.Stages__c == 'Rejected') {
            binder.Stages__c.addError('Cannot change stage from Approval completed to Not Approved.');
        }
    }
}