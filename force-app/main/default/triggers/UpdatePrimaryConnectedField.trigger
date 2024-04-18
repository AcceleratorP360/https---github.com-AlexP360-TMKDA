trigger UpdatePrimaryConnectedField on Account (before update) {
    for (Account acc : Trigger.new) {
        // Check if the P360_Connection_Type__c field is being changed to 'Primary', 'Solo', or 'None'
        if (acc.P360_Connection_Type__c == 'Primary' || acc.P360_Connection_Type__c == 'Solo' || acc.P360_Connection_Type__c == 'None') {
            // Set the P360_Primary_Connected__c field to NULL
            acc.P360_Primary_Connected__c = null;
        }
    }
}