public class S3_BDX_LogFiles implements Database.Batchable<sObject> , Database.AllowsCallouts, Database.Stateful{
    
    Set<Id> stg_RecordIds;
    Map<String, List<String>> errorMap;
    public String docName;
    
    public S3_BDX_LogFiles(Set<Id> stg_RecordIds, Map<String, List<String>> errorMap, String docName){
        this.stg_RecordIds = stg_RecordIds;
        this.errorMap = errorMap;
        this.docName = docName;
    }
    
    public Database.querylocator Start(Database.BatchableContext bc){
        String query = 'SELECT Id, Name, P360_Serial_No__c, P360_UMR__c, P360_Coverholder_TPA__c, P360_Finding_Status__c, P360_Finding_Category__c, P360_Due_Date__c,'
            +' P360_Date_Completed__c, P360_YOA__c, P360_Audit_End_Date__c, P360_Audit_Reference__c FROM P360_STG_BDX__c WHERE Id =: stg_RecordIds';
        return Database.getQueryLocator(query);
    }
    
    public void execute(Database.BatchableContext bc, List<P360_STG_BDX__c> scope){
        
        List<String> csvLines = new List<String>();
        
        P360_BDX__mdt bdx_mdt = [ SELECT P360_UMR__c, P360_Coverholder_TPA__c, P360_Finding_Status__c, P360_Finding_Category__c, P360_Due_Date__c, 
                                 P360_Date_Completed__c, P360_YOA__c, P360_Audit_End_Date__c, P360_Audit_Reference__c FROM P360_BDX__mdt WHERE DeveloperName = 'BDX' LIMIT 1];
        
        csvLines.add(bdx_mdt.P360_UMR__c + ',' + bdx_mdt.P360_Coverholder_TPA__c + ',' + bdx_mdt.P360_Finding_Status__c + ',' + bdx_mdt.P360_Finding_Category__c 
                     + ',' + bdx_mdt.P360_Due_Date__c + ',' + bdx_mdt.P360_Date_Completed__c + ',' + bdx_mdt.P360_YOA__c + ',' + bdx_mdt.P360_Audit_End_Date__c 
                     + ',' + bdx_mdt.P360_Audit_Reference__c);
        
        for(P360_STG_BDX__c bdx : scope){            
            
            String csvRowVal = bdx.P360_UMR__c + ',' + bdx.P360_Coverholder_TPA__c + ',' + bdx.P360_Finding_Status__c + ',' + bdx.P360_Finding_Category__c 
                + ',' + bdx.P360_Due_Date__c + ',' + bdx.P360_Date_Completed__c + ',' + bdx.P360_YOA__c + ',' + bdx.P360_Audit_End_Date__c 
                + ',' + bdx.P360_Audit_Reference__c;
            csvLines.add(csvRowVal);
            
            if(errorMap.containsKey(bdx.P360_Serial_No__c)){
                errorMap.remove(bdx.P360_Serial_No__c);
            }
            
        }
        
        String csvBody = String.join(csvLines, '\n');
        S3_LogFilesCtrl.pushSuccessRecords(csvBody, 'BDX', docName.replace(' ','%20'));
    }
    
    public void finish(Database.BatchableContext bc){
        
        if(!errorMap.isEmpty() && errorMap.size() > 1){
            AsyncApexJob job = [SELECT Id FROM AsyncApexJob WHERE Id = :bc.getJobId()];
            S3_ErrorFile error_Batch = new S3_ErrorFile(errorMap, 'BDX', docName.replace(' ','%20'), job.Id);
            Database.executeBatch(error_Batch);
        }
    }
}