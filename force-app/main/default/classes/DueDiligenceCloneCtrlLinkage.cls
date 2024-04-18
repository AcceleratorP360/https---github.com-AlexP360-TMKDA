/**
 * Class: DueDiligenceCloneCtrlLinkage
 * Description: This class provides creation of junction object records when a due diligence record is cloned.
 * * Created Date: 10/11/23
 * Last Modified: 14/11/2023
 */
public class DueDiligenceCloneCtrlLinkage {
  /**
     * Method: getDueDiligenceRecrd
     * Description: fetch the Due Diligence details based on current recordId.
        - ReturnType: Query .
     */  
        @AuraEnabled(cacheable = true) 
    public Static P360_Due_Diligence__c getDueDiligenceRecrd(String recordId) {
        return [SELECT Id,
                Category_Status__c,
                Completion_Status__c,
                Completion__c,
                Name,
                P360_Approval_Status__c,
                P360_Approved_By__c,
                P360_CoverHolder_TPA_Name__c,
                P360_Coverholder_TPA_summary__c,
                P360_Due_Diligence_Date__c,
               // P360_Due_Diligence_Type__c,
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
                P360_Is_Due_Diligence_Renewed__c,
                P360_Renewed_Due_Diligence__c,
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
                Record_Count__c FROM P360_Due_Diligence__c WHERE Id =: recordId
               ];   
    }
    
    /**
     * Method: cloneRecords
     * Description: cloning process started 
        - ReturnType:Id 
     *recordId - get Due Diligence data based on current recordId
     * name - passing updated Due Diligence updated name
     * plannedAssessmentStartDate - passing updated Due Diligence updated plannedAssessmentStartDate default is today day
     * plannedAssessmentEndDate - passing updated Due Diligence updated plannedAssessmentEndDate default is null
     * coverHolderTPAName - passing updated coverHolderTPAName record type will be CoverHolder or TPA.
     */   
   
    
    @AuraEnabled 
    public Static String cloneRecords(String recordId, String name,
        // Date actualAssessmentStartDate, Date actualAssessmentEndDate,
        Date plannedAssessmentStartDate, Date plannedAssessmentEndDate,
        String coverHolderTPAName) {

        List < P360_DD_Category__c > ddCategoryCloneList = new List < P360_DD_Category__c > ();
        List < P360_DD_Sub_Category__c > clone_SubCategoryList = new List < P360_DD_Sub_Category__c > ();
        List < P360_Review_Area__c > clone_ReviewAreaList = new List < P360_Review_Area__c > ();
        
            
        //get Due Diligence record by query
        P360_Due_Diligence__c dueDiligenceRecrd = [SELECT Id,
            Category_Status__c,
            Completion_Status__c,
            Completion__c,
            Name,
            P360_DD_Assessment__c,
            P360_DD_Assessment_risk_summary__c,
            P360_Approval_Status__c,
            P360_CoverHolder_TPA_Name__c,
            P360_Coverholder_TPA_summary__c,
           // P360_Due_Diligence_Type__c,
            p360_Planned_Assessment_Start_Date__c,
            p360_Planned_Assessment_End_Date__c,
            p360_Actual_Assessment_Start_Date__c,
            p360_Actual_Assessment_End_Date__c,
            P360_CoverHolder_TPA_Name__r.Name,
            P360_DD_Is_this_Template__c,
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
            Record_Count__c FROM P360_Due_Diligence__c WHERE Id =: recordId
        ];
            // when clone action is done field mapping to get fields to updated in P360_Due_Diligence__c

        P360_Due_Diligence__c dueDiligenceClone = dueDiligenceRecrd.clone(false, true);
        dueDiligenceClone.Name = name;
        dueDiligenceClone.P360_Approval_Status__c = 'Pending';
        dueDiligenceClone.P360_CoverHolder_TPA_Name__c = coverHolderTPAName;
        // dueDiligenceClone.P360_Due_Diligence_Date__c = System.today();
        dueDiligenceClone.p360_Planned_Assessment_Start_Date__c = plannedAssessmentStartDate;
        dueDiligenceClone.p360_Planned_Assessment_End_Date__c = plannedAssessmentEndDate;

        try {
            insert dueDiligenceClone;
            system.debug('Cloning of DueDiligence done and cloned Record is created successfully');
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
                P360_CT_Is_applicable_Complaints__c FROM P360_DD_Category__c WHERE
                P360_Due_Diligence_Name__c =:
                dueDiligenceRecrd.Id
            ];

            if (!existingCategoryList.isEmpty()) {
                for (P360_DD_Category__c ddCategoryRecords: existingCategoryList) {
                    P360_DD_Category__c ddCloneCategory = ddCategoryRecords.clone(false, true);
                    ddCloneCategory.P360_Due_Diligence_Name__c = dueDiligenceClone.Id;
                    ddCloneCategory.P360_External_Id__c = ddCategoryRecords.Id;
                    ddCloneCategory.P360_Coverholder_TPA_Name__c = coverHolderTPAName;
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
                        P360_External_Id__c FROM P360_DD_Sub_Category__c WHERE P360_Category_Name__c =:
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
                        subCategory_Map.put(ddSubCategoryRecords.P360_External_Id__c,
                            ddSubCategoryRecords.Id);
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
                        P360_Completion_Marker__c,
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
                        P360_DD_Sub_Category__r.P360_Category_Name__c 
                        FROM P360_Review_Area__c WHERE P360_DD_Sub_Category__c =:
                        subCategory_Map.keySet() AND Due_Diligence__c =: recordId
                    ];

                    for (P360_Review_Area__c reviewAreaRecrds: existingReviewAreaList) {
                        if (subCategory_Map.containskey(reviewAreaRecrds.P360_DD_Sub_Category__c)) {
                            P360_Review_Area__c cloneReviewArea = reviewAreaRecrds.clone(false,true);
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
    // Creating Category Linkage records when category records are created 
        @AuraEnabled(cacheable = true) 
      public static void onCloneButtonClick(List<P360_DD_Category__c> newCategoryList) { 
         

      List<P360_DA_DD_Categories_Linkage__c> ddCategoryLinkageCloneList = new List<P360_DA_DD_Categories_Linkage__c>();
            for (P360_DD_Category__c newCategory : newCategoryList) {
            P360_DA_DD_Categories_Linkage__c ddCategoryLinkage = new P360_DA_DD_Categories_Linkage__c();
            ddCategoryLinkage.P360_DA_Category_Name__c = newCategory.Id;
            ddCategoryLinkage.P360_DA_Linked_Due_Diligence_Name__c=newCategory.P360_Due_Diligence_Name__c;
            //ddCategoryLinkage.P360_DA_CA_Linked_Status__c='cloned';           
                          
            ddCategoryLinkageCloneList.add(ddCategoryLinkage);
        }

        if (!ddCategoryLinkageCloneList.isEmpty()) {
            try{
            insert ddCategoryLinkageCloneList;                
                system.debug('P360_DA_DD_Categories_Linkage__c Record Created Successfully');                
            }catch (Exception e) {                
            throw new AuraHandledException(e.getMessage());
        }
        }       
    }
        @AuraEnabled(cacheable = true) 
    public static void onCloneClick(List < P360_DD_Sub_Category__c > newSubCategoryList) {

      List < P360_DA_DD_Sub_Category_Linkage__c > clone_SubCategoryLinkageList = new List < P360_DA_DD_Sub_Category_Linkage__c > ();
            for (P360_DD_Sub_Category__c newSubCategory : newSubCategoryList) {
            P360_DA_DD_Sub_Category_Linkage__c ddSubCategoryLinkage = new P360_DA_DD_Sub_Category_Linkage__c();
            ddSubCategoryLinkage.P360_DA_DD_Category_Linkage__c = newSubCategory.Id;
            ddSubCategoryLinkage.P360_DA_Linked_Due_Diligence_Name__c=newSubCategory.P360_Due_Diligence_Name__c;
            ddSubCategoryLinkage.P360_DA_DD_Category_Linkage__c=newSubCategory.P360_Category_Name__c;
            clone_SubCategoryLinkageList.add(ddSubCategoryLinkage);
        }

        if (!clone_SubCategoryLinkageList.isEmpty()) {
            try{
            insert clone_SubCategoryLinkageList;
                System.debug('P360_DA_DD_Sub_Category_Linkage__c Created Record Succesfully');
            }catch (Exception e) {                
            throw new AuraHandledException(e.getMessage());
        }
        }       
    }
        @AuraEnabled(cacheable = true) 
    public static void onCloneButtClick( List < P360_Review_Area__c > newReviewAreaList) {
     List < P360_DA_DD_Review_Area_Linkage__c > clone_ReviewAreaLinkageList = new List < P360_DA_DD_Review_Area_Linkage__c > ();
        for (P360_Review_Area__c newReviewArea : newReviewAreaList) {
            P360_DA_DD_Review_Area_Linkage__c ddReviewLinkageArea = new  P360_DA_DD_Review_Area_Linkage__c();
            ddReviewLinkageArea.P360_DA_Linked_Due_Diligence_Name__c = newReviewArea.Due_Diligence__c;
            ddReviewLinkageArea.P360_DA_DD_Sub_Category_Linkage__c = newReviewArea.P360_DD_Sub_Category__c;
            
            clone_ReviewAreaLinkageList.add(ddReviewLinkageArea);
        }
        if (!clone_ReviewAreaLinkageList.isEmpty()) {
            try{
            insert clone_ReviewAreaLinkageList;
                System.debug('P360_DA_DD_Review_Area_Linkage__c Created Record Succesfully');
            }catch (Exception e) {                
            throw new AuraHandledException(e.getMessage());
        }   
    } 
}
    
}
    
    
          





/* get related DD CategoriesLinkage records
           
             List < P360_DA_DD_Categories_Linkage__c > existingCategoryLinkageList = [SELECT Id,Name,
                    P360_DA_Category_Name__c,                    
                    P360_DA_Linked_Due_Diligence_Name__c
                    FROM P360_DA_DD_Categories_Linkage__c WHERE
                    P360_DA_Linked_Due_Diligence_Name__c =:dueDiligenceRecrd.Id];
            
            if (!existingCategoryLinkageList.isEmpty()) {
                for (P360_DA_DD_Categories_Linkage__c ddCategoryLinkageRecords: existingCategoryLinkageList) {
                    P360_DA_DD_Categories_Linkage__c ddCloneCategoryLinkage = ddCategoryLinkageRecords.clone(false, true);
                    ddCloneCategoryLinkage.P360_DA_Linked_Due_Diligence_Name__c = dueDiligenceClone.Id;
                    ddCloneCategoryLinkage.P360_DA_Category_Name__c = dueDiligenceClone.Category_Due_Diligence__c;
                    //ddCloneCategoryLinkage.P360_Coverholder_TPA_Name__c = coverHolderTPAName; // check need to update external Id 
                    ddCategoryLinkageCloneList.add(ddCloneCategoryLinkage);
                }
            }
            
            if (!ddCategoryLinkageCloneList.isEmpty()) {
                    insert ddCategoryLinkageCloneList;
                }
            
            Map < Id, P360_DA_DD_Categories_Linkage__c > categoryLinkageMap = new Map < Id, P360_DA_DD_Categories_Linkage__c > ();

                // put oldId and new recordId using Id 

                if (!ddCategoryLinkageCloneList.isEmpty()) {
                    for (P360_DA_DD_Categories_Linkage__c ddCategoryLinkageRecords: ddCategoryLinkageCloneList) {
                        categoryLinkageMap.put(ddCategoryLinkageRecords.Id, ddCategoryLinkageRecords);   /* check mapping parameters need to modify*/
             //       }
             //   }
            
            // get related DD Sub-Category Linkage records based on oldId

             /*   if (!categoryLinkageMap.IsEmpty()) {
                    List < P360_DA_DD_Sub_Category_Linkage__c > existingSubCategoryLinkageList = [SELECT Id,Name,
                           P360_DA_DD_Category_Linkage__c,
                           P360_DA_Linked_Due_Diligence_Name__c,
                           P360_DA_Sub_Category_Name__c FROM P360_DA_DD_Sub_Category_Linkage__c WHERE P360_DA_DD_Category_Linkage__c =:
                           categoryLinkageMap.keySet() AND P360_DA_Linked_Due_Diligence_Name__c =: recordId];
                }
            
             for (P360_DA_DD_Sub_Category_Linkage__c ddSubCategoryLinkageRecrd: existingSubCategoryLinkageList) {
                        if (categoryLinkageMap.containskey(ddSubCategoryLinkageRecrd.P360_DA_DD_Category_Linkage__c)) {
                            P360_DA_DD_Sub_Category_Linkage__c ddCloneSubCategoryLinkage = ddSubCategoryLinkageRecrd.clone(false,true);
                            ddCloneSubCategoryLinkage.P360_DA_DD_Category_Linkage__c = categoryLinkageMap.get(ddSubCategoryLinkageRecrd.P360_DA_DD_Category_Linkage__c).Id;
                            //ddCloneSubCategoryLinkage.Name = ddSubCategoryLinkageRecrd.Id;
                            ddCloneSubCategoryLinkage.P360_DA_Linked_Due_Diligence_Name__c = dueDiligenceClone.Id;
                            //ddCloneSubCategoryLinkage.P360_Coverholder_TPA_Name__c = coverHolderTPAName;
                            clone_SubCategoryLinkageList.add(ddCloneSubCategoryLinkage);
                        }
                    }
                       if (!clone_SubCategoryLinkageList.IsEmpty()) {
                        insert clone_SubCategoryLinkageList;
                    }
 Map < Id, P360_DA_DD_Sub_Category_Linkage__c > subCategoryLinkage_Map = new Map < Id, P360_DA_DD_Sub_Category_Linkage__c > ();

                // put oldId and new recordId using 

                if (!clone_SubCategoryLinkageList.isEmpty()) {
                    for (P360_DA_DD_Sub_Category_Linkage__c ddSubCategoryLinkageRecrd:
                        clone_SubCategoryLinkageList) {
                        subCategoryLinkage_Map.put(ddSubCategoryLinkageRecrd.Id,ddSubCategoryLinkageRecrd); // need to check mapping
                    }
                }
            
            // get DD Linkage review area records based on sub category oldId
                if (!subCategoryLinkage_Map.isEmpty()) {
                    List < P360_DA_DD_Review_Area_Linkage__c > existingReviewAreaLinkageList = [SELECT Id,
                           Name,
                           P360_DA_Linked_Due_Diligence_Name__c,
                           P360_DA_RA_Linked_Status__c,
                           P360_DA_DD_Sub_Category_Linkage__c
                           FROM P360_DA_DD_Review_Area_Linkage__c WHERE P360_DA_DD_Sub_Category_Linkage__c =:
                           subCategoryLinkage_Map.keySet() AND 	P360_DA_Linked_Due_Diligence_Name__c =: recordId
                    ];
                }
                        for (P360_DA_DD_Review_Area_Linkage__c reviewAreaLinkageRecrds: existingReviewAreaLinkageList) {
                        if (subCategoryLinkage_Map.containskey(reviewAreaLinkageRecrds.P360_DA_DD_Sub_Category_Linkage__c)) {
                            P360_DA_DD_Review_Area_Linkage__c cloneReviewAreaLinkage = reviewAreaLinkageRecrds.clone(false,true);
                            //cloneReviewAreaLinkage.P360_DA_DD_Sub_Category_Linkage__c = subCategoryLinkage_Map.get(reviewAreaLinkageRecrds.P360_DA_DD_Sub_Category_Linkage__c);
                            cloneReviewAreaLinkage.P360_DA_Linked_Due_Diligence_Name__c = dueDiligenceClone.Id;
                            //cloneReviewArea.P360_CoverHolder_Name__c = coverHolderTPAName;
                             //cloneReviewAreaLinkage.P360_RA_Category__c = categoryMap.get(reviewAreaRecrds.P360_DD_Sub_Category__r.P360_Category_Name__c).Id;
                             clone_ReviewAreaLinkageList.add(cloneReviewAreaLinkage);
                        }
                    }

             if (!clone_ReviewAreaLinkageList.isEmpty()) {
                        insert clone_ReviewAreaLinkageList;
                    }                                                                   
                                                                                                  
   */