public class S3_ErrorFile implements Database.Batchable<String>, Database.Stateful, Database.AllowsCallouts{
    
    
    public Map<String, List<String>> errorMap;
    public String folderName;
    public String fileName;
    public String jobId;
    public Set<Id> setOf_ConVerIds;
    
    public S3_ErrorFile(Map<String, List<String>> errorMap, String folderName, String fileName, String jobId, Set<Id> setOf_ConVerIds){
        this.errorMap = errorMap;
        this.folderName = folderName;
        this.fileName = fileName;
        this.jobId = jobId;
        this.setOf_ConVerIds = setOf_ConVerIds;
    }
    
    public Iterable<String> start(Database.BatchableContext context) {
        // errorMap.remove('1');
        return errorMap.keySet();
    }
    
    public void execute(Database.BatchableContext context, List<String> scope) {
        
        List<String> csvLines = new List<String>();        
        
        /* if(fileName.contains('_SD1_')){
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
}else if(fileName.contains('_SD10a_')){
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
}
else if(fileName.contains('_SD3_')){
P360_DCOM_Authorized_COB_md__mdt sd3_DCOM = [ SELECT P360_Unique_Market_Reference_Number__c, P360_Contract_Unique_Identifier__c, P360_Section_Name__c, 
P360_Section_Unique_ID__c, P360_Distribution_Method__c, P360_Premium_level_of_authority__c, P360_Deductibles_andor_excesses__c, 
P360_Items_insured_Group_Insured_Item__c, P360_High_Level_Class_of_Business__c, P360_Generic_Class_of_Business__c,
P360_Risk_codes_and_description__c FROM P360_DCOM_Authorized_COB_md__mdt WHERE DeveloperName = 'SD3' LIMIT 1 ];

csvLines.add(sd3_DCOM.P360_Unique_Market_Reference_Number__c + ',' + sd3_DCOM.P360_Contract_Unique_Identifier__c + ',' + sd3_DCOM.P360_Section_Name__c 
+ ',' + sd3_DCOM.P360_Section_Unique_ID__c + ',' + sd3_DCOM.P360_Distribution_Method__c + ',' + sd3_DCOM.P360_Premium_level_of_authority__c 
+ ',' + sd3_DCOM.P360_Deductibles_andor_excesses__c + ',' + sd3_DCOM.P360_Items_insured_Group_Insured_Item__c 
+ ',' + sd3_DCOM.P360_High_Level_Class_of_Business__c + ',' + sd3_DCOM.P360_Generic_Class_of_Business__c + ',' + sd3_DCOM.P360_Risk_codes_and_description__c);
}
else if(fileName.contains('_SD3a_')){
DCOM_High_COB_Max_limit_md__mdt sd3a_DCOM = [ SELECT P360_Unique_Market_Reference_Number__c, P360_Contract_Unique_Identifier__c, P360_Section_Name__c,
P360_Section_Unique_ID__c, P360_High_Level_Class_of_Business__c, P360_Regulatory_Client_Classification__c,
P360_Currency_High_level_COB__c, P360_Value_High_level_COB__c, P360_Limit_Basis_High_level_COB__c,
P360_Other_Limit_Basis_High_Level_COB__c FROM DCOM_High_COB_Max_limit_md__mdt WHERE DeveloperName = 'SD3a' LIMIT 1 ];

csvLines.add(sd3a_DCOM.P360_Unique_Market_Reference_Number__c + ',' + sd3a_DCOM.P360_Contract_Unique_Identifier__c + ',' + sd3a_DCOM.P360_Section_Name__c 
+ ',' + sd3a_DCOM.P360_Section_Unique_ID__c + ',' + sd3a_DCOM.P360_High_Level_Class_of_Business__c + ',' + sd3a_DCOM.P360_Regulatory_Client_Classification__c 
+ ',' + sd3a_DCOM.P360_Currency_High_level_COB__c + ',' + sd3a_DCOM.P360_Value_High_level_COB__c + ',' + sd3a_DCOM.P360_Limit_Basis_High_level_COB__c 
+ ',' + sd3a_DCOM.P360_Other_Limit_Basis_High_Level_COB__c);
}
else if(fileName.contains('_SD4_')){
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
}
else if(fileName.contains('_SD8_')){
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
}
else if(fileName.contains('KDR')){
P360_KDR__mdt kdr_mdt = [ SELECT P360_UNIQUE_MARKET_REFERENCE__c, P360_INCEPTION_DT__c, P360_EXPIRY_DT__c, P360_LEAD_SYNDICATE__c,
P360_POLICY_REFERENCE__c, P360_YEAR_OF_ACCOUNT__c, P360_LINE_STATUS__c, P360_PLACING_BASIS__c, P360_CONTRACT_RECORD_TYPE__c,
P360_LEAD_OR_FOLLOW__c, P360_UNDERWRITER__c, P360_BUDGET_EPI_GBP_AMT__c, P360_CONTRACT_STATUS__c FROM P360_KDR__mdt WHERE DeveloperName = 'KDR' LIMIT 1];

csvLines.add(kdr_mdt.P360_UNIQUE_MARKET_REFERENCE__c + ',' + kdr_mdt.P360_INCEPTION_DT__c + ',' + kdr_mdt.P360_EXPIRY_DT__c + ',' + kdr_mdt.P360_LEAD_SYNDICATE__c 
+ ',' + kdr_mdt.P360_POLICY_REFERENCE__c + ',' + kdr_mdt.P360_YEAR_OF_ACCOUNT__c + ',' + kdr_mdt.P360_LINE_STATUS__c + ',' + kdr_mdt.P360_PLACING_BASIS__c 
+ ',' + kdr_mdt.P360_CONTRACT_RECORD_TYPE__c + ',' + kdr_mdt.P360_LEAD_OR_FOLLOW__c + ',' + kdr_mdt.P360_UNDERWRITER__c + ',' + kdr_mdt.P360_BUDGET_EPI_GBP_AMT__c 
+ ',' + kdr_mdt.P360_CONTRACT_STATUS__c);
}
else if(fileName.contains('PDT')){
P360_PDT__mdt pdt_mdt = [ SELECT P360_PDT_Number__c, P360_PDT_Status__c, P360_DA_Criteria__c, P360_Q6_New_Or_Renewal__c, P360_Q7_Eclipse_Ref__c, P360_Q8_Contract_Type__c 
FROM P360_PDT__mdt WHERE DeveloperName = 'PDT' LIMIT 1];

csvLines.add(pdt_mdt.P360_PDT_Number__c + ',' + pdt_mdt.P360_PDT_Status__c + ',' + pdt_mdt.P360_DA_Criteria__c + ',' + pdt_mdt.P360_Q6_New_Or_Renewal__c + ',' + pdt_mdt.P360_Q7_Eclipse_Ref__c 
+ ',' + pdt_mdt.P360_Q8_Contract_Type__c);
}
else if(fileName.contains('BDX')){
P360_BDX__mdt bdx_mdt = [ SELECT P360_UMR__c, P360_Coverholder_TPA__c, P360_Finding_Status__c, P360_Finding_Category__c, P360_Due_Date__c, 
P360_Date_Completed__c, P360_YOA__c, P360_Audit_End_Date__c, P360_Audit_Reference__c FROM P360_BDX__mdt WHERE DeveloperName = 'BDX' LIMIT 1];

csvLines.add(bdx_mdt.P360_UMR__c + ',' + bdx_mdt.P360_Coverholder_TPA__c + ',' + bdx_mdt.P360_Finding_Status__c + ',' + bdx_mdt.P360_Finding_Category__c 
+ ',' + bdx_mdt.P360_Due_Date__c + ',' + bdx_mdt.P360_Date_Completed__c + ',' + bdx_mdt.P360_YOA__c + ',' + bdx_mdt.P360_Audit_End_Date__c 
+ ',' + bdx_mdt.P360_Audit_Reference__c);
}*/
        
        if(errorMap.size() > 0){
            for(String str : scope){
                if(errorMap.containskey(str)){
                    List<String> values = errorMap.get(str); 
                    String csvLine = String.join(values, ',');
                    csvLines.add(csvLine.remove('﻿').replace('comma', ','));
                }
            }
            
            String csvBody = String.join(csvLines, '\n');
            S3_LogFilesCtrl.pushErrorRecords(csvBody, folderName, fileName.replace('.csv', String.valueOf(System.now()).replaceAll(' ', '%20')));
            
            
            Messaging.EmailFileAttachment attachment = new Messaging.EmailFileAttachment();
            attachment.setFileName('Error_'+fileName.replace('.csv', '.err'));
            attachment.setBody(Blob.valueOf(csvBody));
            
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            String emailRecipients = System.Label.Email_Recipients;
            String[] toAddresses = emailRecipients.split(';');
            email.setToAddresses(toAddresses);
            email.setSubject('Process failed - '+ folderName);
            email.setPlainTextBody(Label.Error_Mail.replace('batch no', 'Batch No: '+jobId));
            email.setFileAttachments(new Messaging.EmailFileAttachment[] { attachment });
            
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { email });
        }   
    }
    
    public void finish(Database.BatchableContext context){
        S3_CopyToArchivedFolder copyBatch = new S3_CopyToArchivedFolder(setOf_ConVerIds);
        Database.executeBatch(copyBatch);
    }
}