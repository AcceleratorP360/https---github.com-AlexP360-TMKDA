public class Autopopulate_Attestation_Type_value {
    
    public static Boolean isFieldUpdatedByTrigger(Account acc, Map<Id, Account> oldMap) {
        if (oldMap.containsKey(acc.Id)) {
            return acc.P360_Attestation_Type__c != oldMap.get(acc.Id).P360_Attestation_Type__c;
        }else
        return false;
    }

    public static void autoPopulateAttestationType(Account acc) {
        
        if (acc.P360_Syndicate_Number__c != null && acc.P360_Lloyd_PIN__c != null) {
            acc.P360_Attestation_Type__c = 'Light';
        } else if (acc.P360_Syndicate_Number__c != null && acc.P360_Lloyd_PIN__c == null) {
            acc.P360_Attestation_Type__c = 'Full';
        } else if (acc.P360_Europe_Syndicate_Number__c != null && acc.P360_Lloyd_PIN__c == null) {
            acc.P360_Attestation_Type__c = 'Light EU';
        } else {
            acc.P360_Attestation_Type__c = null; // or set to another default value
        }
    }
}