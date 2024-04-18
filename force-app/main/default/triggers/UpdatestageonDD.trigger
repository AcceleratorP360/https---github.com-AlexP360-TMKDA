/* Trigger update the dd stage on basis of Claims authority and Out of scope field 
   Date : 15-DEC-2023 
   Created by : Md Sarwar Alam*/
   

trigger UpdatestageonDD on P360_Due_Diligence__c (before insert,before update) {
    for (P360_Due_Diligence__c record : Trigger.new) {
        // Check conditions and update the Stage field accordingly
        if(record.TMKDA_Due_diligence_stages__c == 'Initiate Renewal'){
        if (record.TMKDA_Claims_Authority__c == 'Yes' && record.TMKDA_Out_of_Scope__c == 'Yes'&& record.P360_DD_Number_of_Live_Binders__c == 0) {
            record.TMKDA_Due_diligence_stages__c = 'OOS Request';
        } else if (record.TMKDA_Claims_Authority__c == 'Yes' && record.TMKDA_Out_of_Scope__c == 'No'&& record.P360_DD_Number_of_Live_Binders__c >= 1) {
            record.TMKDA_Due_diligence_stages__c = 'Reallocation';
        }
        }
    }
}