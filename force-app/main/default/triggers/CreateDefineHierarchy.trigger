trigger CreateDefineHierarchy on Account (after update) {
    System.debug('Trigger Fired'); // Add this line for debugging purposes

  /*   if(Trigger.isAfter && Trigger.isUpdate){
        AccountTriggerHandler.handleAfterUpdateActivities(Trigger.New, Trigger.OldMap);
    } */
    
    List<Task> tasksToInsert = new List<Task>();
    // List<EmailMessage> emailMessagesToInsert = new List<EmailMessage>();
    
    List<Task> tasksToUpdate = new List<Task>();             
    List<Account> accountsToUpdate = new List<Account>();   
    
    

    //String toAddress = '';
    // Query the email address of the specific queue
    Group daAdvisoryQueue = [SELECT Email, Id FROM Group WHERE Type = 'Queue' AND Name = 'DA Senior Advisory Manager' LIMIT 1];
    
    Group daAnalystQueue = [SELECT Email, Id FROM Group WHERE Type = 'Queue' AND Name = 'Senior DA Analyst' LIMIT 1];

    // Query the email address of the DA Coordination Team queue
    Group daCoordinationQueue = [SELECT Id FROM Group WHERE Type = 'Queue' AND Name = 'DA Coordination Analyst' LIMIT 1];

    if (daAdvisoryQueue != null) {
        // toAddress = daAdvisoryQueue.Email;

        for (Account acc : Trigger.new) {
            Account oldAcc = Trigger.oldMap.get(acc.Id);
            Account accToUpdate = acc.clone();

            if (acc.P360_DA_TPA_Stages__c.equalsIgnoreCase('Reassign') &&
                !oldAcc.P360_DA_TPA_Stages__c.equalsIgnoreCase('Reassign')) {

                Task newTask = new Task();
                newTask.Subject = 'Reassign ' + acc.Name;
                newTask.Description = 'Please assign a DA Analyst to complete the onboarding for the new company.';
                newTask.WhatId = acc.Id;
                newTask.Status = 'Not Started';
                newTask.Priority = 'Normal';
                newTask.ActivityDate = Date.today();
                newTask.OwnerId = acc.OwnerId; 
                // newTask.OwnerId = daAdvisoryQueue.Id; 
                newTask.P360_Task_Type__c= 'Reassign';

                tasksToInsert.add(newTask);
            }
                    
            if (acc.P360_DA_TPA_Stages__c.equalsIgnoreCase('P360_Define_hierarchy') &&
                !oldAcc.P360_DA_TPA_Stages__c.equalsIgnoreCase('P360_Define_hierarchy')) {
                
            /*    List<Task> existingTasks = [SELECT Id, Status FROM Task WHERE WhatId = :acc.Id AND P360_Task_Type__c= 'Reassign' LIMIT 1];
                for (Task task : existingTasks) {
                    if (task.Status != 'Completed') {
                        task.Status = 'Completed';
                        update task;
                    }
                }*/
            }   

            if (acc.P360_DA_TPA_Stages__c == 'P360_Peer_review' && acc.P360_Peer_Review_Outcome__c == 'Revert') {
                Account accUpdate = new Account(
                    Id = acc.Id,
                    P360_DA_TPA_Stages__c = 'P360_Prepare_attestation',
                    OwnerId = Trigger.OldMap.get(acc.Id).OwnerId,
                    P360_Peer_Review_Outcome__c = '',
                    P360_Peer_Review_Notes__c ='',
                    Status__c ='Pending'
                );
                accountsToUpdate.add(accUpdate);
                
                Task newTask = new Task(
                    WhatId = acc.Id,
                    Subject = 'Reverted Task - '+acc.Name,
                    P360_Task_Type__c = 'TMKDA_CH onboarding - Prepare Lloyd\'s Attestation',
                    Description = 'Lloyd\'s attestation has been reverted. Please find the review notes below and resubmit. Peer review notes : ' + acc.P360_Peer_Review_Notes__c
                );
                tasksToInsert.add(newTask);
            }
            
  /*        List<Task> existingTasks = [SELECT Id, Status FROM Task WHERE WhatId = :acc.Id AND Type = 'Peer Review' AND Status != 'Completed'];
                for (Task tsk : existingTasks) {
                    tsk.Status = 'Completed';
                    tasksToUpdate.add(tsk);
                } */
                 
          /*   if (acc.P360_DA_TPA_Stages__c.equalsIgnoreCase('P360_Peer_review') &&
                oldAcc.P360_DA_TPA_Stages__c.equalsIgnoreCase('P360_Prepare_attestation')) {
                    Account accUpdate = new Account(
                    Id = acc.Id,
                    OwnerId = Trigger.OldMap.get(acc.Id).OwnerId
                );
                accountsToUpdate.add(accUpdate);
                } */
            
            if (acc.P360_DA_TPA_Stages__c.equalsIgnoreCase('P360_Peer_review') &&
                !oldAcc.P360_DA_TPA_Stages__c.equalsIgnoreCase('P360_Peer_review')) {

                Task peerReviewTask = new Task();
                peerReviewTask.Subject = 'Peer Review Task- ' + acc.Name;
                peerReviewTask.Description = 'Peer Review task needs attention.';
                peerReviewTask.WhatId = acc.Id;
                peerReviewTask.Status = 'Not Started';
                peerReviewTask.Priority = 'Normal';
                peerReviewTask.ActivityDate = Date.today();
                peerReviewTask.OwnerId = daAnalystQueue.Id; 
                peerReviewTask.P360_Task_Type__c = 'Peer Review';
                tasksToInsert.add(peerReviewTask);
                    
                 List<Task> existingTasks = [SELECT Id, Status FROM Task WHERE WhatId = :acc.Id AND P360_Task_Type__c= 'TMKDA_CH onboarding - Prepare Lloyd\'s Attestation' LIMIT 1];
                for (Task task : existingTasks) {
                    if (task.Status != 'Completed') {
                        task.Status = 'Completed';
                       tasksToUpdate.add(task);
                    }
                }
            }
            
            if (acc.P360_DA_TPA_Stages__c.equalsIgnoreCase('P360_Submit_to_Lloyd\'s') &&
                !oldAcc.P360_DA_TPA_Stages__c.equalsIgnoreCase('P360_Submit_to_Lloyd\'s')) {
                
                List<Task> existingTasks = [SELECT Id, Status FROM Task WHERE WhatId = :acc.Id AND P360_Task_Type__c= 'Peer Review' LIMIT 1];
                for (Task task : existingTasks) {
                    if (task.Status != 'Completed') {
                        task.Status = 'Completed';
                        update task;
                    }
                }
            }  
            
            if (acc.P360_DA_TPA_Stages__c.equalsIgnoreCase('P360_Submit_to_Lloyd\'s') &&
                !oldAcc.P360_DA_TPA_Stages__c.equalsIgnoreCase('P360_Submit_to_Lloyd\'s')) {

                Task submitToLloydsTask = new Task();
                submitToLloydsTask.Subject = 'Submit the Attestation paper to Lloyd\'s for ' + acc.Name;
                submitToLloydsTask.Description = 'Lloyd\'s attestation has been approved. Please send an email to Lloyd\'s.';
                submitToLloydsTask.WhatId = acc.Id;
                submitToLloydsTask.Status = 'Not Started';
                submitToLloydsTask.Priority = 'Normal';
                submitToLloydsTask.ActivityDate = Date.today();
                submitToLloydsTask.OwnerId = Trigger.OldMap.get(acc.Id).OwnerId; 
                submitToLloydsTask.P360_Task_Type__c = 'TMKDA_CH onboarding - Submit to Lloyd\'s';
                tasksToInsert.add(submitToLloydsTask);
            }

            if (acc.P360_DA_TPA_Stages__c.equalsIgnoreCase('P360_Record_Lloyd\'s_decision') &&
                !oldAcc.P360_DA_TPA_Stages__c.equalsIgnoreCase('P360_Record_Lloyd\'s_decision')) {
                
                List<Task> existingTasks = [SELECT Id, Status FROM Task WHERE WhatId = :acc.Id AND P360_Task_Type__c= 'TMKDA_CH onboarding - Submit to Lloyd\'s' LIMIT 1];
                for (Task task : existingTasks) {
                    if (task.Status != 'Completed') {
                        task.Status = 'Completed';
                        update task;
                    }
                }
            } 
                                                                        
            if (acc.P360_DA_TPA_Stages__c.equalsIgnoreCase('P360_Post_approval_updates') &&
                !oldAcc.P360_DA_TPA_Stages__c.equalsIgnoreCase('P360_Post_approval_updates')) {

                Boolean taskExists = [SELECT COUNT() FROM Task WHERE WhatId = :acc.Id AND Subject = 'Update High Monitor Contract List'] > 0;

                if (!taskExists) {
                    Task updateContractTask = new Task();
                    updateContractTask.Subject = 'Update High Monitor Contract List-' + acc.Name;
                    updateContractTask.Description = 'Update the High Monitor Contract List checkbox, once the High Monitor Contract List has been updated in the internal systems.';
                    updateContractTask.WhatId = acc.Id;
                    updateContractTask.Status = 'Not Started';
                    updateContractTask.Priority = 'Normal';
                    updateContractTask.ActivityDate = Date.today();
                    updateContractTask.OwnerId = daCoordinationQueue.Id; 
                    updateContractTask.P360_Task_Type__c = 'Update High Monitor Contract List';
                    tasksToInsert.add(updateContractTask);
                }

                taskExists = [SELECT COUNT() FROM Task WHERE WhatId = :acc.Id AND Subject = 'TMK Systems'] > 0;

                if (!taskExists) {
                    Task tmkSystemsTask = new Task();
                    tmkSystemsTask.Subject = 'Record updates completed in TMK Systems for CH - ' + acc.Name;
                    tmkSystemsTask.Description = 'Task for TMK systems update';
                    tmkSystemsTask.WhatId = acc.Id;
                    tmkSystemsTask.Status = 'Not Started';
                    tmkSystemsTask.Priority = 'Normal';
                    tmkSystemsTask.ActivityDate = Date.today();
                    tmkSystemsTask.OwnerId = daCoordinationQueue.Id; 
                    tmkSystemsTask.P360_Task_Type__c = 'Update TMK systems';
                    tasksToInsert.add(tmkSystemsTask);
                }
            }
            
             if (acc.P360_DA_TPA_Stages__c.equalsIgnoreCase('P360_Record_Lloyd\'s_decision') &&
                !oldAcc.P360_DA_TPA_Stages__c.equalsIgnoreCase('P360_Record_Lloyd\'s_decision')) {
             
                    List<Task> existingTasks = [
                        SELECT Id, Status 
                        FROM Task 
                        WHERE WhatId = :acc.Id 
                        AND (P360_Task_Type__c = 'Update High Monitor Contract List' OR P360_Task_Type__c = 'Update TMK Systems')
                    ];

                    for (Task task : existingTasks) {
                    if (task.Status != 'Completed') {
                        task.Status = 'Completed';
                        update task;
                    }
                }
            } 
        }
    }

    if (!tasksToInsert.isEmpty()) {
        insert tasksToInsert;
    }
    
        if (!tasksToUpdate.isEmpty()) {
            update tasksToUpdate;
        }
        if (!accountsToUpdate.isEmpty()) {
            update accountsToUpdate;
        }

    // if (!emailMessagesToInsert.isEmpty()) {
    //     insert emailMessagesToInsert;
    // }
}