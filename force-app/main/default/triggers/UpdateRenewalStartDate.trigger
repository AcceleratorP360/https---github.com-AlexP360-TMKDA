trigger UpdateRenewalStartDate on Task (after update) {
    // Collect Account Ids for related tasks
    Set<Id> accountIds = new Set<Id>();
    
    for (Task tmkSystemsTask : Trigger.new) {
        Task oldTask = Trigger.oldMap.get(tmkSystemsTask.Id);

        // Check if Task subject matches the specified pattern and status is changed to 'Completed'
        if (tmkSystemsTask.Subject != null 
            && tmkSystemsTask.Subject.startsWith('TMK Systems-') 
            && tmkSystemsTask.Status == 'Completed'
            && (oldTask == null || oldTask.Status != 'Completed')) {
            accountIds.add(tmkSystemsTask.WhatId);
        }
    }

    // Query for related Accounts and their necessary fields
    List<Account> accountsToUpdate = [SELECT Id, P360_DD_renewal_start_date__c, P360_Date_of_Lloyd_s_Approval__c, P360_DA_TPA_Stages__c
                                      FROM Account
                                      WHERE Id IN :accountIds];

    // Update P360_DD_renewal_start_date__c based on criteria
    List<Account> accountsToUpdateList = new List<Account>();
    for (Account acc : accountsToUpdate) {
        // Perform additional checks for stage
        if (acc.P360_DD_renewal_start_date__c == null
            && acc.P360_Date_of_Lloyd_s_Approval__c != null
            && acc.P360_DA_TPA_Stages__c == 'P360_Post_approval_updates') {
            
            // Calculate P360_DD_renewal_start_date__c as P360_Date_of_Lloyd_s_Approval__c + 7 months
            acc.P360_DD_renewal_start_date__c = acc.P360_Date_of_Lloyd_s_Approval__c.addMonths(7);
            accountsToUpdateList.add(acc);
        }
    }

    // Update the Account records
    if (!accountsToUpdateList.isEmpty()) {
        update accountsToUpdateList;
    }
}