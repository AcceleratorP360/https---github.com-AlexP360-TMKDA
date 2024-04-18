trigger UpdateDDrecords on P360_Due_Diligence__c (before insert, before Update) {
    
    // List to hold Due Diligence records to be updated
    List<P360_Due_Diligence__c> dueDiligenceToUpdateList = new List<P360_Due_Diligence__c>();

    // Set to store unique Account IDs to be queried
    Set<Id> accountIds = new Set<Id>();

    // Collect the Account IDs of the parent records
    for (P360_Due_Diligence__c dueDiligence : Trigger.new) {
        accountIds.add(dueDiligence.P360_CoverHolder_TPA_Name__c);
    }

    // Query the parent Account records to get the required field values
    Map<Id, Account> accountMap = new Map<Id, Account>([SELECT Id, DD_Type__c,p360_DA_EPI__c,Coverholder_DCA__c,P360_DA_Earliest_Binder_Renewal__c,P360_Domicile__c,P360_Onboard_Date__c,Line_of_business__c,P360_Date_Last_DD_Completed__c,P360_Number_of_Live_Binders__c,P360_Key_Contact__c,P360_Number_of_Run_Off_Binders__c,P360_DA_Customer_Domicile__c,P360_Territorial_limits_risks__c,P360_Advisory_Grouping__c,P360_Due_Diligence_Connections__c,P360_DA_TPA_Summary__c FROM Account WHERE Id IN :accountIds]);

    // Loop through the Due Diligence records and update the fields with the corresponding parent field value
    for (P360_Due_Diligence__c dueDiligence : Trigger.new) {
        Account parentAccount = accountMap.get(dueDiligence.P360_CoverHolder_TPA_Name__c);
        if (parentAccount != null) {
            dueDiligence.P360_DD_Total_EPI__c = parentAccount.P360_EPI__c;
            //dueDiligence.P360_DD_Coverholder_or_DCA__c = parentAccount.Coverholder_DCA__c;
            //dueDiligence.P360_Due_Diligence_Type__c = parentAccount.DD_Type__c;
            //dueDiligence.P360_DD_Earliest_Binder_Renewal__c =parentAccount.P360_DA_Earliest_Binder_Renewal__c;
            dueDiligence.P360_DD_Customer_Domicile__c = parentAccount.P360_Domicile__c;
            //dueDiligence.P360_DD_Coverholder_Live_Date__c = parentAccount.P360_Onboard_Date__c;
            //dueDiligence.P360_DD_Line_of_Business__c = parentAccount.Line_of_business__c;
            //dueDiligence.P360_Date_Last_DD_Completed__c = parentAccount.P360_Date_Last_DD_Completed__c;
            //dueDiligence.P360_DD_Number_of_Live_Binders__c = parentAccount.P360_Number_of_Live_Binders__c;
           // dueDiligence.P360_DD_Key_Contact__c = parentAccount.P360_Key_Contact__c;
            //dueDiligence.P360_DD_Number_of_Run_Off_Binders__c = parentAccount.P360_Number_of_Run_Off_Binders__c;
            //dueDiligence.P360_DD_Customer_Domicile__c = parentAccount.P360_DA_Customer_Domicile__c;
            //dueDiligence.P360_DD_Risk_Location__c = parentAccount.P360_Territorial_limits_risks__c;
            //dueDiligence.P360_DD_Advisory_Grouping__c = parentAccount.P360_Advisory_Grouping__c;
            //dueDiligence.P360_Due_Diligence_Connection__c = parentAccount.P360_Due_Diligence_Connections__c;
            //dueDiligence.P360_Coverholder_TPA_summary__c = parentAccount.P360_DA_TPA_Summary__c;
            dueDiligenceToUpdateList.add(dueDiligence);
        }
    }

    // Update the Due Diligence records
    if (!dueDiligenceToUpdateList.isEmpty()) {
        update dueDiligenceToUpdateList;
    system.debug('due diligence is' +dueDiligenceToUpdateList);
    }
}