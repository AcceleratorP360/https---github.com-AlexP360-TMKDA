trigger UpdateP360ActiveStatus on Account (before insert, before update) {
    for (Account acc : Trigger.new) {
        // Check if the 'Status__c' is 'Approved' or 'Rejected'
        if (acc.Status__c == 'Approved') {
            acc.P360_Active__c = 'Yes';
        } else if (acc.Status__c == 'Rejected') {
            acc.P360_Active__c = 'No';

            // Check if P360_DA_TPA_Stages__c has changed
            if (Trigger.isUpdate && acc.P360_DA_TPA_Stages__c != Trigger.oldMap.get(acc.Id).P360_DA_TPA_Stages__c) {
                // Throw an error if trying to move to a different stage
                acc.P360_Active__c.addError('Status (Lloyd\'s Outcome) as Rejected cannot move the stage.');
            }
        }
        else if (acc.Status__c == 'Pending') {
            acc.P360_Active__c = 'None'; 
        }
    }
}