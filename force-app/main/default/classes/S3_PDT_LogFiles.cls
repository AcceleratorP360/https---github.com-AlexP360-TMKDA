public class S3_PDT_LogFiles implements Database.Batchable<sObject>, Database.AllowsCallouts, Database.Stateful{
    
    
    Set<Id> stg_RecordIds;
    Map<String, List<String>> errorMap;
    public String docName;
    
    public S3_PDT_LogFiles(Set<Id> stg_RecordIds, Map<String, List<String>> errorMap, String docName){
        this.stg_RecordIds = stg_RecordIds;
        this.errorMap = errorMap;
        this.docName = docName;
    }
    
    public Database.querylocator Start(Database.BatchableContext bc){
        String query = 'SELECT Id, Name, P360_Serial_No__c, P360_PDT_Number__c, P360_PDT_Status__c, P360_DA_Criteria__c, P360_Q7_Eclipse_Ref__c, P360_Q8_Contract_Type__c FROM P360_STG_PDT__c WHERE Id =: stg_RecordIds';
        return Database.getQueryLocator(query);
    }
    
    public void execute(Database.BatchableContext bc, List<P360_STG_PDT__c> scope){
        
        List<String> csvLines = new List<String>();
        
        P360_PDT__mdt pdt_mdt = [ SELECT P360_PDT_Number__c, P360_PDT_Status__c, P360_DA_Criteria__c, P360_Q6_New_Or_Renewal__c, P360_Q7_Eclipse_Ref__c, P360_Q8_Contract_Type__c 
                                 FROM P360_PDT__mdt WHERE DeveloperName = 'PDT' LIMIT 1];
        
        csvLines.add(pdt_mdt.P360_PDT_Number__c + ',' + pdt_mdt.P360_PDT_Status__c + ',' + pdt_mdt.P360_DA_Criteria__c + ',' + pdt_mdt.P360_Q6_New_Or_Renewal__c + ',' + pdt_mdt.P360_Q7_Eclipse_Ref__c 
                     + ',' + pdt_mdt.P360_Q8_Contract_Type__c);
        
        for(P360_STG_PDT__c pdt : scope){            
            
            String csvRowVal = pdt.P360_PDT_Number__c + ',' + pdt.P360_PDT_Status__c + ',' + pdt.P360_DA_Criteria__c + ',' + pdt.P360_Q7_Eclipse_Ref__c 
                + ',' + pdt.P360_Q8_Contract_Type__c;
            csvLines.add(csvRowVal);
            
            if(errorMap.containsKey(pdt.P360_Serial_No__c)){
                errorMap.remove(pdt.P360_Serial_No__c);
            }
        }
        
        String csvBody = String.join(csvLines, '\n');
        S3_LogFilesCtrl.pushSuccessRecords(csvBody, 'PDT', docName.replace(' ','%20'));
    }
    
    public void finish(Database.BatchableContext bc){
        if(!errorMap.isEmpty() && errorMap.size() > 1){
            AsyncApexJob job = [SELECT Id FROM AsyncApexJob WHERE Id = :bc.getJobId()];
            S3_ErrorFile error_Batch = new S3_ErrorFile(errorMap, 'PDT', docName.replace(' ','%20'), job.Id);
            Database.executeBatch(error_Batch);
        }
    }
}