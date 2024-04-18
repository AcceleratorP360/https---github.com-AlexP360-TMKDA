trigger UpdateClosedDate on P360_Actions__c (before update) {
    for (P360_Actions__c action : Trigger.new) {
        P360_Actions__c oldAction = Trigger.oldMap.get(action.Id);
        if (action.Status__c == 'Closed' && oldAction.Status__c != 'Closed') {
            action.P360_Closed_Date__c = Date.today();
        }
    }
}