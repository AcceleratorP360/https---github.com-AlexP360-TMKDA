trigger P360_BPA_Assign_key_UW on TMKDA_BPA_Summary_Header__c (before insert) {

    // Map to hold Account Id to P360_DA_UnderWriter_Name__c Contact Owner Id
    Map<Id, Id> accountToContactOwnerMap = new Map<Id, Id>();

    // Fetch all the Account Ids from the records being inserted
    Set<Id> accountIds = new Set<Id>();
    for (TMKDA_BPA_Summary_Header__c obj : Trigger.new) {
        accountIds.add(obj.TMKDA_Coverholder_DCA__c);
    }

    // Query to fetch the Account records and their related P360_DA_UnderWriter_Name__c Contact Owner Ids
    List<Account> accountsWithContactOwners = [SELECT Id, P360_DA_UnderWriter_Name__r.OwnerId FROM Account WHERE Id IN :accountIds];

    // Populate the accountToContactOwnerMap
    for (Account acc : accountsWithContactOwners) {
        if (acc.P360_DA_UnderWriter_Name__r != null && acc.P360_DA_UnderWriter_Name__r.OwnerId != null) {
            accountToContactOwnerMap.put(acc.Id, acc.P360_DA_UnderWriter_Name__r.OwnerId);
        }
    }

    // Loop through the records being inserted
    for (TMKDA_BPA_Summary_Header__c obj : Trigger.new) {
        // Check if the Account has a related Contact with P360_DA_UnderWriter_Name__c populated
        if (accountToContactOwnerMap.containsKey(obj.TMKDA_Coverholder_DCA__c)) {
            // Set the TMKDA_Assigned_to_UW__c field to the Contact Owner Id
            obj.TMKDA_Assigned_to_UW__c = accountToContactOwnerMap.get(obj.TMKDA_Coverholder_DCA__c);
        }
    }
}