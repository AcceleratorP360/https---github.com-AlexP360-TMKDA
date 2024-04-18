public class DueDiligenceMTACtrl {
    
   // fetch the Due Diligence details based on current recordId
   @AuraEnabled(cacheable = true) 
   public Static P360_Due_Diligence__c getDueDiligenceRecrd(String recordId) {
       return [SELECT Id,
               Category_Status__c,
               Completion_Status__c,
               Completion__c,
               Name,
               CreatedDate,
               P360_Approval_Status__c,
               P360_Approved_By__c,
               CreatedById,
               P360_CoverHolder_TPA_Name__c,
               P360_Coverholder_TPA_summary__c,
               P360_Due_Diligence_Date__c,
               P360_Due_Diligence_Type__c,
               P360_DD_Assessment__c,
               p360_Due_Diligence_Date_Valid_To__c,
               p360_Planned_Assessment_Start_Date__c,
               P360_DD_Assessment_risk_summary__c,
               p360_Actual_Assessment_Start_Date__c,
               p360_Actual_Assessment_End_Date__c,
               P360_CoverHolder_TPA_Name__r.Name,
               P360_DA_Analyst__c,
               P360_DD_Is_this_Template__c,
               P360_wouldyouliketooverride_assessment__c,
               P360_DD_Override_assessment__c,
               P360_DD_Override_reason__c,
               Green_score_range__c,
               P360_DD_Red__c,
               P360_DD_Amber__c,
               P360_DD_Green__c,
               P360_DD_Weighting__c,
               P360_DD_Weighting_Total__c,
               P360_DD_Red_score_range__c,
               //P360_Is_Due_Diligence_Renewed__c,
               //P360_Renewed_Due_Diligence__c,
               P360_Due_Diligence_Connection__c,
               P360_Date_Last_DD_Completed__c,
               P360_Recommendation__c,
               P360_Approval_Method__c,
               P360_Completed_By__c,
               P360_DA_Peer_Reviewer__c,
               P360_Claims_Sign_Off__c,
               P360_Attestation_Signed_By__c,
               P360_Date_Completed__c,
               P360_Date_Signed_Off__c,
               P360_Claims_ManagerDate_Signed_Off__c,
               P360_Date_Attestation_Received__c,
               P360_Due_Diligence_Summary__c,
               P360_DD_Last_Audit_Date__c,
               P360_DD_Next_Audit_Date__c,
               P360_DD_Audit_Summary__c,
               Record_Count__c,
               /* New fields added */
               P360_DD_Actual_Assessment_End_Date__c,
               P360_DD_Actual_Assessment_Start_Date__c,
               P360_DD_Advisory_Grouping__c,
               TMKDA_Approved_Date__c,
               P360_DD_Assessed_Risk__c,
               P360_DD_Assessment_Status__c,
               P360_DD_Name__c,
               P360_Due_Diligence_Survey__c,
               Binders__c,
               P360_DD_Calculated_Assessment__c,
               Category_Due_Diligence__c,
               Completion_Percentage__c,
               CompletionCount__c,
               Contact__c,
               //P360_DD_Coverholder_Domicile__c,
               P360_DD_Coverholder_Live_Date__c,
               P360_DD_Coverholder_or_DCA__c,
               //P360_DD_Customer_Domicile__c,
               P360_Default_weighting__c,
               P360_Delay_Count__c,
               P360_Delayed_Days__c,
               P360_Delayed_or_Due__c,
               Due_Diligence__c,
               P360_Due_Diligence_Record_Id__c,
               P360_DD_Earliest_Binder_Renewal__c,
               P360_DD_Key_Contact__c,
               P360_DD_Line_of_Business__c,
               MTA_to_Binder__c,
               MTA_to_Coverholder__c,
               P360_DD_Number_of_Live_Binders__c,
               P360_DD_Number_of_Run_Off_Binders__c,
               Overall_Assessment__c,
               P360_DD_Overall_score__c,
               P360_Override_score__c,
               //P360_Previous_Due_Diligence__c,
               P360_Primary_Correspondence_Email_Id__c,
               P360_RAG_Status__c,
               P360_DD_Rating_from_Property__c,
               //P360_Renewal_Due_Diligence__c,
               P360_DD_Risk_Location__c,
               P360_DD_Assessment_score__c,
               P360_DD_Total_EPI__c,
               Total_DD_Points_that_can_be_allocated__c,
               P360_DD_Weightage__c,
               TMKDA_Primary_Due_Diligence_record__c,
               //TMKDA_Domicile__c,
               TMKDA_Previous_Committee_Date__c,
               TMKDA_DD_Connection_Status__c,
               TMKDA_Overview__c,
               TMKDA_Binder_Renewal_Date__c,
               TMKDA_Committee__c,
               TMKDA_Committee_Date_Completed__c,
               TMKDA_High_Actions_Report__c,
               TMKDA_Medium_Actions_Report__c,
               TMKDA_Low_Actions_Report__c,
               TMKDA_Low_Open_at_DD_Review_Date__c,
               TMKDA_Medium_Open_at_DD_Review_Date__c,
               TMKDA_Medium_Overview_at_DD_Review_Date__c,
               RecordTypeId,
               TMKDA_Is_DD_MTA__c,
               TMKDA_MTA_Initiated_By__c,
               TMKDA_MTA_Initiated_Date__c,                                                                    
               TMKDA_MTA_Due_Diligence__c,
               TMKDA_Renewal_initiated_date__c,
               TMKDA_Renewal_initiated_by__c,
               TMKDA_Previous_DD_Type__c,
               TMKDA_Low_Overview_at_DD_Review_Date__c
               FROM P360_Due_Diligence__c WHERE Id =: recordId
              ];   
   }
   
   // cloning process started
   // recordId - get Due Diligence data based on current recordId
   // name - passing updated Due Diligence updated name
   // plannedAssessmentStartDate - passing updated Due Diligence updated plannedAssessmentStartDate default is today day
   // plannedAssessmentEndDate - passing updated Due Diligence updated plannedAssessmentEndDate default is null
   // coverHolderTPAName - passing updated coverHolderTPAName record type will be CoverHolder or TPA
   
   @AuraEnabled 
   public Static String cloneRecords(String recordId, String name,
                                     // Date actualAssessmentStartDate, Date actualAssessmentEndDate,
                                     Date plannedAssessmentStartDate, Date plannedAssessmentEndDate,
                                     String coverHolderTPAName) {
                                         
                                         List < P360_DD_Category__c > ddCategoryCloneList = new List < P360_DD_Category__c > ();
                                         List < P360_DD_Sub_Category__c > clone_SubCategoryList = new List < P360_DD_Sub_Category__c > ();
                                         List < P360_Review_Area__c > clone_ReviewAreaList = new List < P360_Review_Area__c > ();
                                         
                                         //get Due Diligence record
                                         P360_Due_Diligence__c dueDiligenceRecrd = [SELECT Id,
                                                                                    //Category_Status__c,
                                                                                    //Completion_Status__c,
                                                                                    //Completion__c,
                                                                                    Name,
                                                                                    CreatedById,
                                                                                    CreatedDate,
                                                                                    P360_DD_Assessment__c,
                                                                                    P360_DD_Assessment_risk_summary__c,
                                                                                    P360_Approval_Status__c,
                                                                                    P360_CoverHolder_TPA_Name__c,
                                                                                    P360_Coverholder_TPA_summary__c,
                                                                                    P360_Due_Diligence_Type__c,
                                                                                    p360_Planned_Assessment_Start_Date__c,
                                                                                    //p360_Planned_Assessment_End_Date__c,
                                                                                    /*p360_Actual_Assessment_Start_Date__c,
                                                                                    p360_Actual_Assessment_End_Date__c,*/
                                                                                    P360_CoverHolder_TPA_Name__r.Name,
                                                                                    //P360_DD_Is_this_Template__c,
                                                                                    P360_DA_Analyst__c,
                                                                                    P360_wouldyouliketooverride_assessment__c,
                                                                                    P360_DD_Override_assessment__c,
                                                                                    P360_DD_Override_reason__c,
                                                                                    Green_score_range__c,
                                                                                    P360_DD_Red__c,
                                                                                    P360_DD_Amber__c,
                                                                                    P360_DD_Green__c,
                                                                                    P360_DD_Weighting__c,
                                                                                    P360_DD_Weighting_Total__c,
                                                                                    P360_DD_Red_score_range__c,
                                                                                    P360_Is_Due_Diligence_Renewed__c,
                                                                                    P360_Renewed_Due_Diligence__c,
                                                                                    P360_Due_Diligence_Connection__c,
                                                                                    P360_Date_Last_DD_Completed__c,
                                                                                    P360_Recommendation__c,
                                                                                    P360_Approval_Method__c,
                                                                                    P360_Completed_By__c,
                                                                                    /*P360_DA_Peer_Reviewer__c,
                                                                                    P360_Claims_Sign_Off__c,
                                                                                    P360_Attestation_Signed_By__c,
                                                                                    P360_Date_Completed__c,
                                                                                    P360_Date_Signed_Off__c,
                                                                                    P360_Claims_ManagerDate_Signed_Off__c,*/
                                                                                    P360_Date_Attestation_Received__c,
                                                                                    P360_DD_Last_Audit_Date__c,
                                                                                    P360_DD_Next_Audit_Date__c,
                                                                                    P360_DD_Audit_Summary__c,
                                                                                    Record_Count__c,
                                                                                    /* New fields added */
                                                                                    //P360_DD_Actual_Assessment_End_Date__c,
                                                                                    //P360_DD_Actual_Assessment_Start_Date__c,
                                                                                    P360_DD_Advisory_Grouping__c,
                                                                                    TMKDA_Approved_Date__c,
                                                                                    P360_DD_Assessed_Risk__c,
                                                                                    P360_DD_Assessment_Status__c,
                                                                                    P360_DD_Name__c,
                                                                                    P360_Due_Diligence_Survey__c,
                                                                                    Binders__c,
                                                                                    P360_DD_Calculated_Assessment__c,
                                                                                    Category_Due_Diligence__c,
                                                                                    Completion_Percentage__c,
                                                                                    CompletionCount__c,
                                                                                    Contact__c,
                                                                                    P360_DD_Coverholder_Domicile__c,
                                                                                    P360_DD_Coverholder_Live_Date__c,
                                                                                    P360_DD_Coverholder_or_DCA__c,
                                                                                    P360_DD_Customer_Domicile__c,
                                                                                    P360_Default_weighting__c,
                                                                                    P360_Delay_Count__c,
                                                                                    P360_Delayed_Days__c,
                                                                                    P360_Delayed_or_Due__c,
                                                                                    Due_Diligence__c,
                                                                                    P360_Due_Diligence_Record_Id__c,
                                                                                    P360_DD_Earliest_Binder_Renewal__c,
                                                                                    P360_DD_Key_Contact__c,
                                                                                    P360_DD_Line_of_Business__c,
                                                                                    MTA_to_Binder__c,
                                                                                    MTA_to_Coverholder__c,
                                                                                    P360_DD_Number_of_Live_Binders__c,
                                                                                    P360_DD_Number_of_Run_Off_Binders__c,
                                                                                    Overall_Assessment__c,
                                                                                    P360_DD_Overall_score__c,
                                                                                    P360_Override_score__c,
                                                                                    P360_Previous_Due_Diligence__c,
                                                                                    P360_Primary_Correspondence_Email_Id__c,
                                                                                    P360_RAG_Status__c,
                                                                                    P360_DD_Rating_from_Property__c,
                                                                                    P360_Renewal_Due_Diligence__c,
                                                                                    P360_DD_Risk_Location__c,
                                                                                    P360_DD_Assessment_score__c,
                                                                                    P360_DD_Total_EPI__c,
                                                                                    Total_DD_Points_that_can_be_allocated__c,
                                                                                    P360_DD_Weightage__c,
                                                                                    TMKDA_Primary_Due_Diligence_record__c,
                                                                                    TMKDA_Domicile__c,
                                                                                    TMKDA_Previous_Committee_Date__c,
                                                                                    TMKDA_DD_Connection_Status__c,
                                                                                    TMKDA_Overview__c,
                                                                                    TMKDA_Binder_Renewal_Date__c,
                                                                                    TMKDA_Committee__c,
                                                                                    TMKDA_Committee_Date_Completed__c,
                                                                                    TMKDA_High_Actions_Report__c,
                                                                                    TMKDA_Medium_Actions_Report__c,
                                                                                    TMKDA_Low_Actions_Report__c,
                                                                                    TMKDA_Low_Open_at_DD_Review_Date__c,
                                                                                    TMKDA_Medium_Open_at_DD_Review_Date__c,
                                                                                    TMKDA_Medium_Overview_at_DD_Review_Date__c,
                                                                                    TMKDA_Low_Overview_at_DD_Review_Date__c,
                                                                                    P360_Due_Diligence_Summary__c,
                                                                                    TMKDA_MTA_Initiated_By__c,
                                                                                    TMKDA_MTA_Initiated_Date__c,
                                                                                    TMKDA_Is_DD_MTA__c,
                                                                                    TMKDA_MTA_Due_Diligence__c,
                                                                                    RecordType.name,
                                                                                    RecordTypeId
                                                                                    FROM P360_Due_Diligence__c WHERE Id =: recordId
                                                                                   ];
                                          string recordtId = [SELECT Id, DeveloperName FROM RecordType WHERE DeveloperName = 'TMKDA_MTA'].id;
                                         P360_Due_Diligence__c dueDiligenceClone = dueDiligenceRecrd.clone(false, true);
                                         dueDiligenceClone.Name = name.left(80);
                                         dueDiligenceClone.P360_Approval_Status__c = 'Not Started';
                                         dueDiligenceClone.P360_CoverHolder_TPA_Name__c = coverHolderTPAName;
                                         // dueDiligenceClone.P360_Due_Diligence_Date__c = System.today();
                                         dueDiligenceClone.RecordTypeId= recordtId;
                                         /*dueDiligenceClone.p360_Planned_Assessment_Start_Date__c = plannedAssessmentStartDate;
                                         dueDiligenceClone.p360_Planned_Assessment_End_Date__c = plannedAssessmentEndDate;*/
                                         //dueDiligenceClone.P360_Is_Due_Diligence_Renewed__c = true;
                                         dueDiligenceClone.P360_Renewal_Due_Diligence__c= true;
                                         dueDiligenceClone.P360_Previous_Due_Diligence__c =recordId;
                                         /*dueDiligenceClone.p360_Planned_Assessment_Start_Date__c = System.today();
                                         dueDiligenceClone.p360_Planned_Assessment_End_Date__c = System.today().addMonths(5);
                                         if(dueDiligenceClone.P360_Actual_Assessment_Start_Date__c=null){
                                         dueDiligenceClone.P360_Actual_Assessment_Start_Date__c = dueDiligenceClone.LastModifiedDate
                                         dueDiligenceClone.P360_Actual_Assessment_End_Date__c =   
                                             }
                                           dueDiligenceClone.TMKDA_Renewal_initiated_by__c = userinfo.getuserid();*/
                                         dueDiligenceClone.TMKDA_Previous_DD_Type__c = dueDiligenceRecrd.RecordType.name;
                                         
                                         try {
                                             insert dueDiligenceClone;
                                             P360_Due_Diligence__c  DD=[select id, Name,CreatedDate,CreatedById from P360_Due_Diligence__c where id =: recordId];
                                              DD.TMKDA_Is_DD_MTA__c = true;
                                              DD.TMKDA_MTA_Due_Diligence__c= dueDiligenceClone.id;
                                              DD.TMKDA_MTA_Initiated_Date__c=system.NOW();
                                              DD.TMKDA_MTA_Initiated_By__c = userinfo.getuserid();
                                             update DD;
                                             
                                             //P360_Due_Diligence__c  DD2 =[select id, Name,P360_Is_Due_Diligence_Renewed__c from P360_Due_Diligence__c where id =: DD.id AND P360_Is_Due_Diligence_Renewed__c = true ];
                                             
                                             /*vardhani commented ---> for testing
                                             //get the task related to Due Diligence DD2
                                             List<Task> tasks = [SELECT Id, OwnerId, Subject, Description, P360_Task_Type__c, Status, WhatId FROM Task WHERE WhatId = :DD2.Id ];
                                                    for (Task t : tasks) {
                                                              if (t.P360_Task_Type__c == 'Scheduled Renewal Due Diligence' && t.Status != 'Completed') {
                                                                     t.Status = 'Completed';
                                                                             }
                                                                   }
                                                           update tasks;*/
                                                 
                                             // get related categoty records
                                             
                                             List < P360_DD_Category__c > existingCategoryList = [SELECT CategoryID__c,
                                                                                                  Completion_Status__c,
                                                                                                  Completion__c,
                                                                                                  Id,
                                                                                                  Name,
                                                                                                  P36_CT_Assessment_Score1__c,
                                                                                                  P360_Any_new_binders_since_last_quarter__c,
                                                                                                  P360_Assessment__c,
                                                                                                  P360_Authority_includes_denying_claims__c,
                                                                                                  P360_Authority_to_handle_complaints__c,
                                                                                                  P360_Category_Id__c,
                                                                                                  P360_CA_TotalPointsthat_can_be_allocated__c,
                                                                                                  P360_Claims_handling_agreement_location__c,
                                                                                                  P360_Commentary__c,
                                                                                                  //P360_Completion_Marker__c,
                                                                                                  P360_Coverholder_TPA_Name__c,
                                                                                                  P360_CT_Amber_Score__c,
                                                                                                  P360_CT_Assessment_Score__c,
                                                                                                  P360_CT_Green_Score__c,
                                                                                                  P360_CT_Overall_Score__c,
                                                                                                  P360_CT_Red_Score__c,
                                                                                                  P360_CT_Total_Points__c,
                                                                                                  P360_CT_Weightage__c,
                                                                                                  P360_Date_of_latest_accounts__c,
                                                                                                  P360_DD_Category__c,
                                                                                                  P360_Did_any_actions_arise_from_the_PDT__c,
                                                                                                  P360_Due_Diligence_Date__c,
                                                                                                  P360_Due_Diligence_Name__c,
                                                                                                  P360_handle_claims_above_authority_limit__c,
                                                                                                  P360_Havetherebeenanysignificant_changes__c,
                                                                                                  P360_Inherent_Risk__c,
                                                                                                  P360_JMD_rating_at_latest_review__c,
                                                                                                  P360_Latest_JMD_financials_review_date__c,
                                                                                                  P360_On_monitored_CH_list__c,
                                                                                                  P360_Summary_Final_Assessment__c,
                                                                                                  Progress__c,
                                                                                                  Record_Count__c,
                                                                                                  Status__c,
                                                                                                  Sub_category_Completion_status__c,
                                                                                                  P360_External_Id__c,
                                                                                                  P360_CT_Claims_Senior_adjuster_sign_off__c,
                                                                                                  P360_CT_Date_of_claims_sign_off_review__c,                                                 
                                                                                                  P360_CT_Is_Category_Claims__c,
                                                                                                  P360_CT_Is_Category_Financial_and_Credit__c,
                                                                                                  P360_CT_Is_applicable_Conduct__c,
                                                                                                  P360_CT_Is_applicable_Financial_Crime__c,
                                                                                                  P360_CT_Weighting__c,
                                                                                                  P360_Company_Type__c,
                                                                                                  P360_In_Scope_for_Whistleblowing__c,
                                                                                                  P360_Are_materialbusiness_functions_outs__c,
                                                                                                  P360_Highest_data_type_held__c,
                                                                                                  P360_In_Scope_for_IDD__c,
                                                                                                  P360_CT_Is_applicable_Complaints__c,
                                                                                                  /* New fields created */
                                                                                                  TMKDA_Are_Claims_delegated_to_a_DCA__c,
                                                                                                  TMKDA_attestationconfirmnew_Outsourci__c,
                                                                                                  TMKDA_attestationconfirm_a_new_Complaint__c,
                                                                                                  TMKDA_Attestation_new_Succession_plan__c,
                                                                                                  TMKDA_Attestation_Fin_Crime_policy__c,
                                                                                                  P360_Authority_Limit__c,
                                                                                                  P360_Authority_to_handle_claims__c,
                                                                                                  P360_DA_Category_ID__c,
                                                                                                  P360_DA_Category_ID_URL__c,
                                                                                                  P360_DD_Changes_to_the_product_s__c,
                                                                                                  TMKDA_Claims_authority_limit__c,
                                                                                                  CompletionCount__c,
                                                                                                  Connect_Copy_Options__c,
                                                                                                  TMKDA_Connected_to_a_Primary__c,
                                                                                                  TMKDA_Coverholder_have_claims_authority__c,
                                                                                                  TMKDA_Distribution_channel__c,
                                                                                                  TMKDA_Does_attestation_confirm_a_new_BCP__c,
                                                                                                  TMKDA_Does_attestation_confirm_a_new_DRP__c,
                                                                                                  TMKDA_Does_attestation_confirm_a_new_TCF__c,
                                                                                                  TMKDA_Attestation_has_new_system__c,
                                                                                                  TMKDA_Has_a_new_Accounting_Procedure__c,
                                                                                                  TMKDA_Has_a_new_Claims_Procedure__c,
                                                                                                  TMKDA_Has_a_new_Complaints_policy__c,
                                                                                                  TMKDA_Hasnew_Conflictsof_Interest_policy__c,
                                                                                                  TMKDA_Has_a_new_Data_Protection_policy__c,
                                                                                                  TMKDA_Has_a_new_Info_Security_policy__c,
                                                                                                  TMKDA_Has_a_new_whistleblowing_policy__c,
                                                                                                  TMKDA_High_Monitored_List__c,
                                                                                                  //TMKDA_Highest_PDT_Output__c,
                                                                                                  TMKDA_CA_Highest_PDT_Output__c,
                                                                                                  TMKDA_High_Risk_Customer_Type__c,
                                                                                                  TMKDA_Highest_underwriting_authority__c,
                                                                                                  TMKDA_Inherent_AB_C__c,
                                                                                                  TMKDA_Inherent_AML__c,
                                                                                                  P360_CT_Inherent_risk__c,
                                                                                                  TMKDA_Inherent_Sactions__c,
                                                                                                  P360_CT_Is_applicable_Company__c,
                                                                                                  P360_CT_Is_applicable_C_r__c,
                                                                                                  TMKDA_Is_GDPR_in_scope__c,
                                                                                                  TMKDA_Is_Operational_Resilience_in_scope__c,
                                                                                                  P360_Last_full_review__c,
                                                                                                  TMKDA_Level_of_Authority__c,
                                                                                                  P360_Loss_Fund__c,
                                                                                                  TMKDA_Number_of_BPAs__c,
                                                                                                  P360_Other_relevant_information__c,
                                                                                                  P360_Group_Risk__c,
                                                                                                  P360_Weighted_Risk_Score__c,
                                                                                                  P360_Weighting__c,
                                                                                                  TMKDA_Is_this_section_MTA__c,
                                                                                                  TMKDA_Review_Area_Completion_Status__c
                                                                                                  FROM P360_DD_Category__c WHERE
                                                                                                  P360_Due_Diligence_Name__c =:
                                                                                                  dueDiligenceRecrd.Id
                                                                                                 ];
                                             
                                             if (!existingCategoryList.isEmpty()) {
                                                 for (P360_DD_Category__c ddCategoryRecords: existingCategoryList) {
                                                     P360_DD_Category__c ddCloneCategory = ddCategoryRecords.clone(false, true);
                                                     ddCloneCategory.P360_Due_Diligence_Name__c = dueDiligenceClone.Id;
                                                     ddCloneCategory.P360_External_Id__c = ddCategoryRecords.Id;
                                                     ddCloneCategory.P360_Coverholder_TPA_Name__c = coverHolderTPAName;
                                                     //ddCloneCategory.TMKDA_DD_Record_Type__c=dueDiligenceClone.RecordTypeId;
                                                     ddCategoryCloneList.add(ddCloneCategory);
                                                 }
                                                 
                                                 if (!ddCategoryCloneList.isEmpty()) {
                                                     insert ddCategoryCloneList;
                                                 }
                                                 
                                                 
                                                 Map < Id, P360_DD_Category__c > categoryMap = new Map < Id, P360_DD_Category__c > ();
                                                 
                                                 // put oldId and new recordId using externalId field
                                                 
                                                 if (!ddCategoryCloneList.isEmpty()) {
                                                     for (P360_DD_Category__c ddCategoryRecords: ddCategoryCloneList) {
                                                         categoryMap.put(ddCategoryRecords.P360_External_Id__c, ddCategoryRecords);
                                                     }
                                                 }
                                                 
                                                 
                                                 // get related sub category records based on oldId
                                                 
                                                 if (!categoryMap.IsEmpty()) {
                                                     List < P360_DD_Sub_Category__c > existingSubCategoryList = [SELECT Assessment__c,
                                                                                                                 Completion__c,
                                                                                                                 Id,
                                                                                                                 Name,
                                                                                                                 P360_Assessment__c,
                                                                                                                 P360_binders_since_last_quarterly_sco__c,
                                                                                                                 P360_Category_Name__c,
                                                                                                                 P360_Changes_to_the_product_s__c,
                                                                                                                 P360_Commentary__c,
                                                                                                                 //P360_Completion_Marker__c,
                                                                                                                 P360_Coverholder_TPA_Name__c,
                                                                                                                 P360_DD_Child_COmpletion_Status__c,
                                                                                                                 P360_Due_Diligence_Date__c,
                                                                                                                 P360_Due_Diligence_Name__c,
                                                                                                                 P360_Final_Full_Review__c,
                                                                                                                 P360_Inherent_Risk_Revised__c,
                                                                                                                 P360_Inherent_Risk__c,
                                                                                                                 P360_SC_Amber_Score__c,
                                                                                                                 P360_SC_Assessment_Score1__c,
                                                                                                                 P360_SC_Assessment_Score__c,
                                                                                                                 P360_SC_Green_Score__c,
                                                                                                                 P360_SC_Overall_Score__c,
                                                                                                                 P360_SC_Red_Score__c,
                                                                                                                 P360_SC_Total_Points__c,
                                                                                                                 P360_SC_Weightage__c,
                                                                                                                 P360_SCT_Weighting__c,
                                                                                                                 P360_Summary_Final_Assessment__c,
                                                                                                                 P360_Total_Points_that_can_be_allocated__c,
                                                                                                                 Record_Count__c,
                                                                                                                 STATUS__c,
                                                                                                                 P360_External_Id__c,
                                                                                                                 /* New fields added */
                                                                                                                 P360_SC_Assessment_status__c,
                                                                                                                 Completion_Status__c,
                                                                                                                 CompletionCount__c,
                                                                                                                 P360_Connect_Copy_Options__c,
                                                                                                                 P360_SC_Inherent_risk__c,
                                                                                                                 Review_Area__c,
                                                                                                                 P360_Sub_group_Risk_Score__c,
                                                                                                                 P360_SC_Risk_Score__c,
                                                                                                                 P360_DA_Sub_Category_ID__c,
                                                                                                                 P360_Weighed_RollUp_Risk_Score__c,
                                                                                                                 P360_SubCategory_Weighting__c
                                                                                                                 FROM P360_DD_Sub_Category__c WHERE P360_Category_Name__c =:
                                                                                                                 categoryMap.keySet() AND P360_Due_Diligence_Name__c =: recordId
                                                                                                                ];
                                                     
                                                     
                                                     for (P360_DD_Sub_Category__c ddSubCategoryRecrd: existingSubCategoryList) {
                                                         if (categoryMap.containskey(ddSubCategoryRecrd.P360_Category_Name__c)) {
                                                             P360_DD_Sub_Category__c ddCloneSubCategory = ddSubCategoryRecrd.clone(false,
                                                                                                                                   true);
                                                             ddCloneSubCategory.P360_Category_Name__c = categoryMap.get(ddSubCategoryRecrd.P360_Category_Name__c).Id;
                                                             ddCloneSubCategory.P360_External_Id__c = ddSubCategoryRecrd.Id;
                                                             ddCloneSubCategory.P360_Due_Diligence_Name__c = dueDiligenceClone.Id;
                                                             ddCloneSubCategory.P360_Coverholder_TPA_Name__c = coverHolderTPAName;
                                                             clone_SubCategoryList.add(ddCloneSubCategory);
                                                         }
                                                     }
                                                     
                                                     if (!clone_SubCategoryList.IsEmpty()) {
                                                         insert clone_SubCategoryList;
                                                     }
                                                 } 
                                                 
                                                 Map < Id, Id > subCategory_Map = new Map < Id, Id > ();
                                                 
                                                 // put oldId and new recordId using externalId field
                                                 
                                                 if (!clone_SubCategoryList.isEmpty()) {
                                                     for (P360_DD_Sub_Category__c ddSubCategoryRecords:
                                                          clone_SubCategoryList) {
                                                              subCategory_Map.put(ddSubCategoryRecords.P360_External_Id__c,ddSubCategoryRecords.Id);
                                                          }
                                                 }
                                                 
                                                 // get review area records based on sub category oldId
                                                 if (!subCategory_Map.isEmpty()) {
                                                     List < P360_Review_Area__c > existingReviewAreaList = [SELECT
                                                                                                            Assessment_Status__c,
                                                                                                            documentUploaded__c,
                                                                                                            Due_Diligence__c,
                                                                                                            Id,
                                                                                                            Name,
                                                                                                            P360_Assessment__c,
                                                                                                            P360_Commentary__c,
                                                                                                           //P360_Completion_Marker__c,
                                                                                                            P360_CoverHolder_Name__c,
                                                                                                            P360_RA_Category__c,
                                                                                                            P360_DD_Claims_team_review_to_consist_of__c,
                                                                                                            P360_DD_DA_team_review_to_consist_of__c,
                                                                                                            P360_DD_Refer_to_claims_team__c,
                                                                                                            P360_DD_Scope_of_DD_review__c,
                                                                                                            P360_DD_Sub_Category__c,
                                                                                                            P360_Evidence_file_path__c,
                                                                                                            P360_Inherent_Risk__c,
                                                                                                            P360_RA_Amber_Score__c,
                                                                                                            P360_RA_Assessment_Score__c,
                                                                                                            P360_RA_Green_Score__c,
                                                                                                            P360_RA_Overall_Score__c,
                                                                                                            P360_RA_Red_Score__c,
                                                                                                            P360_RA_Total_Points__c,
                                                                                                            P360_RA_Justification_explanation__c,
                                                                                                            P360_Green_Criteria__c,
                                                                                                            P360_Amber_Criteria__c,
                                                                                                            P360_Red_Criteria__c,
                                                                                                            P360_Green__c,
                                                                                                            P360_RA_Weighting__c,
                                                                                                            P360_RA_Weighting_Total__c,
                                                                                                            P30_RA_DD_Risk_Score__c,
                                                                                                            status__c,
                                                                                                            P360_Red__c,
                                                                                                            P360_Amber__c,
                                                                                                            P360_RA_Weightage__c,
                                                                                                            P360_Scope_of_DD_Review__c,
                                                                                                            P360_Materiality__c,
                                                                                                            P360_Review_Point__c,
                                                                                                            P360_Contained_in_Policy__c,
                                                                                                            P360_Original_Evidence_Found__c,
                                                                                                            P360_Original_Evidence_Name__c,
                                                                                                            P360_Pass_Fail__c,
                                                                                                            P360_Comment__c,
                                                                                                            P360_Guidance__c,
                                                                                                            P360_DD_Sub_Category__r.P360_Category_Name__c,
                                                                                                            /* New fields added */
                                                                                                            TMKDA_Answer__c,
                                                                                                            Connect_Copy_Options__c,
                                                                                                            Inherent_Risk__c,
                                                                                                            ID__c,
                                                                                                            TMKDA_Primary_Linked__c,
                                                                                                            P360_RAG_Point__c,
                                                                                                            P360_Review_Risk__c,
                                                                                                            P360_DA_Review_Area_ID__c,
                                                                                                            P360_Review_Score__c,
                                                                                                            P360_Risk_Status__c,
                                                                                                            TMKDA_Severity__c,
                                                                                                            TMKDA_Source__c,
                                                                                                            P360_Summary__c,
                                                                                                            TMKDA_CA_Is_this_section_MTA__c,
                                                                                                            P360_Weighted_RAG_Score__c
                                                                                                            FROM P360_Review_Area__c WHERE P360_DD_Sub_Category__c =:
                                                                                                            subCategory_Map.keySet() AND Due_Diligence__c =: recordId
                                                                                                           ];
                                                     
                                                     for (P360_Review_Area__c reviewAreaRecrds: existingReviewAreaList) {
                                                         if (subCategory_Map.containskey(reviewAreaRecrds.P360_DD_Sub_Category__c)) {
                                                             P360_Review_Area__c cloneReviewArea = reviewAreaRecrds.clone(false,
                                                                                                                          true);
                                                             cloneReviewArea.P360_DD_Sub_Category__c = subCategory_Map.get(reviewAreaRecrds.P360_DD_Sub_Category__c);
                                                             cloneReviewArea.Due_Diligence__c = dueDiligenceClone.Id;
                                                             cloneReviewArea.P360_CoverHolder_Name__c = coverHolderTPAName;
                                                             cloneReviewArea.P360_RA_Category__c = categoryMap.get(reviewAreaRecrds.P360_DD_Sub_Category__r.P360_Category_Name__c).Id;
                                                             clone_ReviewAreaList.add(cloneReviewArea);
                                                         }
                                                     }
                                                     
                                                     if (!clone_ReviewAreaList.isEmpty()) {
                                                         insert clone_ReviewAreaList;
                                                     }
                                                 }
                                             }
                                             
                                         } catch (Exception e) {
                                             throw new AuraHandledException(e.getMessage());
                                         }
                                         
                                         return dueDiligenceClone.Id;
                                     }  
   
   
}