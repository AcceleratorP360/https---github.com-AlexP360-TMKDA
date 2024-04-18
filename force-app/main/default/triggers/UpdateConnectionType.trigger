trigger UpdateConnectionType on Account (before update) {
    for (Account acc : Trigger.new) {
        Account oldAcc = Trigger.oldMap.get(acc.Id);

        // Check if 'Status__c' has been changed to 'Rejected'
        if (acc.Status__c == 'Rejected' && (oldAcc == null || oldAcc.Status__c != 'Rejected')) {
            // Set 'P360_Connection_Type__c' to 'None'
            acc.P360_Connection_Type__c = '';
        }
    }
}