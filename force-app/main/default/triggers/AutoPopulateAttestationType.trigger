trigger AutoPopulateAttestationType on Account (before insert, before update) {      
   if (Trigger.isBefore) {
        for (Account acc : Trigger.new) {
            if (!Autopopulate_Attestation_Type_value.isFieldUpdatedByTrigger(acc, Trigger.oldMap)) {
                Autopopulate_Attestation_Type_value.autoPopulateAttestationType(acc);
            }
        }
    }
}