trigger CreateTaskOnPlannedassessmentEndDate on P360_Due_Diligence__c (after insert, after update) {
     List<Task> tasksToInsert = new List<Task>();
    
    // Iterate over the inserted or updated P360_Due_Diligence__c records
    for (P360_Due_Diligence__c DueDiligence : Trigger.new) {
        // Check if the p360_Planned_Assessment_End_Date__c is not null
        if (DueDiligence.p360_Planned_Assessment_End_Date__c != null && (DueDiligence.P360_Approval_Status__c =='Pending' ||DueDiligence.P360_Approval_Status__c=='In Progress')) {
            // Calculate the date one week before the p360_Planned_Assessment_End_Date__c
            Date followUpDate = DueDiligence.p360_Planned_Assessment_End_Date__c.addDays(-7);
            
            // Check if there are any existing follow-up tasks for this P360_Due_Diligence__c
            List<Task> existingTasks = [SELECT Id FROM Task WHERE WhatId = :DueDiligence.Id AND Subject = 'FollowUp on Due Diligence' AND ActivityDate = :followUpDate];
            if (existingTasks.isEmpty()) {
                // Create a new Task object with the appropriate values
                Task followUpTask = new Task();
                followUpTask.Subject = 'FollowUp on Due Diligence';
                followUpTask.ActivityDate = followUpDate;
                followUpTask.WhatId = DueDiligence.Id;
                 followUpTask.Description = 'Kindly follow up for the Due Diligence as the Approval Status is still in "Pending" or "In Progress" and Planned Assessment End date has only 7 days left ';
                // Add the Task object to the list of tasks to insert
                tasksToInsert.add(followUpTask);
            }
        }
    }
    
    // Insert the new Task objects
    insert tasksToInsert;
    }