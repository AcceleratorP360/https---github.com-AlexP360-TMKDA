trigger OutcomeRevert on Account (after update) {
    // List to store tasks to be inserted
    List<Task> tasksToInsert = new List<Task>();

    for (Account acc : Trigger.new) {
        // Check if the picklist field is updated to 'Revert'
        if (Trigger.oldMap.get(acc.Id).P360_Peer_Review_Outcome__c != acc.P360_Peer_Review_Outcome__c
            && acc.P360_Peer_Review_Outcome__c == 'Revert') {

            // Create a new Task record for 'Revert' scenario
            Task newTask = new Task();
            newTask.WhatId = acc.Id; // Link the task to the account
            newTask.OwnerId = [SELECT Id FROM Group WHERE DeveloperName = 'P360_DA_Advisory_Queue'].Id; // Replace 'P360_DA_Advisory_Queue' with the actual DeveloperName of your group
            newTask.Subject = 'Peer Review'; // Auto-populate the subject
            newTask.P360_Task_Type__c = 'Peer Review'; // Set the custom field value

            tasksToInsert.add(newTask);
        }

        // Check if the picklist field is updated to 'Pass'
        if (Trigger.oldMap.get(acc.Id).P360_Peer_Review_Outcome__c != acc.P360_Peer_Review_Outcome__c
            && acc.P360_Peer_Review_Outcome__c == 'Pass') {

            // Create a new Task record for 'Pass' scenario
            Task newTask = new Task();
            newTask.WhatId = acc.Id; // Link the task to the account
            newTask.OwnerId = acc.OwnerId; // Assign the task to the owner of the account
            newTask.Subject = 'Peer Review Passed'; // Auto-populate the subject
            newTask.P360_Task_Type__c = 'Peer Review Passed'; // Set the custom field value

            tasksToInsert.add(newTask);
        }
    }

    // Insert the new tasks
    if (!tasksToInsert.isEmpty()) {
        insert tasksToInsert;
    }
}