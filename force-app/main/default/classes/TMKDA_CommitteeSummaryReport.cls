public class TMKDA_CommitteeSummaryReport {
    
    public P360_Due_Diligence__c duediligence {set;get;}
    public List<CategoryWrapperClass> category {set;get;}
    public List<P360_DA_DD_Sub_Category_Linkage__c> subCategory {set;get;}
    public List<P360_DA_DD_Review_Area_Linkage__c> reviewArea {set;get;}

//    public String totalAmount {set;get;}   
    public string generateddate {get;set;}
    
    public TMKDA_CommitteeSummaryReport (ApexPages.StandardController standardPageController){
        DateTime d = Date.Today() ;
        String dateStr =  d.format('dd/MM/yyyy') ;

        this.generatedDate = dateStr;
    
        // Query the DD record
       	duediligence = [SELECT Id, Name, P360_DD_Coverholder_or_DCA__c, P360_Due_Diligence_Type__c, P360_CoverHolder_TPA_Name__r.Name,
                       			TMKDA_Binder_Renewal_Date__c, TMKDA_Domicile__c, P360_DD_Coverholder_Live_Date__c, P360_DD_Total_EPI__c,
                       			P360_DD_Line_of_Business__c, TMKDA_Previous_Committee_Date__c, P360_DD_Number_of_Live_Binders__c, 
                       			TMKDA_DD_Connection_Status__c, P360_DD_Number_of_Run_Off_Binders__c,P360_DD_Customer_Domicile__c,
                   			  	P360_DD_Risk_Location__c, TMKDA_Overview__c, P360_DD_Last_Audit_Date__c, P360_DD_Next_Audit_Date__c,
                       			P360_Recommendation__c, TMKDA_High_Actions_Report__c, TMKDA_Medium_Actions_Report__c, TMKDA_Low_Actions_Report__c,
                       			TMKDA_High_Open_at_DD_Review_Date__c,TMKDA_Medium_Open_at_DD_Review_Date__c,TMKDA_Low_Open_at_DD_Review_Date__c,
                              	TMKDA_High_Overview_at_DD_Review_Date__c,TMKDA_Medium_Overview_at_DD_Review_Date__c,TMKDA_Low_Overview_at_DD_Review_Date__c,
                        		P360_Due_Diligence_Summary__c, P360_Approval_Method__c,
                        		P360_Attestation_Signed_By__c, TMKDA_Completed_By_Name_Rpt__c, P360_Completed_By__c, 
                        		TMKDA_DD_Peer_Approver_Name_Rpt__c, P360_DA_Peer_Reviewer__c, TMKDA_Commitee_Date__c,
                        		P360_Date_Attestation_Received__c, P360_Date_Completed__c, P360_Date_Signed_Off__c, TMKDA_Committee_Date_Completed__c
                       FROM P360_Due_Diligence__c
                       WHERE Id =: standardPageController.getRecord().Id
                              ];   
        
 		// NEW CODE for *** Linked Category ****    
 		   
       	List<P360_DA_DD_Categories_Linkage__c> 
            
       	categoryObj = [SELECT 	Id, 
                       			P360_DA_Category_Name__r.Name,											P360_DA_Category_Name__r.TMKDA_High_Risk_Customer_Type__c, 		
                       			P360_DA_Category_Name__r.TMKDA_CA_Highest_PDT_Output__c,					P360_DA_Category_Name__r.TMKDA_Number_of_BPAs__c, 
                       			P360_DA_Category_Name__r.TMKDA_Does_attestation_confirm_a_new_TCF__c,	TMKDA_Connect_To_Primary__c, TMKDA_Primary_Linked__c,
                       	// Connected_to_Primary_linkage__c, //P360_DA_Category_Name__r.TMKDA_Connected_to_a_Primary__c, 
                       			P360_DA_Category_Name__r.TMKDA_High_Monitored_List__c, 					P360_DA_Category_Name__r.TMKDA_Level_of_Authority__c, 
                       			P360_DA_Category_Name__r.TMKDA_attestationconfirm_a_new_Complaint__c,	P360_DA_Category_Name__r.TMKDA_Has_a_new_Complaints_policy__c, 
                       			P360_DA_Category_Name__r.P360_Loss_Fund__c, 							P360_DA_Category_Name__r.P360_CT_Date_of_claims_sign_off_review__c, 
                       			P360_DA_Category_Name__r.TMKDA_Has_a_new_Claims_Procedure__c,			P360_DA_Category_Name__r.TMKDA_Claims_authority_limit__c, 
                       			P360_DA_Category_Name__r.TMKDA_Coverholder_have_claims_authority__c, 	P360_DA_Category_Name__r.TMKDA_Are_Claims_delegated_to_a_DCA__c,
                    	   		P360_DA_Category_Name__r.TMKDA_Is_Operational_Resilience_in_scope__c, 	P360_DA_Category_Name__r.P360_In_Scope_for_Whistleblowing__c, 
                       			P360_DA_Category_Name__r.TMKDA_Does_attestation_confirm_a_new_DRP__c,	P360_DA_Category_Name__r.TMKDA_Does_attestation_confirm_a_new_BCP__c,
                       			P360_DA_Category_Name__r.TMKDA_Has_a_new_whistleblowing_policy__c,		P360_DA_Category_Name__r.TMKDA_attestationconfirmnew_Outsourci__c,
                    	   		P360_DA_Category_Name__r.TMKDA_Has_a_new_Info_Security_policy__c, 		P360_DA_Category_Name__r.TMKDA_Has_a_new_Data_Protection_policy__c, 
                       			P360_DA_Category_Name__r.P360_Highest_data_type_held__c, 				P360_DA_Category_Name__r.TMKDA_Is_GDPR_in_scope__c,
                    	   		P360_DA_Category_Name__r.TMKDA_Has_a_new_Accounting_Procedure__c, 		P360_DA_Category_Name__r.P360_JMD_rating_at_latest_review__c, 
                       			P360_DA_Category_Name__r.TMKDA_Inherent_AB_C__c, 						P360_DA_Category_Name__r.TMKDA_Inherent_AML__c,
                       			P360_DA_Category_Name__r.TMKDA_Inherent_Sactions__c, 					P360_DA_Category_Name__r.TMKDA_Attestation_Fin_Crime_policy__c, 
                       			P360_DA_Category_Name__r.TMKDA_Highest_underwriting_authority__c,		P360_DA_Category_Name__r.TMKDA_Attestation_has_new_system__c,
                       			P360_DA_Category_Name__r.TMKDA_Attestation_new_Succession_plan__c
                    	FROM  P360_DA_DD_Categories_Linkage__c  
                    	WHERE P360_DA_Linked_Due_Diligence_Name__c =: duediligence.Id
//                      	AND	  TMKDA_Show_in_DDCS__c = 'Yes'
                      	ORDER BY P360_DA_Category_Name__r.Name];        
        try{
            category = new List<CategoryWrapperClass>();
        
            for (P360_DA_DD_Categories_Linkage__c cLink : categoryObj){
        		CategoryWrapperClass cws = New CategoryWrapperClass();
            
        		cws.Id 											= cLink.Id;    
        		cws.Name 										= cLink.P360_DA_Category_Name__r.Name;    
	        	cws.TMKDA_High_Risk_Customer_Type_wc 			= cLink.P360_DA_Category_Name__r.TMKDA_High_Risk_Customer_Type__c;    
    	    	cws.TMKDA_Highest_PDT_Output_wc 				= cLink.P360_DA_Category_Name__r.TMKDA_CA_Highest_PDT_Output__c; //updated by Sarwar on 03/20/24   
        		cws.TMKDA_Number_of_BPAs_wc 					= cLink.P360_DA_Category_Name__r.TMKDA_Number_of_BPAs__c;    
        		cws.TMKDA_Does_attestation_confirm_a_new_TCF_wc	= cLink.P360_DA_Category_Name__r.TMKDA_Does_attestation_confirm_a_new_TCF__c;    
	        	cws.TMKDA_Connect_To_Primary_wc 				= cLink.TMKDA_Connect_To_Primary__c;    
	        	cws.TMKDA_Primary_Linked_wc 					= cLink.TMKDA_Primary_Linked__c;    
    	    	cws.TMKDA_High_Monitored_List_wc 				= cLink.P360_DA_Category_Name__r.TMKDA_High_Monitored_List__c;    
        		cws.TMKDA_Level_of_Authority_wc 				= cLink.P360_DA_Category_Name__r.TMKDA_Level_of_Authority__c;    
        		cws.TMKDA_attestationconfirm_a_new_Complaint_wc = cLink.P360_DA_Category_Name__r.TMKDA_attestationconfirm_a_new_Complaint__c;    
	        	cws.TMKDA_Has_a_new_Complaints_policy_wc 		= cLink.P360_DA_Category_Name__r.TMKDA_Has_a_new_Complaints_policy__c;    
    	    	cws.P360_Loss_Fund_wc 							= cLink.P360_DA_Category_Name__r.P360_Loss_Fund__c;    
        		cws.P360_CT_Date_of_claims_sign_off_review_wc 	= cLink.P360_DA_Category_Name__r.P360_CT_Date_of_claims_sign_off_review__c;    
        		cws.TMKDA_Has_a_new_Claims_Procedure_wc 		= cLink.P360_DA_Category_Name__r.TMKDA_Has_a_new_Claims_Procedure__c;    
	        	cws.TMKDA_Claims_authority_limit_wc 			= cLink.P360_DA_Category_Name__r.TMKDA_Claims_authority_limit__c;    
    	    	cws.TMKDA_Coverholder_have_claims_authority_wc 	= cLink.P360_DA_Category_Name__r.TMKDA_Coverholder_have_claims_authority__c;    
        		cws.TMKDA_Are_Claims_delegated_to_a_DCA_wc 		= cLink.P360_DA_Category_Name__r.TMKDA_Are_Claims_delegated_to_a_DCA__c;    
        		cws.TMKDA_Is_Operational_Resilience_in_scope_wc	= cLink.P360_DA_Category_Name__r.TMKDA_Is_Operational_Resilience_in_scope__c;    
	        	cws.P360_In_Scope_for_Whistleblowing_wc 		= cLink.P360_DA_Category_Name__r.P360_In_Scope_for_Whistleblowing__c;    
    	    	cws.TMKDA_Does_attestation_confirm_a_new_DRP_wc	= cLink.P360_DA_Category_Name__r.TMKDA_Does_attestation_confirm_a_new_DRP__c;    
        		cws.TMKDA_Does_attestation_confirm_a_new_BCP_wc	= cLink.P360_DA_Category_Name__r.TMKDA_Does_attestation_confirm_a_new_BCP__c;    
        		cws.TMKDA_Has_a_new_whistleblowing_policy_wc 	= cLink.P360_DA_Category_Name__r.TMKDA_Has_a_new_whistleblowing_policy__c;    
	        	cws.TMKDA_attestationconfirmnew_Outsourci_wc 	= cLink.P360_DA_Category_Name__r.TMKDA_attestationconfirmnew_Outsourci__c;    
    	    	cws.TMKDA_Has_a_new_Info_Security_policy_wc 	= cLink.P360_DA_Category_Name__r.TMKDA_Has_a_new_Info_Security_policy__c;    
        		cws.TMKDA_Has_a_new_Data_Protection_policy_wc 	= cLink.P360_DA_Category_Name__r.TMKDA_Has_a_new_Data_Protection_policy__c;    
        		cws.P360_Highest_data_type_held_wc 				= cLink.P360_DA_Category_Name__r.P360_Highest_data_type_held__c;    
	        	cws.TMKDA_Is_GDPR_in_scope_wc 					= cLink.P360_DA_Category_Name__r.TMKDA_Is_GDPR_in_scope__c;    
    	    	cws.TMKDA_Has_a_new_Accounting_Procedure_wc 	= cLink.P360_DA_Category_Name__r.TMKDA_Has_a_new_Accounting_Procedure__c;    
        		cws.P360_JMD_rating_at_latest_review_wc 		= cLink.P360_DA_Category_Name__r.P360_JMD_rating_at_latest_review__c;    
        		cws.TMKDA_Inherent_AB_C_wc 						= cLink.P360_DA_Category_Name__r.TMKDA_Inherent_AB_C__c;    
	        	cws.TMKDA_Inherent_AML_wc 						= cLink.P360_DA_Category_Name__r.TMKDA_Inherent_AML__c;    
    	    	cws.TMKDA_Inherent_Sactions_wc 					= cLink.P360_DA_Category_Name__r.TMKDA_Inherent_Sactions__c;    
        		cws.TMKDA_Attestation_Fin_Crime_policy_wc 		= cLink.P360_DA_Category_Name__r.TMKDA_Attestation_Fin_Crime_policy__c;    
        		cws.TMKDA_Highest_underwriting_authority_wc 	= cLink.P360_DA_Category_Name__r.TMKDA_Highest_underwriting_authority__c;
	        	cws.TMKDA_Attestation_has_new_system_wc 		= cLink.P360_DA_Category_Name__r.TMKDA_Attestation_has_new_system__c;
    	    	cws.TMKDA_Attestation_new_Succession_plan_wc 	= cLink.P360_DA_Category_Name__r.TMKDA_Attestation_new_Succession_plan__c;
        
                category.add(cws);
	        }
        }
        catch(exception ex){
            system.debug('-----ex '+ex.getLineNumber());
        }
            
        
 // ENDS HERE ****
	// Query Sub-category records for the Category
     /*	subCategory = [SELECT Id, Name, P360_Category_Name__r.Name 
            		   		FROM  P360_DD_Sub_Category__c 
                            WHERE P360_Due_Diligence_Name__c =: duediligence.Id];  */
		subCategory = [SELECT Id, Name, P360_DA_Sub_Category_Name__r.Name, P360_DA_Category_Name_linkage__c 
                       FROM  P360_DA_DD_Sub_Category_Linkage__c 
                       WHERE P360_DA_Linked_Due_Diligence_Name__c =: duediligence.Id ORDER BY P360_DA_Sub_Category_Name__r.Name];
        
        
   	// Query Review-Area records for the Sub-Category
/*        reviewArea = [SELECT Id, P360_DD_Sub_Category__r.Name, Name, TMKDA_Answer__c, TMKDA_Source__c,
                              	P360_Comment__c, P360_DA_Review_Area_Name__c, P360_Review_Point__c, TMKDA_Primary_Linked__c, P360_Summary__c
                         FROM P360_Review_Area__c 
                         WHERE Due_Diligence__c =: duediligence.Id]; // P360_DD_Sub_Category__c  =: subCategory AND   */
        
        
        reviewArea = [SELECT Id, Name, 
                      			P360_DA_Review_Area_Name__r.P360_Comment__c, 
                      			P360_DA_Review_Area_Name__r.P360_Assessment__c, 
                      			P360_DA_Review_Area_Name__r.TMKDA_Source__c,
                      			P360_DA_Review_Area_Name__r.TMKDA_Answer__c, P360_DA_Review_Area_Name__r.TMKDA_Answer_formula__c, 
                      			P360_DA_Review_Area_Name__r.P360_Review_Point__c,
                      			P360_DA_Category_linkage__c, P360_DA_DD_Sub_Category_Linkage__c, 
                      			P360_DA_Linked_Due_Diligence_Name__c,TMKDA_Primary_Connected_Value_formula__c,
                      			P360_DA_Party_Name__c, P360_DA_Primary_Linked__c, P360_DA_RA_Linked_Status__c, P360_DA_Review_Area_Name__c,
                      			P360_DA_Sub_Category_linkage__c, P360_Linked_Sub_category_Name__c, TMKDA_Pass_Fail__c, TMKDA_Linked_Category__c  
                      	FROM P360_DA_DD_Review_Area_Linkage__c 
                      	WHERE P360_DA_Linked_Due_Diligence_Name__c =: duediligence.Id
                     	AND	TMKDA_Pass_Fail__c IN ('Risk Accepted','Fail')
                     ];
  	}
    
    public class CategoryWrapperClass {
        public String Id{set;get;}
        public String Name{set;get;}
        public String TMKDA_High_Risk_Customer_Type_wc{set;get;}
        public String TMKDA_Highest_PDT_Output_wc{set;get;} //Change data type from Decimal to String by Sarwar on 03/20/2024
        public Decimal TMKDA_Number_of_BPAs_wc{set;get;}
        public String TMKDA_Does_attestation_confirm_a_new_TCF_wc{set;get;}
        public String TMKDA_Connect_To_Primary_wc{set;get;}
        public Boolean TMKDA_Primary_Linked_wc{set;get;}
        public String TMKDA_High_Monitored_List_wc{set;get;}
        public String TMKDA_Level_of_Authority_wc{set;get;}
        public String TMKDA_attestationconfirm_a_new_Complaint_wc{set;get;}
        public String TMKDA_Has_a_new_Complaints_policy_wc{set;get;}
        public Decimal P360_Loss_Fund_wc{set;get;}
        public Date P360_CT_Date_of_claims_sign_off_review_wc{set;get;}
        public String TMKDA_Has_a_new_Claims_Procedure_wc{set;get;}
        public String TMKDA_Claims_authority_limit_wc{set;get;}
        public String TMKDA_Coverholder_have_claims_authority_wc{set;get;}
        public String TMKDA_Are_Claims_delegated_to_a_DCA_wc{set;get;}
        public String TMKDA_Is_Operational_Resilience_in_scope_wc{set;get;}
        public String P360_In_Scope_for_Whistleblowing_wc{set;get;}
        public String TMKDA_Does_attestation_confirm_a_new_DRP_wc{set;get;}
        public String TMKDA_Does_attestation_confirm_a_new_BCP_wc{set;get;}
        public String TMKDA_Has_a_new_whistleblowing_policy_wc{set;get;}
        public String TMKDA_attestationconfirmnew_Outsourci_wc{set;get;}
        public String TMKDA_Has_a_new_Info_Security_policy_wc{set;get;}
        public String TMKDA_Has_a_new_Data_Protection_policy_wc{set;get;}
        public String P360_Highest_data_type_held_wc{set;get;}
        public String TMKDA_Is_GDPR_in_scope_wc{set;get;}
        public String TMKDA_Has_a_new_Accounting_Procedure_wc{set;get;}
        public String P360_JMD_rating_at_latest_review_wc{set;get;}
        public String TMKDA_Inherent_AB_C_wc{set;get;}
        public String TMKDA_Inherent_AML_wc{set;get;}
        public String TMKDA_Inherent_Sactions_wc{set;get;}
        public String TMKDA_Attestation_Fin_Crime_policy_wc{set;get;}
        public String TMKDA_Highest_underwriting_authority_wc{set;get;}
        public String TMKDA_Attestation_has_new_system_wc{set;get;}
        public String TMKDA_Attestation_new_Succession_plan_wc{set;get;}
    }
}