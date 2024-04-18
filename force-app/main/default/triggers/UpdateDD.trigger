trigger UpdateDD  on P360_Binder__c (after insert, after delete, after undelete) {
    Set<Id> binderIds = new Set<Id>();

    if (Trigger.isInsert || Trigger.isUpdate || Trigger.isUndelete) {
        for (P360_Binder__c binder : Trigger.new) {
            binderIds.add(binder.Id);
        }
    }

    if (Trigger.isUpdate || Trigger.isDelete) {
        for (P360_Binder__c binder : Trigger.old) {
            binderIds.add(binder.Id);
        }
    }

    if (!binderIds.isEmpty()) {
        List<P360_Binder__c> updatedBinders = new List<P360_Binder__c>();

        Map<Id, Integer> reasonCountMap = new Map<Id, Integer>();

        for (P360_MTA_Reasons__c reason : [SELECT BindersMTA__c, Due_Diligence_required__c FROM P360_MTA_Reasons__c WHERE BindersMTA__c IN :binderIds]) {
            if (reason.Due_Diligence_required__c == 'Yes') {
                if (!reasonCountMap.containsKey(reason.BindersMTA__c)) {
                    reasonCountMap.put(reason.BindersMTA__c, 1);
                } else {
                    Integer count = reasonCountMap.get(reason.BindersMTA__c);
                    reasonCountMap.put(reason.BindersMTA__c, count + 1);
                }
            }
        }

        for (P360_Binder__c binder : [SELECT Id, No_of_DD__c FROM P360_Binder__c WHERE Id IN :binderIds]) {
            if (reasonCountMap.containsKey(binder.Id)) {
                binder.No_of_DD__c = String.valueOf(reasonCountMap.get(binder.Id));
                updatedBinders.add(binder);
            } else {
                binder.No_of_DD__c = '0';
                updatedBinders.add(binder);
            }
        }

       // if (!updatedBinders.isEmpty()) {
           // update updatedBinders;
     //   }
    }
}