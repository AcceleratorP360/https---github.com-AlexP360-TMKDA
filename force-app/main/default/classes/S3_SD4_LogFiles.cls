public class S3_SD4_LogFiles implements Database.Batchable<sObject>, Database.AllowsCallouts, Database.Stateful {
    
    public Set<Id> stg_RecordIds;
    Map<String, List<String>> errorMap;
    public String docName;
    
    public S3_SD4_LogFiles(Set<Id> stg_RecordIds, Map<String, List<String>> errorMap, String docName){
        this.stg_RecordIds = stg_RecordIds;
        this.errorMap = errorMap;
        this.docName = docName;
    }
    
    public Database.querylocator Start(Database.BatchableContext bc){
        String query = 'SELECT Id, Name, P360_Serial_No__c, P360_Unique_Market_Reference_Number__c, P360_Contract_Unique_Identifier__c, P360_Section_Name__c, P360_Section_Unique_ID__c,'
            + ' P360_Worldwide__c, P360_Excluding__c, P360_Risk_Location_Region__c, P360_Risk_Location_Country__c, P360_Risk_Location_Division__c,'
            + ' P360_Worldwide_for_Insured_Domicile__c, P360_Excluding_for_excluded_countries__c, P360_Insured_Domicile_Region__c, P360_Insured_Domicile_Counrty__c,'
            + ' P360_Insured_Domicile_Division__c, P360_Worldwide_for_Territorial_limits__c, P360_Excluding_excluded_countries__c, P360_Territorial_Limits_Region__c,'
            + ' P360_Territorial_Limits_Country__c, P360_Territorial_Limits_Division__c FROM P360_DCOM_Territorial_limits__c WHERE Id =: stg_RecordIds';
        return Database.getQueryLocator(query);
    }
    
    public void execute(Database.BatchableContext bc, List<P360_DCOM_Territorial_limits__c> scope){
        
        List<String> csvLines = new List<String>();
        
        P360_DCOM_Territorial_Limits_md__mdt sd4_DCOM = [ SELECT P360_Unique_Market_Reference_Number__c, P360_Contract_Unique_Identifier__c, P360_Section_Name__c, P360_Section_Unique_ID__c,
                                                         P360_Worldwide__c, P360_Excluding__c, P360_Risk_Location_Region__c, P360_Risk_Location_Country__c, P360_Risk_Location_Division__c,
                                                         P360_Worldwide_Insured_Domicile__c, P360_Excluding_for_excluded_countries__c, 
                                                         P360_Insured_Domicile_Region__c, P360_Insured_Domicile_Counrty__c, P360_Insured_Domicile_Division__c, 
                                                         P360_Worldwide_Territorial_limits__c, P360_Excluding_Territorial_limits__c, P360_Territorial_Limits_Region__c,
                                                         P360_Territorial_Limits_Country__c, P360_Territorial_Limits_Division__c FROM P360_DCOM_Territorial_Limits_md__mdt WHERE DeveloperName = 'SD4' LIMIT 1];
        
        csvLines.add(sd4_DCOM.P360_Unique_Market_Reference_Number__c + ',' + sd4_DCOM.P360_Contract_Unique_Identifier__c + ',' + sd4_DCOM.P360_Section_Name__c 
                     + ',' + sd4_DCOM.P360_Section_Unique_ID__c + ',' + sd4_DCOM.P360_Worldwide__c + ',' + sd4_DCOM.P360_Excluding__c + ',' + sd4_DCOM.P360_Risk_Location_Region__c 
                     + ',' + sd4_DCOM.P360_Risk_Location_Country__c + ',' + sd4_DCOM.P360_Risk_Location_Division__c + ',' + sd4_DCOM.P360_Worldwide_Insured_Domicile__c 
                     + ',' + sd4_DCOM.P360_Excluding_for_excluded_countries__c + ',' + sd4_DCOM.P360_Insured_Domicile_Region__c + ',' + sd4_DCOM.P360_Insured_Domicile_Counrty__c 
                     + ',' + sd4_DCOM.P360_Insured_Domicile_Division__c + ',' + sd4_DCOM.P360_Worldwide_Territorial_limits__c + ',' + sd4_DCOM.P360_Excluding_Territorial_limits__c 
                     + ',' + sd4_DCOM.P360_Territorial_Limits_Region__c + ',' + sd4_DCOM.P360_Territorial_Limits_Country__c + ',' + sd4_DCOM.P360_Territorial_Limits_Division__c);
        
        for(P360_DCOM_Territorial_limits__c sd4 : scope){
            
            String csvRowVal = sd4.P360_Unique_Market_Reference_Number__c + ',' + sd4.P360_Contract_Unique_Identifier__c
                + ',' + sd4.P360_Section_Name__c + ',' + sd4.P360_Section_Unique_ID__c
                + ',' + sd4.P360_Worldwide__c + ',' + sd4.P360_Excluding__c
                + ',' + sd4.P360_Risk_Location_Region__c + ',' + sd4.P360_Risk_Location_Country__c
                + ',' + sd4.P360_Risk_Location_Division__c + ',' + sd4.P360_Worldwide_for_Insured_Domicile__c
                + ',' + sd4.P360_Excluding_for_excluded_countries__c + ',' + sd4.P360_Insured_Domicile_Region__c
                + ',' + sd4.P360_Insured_Domicile_Counrty__c + ',' + sd4.P360_Insured_Domicile_Division__c
                + ',' + sd4.P360_Worldwide_for_Territorial_limits__c + ',' + sd4.P360_Excluding_excluded_countries__c
                + ',' + sd4.P360_Territorial_Limits_Region__c + ',' + sd4.P360_Territorial_Limits_Country__c
                + ',' + sd4.P360_Territorial_Limits_Division__c;

            csvLines.add(csvRowVal);
            
            if(errorMap.containsKey(sd4.P360_Serial_No__c)){
                errorMap.remove(sd4.P360_Serial_No__c);
            }
        }

            String csvBody = String.join(csvLines, '\n');
            S3_LogFilesCtrl.pushSuccessRecords(csvBody, 'DCOM', docName);
    }
    
    public void finish(Database.BatchableContext bc){
        
        if(!errorMap.isEmpty() && errorMap.size() > 1){
            AsyncApexJob job = [SELECT Id FROM AsyncApexJob WHERE Id = :bc.getJobId()];
            S3_ErrorFile error_Batch = new S3_ErrorFile(errorMap, 'DCOM', docName.replace(' ','%20'), job.Id);
            Database.executeBatch(error_Batch);
        }
    }
}