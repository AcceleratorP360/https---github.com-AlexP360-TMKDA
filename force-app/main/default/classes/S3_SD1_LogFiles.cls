public class S3_SD1_LogFiles implements Database.Batchable<sObject>, Database.AllowsCallouts, Database.Stateful{
    

    Set<Id> stg_RecordIds;
    Map<String, List<String>> errorMap;
    public String docName;
    
    public S3_SD1_LogFiles(Set<Id> stg_RecordIds, Map<String, List<String>> errorMap, String docName){
        this.stg_RecordIds = stg_RecordIds;
        this.errorMap = errorMap;
        this.docName = docName;
    }
    
    public Database.querylocator Start(Database.BatchableContext bc){
        String query = 'SELECT Id, Name, P360_Serial_No__c, P360_Unique_Market_Reference_Number__c, P360_Contract_Unique_Identifier__c, P360_Section_Name__c, P360_Section_Unique_ID__c,P360_Participant_Type__c, P360_Participant_Company_Name__c, P360_Participant_Trading_Name_s__c, P360_Participant_PIN__c, P360_Participant_Trading_Address__c, P360_Participant_Postal_Address__c, P360_Participant_Domicile__c, P360_Participant_Approval_Status__c FROM P360_STG_DCOM__c  WHERE Id =: stg_RecordIds';
        return Database.getQueryLocator(query);
    }
    
    public void execute(Database.BatchableContext bc, List<P360_STG_DCOM__c> scope){
        
        List<String> csvLines = new List<String>();
        
        P360_STG_DCOM_Coverholder_md__mdt sd1_DCOM = [ SELECT P360_Unique_Market_Reference_Number__c, P360_Contract_Unique_Identifier__c, 
                                                      P360_Section_Name__c, P360_Section_Unique_ID__c,
                                                      P360_Participant_Type__c, P360_Participant_Company_Name__c, P360_Participant_Trading_Name_s__c, P360_Participant_PIN__c, 
                                                      P360_Participant_Trading_Address__c, P360_Participant_Postal_Address__c, P360_Participant_Domicile__c, P360_Participant_Approval_Status__c
                                                      FROM P360_STG_DCOM_Coverholder_md__mdt WHERE DeveloperName = 'SD_1' LIMIT 1];
        
        csvLines.add(sd1_DCOM.P360_Unique_Market_Reference_Number__c + ',' + sd1_DCOM.P360_Contract_Unique_Identifier__c
                     + ',' + sd1_DCOM.P360_Section_Name__c + ',' + sd1_DCOM.P360_Section_Unique_ID__c
                     + ',' +  sd1_DCOM.P360_Participant_Type__c + ',' + sd1_DCOM.P360_Participant_Company_Name__c
                     + ',' +  sd1_DCOM.P360_Participant_Trading_Name_s__c + ',' + sd1_DCOM.P360_Participant_PIN__c
                     + ',' +  sd1_DCOM.P360_Participant_Trading_Address__c + ',' + sd1_DCOM.P360_Participant_Postal_Address__c
                     + ',' +  sd1_DCOM.P360_Participant_Domicile__c + ',' + sd1_DCOM.P360_Participant_Approval_Status__c);
        
        for(P360_STG_DCOM__c sd_1 : scope){
            String csvRowVal = sd_1.P360_Unique_Market_Reference_Number__c + ',' + sd_1.P360_Contract_Unique_Identifier__c
                + ',' + sd_1.P360_Section_Name__c + ',' + sd_1.P360_Section_Unique_ID__c
                + ',' + sd_1.P360_Participant_Type__c + ',' + sd_1.P360_Participant_Company_Name__c
                + ',' + sd_1.P360_Participant_Trading_Name_s__c + ',' + sd_1.P360_Participant_PIN__c
                + ',' + sd_1.P360_Participant_Trading_Address__c + ',' + sd_1.P360_Participant_Postal_Address__c
                + ',' + sd_1.P360_Participant_Domicile__c + ',' + sd_1.P360_Participant_Approval_Status__c;
            
            
            csvLines.add(csvRowVal);
            
            if(errorMap.containsKey(sd_1.P360_Serial_No__c)){
                errorMap.remove(sd_1.P360_Serial_No__c);
            }
            //csvMap.get(sd_1.Name.replace(' ','%20')).add(csvRowVal);
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