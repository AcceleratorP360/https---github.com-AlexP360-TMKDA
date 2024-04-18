trigger ConnectiontypeTrigger on Account (before insert, before update) {
    for (Account acc : Trigger.new) {
        // Check if the stage is P360_Define_hierarchy
        if (acc.P360_DA_TPA_Stages__c == 'P360_DA_Duediligence') {
            // Check if the Connection Type is blank
            if (String.isBlank(acc.P360_Connection_Type__c)) {
                acc.addError('Connection Type is required when the stage is Define hierarchy');
            }
        }
    }
}