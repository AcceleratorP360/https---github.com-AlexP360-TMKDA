trigger CheckOwner on Task (before insert, before update) {
    if (Trigger.isInsert || Trigger.isUpdate) {
        List<Task> tasksToUpdate = new List<Task>();

        // Query the 'P360_Senior_DA_Analyst' Group Id
        Group seniorDAAnalystGroup = [SELECT Id FROM Group WHERE DeveloperName = 'P360_Senior_DA_Analyst' LIMIT 1];

        // Collect Account Ids with P360_Peer_review stage
        Set<Id> accountsWithPeerReview = new Set<Id>();
        for (Task task : [SELECT WhatId FROM Task WHERE WhatId IN :Trigger.newMap.keySet()]) {
            accountsWithPeerReview.add(task.WhatId);
        }

        for (Task task : Trigger.new) {
            // Check if the stage is "P360_Peer_review"
            if (accountsWithPeerReview.contains(task.WhatId)) {
                // Allow tasks with "P360_Peer_review" stage
                continue;
            }

            if ( task.P360_Task_Type__c == 'Peer Review') {
                if (seniorDAAnalystGroup != null) {
                    // Check if the Assigned To is a member of 'P360_Senior_DA_Analyst'
                    Set<Id> groupMemberIds = new Set<Id>();
                    for (GroupMember member : [SELECT UserOrGroupId FROM GroupMember WHERE GroupId = :seniorDAAnalystGroup.Id]) {
                        groupMemberIds.add(member.UserOrGroupId);
                    }

                    if (!groupMemberIds.contains(task.OwnerId)) {
                        task.addError('Please assign to Senior Analyst');
                    }
                }

                // Check if the Owner of the Task is the same as the Owner of the related Account
                if (task.WhatId != null) {
                    Account relatedAccount = [SELECT OwnerId, P360_DA_TPA_Stages__c FROM Account WHERE Id = :task.WhatId LIMIT 1];

                    if (relatedAccount != null && task.OwnerId == relatedAccount.OwnerId && relatedAccount.P360_DA_TPA_Stages__c == 'P360_Peer_review') {
                        task.addError('Please assign to Senior Analyst');
                    }
                }
            }
        }
    }
}