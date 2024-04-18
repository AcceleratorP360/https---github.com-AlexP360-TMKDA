Trigger Updateddrenewal on Account (before insert, before update) {
   for (Account acc : Trigger.new) {
        // Before update scenario
        if (Trigger.isUpdate) {
            Account oldAcc = Trigger.oldMap.get(acc.Id);

            // Check if Lloyd's Approval Status is changed to 'Pending' or 'Rejected'
            if (oldAcc != null && (
                    (acc.Status__c == 'Pending' || acc.Status__c == 'Rejected') &&
                    acc.Status__c != oldAcc.Status__c
                )) {
                acc.P360_Date_of_Lloyd_s_Approval__c = null;
            }
        }

        // Check if the approval date is not null
        if (acc.P360_Date_of_Lloyd_s_Approval__c != null) {
            // Calculate the renewal start date by adding 7 months to the approval date
            acc.P360_DD_renewal_start_date__c = acc.P360_Date_of_Lloyd_s_Approval__c.addMonths(7);
        }
    }
}