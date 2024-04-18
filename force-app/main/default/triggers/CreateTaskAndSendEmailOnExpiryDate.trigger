trigger CreateTaskAndSendEmailOnExpiryDate on P360_Binder__c (after insert, after update) {
    List<Task> tasksToInsert = new List<Task>();
    List<Messaging.SingleEmailMessage> emailsToSend = new List<Messaging.SingleEmailMessage>();

    // Iterate over the inserted or updated P360_Binder__c records
    for (P360_Binder__c binder : Trigger.new) {
        // Check if the P360_Expiry_Date__c is not null
        if (binder.P360_Expiry_Date__c != null) {
            // Calculate the date 30 days before the P360_Expiry_Date__c
            Date followUpDate = binder.P360_Expiry_Date__c.addDays(-30);

            // Check if the follow-up date is today's date
            if (followUpDate == Date.today()) {
                // Check if there is no existing follow-up task
                if ([SELECT COUNT() FROM Task WHERE WhatId = :binder.Id AND Subject = 'FollowUp-Contract is Expiring' AND ActivityDate = :followUpDate] == 0) {
                    // Create a new Task object with the appropriate values
                    Task followUpTask = new Task();
                    followUpTask.Subject = 'FollowUp-Contract is Expiring';
                    followUpTask.ActivityDate = followUpDate;
                    followUpTask.WhatId = binder.Id;
                    followUpTask.Description = 'Kindly follow up for the Binder Renewal';
                    // Add the Task object to the list of tasks to insert
                    tasksToInsert.add(followUpTask);

                    // Get the owner of the P360_Binder__c record
                    User owner = [SELECT Id, Email, Name FROM User WHERE Id = :binder.OwnerId];

                    // Create an email message
                    Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                  
                    email.setToAddresses(new List<String>{owner.Email});
                    email.setSubject('Follow-up Task for Expiring Binder: ' + binder.Name);
                    email.setPlainTextBody('Dear ' + owner.Name + ',\n\nA new follow-up task has been created for the expiring binder: ' + binder.Name + '.\n\nPlease take appropriate action to ensure that the binder is renewed on time.\n\nThanks and regards,\nSalesforce Admin');
                    emailsToSend.add(email);
                }
            }
        }
    }

    // Insert the new Task objects
    insert tasksToInsert;

    // Send the emails
    if (!emailsToSend.isEmpty()) {
        Messaging.sendEmail(emailsToSend);
    }
}