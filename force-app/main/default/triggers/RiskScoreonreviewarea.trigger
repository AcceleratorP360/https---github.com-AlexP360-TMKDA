trigger RiskScoreonreviewarea on P360_Review_Area__c (after insert) {
    for (P360_Review_Area__c RArea : Trigger.new) {
        if (RArea.P360_Assessment__c != null && RArea.P360_RA_Weighting__c != null && RArea.P360_RA_Weighting_Total__c != null) {
            if (RArea.P360_Assessment__c == 'Red') {
                RArea.P360_RA_Assessment_Score__c = 50 * RArea.P360_RA_Weighting__c * RArea.P360_RA_Weighting_Total__c;
            } else if (RArea.P360_Assessment__c == 'Amber') {
                RArea.P360_RA_Assessment_Score__c = 7 * RArea.P360_RA_Weighting__c * RArea.P360_RA_Weighting_Total__c;
            } else if (RArea.P360_Assessment__c == 'Green') {
                RArea.P360_RA_Assessment_Score__c = 1 * RArea.P360_RA_Weighting__c * RArea.P360_RA_Weighting_Total__c;
            } else {
                RArea.P360_RA_Assessment_Score__c = null;
            }
        } else {
            RArea.P360_RA_Assessment_Score__c = null;
        }
    }
}