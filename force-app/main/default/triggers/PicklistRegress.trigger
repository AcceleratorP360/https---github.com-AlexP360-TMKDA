trigger PicklistRegress on P360_Binder__c (before update) {
    for(P360_Binder__c binder : Trigger.new) {
        P360_Binder__c oldBinder = Trigger.oldMap.get(binder.Id);
        
        // Map picklist values to numeric values for comparison
        Map<String, Integer> picklistValues = new Map<String, Integer>{
            'Initiation' => 1,
            'Analysis & Correspondence' => 2,
            'Approved' => 3,
            'Successful' => 4,
            'Rejected' => 5
        };
        
        // Compare picklist values numerically
        if(picklistValues.get(oldBinder.Stages__c) > picklistValues.get(binder.Stages__c)) {
            binder.Stages__c.addError('Cannot move back to previous stages.');
        }
    }
}