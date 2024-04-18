public class S3_SD10a_LogFiles implements Database.Batchable<sObject>, Database.AllowsCallouts, Database.Stateful{
    
    public Set<Id> stg_RecordIds;
    Map<String, List<String>> errorMap;
    public String docName;
    
    public S3_SD10a_LogFiles(Set<Id> stg_RecordIds, Map<String, List<String>> errorMap, String docName){
        this.stg_RecordIds = stg_RecordIds;
        this.errorMap = errorMap;
        this.docName = docName;
    }
    
    public Database.querylocator Start(Database.BatchableContext bc){
        String query = 'SELECT Id, Name, P360_Serial_No__c, P360_Unique_Market_Reference_Number__c, P360_Contract_Unique_Identifier__c, P360_Section_Name__c, P360_Section_Unique_ID__c,'
            + ' P360_Is_this_a_Non_Lloyd_s_Insurer_led__c, P360_Lead_Type_Section_Lead_s__c, P360_Company_reference__c, P360_Written_LineS__c, P360_Signed_Line__c,'
            + ' P360_Syndicate_Name__c, P360_Syndicate_Year_of_Account__c, P360_Syndicate_Number__c, P360_Managing_Agent__c, P360_Service_Company_Name__c,'
            + ' P360_Service_Company_PIN__c, P360_UMR_Number__c, P360_Non_Lloyd_s_Insurer_ID__c, P360_Non_Lloyd_s_Insurer_Company_Name__c, P360_Non_Lloyd_s_Insurer_City__c,'
            + ' P360_Non_Lloyd_s_Insurer_Division_ID__c, P360_Non_Lloyd_s_Insurer_Division_Name__c, P360_Non_Lloyd_s_Insurer_Trading_Name__c, P360_Other_Non_Lloyd_s_Insurer__c,'
            + ' P360_Year_of_account__c, P360_Date_confirmation_was_received__c, P360_Total_Capacity__c FROM P360_DCOM_Section_Leads__c WHERE Id =: stg_RecordIds';
        return Database.getQueryLocator(query);
    }
    
    public void execute(Database.BatchableContext bc, List<P360_DCOM_Section_Leads__c> scope){
        
        List<String> csvLines = new List<String>();
        
        P360_DCOM_Section_Leads_md__mdt sd10a_DCOM = [ SELECT P360_Unique_Market_Reference_Number__c, P360_Contract_Unique_Identifier__c, 
                                                      P360_Section_Name__c, P360_Section_Unique_ID__c, P360_Is_this_a_Non_Lloyd_s_Insurer_led__c, 
                                                      P360_Lead_Type_Section_Lead_s__c, P360_Company_reference__c, P360_Written_Line__c, 
                                                      P360_Signed_Line__c, P360_Syndicate_Name__c, P360_Syndicate_Year_of_Account__c, P360_Syndicate_Number__c,
                                                      P360_Managing_Agent__c, P360_Service_Company_Name__c, P360_Service_Company_PIN__c, P360_UMR_Number__c,
                                                      P360_Non_Lloyd_s_Insurer_ID__c, P360_Non_Lloyd_s_Insurer_Company_Name__c, P360_Non_Lloyd_s_Insurer_City__c, 
                                                      P360_Non_Lloyd_s_Insurer_Division_ID__c, P360_Non_Lloyd_s_Insurer_Division_Name__c,
                                                      P360_Non_Lloyd_s_Insurer_Trading_Name__c, P360_Other_Non_Lloyd_s_Insurer__c, P360_Year_of_account__c,
                                                      P360_Date_confirmation_was_received__c, P360_Total_Capacity__c
                                                      FROM P360_DCOM_Section_Leads_md__mdt WHERE DeveloperName = 'SD_10a' LIMIT 1];
        
        csvLines.add(sd10a_DCOM.P360_Unique_Market_Reference_Number__c + ',' + sd10a_DCOM.P360_Contract_Unique_Identifier__c
                     + ',' + sd10a_DCOM.P360_Section_Name__c + ',' + sd10a_DCOM.P360_Section_Unique_ID__c + ',' + sd10a_DCOM.P360_Is_this_a_Non_Lloyd_s_Insurer_led__c
                     + ',' + sd10a_DCOM.P360_Lead_Type_Section_Lead_s__c + ',' + sd10a_DCOM.P360_Company_reference__c + ',' + sd10a_DCOM.P360_Written_Line__c
                     + ',' + sd10a_DCOM.P360_Signed_Line__c + ',' + sd10a_DCOM.P360_Syndicate_Name__c + ',' + sd10a_DCOM.P360_Syndicate_Year_of_Account__c 
                     + ',' + sd10a_DCOM.P360_Syndicate_Number__c + ',' + sd10a_DCOM.P360_Managing_Agent__c + ',' + sd10a_DCOM.P360_Service_Company_Name__c
                     + ',' + sd10a_DCOM.P360_Service_Company_PIN__c + ',' + sd10a_DCOM.P360_UMR_Number__c + ',' + sd10a_DCOM.P360_Non_Lloyd_s_Insurer_ID__c
                     + ',' + sd10a_DCOM.P360_Non_Lloyd_s_Insurer_Company_Name__c + ',' + sd10a_DCOM.P360_Non_Lloyd_s_Insurer_City__c 
                     + ',' + sd10a_DCOM.P360_Non_Lloyd_s_Insurer_Division_ID__c + ',' + sd10a_DCOM.P360_Non_Lloyd_s_Insurer_Division_Name__c
                     + ',' + sd10a_DCOM.P360_Non_Lloyd_s_Insurer_Trading_Name__c + ',' + sd10a_DCOM.P360_Other_Non_Lloyd_s_Insurer__c 
                     + ',' + sd10a_DCOM.P360_Year_of_account__c + ',' + sd10a_DCOM.P360_Date_confirmation_was_received__c + ',' + sd10a_DCOM.P360_Total_Capacity__c);
        
        for(P360_DCOM_Section_Leads__c sd10a : scope){
            
            String csvRowVal = sd10a.P360_Unique_Market_Reference_Number__c + ',' + sd10a.P360_Contract_Unique_Identifier__c
                + ',' + sd10a.P360_Section_Name__c + ',' + sd10a.P360_Section_Unique_ID__c
                + ',' + sd10a.P360_Is_this_a_Non_Lloyd_s_Insurer_led__c + ',' + sd10a.P360_Lead_Type_Section_Lead_s__c
                + ',' + sd10a.P360_Company_reference__c + ',' + sd10a.P360_Written_LineS__c
                + ',' + sd10a.P360_Signed_Line__c + ',' + sd10a.P360_Syndicate_Name__c
                + ',' + sd10a.P360_Syndicate_Year_of_Account__c + ',' + sd10a.P360_Syndicate_Number__c
                + ',' + sd10a.P360_Managing_Agent__c + ',' + sd10a.P360_Service_Company_Name__c
                + ',' + sd10a.P360_Service_Company_PIN__c + ',' + sd10a.P360_UMR_Number__c
                + ',' + sd10a.P360_Non_Lloyd_s_Insurer_ID__c + ',' + sd10a.P360_Non_Lloyd_s_Insurer_Company_Name__c
                + ',' + sd10a.P360_Non_Lloyd_s_Insurer_City__c
                + ',' + sd10a.P360_Non_Lloyd_s_Insurer_Division_ID__c + ',' + sd10a.P360_Non_Lloyd_s_Insurer_Division_Name__c
                + ',' + sd10a.P360_Non_Lloyd_s_Insurer_Trading_Name__c + ',' + sd10a.P360_Other_Non_Lloyd_s_Insurer__c
                + ',' + sd10a.P360_Year_of_account__c + ',' + sd10a.P360_Date_confirmation_was_received__c
                + ',' + sd10a.P360_Total_Capacity__c;

            csvLines.add(csvRowVal);
            
            if(errorMap.containsKey(sd10a.P360_Serial_No__c)){
                errorMap.remove(sd10a.P360_Serial_No__c);
            }

        }
        
        String csvBody = String.join(csvLines, '\n');
        S3_LogFilesCtrl.pushSuccessRecords(csvBody, 'DCOM', docName.replace(' ','%20'));        
    }
    
    public void finish(Database.BatchableContext bc){
        
        if(!errorMap.isEmpty() && errorMap.size() > 1){
            AsyncApexJob job = [SELECT Id FROM AsyncApexJob WHERE Id = :bc.getJobId()];
            S3_ErrorFile error_Batch = new S3_ErrorFile(errorMap, 'DCOM', docName.replace(' ','%20'), Job.Id);
            Database.executeBatch(error_Batch);
        }
    }
}