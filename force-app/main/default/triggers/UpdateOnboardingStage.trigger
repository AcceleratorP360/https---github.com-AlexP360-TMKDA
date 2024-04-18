trigger UpdateOnboardingStage on Account (before update) {
    for (Account acc : Trigger.new) {
        if(acc.P360_DA_TPA_Stages__c == 'P360_Initiate_CH_onboarding'){
            acc.P360_Onboarding_Stages__c = 'New';
        } else if (acc.P360_DA_TPA_Stages__c == 'Reassign') {
            acc.P360_Onboarding_Stages__c = 'Pending';
        } else if (acc.P360_DA_TPA_Stages__c == 'P360_DA_Duediligence') {
            acc.P360_Onboarding_Stages__c = 'Due diligence';
        } else if (acc.P360_DA_TPA_Stages__c == 'P360_Define_Hierarchy') {
            acc.P360_Onboarding_Stages__c = 'Define Hierarchy';
        } else if (acc.P360_DA_TPA_Stages__c == 'P360_Prepare_attestation') {
            acc.P360_Onboarding_Stages__c = 'Prepare attestation';
        } else if (acc.P360_DA_TPA_Stages__c == 'P360_Peer_review') {
            acc.P360_Onboarding_Stages__c = 'Peer Review';
             if (acc.P360_Peer_Review_Outcome__c == 'Pass') {
                acc.P360_Onboarding_Stages__c = 'Peer Review - Pass';
            } else if (acc.P360_Peer_Review_Outcome__c == 'Revert') {
            acc.P360_Onboarding_Stages__c = 'Peer Review - Revert with Comments';
            } else if (acc.P360_Peer_Review_Outcome__c == 'Reject') {
            acc.P360_Onboarding_Stages__c = 'Peer Review - Rejected';
            }
        } else if (acc.P360_DA_TPA_Stages__c == 'P360_Submit_to_Lloyd\'s') {
            acc.P360_Onboarding_Stages__c = 'Submit to Lloyd\'s';
        } else if (acc.P360_DA_TPA_Stages__c == 'P360_Record_Lloyd\'s_decision') {
            acc.P360_Onboarding_Stages__c = 'Awaiting Lloyd\'s decision';
        } else if (acc.P360_DA_TPA_Stages__c == 'P360_Post_approval_updates') {
            acc.P360_Onboarding_Stages__c = 'Post approval updates';
        }
    }
}