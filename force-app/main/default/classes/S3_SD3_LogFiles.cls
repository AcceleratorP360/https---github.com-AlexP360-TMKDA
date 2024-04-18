public class S3_SD3_LogFiles implements Database.Batchable<sObject>, Database.AllowsCallouts, Database.Stateful {
    
    public Set<Id> stg_RecordIds;
    Map<String, List<String>> errorMap;
    public String docName;
    
    public S3_SD3_LogFiles(Set<Id> stg_RecordIds, Map<String, List<String>> errorMap, String docName){
        this.stg_RecordIds = stg_RecordIds;
        this.errorMap = errorMap;
        this.docName = docName;
    }
    
    public Database.querylocator Start(Database.BatchableContext bc){
        String query = 'SELECT Id, Name, P360_Serial_No__c, P360_Unique_Market_Reference_Number__c, P360_Contract_Unique_Identifier__c, P360_Section_Name__c, P360_Section_Unique_ID__c,'
            + ' P360_Distribution_Method__c, P360_Premium_level_of_authority__c, P360_Deductibles_andor_excesses__c, P360_Items_insured_Group_Insured_Item__c,'
            + ' P360_High_Level_Class_of_Business__c, P360_Generic_Class_of_Business__c, P360_Risk_codes_and_description__c FROM P360_DCOM_Authorized_COB__c WHERE Id =: stg_RecordIds';
        return Database.getQueryLocator(query);
    }
    
    public void execute(Database.BatchableContext bc, List<P360_DCOM_Authorized_COB__c> scope){
        
        List<String> csvLines = new List<String>();
        
        P360_DCOM_Authorized_COB_md__mdt sd3_DCOM = [ SELECT P360_Unique_Market_Reference_Number__c, P360_Contract_Unique_Identifier__c, P360_Section_Name__c, 
                                                     P360_Section_Unique_ID__c, P360_Distribution_Method__c, P360_Premium_level_of_authority__c, P360_Deductibles_andor_excesses__c, 
                                                     P360_Items_insured_Group_Insured_Item__c, P360_High_Level_Class_of_Business__c, P360_Generic_Class_of_Business__c,
                                                     P360_Risk_codes_and_description__c FROM P360_DCOM_Authorized_COB_md__mdt WHERE DeveloperName = 'SD3' LIMIT 1 ];
        
        csvLines.add(sd3_DCOM.P360_Unique_Market_Reference_Number__c + ',' + sd3_DCOM.P360_Contract_Unique_Identifier__c + ',' + sd3_DCOM.P360_Section_Name__c 
                     + ',' + sd3_DCOM.P360_Section_Unique_ID__c + ',' + sd3_DCOM.P360_Distribution_Method__c + ',' + sd3_DCOM.P360_Premium_level_of_authority__c 
                     + ',' + sd3_DCOM.P360_Deductibles_andor_excesses__c + ',' + sd3_DCOM.P360_Items_insured_Group_Insured_Item__c 
                     + ',' + sd3_DCOM.P360_High_Level_Class_of_Business__c + ',' + sd3_DCOM.P360_Generic_Class_of_Business__c + ',' + sd3_DCOM.P360_Risk_codes_and_description__c);
        
        for(P360_DCOM_Authorized_COB__c sd3 : scope){
            
            String csvRowVal = sd3.P360_Unique_Market_Reference_Number__c + ',' + sd3.P360_Contract_Unique_Identifier__c
                + ',' + sd3.P360_Section_Name__c + ',' + sd3.P360_Section_Unique_ID__c
                + ',' + sd3.P360_Distribution_Method__c + ',' + sd3.P360_Premium_level_of_authority__c
                + ',' + sd3.P360_Deductibles_andor_excesses__c + ',' + sd3.P360_Items_insured_Group_Insured_Item__c
                + ',' + sd3.P360_High_Level_Class_of_Business__c + ',' + sd3.P360_Generic_Class_of_Business__c
                + ',' + sd3.P360_Risk_codes_and_description__c;
            
            csvLines.add(csvRowVal);
            
            if(errorMap.containsKey(sd3.P360_Serial_No__c)){
                errorMap.remove(sd3.P360_Serial_No__c);
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