trigger UpdateOnboardingAndActiveFields on Account (before update) {
    for (Account acc : Trigger.new) {
        // Check if 'P360_Peer_Review_Outcome__c' has changed
        if (Trigger.oldMap.get(acc.Id).P360_Peer_Review_Outcome__c != acc.P360_Peer_Review_Outcome__c) {
            // If 'Pass' is selected, set 'P360_Onboarding_Stages__c' to 'Pending'
            if (acc.P360_Peer_Review_Outcome__c == 'Pass') {
                acc.P360_Onboarding_Stages__c = 'Pending';
            }
            // If 'Reject' is selected, set 'P360_Active__c' to 'No'
            else if (acc.P360_Peer_Review_Outcome__c == 'Reject') {
             acc.P360_Onboarding_Stages__c = 'Out of scope';
                acc.P360_Active__c= 'No';
            }
        }
    }
}