public class S3_SD3a_LogFiles implements Database.Batchable<sObject>, Database.AllowsCallouts, Database.Stateful {
    
    public Set<Id> stg_RecordIds;
    Map<String, List<String>> errorMap;
    public String docName;
    
    public S3_SD3a_LogFiles(Set<Id> stg_RecordIds, Map<String, List<String>> errorMap, String docName){
        this.stg_RecordIds = stg_RecordIds;
        this.errorMap = errorMap;
        this.docName = docName;
    }
    
    public Database.querylocator Start(Database.BatchableContext bc){
        String query = 'SELECT Id, Name, P360_Serial_No__c, P360_Unique_Market_Reference_Number__c, P360_Contract_Unique_Identifier__c, P360_Section_Name__c, P360_Section_Unique_ID__c,'
            + ' P360_High_Level_Class_of_Business__c, P360_Regulatory_Client_Classification__c, P360_Currency_High_level_COB__c, P360_Value_High_level_COB__c,'
            + ' P360_Limit_Basis_High_level_COB__c, P360_Other_Limit_Basis_High_Level_COB__c FROM DCOM_High_COB_Max_limit__c WHERE Id =: stg_RecordIds';
        return Database.getQueryLocator(query);
    }
    
    public void execute(Database.BatchableContext bc, List<DCOM_High_COB_Max_limit__c> scope){
        
        List<String> csvLines = new List<String>();
        
        DCOM_High_COB_Max_limit_md__mdt sd3a_DCOM = [ SELECT P360_Unique_Market_Reference_Number__c, P360_Contract_Unique_Identifier__c, P360_Section_Name__c,
                                                     P360_Section_Unique_ID__c, P360_High_Level_Class_of_Business__c, P360_Regulatory_Client_Classification__c,
                                                     P360_Currency_High_level_COB__c, P360_Value_High_level_COB__c, P360_Limit_Basis_High_level_COB__c,
                                                     P360_Other_Limit_Basis_High_Level_COB__c FROM DCOM_High_COB_Max_limit_md__mdt WHERE DeveloperName = 'SD3a' LIMIT 1 ];
        
        csvLines.add(sd3a_DCOM.P360_Unique_Market_Reference_Number__c + ',' + sd3a_DCOM.P360_Contract_Unique_Identifier__c + ',' + sd3a_DCOM.P360_Section_Name__c 
                     + ',' + sd3a_DCOM.P360_Section_Unique_ID__c + ',' + sd3a_DCOM.P360_High_Level_Class_of_Business__c + ',' + sd3a_DCOM.P360_Regulatory_Client_Classification__c 
                     + ',' + sd3a_DCOM.P360_Currency_High_level_COB__c + ',' + sd3a_DCOM.P360_Value_High_level_COB__c + ',' + sd3a_DCOM.P360_Limit_Basis_High_level_COB__c 
                     + ',' + sd3a_DCOM.P360_Other_Limit_Basis_High_Level_COB__c);
        
        for(DCOM_High_COB_Max_limit__c sd3a : scope){
            
            String csvRowVal = sd3a.P360_Unique_Market_Reference_Number__c + ',' + sd3a.P360_Contract_Unique_Identifier__c
                + ',' + sd3a.P360_Section_Name__c + ',' + sd3a.P360_Section_Unique_ID__c
                + ',' + sd3a.P360_High_Level_Class_of_Business__c + ',' + sd3a.P360_Regulatory_Client_Classification__c
                + ',' + sd3a.P360_Currency_High_level_COB__c + ',' + sd3a.P360_Value_High_level_COB__c
                + ',' + sd3a.P360_Limit_Basis_High_level_COB__c + ',' + sd3a.P360_Other_Limit_Basis_High_Level_COB__c;
          
            csvLines.add(csvRowVal);
            
            if(errorMap.containsKey(sd3a.P360_Serial_No__c)){
                errorMap.remove(sd3a.P360_Serial_No__c);
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