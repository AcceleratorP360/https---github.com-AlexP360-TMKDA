public class ConnectDDToPrimaryGroup_ConnectHelper {
    
    public static void getConnectedCatgory_records(String currentRecrdId, String primaryRecordId, Map < Id, String > primaryMap) {
        P360_Due_Diligence__c ddRecrd = [ SELECT Id, P360_CoverHolder_TPA_Name__c FROM P360_Due_Diligence__c WHERE Id =:currentRecrdId ];
        List < P360_DD_Category__c > catgoryList = [ SELECT CategoryID__c,
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
                                                    P360_Completion_Marker__c,
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
                                                    TMKDA_CA_Highest_PDT_Output__c,//Added by Sarwar on 03/20/2024
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
                                                    P360_DA_Category_ID__r.P360_DA_Category_Name__c,
                                                    P360_Primary_External_ID__c,
                                                    P360_Primary_ID__c
                                                    FROM P360_DD_Category__c
                                                    WHERE Id =: primaryMap.KeySet()];
        List < P360_DA_DD_Categories_Linkage__c > categoryLinkageList = new List < P360_DA_DD_Categories_Linkage__c > ();
        Boolean isCopied = false;
        Boolean isCreate = false;
        for (P360_DD_Category__c ddCat: catgoryList) {
            if (primaryMap.containsKey(ddCat.Id)) {
                if(primaryMap.get(ddCat.Id) == 'Linked'){
                    P360_DA_DD_Categories_Linkage__c dd_Linkage = new P360_DA_DD_Categories_Linkage__c();
                    dd_Linkage.P360_DA_Linked_Due_Diligence_Name__c = currentRecrdId;
                    dd_Linkage.P360_DA_CA_Linked_Status__c = primaryMap.get(ddCat.Id);
                    dd_Linkage.P360_DA_Category_Name__c = ddCat.Id;
                    dd_Linkage.TMKDA_Connect_To_Primary__c = 'Yes';
                    dd_Linkage.Name = ddCat.P360_DA_Category_ID__r.P360_DA_Category_Name__c;
                    categoryLinkageList.add(dd_Linkage);
                }
            }if(primaryMap.get(ddCat.Id) == 'Copied'){
                isCopied = true;
            }
            if(primaryMap.get(ddCat.Id) == 'Create'){
                isCreate = true;
            }
        }
        
        List<P360_DD_Category__c> insertddCategoryCloneList = new List<P360_DD_Category__c>();
        if(isCopied){      
            if (!catgoryList.isEmpty()) {
                for (P360_DD_Category__c ddCategoryRecords: catgoryList) {
                    if (primaryMap.containsKey(ddCategoryRecords.Id) && primaryMap.get(ddCategoryRecords.Id) == 'Copied'
                        && ddCategoryRecords.P360_Due_Diligence_Name__c == primaryRecordId){
                            P360_DD_Category__c ddCloneCategory = ddCategoryRecords.clone(false, true);
                            ddCloneCategory.P360_Due_Diligence_Name__c = currentRecrdId;
                            ddCloneCategory.P360_Primary_External_ID__c = ddCategoryRecords.P360_DA_Category_ID__c + currentRecrdId;
                            ddCloneCategory.P360_Coverholder_TPA_Name__c = ddRecrd.P360_CoverHolder_TPA_Name__c;
                            ddCloneCategory.P360_Primary_ID__c = ddCategoryRecords.Id;
                            ddCloneCategory.P360_Linked_Status__c = 'Copied';
                            ddCloneCategory.P360_Completion_Marker__c = '';
                            insertddCategoryCloneList.add(ddCloneCategory);
                        }
                }
            }
        }
        
        if(isCreate){
            if (!catgoryList.isEmpty()) {
                for (P360_DD_Category__c ddCategoryRecords: catgoryList) {
                    if (primaryMap.containsKey(ddCategoryRecords.Id) && primaryMap.get(ddCategoryRecords.Id) == 'Create'
                        && ddCategoryRecords.P360_Due_Diligence_Name__c == primaryRecordId){
                            P360_DD_Category__c ddCloneCategory = new P360_DD_Category__c();
                            ddCloneCategory.P360_Due_Diligence_Name__c = currentRecrdId;
                            ddCloneCategory.P360_Primary_External_ID__c = ddCategoryRecords.P360_DA_Category_ID__c + currentRecrdId;
                            ddCloneCategory.P360_Coverholder_TPA_Name__c = ddRecrd.P360_CoverHolder_TPA_Name__c;
                            ddCloneCategory.P360_Primary_ID__c = ddCategoryRecords.Id;
                            ddCloneCategory.P360_DA_Category_ID__c = ddCategoryRecords.P360_DA_Category_ID__c;
                            ddCloneCategory.Name = ddCategoryRecords.Name;
                            ddCloneCategory.P360_Completion_Marker__c = '';
                            insertddCategoryCloneList.add(ddCloneCategory);
                        }
                }
            }
        }
        
        if(!insertddCategoryCloneList.isEmpty()){
            // upsert insertddCategoryCloneList P360_Primary_External_ID__c;
            Database.upsert(insertddCategoryCloneList, P360_DD_Category__c.P360_Primary_External_ID__c, false);
            List<P360_DA_DD_Categories_Linkage__c> updateStatus = new List<P360_DA_DD_Categories_Linkage__c>();
            List<P360_DA_DD_Categories_Linkage__c> updateStatusList = [ SELECT Id, P360_DA_CA_Linked_Status__c FROM P360_DA_DD_Categories_Linkage__c WHERE P360_DA_Category_Name__c =: insertddCategoryCloneList
                                                                       AND P360_DA_Category_Name__r.P360_Linked_Status__c = 'Copied' ];
            for(P360_DA_DD_Categories_Linkage__c ddLinkCat : updateStatusList){
                ddLinkCat.P360_DA_CA_Linked_Status__c = 'Copied';
                updateStatus.add(ddLinkCat);
            }
            
            if(!updateStatus.isEmpty()){
                update updateStatus;
            }
        }
        
        if (!categoryLinkageList.isEmpty()) {
            Insert categoryLinkageList;
            // delete the existing linked records 
            List<P360_DA_DD_Categories_Linkage__c> catLink = [ SELECT Id, P360_DA_Category_Name__c, P360_DA_Category_Name__r.P360_DA_Category_ID__c, P360_DA_Linked_Due_Diligence_Name__c 
                                                              FROM P360_DA_DD_Categories_Linkage__c WHERE Id =: categoryLinkageList];
            Map < Id, P360_DA_DD_Categories_Linkage__c > categoryMap = new Map < Id, P360_DA_DD_Categories_Linkage__c > ();
            Set < Id > setOfCatIds = new Set < Id > ();
            Set < Id > setOfCatLinkIds = new Set < Id > ();
            for (P360_DA_DD_Categories_Linkage__c catLinkage: catLink) {
                if(primaryMap.get(catLinkage.P360_DA_Category_Name__c) == 'Linked'){
                    categoryMap.put(catLinkage.P360_DA_Linked_Due_Diligence_Name__c, catLinkage);
                    setOfCatLinkIds.add(catLinkage.Id);
                    // setOfCatIds.add(catLinkage.P360_DA_Category_Name__c);
                    setOfCatIds.add(catLinkage.P360_DA_Category_Name__r.P360_DA_Category_ID__c);
                }
            }
            
            List < P360_DA_DD_Categories_Linkage__c > existingLinkageList = [SELECT Id, P360_DA_Linked_Due_Diligence_Name__c, P360_DA_Category_Name__c,
                                                                             P360_DA_CA_Linked_Status__c, TMKDA_Connect_To_Primary__c FROM P360_DA_DD_Categories_Linkage__c
                                                                             WHERE P360_DA_Linked_Due_Diligence_Name__c =: categoryMap.keySet()
                                                                             AND Id !=: setOfCatLinkIds
                                                                             //  AND P360_DA_Category_Name__c =: setOfCatIds
                                                                             AND P360_DA_Category_Name__r.P360_DA_Category_ID__c =: setOfCatIds
                                                                             AND P360_DA_Category_Name__r.P360_DA_Category_ID__c <> NULL
                                                                             AND P360_DA_Linked_Due_Diligence_Name__c <> NULL
                                                                            ];
            
            List < P360_DA_DD_Categories_Linkage__c > deleteLinkList = new List < P360_DA_DD_Categories_Linkage__c > ();
            for (P360_DA_DD_Categories_Linkage__c existingLinkage: existingLinkageList) {
                if (categoryMap.containsKey(existingLinkage.P360_DA_Linked_Due_Diligence_Name__c)
                    //  && categoryMap.get(existingLinkage.P360_DA_Linked_Due_Diligence_Name__c).P360_DA_Category_Name__c == existingLinkage.P360_DA_Category_Name__c
                   ) {
                       deleteLinkList.add(existingLinkage);
                   }
            }
            
            if (!deleteLinkList.isEmpty()) {
                delete deleteLinkList;
            }
        }
    }
    
    public static void getConnectedSubCatgory_records(String currentRecrdId, String primaryRecordId, Map < Id, String > primaryMap) {
        P360_Due_Diligence__c ddRecrd = [ SELECT Id, P360_CoverHolder_TPA_Name__c FROM P360_Due_Diligence__c WHERE Id =:currentRecrdId ];
        List < P360_DD_Sub_Category__c > dd_SubCatgory = [ SELECT Assessment__c,
                                                          Completion__c,
                                                          Id,
                                                          Name,
                                                          P360_Assessment__c,
                                                          P360_binders_since_last_quarterly_sco__c,
                                                          P360_Category_Name__c,
                                                          P360_Changes_to_the_product_s__c,
                                                          P360_Commentary__c,
                                                          P360_Completion_Marker__c,
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
                                                          P360_SubCategory_Weighting__c,
                                                          P360_DA_Sub_Category_ID__r.P360_DA_Sub_Category_Name__c,
                                                          P360_Primary_External_ID__c,
                                                          P360_Category_Name__r.P360_Primary_ID__c,
                                                          P360_Primary_ID__c
                                                          FROM P360_DD_Sub_Category__c WHERE Id =: primaryMap.keySet()];
        List < P360_DA_DD_Categories_Linkage__c > existing_SubCatList = [SELECT Id, P360_DA_Category_Name__c, P360_DA_Linked_Due_Diligence_Name__c
                                                                         FROM P360_DA_DD_Categories_Linkage__c WHERE P360_DA_Linked_Due_Diligence_Name__c =: currentRecrdId
                                                                        ];
        List < P360_DA_DD_Sub_Category_Linkage__c > dd_SubCat_LinkageList = new List < P360_DA_DD_Sub_Category_Linkage__c > ();
        Map < String, P360_DA_DD_Categories_Linkage__c > subCatMap = new Map < String, P360_DA_DD_Categories_Linkage__c > ();
        for (P360_DA_DD_Categories_Linkage__c subCat: existing_SubCatList) {
            subCatMap.put(subCat.P360_DA_Category_Name__c, subCat);
            // dd_SubCat_LinkageList.add(subCat);
        }
        Boolean isCopied = false;
        Boolean isCreate = false;
        Set<Id> setOfCatIds = new Set<Id>();
        for (P360_DD_Sub_Category__c dd_SubCat: dd_SubCatgory) {
            if (subCatMap.containskey(dd_SubCat.P360_Category_Name__c) && primaryMap.containsKey(dd_SubCat.Id)) {
                if(primaryMap.get(dd_SubCat.Id) == 'Linked'){
                    P360_DA_DD_Sub_Category_Linkage__c dd_Sub_Linkage = new P360_DA_DD_Sub_Category_Linkage__c();
                    dd_Sub_Linkage.P360_DA_Sub_Category_Name__c = dd_SubCat.Id;
                    dd_Sub_Linkage.P360_DA_DD_Category_Linkage__c = subCatMap.get(dd_SubCat.P360_Category_Name__c).Id;
                    dd_Sub_Linkage.P360_DA_SC_Linked_Status__c = primaryMap.get(dd_SubCat.Id);
                    dd_Sub_Linkage.P360_DA_Linked_Due_Diligence_Name__c = currentRecrdId;
                    dd_Sub_Linkage.TMKDA_Connect_To_Primary__c = 'Yes';
                    dd_Sub_Linkage.Name = dd_SubCat.P360_DA_Sub_Category_ID__r.P360_DA_Sub_Category_Name__c;
                    dd_SubCat_LinkageList.add(dd_Sub_Linkage);
                }
            }else if(primaryMap.get(dd_SubCat.Id) == 'Copied'){
                isCopied = true;
                setOfCatIds.add(dd_SubCat.P360_Category_Name__c);
            }
            else if(primaryMap.get(dd_SubCat.Id) == 'Create'){
                isCreate = true;
                setOfCatIds.add(dd_SubCat.P360_Category_Name__c);
            }
        }
        
        List<P360_DD_Sub_Category__c> subCategoryList = new List<P360_DD_Sub_Category__c>();        
        List<P360_DD_Category__c> ddCat = [ SELECT Id, P360_Primary_ID__c FROM P360_DD_Category__c WHERE P360_Primary_ID__c != NULL AND P360_Primary_ID__c =: setOfCatIds
                                           AND P360_Due_Diligence_Name__c =: currentRecrdId];
        Map<Id, Id> catMap = new Map<Id, Id>();
        for(P360_DD_Category__c catRecrd : ddCat){
            catMap.put(catRecrd.P360_Primary_ID__c, catRecrd.Id);
        }
        
        if(isCopied){
            for(P360_DD_Sub_Category__c subCat : dd_SubCatgory){
                if (primaryMap.containsKey(subCat.Id) && primaryMap.get(subCat.Id) == 'Copied'
                    && subCat.P360_Due_Diligence_Name__c == primaryRecordId
                    && catMap.containsKey(subCat.P360_Category_Name__c)){
                        P360_DD_Sub_Category__c ddCloneSubCategory = subCat.clone(false,true);
                        ddCloneSubCategory.P360_Due_Diligence_Name__c = currentRecrdId;
                        ddCloneSubCategory.P360_Primary_External_ID__c = subCat.P360_DA_Sub_Category_ID__c + currentRecrdId;
                        ddCloneSubCategory.P360_Coverholder_TPA_Name__c = ddRecrd.P360_CoverHolder_TPA_Name__c;
                        ddCloneSubCategory.P360_Category_Name__c = catMap.get(subCat.P360_Category_Name__c);
                        ddCloneSubCategory.P360_Primary_ID__c = subCat.Id;
                        subCategoryList.add(ddCloneSubCategory);
                    }
            }
        }
        
        if(isCreate){
            for(P360_DD_Sub_Category__c subCat : dd_SubCatgory){
                if (primaryMap.containsKey(subCat.Id) && primaryMap.get(subCat.Id) == 'Create'
                    && subCat.P360_Due_Diligence_Name__c == primaryRecordId
                    && catMap.containsKey(subCat.P360_Category_Name__c)){
                        P360_DD_Sub_Category__c ddCloneSubCategory = new P360_DD_Sub_Category__c();
                        ddCloneSubCategory.P360_Due_Diligence_Name__c = currentRecrdId;
                        ddCloneSubCategory.P360_Primary_External_ID__c = subCat.P360_DA_Sub_Category_ID__c + currentRecrdId;
                        ddCloneSubCategory.P360_Coverholder_TPA_Name__c = ddRecrd.P360_CoverHolder_TPA_Name__c;
                        ddCloneSubCategory.P360_Category_Name__c = catMap.get(subCat.P360_Category_Name__c);
                        ddCloneSubCategory.P360_Primary_ID__c = subCat.Id;
                        ddCloneSubCategory.P360_DA_Sub_Category_ID__c = subCat.P360_DA_Sub_Category_ID__c;
                        ddCloneSubCategory.Name = subCat.Name;
                        subCategoryList.add(ddCloneSubCategory);
                    }
            }
        }
        
        if(!subCategoryList.isEmpty()){
            // upsert subCategoryList P360_Primary_External_ID__c;
            Database.upsert(subCategoryList, P360_DD_Sub_Category__c.P360_Primary_External_ID__c, false);
        }
        
        if (!dd_SubCat_LinkageList.isEmpty()) {
            Insert dd_SubCat_LinkageList;
        }
    }
    
    public static void getConnectedReviewArea_records(String currentRecrdId, String primaryRecordId, Map < Id, String > primaryMap) {
        P360_Due_Diligence__c ddRecrd = [ SELECT Id, P360_CoverHolder_TPA_Name__c FROM P360_Due_Diligence__c WHERE Id =:currentRecrdId ];
        List < P360_Review_Area__c > reviewAreaList = [ SELECT
                                                       Assessment_Status__c,
                                                       documentUploaded__c,
                                                       Due_Diligence__c,
                                                       Id,
                                                       Name,
                                                       P360_Assessment__c,
                                                       P360_Commentary__c,
                                                       P360_Completion_Marker__c,
                                                       P360_CoverHolder_Name__c,
                                                     //  P360_RA_Category__c,
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
                                                       P360_Weighted_RAG_Score__c,
                                                       P360_DA_Review_Area_ID__r.Name,
                                                       P360_Primary_External_ID__c
                                                       FROM P360_Review_Area__c WHERE
                                                       Id =: primaryMap.keySet() ];
        
        List < P360_DA_DD_Sub_Category_Linkage__c > existingArea = [SELECT Id, P360_DA_DD_Category_Linkage__c, P360_DA_Linked_Due_Diligence_Name__c, P360_DA_Sub_Category_Name__c
                                                                    FROM P360_DA_DD_Sub_Category_Linkage__c WHERE P360_DA_Linked_Due_Diligence_Name__c =: currentRecrdId
                                                                   ];
        List < P360_DA_DD_Review_Area_Linkage__c > reviewLikageList = new List < P360_DA_DD_Review_Area_Linkage__c > ();
        Map < String, P360_DA_DD_Sub_Category_Linkage__c > areaMap = new Map < String, P360_DA_DD_Sub_Category_Linkage__c > ();
        Boolean isCopied = false;
        Boolean isCreate = false;
        for (P360_DA_DD_Sub_Category_Linkage__c dd_Area_Linkage: existingArea) {
            areaMap.put(dd_Area_Linkage.P360_DA_Sub_Category_Name__c, dd_Area_Linkage);
            // reviewLikageList.add(dd_Area_Linkage);
        }
        Set<Id> setOfSubCatIds = new Set<Id>();
        for (P360_Review_Area__c rArea: reviewAreaList) {
            if (areaMap.containskey(rArea.P360_DD_Sub_Category__c) && primaryMap.containsKey(rArea.Id)) {
                if(primaryMap.get(rArea.Id) == 'Linked'){
                    P360_DA_DD_Review_Area_Linkage__c rLinkage = new P360_DA_DD_Review_Area_Linkage__c();
                    rLinkage.P360_DA_Review_Area_Name__c = rArea.Id;
                    rLinkage.P360_DA_DD_Sub_Category_Linkage__c = areaMap.get(rArea.P360_DD_Sub_Category__c).Id;
                    rLinkage.P360_DA_RA_Linked_Status__c = primaryMap.get(rArea.Id);
                    rLinkage.P360_DA_Linked_Due_Diligence_Name__c = currentRecrdId;
                    rLinkage.TMKDA_Connect_To_Primary__c = 'Yes';
                    rLinkage.Name = rArea.P360_DA_Review_Area_ID__r.Name;
                    reviewLikageList.add(rLinkage);
                }
            }else if(primaryMap.get(rArea.Id) == 'Copied'){
                isCopied = true;
                setOfSubCatIds.add(rArea.P360_DD_Sub_Category__c);
            }
            else if(primaryMap.get(rArea.Id) == 'Create'){
                isCreate = true;
                setOfSubCatIds.add(rArea.P360_DD_Sub_Category__c);
            }
        }
        
        List<P360_DD_Sub_Category__c> subCatList = [ SELECT Id, P360_Primary_ID__c FROM P360_DD_Sub_Category__c WHERE P360_Primary_ID__c!= NULL AND 
                                                    P360_Primary_ID__c =: setOfSubCatIds
                                                    AND P360_Due_Diligence_Name__c =: currentRecrdId];
        Map<Id, Id> catMap = new Map<Id, Id>();
        for(P360_DD_Sub_Category__c catRecrd : subCatList){
            catMap.put(catRecrd.P360_Primary_ID__c, catRecrd.Id);
        }
        
        List<P360_Review_Area__c> reviewList = new List<P360_Review_Area__c>();        
        
        if(isCopied){
            for(P360_Review_Area__c review : reviewAreaList){
                if (primaryMap.containsKey(review.Id) && primaryMap.get(review.Id) == 'Copied'
                    && review.Due_Diligence__c == primaryRecordId
                    &&  catMap.containsKey(review.P360_DD_Sub_Category__c)
                    && review.P360_DA_Review_Area_ID__c <> NULL){
                        P360_Review_Area__c rArea = review.clone(false,true);
                        rArea.Due_Diligence__c = currentRecrdId;
                        rArea.P360_Primary_External_ID__c = review.P360_DA_Review_Area_ID__c + currentRecrdId;
                        rArea.P360_CoverHolder_Name__c = ddRecrd.P360_CoverHolder_TPA_Name__c;
                        rArea.P360_DD_Sub_Category__c = catMap.get(review.P360_DD_Sub_Category__c);
                        reviewList.add(rArea);
                    }
            }
        }
        
        if(isCreate){
            for(P360_Review_Area__c review : reviewAreaList){
                if (primaryMap.containsKey(review.Id) && primaryMap.get(review.Id) == 'Create'
                    && review.Due_Diligence__c == primaryRecordId
                    &&  catMap.containsKey(review.P360_DD_Sub_Category__c)
                    && review.P360_DA_Review_Area_ID__c <> NULL){
                        P360_Review_Area__c rArea = new P360_Review_Area__c();
                        rArea.Due_Diligence__c = currentRecrdId;
                        rArea.P360_Primary_External_ID__c = review.P360_DA_Review_Area_ID__c + currentRecrdId;
                        rArea.P360_CoverHolder_Name__c = ddRecrd.P360_CoverHolder_TPA_Name__c;
                        rArea.P360_DD_Sub_Category__c = catMap.get(review.P360_DD_Sub_Category__c);
                        rArea.P360_DA_Review_Area_ID__c = review.P360_DA_Review_Area_ID__c;
                        rArea.P360_Guidance__c = review.P360_Guidance__c;
                        rArea.Name = review.Name;
                        rArea.P360_Review_Point__c = review.P360_Review_Point__c;
                        reviewList.add(rArea);
                    }
            }
        }
        
        if(!reviewList.isEmpty()){
            // upsert reviewList P360_Primary_External_ID__c;
            Database.upsert(reviewList, P360_Review_Area__c.P360_Primary_External_ID__c, false);
        }
        
        if (!reviewLikageList.isEmpty()) {
            Insert reviewLikageList;
            // delete the existing linked records
            Map < Id, P360_DA_DD_Review_Area_Linkage__c > reviewMap = new Map < Id, P360_DA_DD_Review_Area_Linkage__c > ();
            Set < Id > setOfReviwIds = new Set < Id > ();
            Set < String > setOfSubLinkIds = new Set < String > ();
            Set < Id > setOfReviewAreaIds = new Set < Id > ();
            List<P360_DA_DD_Review_Area_Linkage__c> newRevieLinkList = [ SELECT Id, P360_DA_Linked_Due_Diligence_Name__c, P360_DA_Sub_Category_linkage__c,
                                                                        P360_DA_Review_Area_Name__r.P360_DA_Review_Area_ID__c, P360_DA_Review_Area_Name__c FROM P360_DA_DD_Review_Area_Linkage__c 
                                                                        WHERE Id =: reviewLikageList ];
            for (P360_DA_DD_Review_Area_Linkage__c reviwLink: newRevieLinkList) {
                if(primaryMap.get(reviwLink.P360_DA_Review_Area_Name__c) == 'Linked'){
                    reviewMap.put(reviwLink.P360_DA_Linked_Due_Diligence_Name__c, reviwLink);
                    setOfReviwIds.add(reviwLink.Id);
                    setOfSubLinkIds.add(reviwLink.P360_DA_Sub_Category_linkage__c);
                    // setOfReviewAreaIds.add(reviwLink.P360_DA_Review_Area_Name__c);
                    setOfReviewAreaIds.add(reviwLink.P360_DA_Review_Area_Name__r.P360_DA_Review_Area_ID__c);
                }
            }
            
            List < P360_DA_DD_Review_Area_Linkage__c > existingReviewLinkList = [SELECT Id, P360_DA_Linked_Due_Diligence_Name__c, P360_DA_DD_Sub_Category_Linkage__c,
                                                                                 P360_DA_Review_Area_Name__c, P360_DA_RA_Linked_Status__c
                                                                                 FROM P360_DA_DD_Review_Area_Linkage__c WHERE Id !=: setOfReviwIds
                                                                                 AND P360_DA_Linked_Due_Diligence_Name__c =: reviewMap.keySet()
                                                                                 AND P360_DA_Sub_Category_linkage__c =: setOfSubLinkIds
                                                                                 // AND P360_DA_Review_Area_Name__c =: setOfReviewAreaIds
                                                                                 AND P360_DA_Review_Area_Name__r.P360_DA_Review_Area_ID__c =: setOfReviewAreaIds
                                                                                 AND P360_DA_Linked_Due_Diligence_Name__c <> NULL
                                                                                 AND P360_DA_Sub_Category_linkage__c <> NULL
                                                                                 AND P360_DA_Review_Area_Name__r.P360_DA_Review_Area_ID__c <> NULL
                                                                                ];
            List < P360_DA_DD_Review_Area_Linkage__c > deleteLinkList = new List < P360_DA_DD_Review_Area_Linkage__c > ();
            
            for (P360_DA_DD_Review_Area_Linkage__c existingLinkage: existingReviewLinkList) {
                if (reviewMap.containskey(existingLinkage.P360_DA_Linked_Due_Diligence_Name__c)
                    //  && reviewMap.get(existingLinkage.P360_DA_Linked_Due_Diligence_Name__c).P360_DA_DD_Sub_Category_Linkage__c == existingLinkage.P360_DA_DD_Sub_Category_Linkage__c
                    //  && reviewMap.get(existingLinkage.P360_DA_Linked_Due_Diligence_Name__c).P360_DA_Review_Area_Name__c == existingLinkage.P360_DA_Review_Area_Name__c
                   ) {
                       deleteLinkList.add(existingLinkage);
                   }
            }
            
            if (!deleteLinkList.isEmpty()) {
                delete deleteLinkList;
            }
        }
    }
    
    public Static void updateDueDeligence(String currentRecrdId, String primaryRecordId) {
        P360_Due_Diligence__c dueDligence = [SELECT Id, TMKDA_Primary_Due_Diligence_record__c FROM P360_Due_Diligence__c WHERE Id =: currentRecrdId];
        dueDligence.TMKDA_Primary_Due_Diligence_record__c = primaryRecordId;
        update dueDligence;
    }
}