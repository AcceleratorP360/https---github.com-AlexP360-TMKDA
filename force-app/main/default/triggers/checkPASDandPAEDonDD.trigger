/* Trigger to check PASD date should not be less than Current Date 
 * PAED should be greater than or equal to PASD date 
 * Created on : 12-27-2023
 * Created by : Md Sarwar Alam 
 * modified on : 01-30-2024 */

trigger checkPASDandPAEDonDD on P360_Due_Diligence__c (before insert) {
    
    

    for (P360_Due_Diligence__c record : Trigger.new) {
        
        If(record.RecordType != null && record.RecordType.Name != 'TMKDA_MTA'){
        
        // Ensure PASD date is not older than today
        if (record.p360_Planned_Assessment_Start_Date__c != null && record.p360_Planned_Assessment_Start_Date__c < Date.today() ) {
            record.addError('Planned assessment start date cannot be older than current date');
        }

        // Ensure PAED date is greater than or equal to PASD date
        if (record.p360_Planned_Assessment_Start_Date__c != null && record.p360_Planned_Assessment_End_Date__c != null && record.p360_Planned_Assessment_End_Date__c < record.p360_Planned_Assessment_Start_Date__c ) {
            record.addError('Planned assessment end date must be greater than or equal to Planned assessment start date');
        }
    }
}
}