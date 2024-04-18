public class S3_SD8_LogFiles implements Database.Batchable<sObject>, Database.AllowsCallouts, Database.Stateful{
    
    public Set<Id> stg_RecordIds;
    Map<String, List<String>> errorMap;
    public String docName;
    
    public S3_SD8_LogFiles(Set<Id> stg_RecordIds, Map<String, List<String>> errorMap, String docName){
        this.stg_RecordIds = stg_RecordIds;
        this.errorMap = errorMap;
        this.docName = docName;
    }
    
    public Database.querylocator Start(Database.BatchableContext bc){
        String query = 'SELECT Id, Name, P360_Serial_No__c, P360_Unique_Market_Reference_Number__c, P360_Contract_Unique_Identifier__c, P360_Section_Name__c, P360_Section_Unique_ID__c,'
            + ' P360_Is_claims_handling_authority_CH__c, P360_Is_claims_handling_authorityDCA__c, P360_Currency__c, P360_Value__c, P360_First_Name__c, P360_Surname__c,'
            + ' P360_DCA_Name__c, P360_DCA_PIN__c, P360_DCA_Address__c, P360_Is_complaints_handling_authoirty_CH__c, P360_Is_complaint_handling_authoirtyDCA__c,'
            + ' P360_Will_policies_be_issued_to_eligible__c FROM P360_DCOM_Claims_Complaints__c WHERE Id =: stg_RecordIds';
        return Database.getQueryLocator(query);
    }
    
    public void execute(Database.BatchableContext bc, List<P360_DCOM_Claims_Complaints__c> scope){
        
        List<String> csvLines = new List<String>();
        
        P360_DCOM_Claims_Complaints_md__mdt sd8_DCOM = [ SELECT P360_Unique_Market_Reference_Number__c, P360_Contract_Unique_Identifier__c, P360_Section_Name__c,
                                                        P360_Section_Unique_ID__c, P360_Is_claims_handling_authority_CH__c, P360_Is_claims_handling_authorityDCA__c,
                                                        P360_Currency__c, P360_Value__c, P360_First_Name__c, P360_Surname__c, P360_DCA_Name__c,
                                                        P360_DCA_PIN__c, P360_DCA_Address__c, P360_Is_complaints_handling_authoirty_CH__c, P360_Is_complaint_handling_authoirtyDCA__c,
                                                        P360_Will_policies_be_issued_to_eligible__c FROM P360_DCOM_Claims_Complaints_md__mdt WHERE DeveloperName = 'SD8' ];
        
        csvLines.add(sd8_DCOM.P360_Unique_Market_Reference_Number__c + ',' + sd8_DCOM.P360_Contract_Unique_Identifier__c + ',' + sd8_DCOM.P360_Section_Name__c 
                     + ',' + sd8_DCOM.P360_Section_Unique_ID__c + ',' + sd8_DCOM.P360_Is_claims_handling_authority_CH__c + ',' + sd8_DCOM.P360_Is_claims_handling_authorityDCA__c 
                     + ',' + sd8_DCOM.P360_Currency__c + ',' + sd8_DCOM.P360_Value__c + ',' + sd8_DCOM.P360_First_Name__c + ',' + sd8_DCOM.P360_Surname__c 
                     + ',' + sd8_DCOM.P360_DCA_Name__c + ',' + sd8_DCOM.P360_DCA_PIN__c + ',' + sd8_DCOM.P360_DCA_Address__c 
                     + ',' + sd8_DCOM.P360_Is_complaints_handling_authoirty_CH__c + ',' + sd8_DCOM.P360_Is_complaint_handling_authoirtyDCA__c 
                     + ',' + sd8_DCOM.P360_Will_policies_be_issued_to_eligible__c);
        
        for(P360_DCOM_Claims_Complaints__c sd8 : scope){
            String csvRowVal = sd8.P360_Unique_Market_Reference_Number__c + ',' + sd8.P360_Contract_Unique_Identifier__c
                + ',' + sd8.P360_Section_Name__c + ',' + sd8.P360_Section_Unique_ID__c
                + ',' + sd8.P360_Is_claims_handling_authority_CH__c + ',' + sd8.P360_Is_claims_handling_authorityDCA__c
                + ',' + sd8.P360_Currency__c + ',' + sd8.P360_Value__c
                + ',' + sd8.P360_First_Name__c + ',' + sd8.P360_Surname__c
                + ',' + sd8.P360_DCA_Name__c + ',' + sd8.P360_DCA_PIN__c
                + ',' + sd8.P360_DCA_Address__c + ',' + sd8.P360_Is_complaints_handling_authoirty_CH__c
                + ',' + sd8.P360_Is_complaint_handling_authoirtyDCA__c + ',' + sd8.P360_Will_policies_be_issued_to_eligible__c;
            
            csvLines.add(csvRowVal);
            
            if(errorMap.containsKey(sd8.P360_Serial_No__c)){
                errorMap.remove(sd8.P360_Serial_No__c);
            }
        }
        
        String csvBody = String.join(csvLines, '\n');
        S3_LogFilesCtrl.pushSuccessRecords(csvBody, 'DCOM', docName.replace(' ','%20'));
        
    }
    
    public void finish(Database.BatchableContext bc){
        
        if(!errorMap.isEmpty() && errorMap.size() > 1){
            AsyncApexJob job = [SELECT Id FROM AsyncApexJob WHERE Id = :bc.getJobId()];
            S3_ErrorFile error_Batch = new S3_ErrorFile(errorMap, 'DCOM', docName.replace(' ','%20'), job.Id);
            Database.executeBatch(error_Batch);
        }
        
    }
}