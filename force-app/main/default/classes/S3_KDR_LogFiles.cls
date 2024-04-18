public class S3_KDR_LogFiles implements Database.Batchable<sObject>, Database.AllowsCallouts, Database.Stateful{
    
    Set<Id> stg_RecordIds;
    Map<String, List<String>> errorMap;
    public String docName;
    
    public S3_KDR_LogFiles(Set<Id> stg_RecordIds, Map<String, List<String>> errorMap, String docName){
        this.stg_RecordIds = stg_RecordIds;
        this.errorMap = errorMap;
        this.docName = docName;
    }
    
    public Database.querylocator Start(Database.BatchableContext bc){
        String query = 'SELECT Id, Name, P360_Serial_No__c, P360_Unique_Market_Reference__c, P360_Inception_Date__c, P360_Expiry_Date__c, P360_Lead_Syndicate__c, P360_Policy_Reference__c,'
            + ' P360_Year_of_Account__c, P360_Line_Status__c, P360_Placing_Basis__c, P360_Contract_Record_Type__c, P360_Lloyds_Lead_Follow__c, P360_Underwriter__c,'
            +' P360_Budget_Epi_Gbp_Amt__c, P360_Contract_Status__c FROM P360_STG_KDR__c WHERE Id =: stg_RecordIds';
        return Database.getQueryLocator(query);
    }
    
    public void execute(Database.BatchableContext bc, List<P360_STG_KDR__c> scope){
        
        List<String> csvLines = new List<String>();
        
        P360_KDR__mdt kdr_mdt = [ SELECT P360_UNIQUE_MARKET_REFERENCE__c, P360_INCEPTION_DT__c, P360_EXPIRY_DT__c, P360_LEAD_SYNDICATE__c,
                                 P360_POLICY_REFERENCE__c, P360_YEAR_OF_ACCOUNT__c, P360_LINE_STATUS__c, P360_PLACING_BASIS__c, P360_CONTRACT_RECORD_TYPE__c,
                                 P360_LEAD_OR_FOLLOW__c, P360_UNDERWRITER__c, P360_BUDGET_EPI_GBP_AMT__c, P360_CONTRACT_STATUS__c FROM P360_KDR__mdt WHERE DeveloperName = 'KDR' LIMIT 1];
        
        csvLines.add(kdr_mdt.P360_UNIQUE_MARKET_REFERENCE__c + ',' + kdr_mdt.P360_INCEPTION_DT__c + ',' + kdr_mdt.P360_EXPIRY_DT__c + ',' + kdr_mdt.P360_LEAD_SYNDICATE__c 
                     + ',' + kdr_mdt.P360_POLICY_REFERENCE__c + ',' + kdr_mdt.P360_YEAR_OF_ACCOUNT__c + ',' + kdr_mdt.P360_LINE_STATUS__c + ',' + kdr_mdt.P360_PLACING_BASIS__c 
                     + ',' + kdr_mdt.P360_CONTRACT_RECORD_TYPE__c + ',' + kdr_mdt.P360_LEAD_OR_FOLLOW__c + ',' + kdr_mdt.P360_UNDERWRITER__c + ',' + kdr_mdt.P360_BUDGET_EPI_GBP_AMT__c 
                     + ',' + kdr_mdt.P360_CONTRACT_STATUS__c);
        
        for(P360_STG_KDR__c kdr : scope){            
            
            String csvRowVal = kdr.P360_Unique_Market_Reference__c + ',' + kdr.P360_Inception_Date__c + ',' + kdr.P360_Expiry_Date__c + ',' + kdr.P360_Lead_Syndicate__c 
                + ',' + kdr.P360_Policy_Reference__c + ',' + kdr.P360_Year_of_Account__c + ',' + kdr.P360_Line_Status__c + ',' + kdr.P360_Placing_Basis__c 
                + ',' + kdr.P360_Contract_Record_Type__c + ',' + kdr.P360_Lloyds_Lead_Follow__c + ',' + kdr.P360_Underwriter__c + ',' + kdr.P360_Budget_Epi_Gbp_Amt__c 
                + ',' + kdr.P360_Contract_Status__c;
            csvLines.add(csvRowVal);
            
            if(errorMap.containsKey(kdr.P360_Serial_No__c)){
                errorMap.remove(kdr.P360_Serial_No__c);
            }
        }
        
        String csvBody = String.join(csvLines, '\n');
        S3_LogFilesCtrl.pushSuccessRecords(csvBody, 'KDR', docName.replace(' ','%20'));
    }
    
    public void finish(Database.BatchableContext bc){
        
        if(!errorMap.isEmpty() && errorMap.size() > 1){
            AsyncApexJob job = [SELECT Id FROM AsyncApexJob WHERE Id = :bc.getJobId()];
            S3_ErrorFile error_Batch = new S3_ErrorFile(errorMap, 'KDR', docName.replace(' ','%20'), job.Id);
            Database.executeBatch(error_Batch);
        }
    }
}