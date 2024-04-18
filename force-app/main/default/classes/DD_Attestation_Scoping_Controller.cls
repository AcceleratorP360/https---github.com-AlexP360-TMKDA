public with sharing class DD_Attestation_Scoping_Controller {

    public TMKDA_DD_Attestation_Scoping__c ddAttestationScoping { get; set; }
    public TMKDA_DD_Attestation_Scoping__c ddAttestationScopingExisting;
    public String selectedContact { get; set; }
    public TMKDA_DD_Attestation_Form__c Clist;
    public String recordId;
    public String Type { get; set; }
    public String fileName { get; set; }
    public transient  blob file { get; set; }
    public String title{ get;set; }
    public ContentVersion cv { get; set; }
    public String linkValue { get; set; }
    String contactId = System.currentPagereference().getParameters().get('Id');
 //   public List<Attachment> fileList {get; set;}
 //   public TMKDA_DD_Attestation_Scoping__c scopingFiles {get; set;}
 //   public Attachment attach {get; set;}
  
  //File upload method
  public PageReference upload() {
            ContentVersion cv = new ContentVersion();
            cv.versionData = file;
            cv.title = title;
            cv.pathOnClient = fileName;
            cv.FirstPublishLocationId = contactId; 
            try
            {
                Insert cv;
            }
            catch (DMLException e)
            {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error uploading Document in Library'));
                return null;
            }
            finally
            {
                cv = new ContentVersion();
            }
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Document uploaded successfully to library'));
            return null;
        } 
   
 /*   public PageReference redirect() {
       PageReference viewPage = new PageReference('/apex/ViewAttestationScoping?id=' + recordId);
        viewPage.getParameters().put('redirect', 'true');
        viewPage.setRedirect(true);
        return viewPage;
    } */
    
  /* 
    public TMKDA_DD_Attestation_Scoping__c getScopingFiles(){
      if(scopingFiles == null) 
      scopingFiles = new TMKDA_DD_Attestation_Scoping__c();
        return scopingFiles; 
     }
    
      public List<Attachment> getAttachments(){
      if(fileList == null) 
      fileList = new List<Attachment>();
        return fileList; 
     }
     
     public PageReference AddAttachs() {
        fileList.add(new Attachment());
        return null;
      }
       
 public PageReference uploadAttachment() { 
   insert scopingFiles;
      
               if(scopingFiles != null) {            
               List<Attachment> attachments = new List<Attachment>();                               
                      
                for(Attachment att : fileList)              
                { 
                if(att.name != null && att.body != null)
                attachments.add(new Attachment(parentId = scopingFiles.Id, name = att.name, body = att.body)) ;                
                }
               if(attachments != null){
                upsert attachments;                 
                ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.INFO, attachments.size() + ' file(s) uploaded successfully'));                                              
                }else {
                 ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'Error uploading file'));
                }              
     }                    
  
      return null;      
    }      */
   
    //Initializing class
   public DD_Attestation_Scoping_Controller() {
        recordId = ApexPages.currentPage().getParameters().get('id');
       
     /*  attach = new Attachment();
       fileList = new List<Attachment>();
       fileList.add(attach); */
       
        system.debug('recordId >>>>' +recordId);
        if (String.isNotBlank(recordId)) {
            getData();
        } 
    }
    
    //Query to get scoping records
      private  void getData() {
        List<TMKDA_DD_Attestation_Scoping__c> records = [Select Id,OwnerId, Name, CreatedById, LastModifiedById, TMKDA_DA_Analyst__c, TMKDA_Scoping_Date__c, 
                                                        TMKDA_Review_Scope__c,TMKDA_Contact__c,TMKDA_Company_Name__c, TMKDA_Claims_Handling__c,
                                                        TMKDA_PDT_Outcome__c, TMKDA_Is_IDD_in_scope__c, TMKDA_Company_Type__c,TMKDA_Due_Diligence__c,
                                                        TMKDA_Is_Whistleblowing_in_Scope__c, TMKDA_Is_Succession_Planning_in_Scope__c,
                                                        TMKDA_ATT_001__c,TMKDA_ATT_002__c, TMKDA_ATT_003__c,TMKDA_ATT_004__c,TMKDA_ATT_005__c,TMKDA_ATT_006__c,
                                                        TMKDA_ATT_007__c,TMKDA_ATT_008__c,TMKDA_ATT_009__c,TMKDA_ATT_010__c,TMKDA_ATT_011__c,TMKDA_ATT_012__c,
                                                        TMKDA_ATT_013__c,TMKDA_ATT_014__c,TMKDA_ATT_015__c,TMKDA_ATT_016__c,TMKDA_ATT_017__c,TMKDA_ATT_018__c,
                                                        TMKDA_ATT_019__c,TMKDA_ATT_020__c,TMKDA_ATT_021__c,TMKDA_ATT_022__c,TMKDA_ATT_023__c,TMKDA_ATT_024__c,
                                                        TMKDA_ATT_025__c,TMKDA_ATT_026__c,TMKDA_ATT_027__c,TMKDA_ATT_028__c,TMKDA_ATT_029__c,TMKDA_ATT_030__c,
                                                        TMDKA_ATT_031__c,TMKDA_ATT_032__c,TMKDA_ATT_033__c,TMKDA_ATT_034__c,TMKDA_ATT_035__c,TMKDA_ATT_036__c,
                                                        TMKDA_ATT_037__c,TMKDA_ATT_038__c,TMKDA_ATT_039__c,TMKDA_ATT_040__c,TMKDA_ATT_041__c,TMKDA_ATT_042__c,
                                                        TMKDA_Attestation_Start_Date__c,TMKDA_Attestation_End_Date__c,Send_Attestation_Form_Contact__c,
                                                        TMKDA_Com_Type__c,TMKDA_CH_Attestation_Link__c,TMKDA_DueDiligence_Name__c,DA_Analyst__c,TMKDA_Attestation_Summary__c,
                                                        TMKDA_DD_Record_Type__c,TMKDA_Name__c,TMKDA_Position__c,TMKDA_Signoff_Comments__c,TMKDA_Peer_Review_Notes__c,TMKDA_Date__c,
                                                        TMKDA_LMA_Q1__c,TMKDA_LMA_Q2__c,TMKDA_LMA_Q3__c,TMKDA_LMA_Q4__c,TMKDA_LMA_Q5__c,TMKDA_LMA_Q6__c,TMKDA_LMA_Q7__c,
                                                        TMKDA_LMA_Q8__c,TMKDA_LMA_Q9__c,TMKDA_LMA_Q10__c,TMKDA_LMA_Q11__c,TMKDA_LMA_Q12__c,TMKDA_LMA_Q13__c,TMKDA_LMA_Q14__c,
                                                        TMKDA_LMA_Q15__c,TMKDA_LMA_Q16__c,TMKDA_LMA_Q17__c,TMKDA_ATT_0171__c,TMKDA_ATT_0172__c,TMKDA_ATT_0173__c,TMKDA_ATT_0174__c,
                                                        TMKDA_LMA_Q1_Comments__c,TMKDA_LMA_Q2_Comments__c,TMKDA_LMA_Q3_Comments__c,TMKDA_LMA_Q4_Comments__c,TMKDA_LMA_Q5_Comments__c,
                                                        TMKDA_LMA_Q6_Comments__c,TMKDA_LMA_Q7_Comments__c,TMKDA_LMA_Q8_Comments__c,TMKDA_LMA_Q9_Comments__c,TMKDA_LMA_Q10_Comments__c,
                                                        TMKDA_LMA_Q11_Comments__c,TMKDA_LMA_Q12_Comments__c,TMKDA_LMA_Q13_Comments__c,TMKDA_LMA_Q14_Comments__c,
                                                        TMKDA_LMA_Q15_Comments__c,TMKDA_LMA_Q16_Comments__c,TMKDA_LMA_Q17_Comments__c,
                                                        TMKDA_UserComments_ATT_001__c,TMKDA_UserComments_ATT_002__c,TMKDA_UserComments_ATT_003__c,TMKDA_UserComments_ATT_004__c,
                                                        TMKDA_UserComments_ATT_005__c,TMKDA_UserComments_ATT_006__c,TMKDA_UserComments_ATT_007__c,TMKDA_UserComments_ATT_008__c,
                                                        TMKDA_UserComments_ATT_009__c,TMKDA_UserComments_ATT_010__c,TMKDA_UserComments_ATT_011__c,TMKDA_UserComments_ATT_012__c,
                                                        TMKDA_UserComments_ATT_013__c,TMKDA_UserComments_ATT_014__c,TMKDA_UserComments_ATT_015__c,TMKDA_UserComments_ATT_016__c,
                                                        TMKDA_UserComments_ATT_0171__c,TMKDA_UserComments_ATT_0172__c,TMKDA_UserComments_ATT_0173__c,TMKDA_UserComments_ATT_0174__c,
                                                        TMKDA_UserComments_ATT_018__c,TMKDA_UserComments_ATT_019__c,TMKDA_UserComments_ATT_020__c,TMKDA_UserComments_ATT_021__c,
                                                        TMKDA_UserComments_ATT_022__c,TMKDA_UserComments_ATT_023__c,TMKDA_UserComments_ATT_024__c,TMKDA_UserComments_ATT_025__c,
                                                        TMKDA_UserComments_ATT_026__c,TMKDA_UserComments_ATT_028__c,TMKDA_UserComments_ATT_029__c,TMKDA_UserComments_ATT_030__c,
                                                        TMKDA_UserComments_ATT_031__c,TMKDA_UserComments_ATT_032__c,TMKDA_UserComments_ATT_033__c,TMKDA_UserComments_ATT_034__c,
                                                        TMKDA_UserComments_ATT_035__c,TMKDA_UserComments_ATT_036__c,TMKDA_UserComments_ATT_037__c,
                                                        TMKDA_UserComments_ATT_038__c,TMKDA_UserComments_ATT_039__c
                                                        FROM TMKDA_DD_Attestation_Scoping__c 
                                                        WHERE Id = :recordId LIMIT 1];

          //  system.debug(records.size());
          if (records.size() > 0) {
            ddAttestationScopingExisting = records[0];
            ddAttestationScoping = ddAttestationScopingExisting.clone(false);
        }
    } 
    
    
    //Submit method to capture and process form submission
    public PageReference submit() {
        
      //  String recordId = ApexPages.currentPage().getParameters().get('id');  
     //   system.debug('recordId SUBMIT>>>>' +recordId);
     
        ddAttestationScoping.Id = ddAttestationScopingExisting.Id;
      //  DD_Attestation_Scoping_Controller_WS.updateObject(ddAttestationScoping);
    
        TMKDA_DD_Attestation_Form__c Clist = new TMKDA_DD_Attestation_Form__c();     
        clist.TMKDA_DD_Attestation_Scoping__c = ddAttestationScopingExisting.Id;
        Clist.Name = ddAttestationScoping.Name;
        Clist.TMKDA_Due_Diligence__c = ddAttestationScoping.TMKDA_Due_Diligence__c;     
        Clist.TMKDA_DD_Attestation_Scoping__c = recordId;     
      
        Clist.TMKDA_Annual_Compliance__c = ddAttestationScoping.TMKDA_ATT_029__c; //att29
        Clist.TMKDA_Any_changes_to_business_system_s__c = ddAttestationScoping.TMKDA_ATT_018__c; //att18
        Clist.TMKADA_Any_changes_to_company_ownership__c = ddAttestationScoping.TMKDA_ATT_019__c; //att19;
        Clist.TMKDA_Any_changes_to_financial_promotion__c = ddAttestationScoping.TMKDA_ATT_016__c; //att16;
        Clist.TMKDA_material_business_func_outsourced__c = ddAttestationScoping.TMKDA_ATT_026__c; //att26;
        Clist.TMKDA_DRP_issues_improvements_identified__c = ddAttestationScoping.TMKDA_ATT_025__c; //att25;
        Clist.TMDA_LicensesandPermitsdeclarationmadeon__c = ddAttestationScoping.TMKDA_ATT_020__c; // att20;
        Clist.TMKDA_Any_issues_improvements_been_id__c = ddAttestationScoping.TMKDA_ATT_023__c; //att23;
        Clist.TMKDA_Binders_requiring_BPA__c = ddAttestationScoping.TMKDA_ATT_015__c; //att15;
        Clist.TMKDA_Changes_to_level_of_customer_data__c = ddAttestationScoping.TMKDA_ATT_027__c; //att27;
        Clist.TMKDA_Conflicts_of_interest_log_provided__c = ddAttestationScoping.TMKDA_ATT_032__c; //att32;
        Clist.TMKDA_Financials_YOA__c = ddAttestationScoping.TMKDA_ATT_030__c; //att30;
        Clist.TMKDA_Gifts_Entertainment_log__c = ddAttestationScoping.TMKDA_ATT_033__c; //att33;
        Clist.TMKDA_Has_a_complaints_log_been_provided__c = ddAttestationScoping.TMDKA_ATT_031__c; //att31;
        Clist.TMKDA_Has_a_new_Conflicts_of_Interest_po__c = ddAttestationScoping.TMKDA_ATT_004__c; //att4;
        Clist.TMKDA_Has_a_new_DRP_been_int__c = ddAttestationScoping.TMKDA_ATT_007__c; //att7;
        Clist.TMKDA_IDD_training_log__c = ddAttestationScoping.TMKDA_ATT_036__c; //att36;
        Clist.TMKDA_Information_Security__c = ddAttestationScoping.TMKDA_ATT_011__c; //att11;
        Clist.TMKDA_Is_the_BCP_tested_annually__c = ddAttestationScoping.TMKDA_ATT_022__c; //att22;
        Clist.TMKDA_Is_the_DRP_tested_annually__c = ddAttestationScoping.TMKDA_ATT_024__c; //att24;
        Clist.TMKDA_Latest_Financials_YOA__c = ddAttestationScoping.TMKDA_ATT_035__c; //att35;
        Clist.TMKDA_Live_EO_policy__c = ddAttestationScoping.TMKDA_ATT_034__c; //att34;
        Clist.TMKDA_Loss_Funds__c = ddAttestationScoping.TMKDA_ATT_013__c; //att13;
        Clist.TMKDA_ew_Accounting_procedure_introduced__c = ddAttestationScoping.TMKDA_ATT_014__c; //att14;
        Clist.TMKDA_New_BCP_been_introduced__c = ddAttestationScoping.TMKDA_ATT_006__c; //att6;
        Clist.TMKDA_New_Claims_procedure_been_intro__c = ddAttestationScoping.TMKDA_ATT_012__c; //att12;
    	Clist.TMKDA_Complaints__c = ddAttestationScoping.TMKDA_ATT_002__c;
        Clist.TMKDA_New_Data_Protection_policy__c = ddAttestationScoping.TMKDA_ATT_010__c; //att10;
        Clist.TMKDA_New_Fin_Crime_policy_been_intro__c = ddAttestationScoping.TMKDA_ATT_003__c; //att3;
        Clist.TMKDA_New_outsourcing_arrangement_intro__c = ddAttestationScoping.TMKDA_ATT_008__c; // att8;
        Clist.TMKDA_New_succession_plan_introduced__c = ddAttestationScoping.TMKDA_ATT_005__c; //att5; 
        Clist.TMKDA_New_TCF_policy_has_been_introduced__c = ddAttestationScoping.TMKDA_ATT_001__c;
        Clist.TMKDA_New_Whistleblowing_policy__c = ddAttestationScoping.TMKDA_ATT_009__c; //att9;
        Clist.TMKDA_Notify_TMK_FinCrime_incidents__c = ddAttestationScoping.TMKDA_ATT_037__c; //att38;
        Clist.TMKDA_Notify_TMK_of_all_data_breaches__c = ddAttestationScoping.TMKDA_ATT_039__c; // att39;
        Clist.TMKDA_Notify_TMK_all_FinCrime_suspicions__c = ddAttestationScoping.TMKDA_ATT_038__c; //att37;
        Clist.TMKDA_Reputationstandingimpact__c = ddAttestationScoping.TMKDA_ATT_021__c; //att21;
        Clist.TMKDA_Staff_Training_TCF_Financial_crime__c = ddAttestationScoping.TMKDA_ATT_017__c; //att17;
        Clist.TMKDA_WhenisthePIpolicyduetoexpire__c = ddAttestationScoping.TMKDA_ATT_028__c; //att28;
    //  Clist.TMKDA_Comment__c = ddAttestationScoping.TMKDA_Attestation_Summary__c;
        
        //LMA Questions and comments
        Clist.TMKDA_LMA_Q1__c = ddAttestationScoping.TMKDA_LMA_Q1__c;
        Clist.TMKDA_LMA_Q2__c = ddAttestationScoping.TMKDA_LMA_Q2__c;
        Clist.TMKDA_LMA_Q3__c = ddAttestationScoping.TMKDA_LMA_Q3__c;
        Clist.TMKDA_LMA_Q4__c = ddAttestationScoping.TMKDA_LMA_Q4__c;
        Clist.TMKDA_LMA_Q5__c = ddAttestationScoping.TMKDA_LMA_Q5__c;
        Clist.TMKDA_LMA_Q6__c = ddAttestationScoping.TMKDA_LMA_Q6__c;
        Clist.TMKDA_LMA_Q7__c = ddAttestationScoping.TMKDA_LMA_Q7__c;
        Clist.TMKDA_LMA_Q8__c = ddAttestationScoping.TMKDA_LMA_Q8__c;
        Clist.TMKDA_LMA_Q9__c = ddAttestationScoping.TMKDA_LMA_Q9__c;
        Clist.TMKDA_LMA_Q10__c = ddAttestationScoping.TMKDA_LMA_Q10__c;
        Clist.TMKDA_LMA_Q11__c = ddAttestationScoping.TMKDA_LMA_Q11__c;
        Clist.TMKDA_LMA_Q12__c = ddAttestationScoping.TMKDA_LMA_Q12__c;
        Clist.TMKDA_LMA_Q13__c = ddAttestationScoping.TMKDA_LMA_Q13__c;
        Clist.TMKDA_LMA_Q14__c = ddAttestationScoping.TMKDA_LMA_Q14__c;
        Clist.TMKDA_LMA_Q15__c = ddAttestationScoping.TMKDA_LMA_Q15__c;
        Clist.TMKDA_LMA_Q16__c = ddAttestationScoping.TMKDA_LMA_Q16__c;
        Clist.TMKDA_LMA_Q17__c = ddAttestationScoping.TMKDA_LMA_Q17__c;
        
        Clist.TMKDA_LMA_Q1_Comments__c = ddAttestationScoping.TMKDA_LMA_Q1_Comments__c;
        Clist.TMKDA_LMA_Q2_Comments__c = ddAttestationScoping.TMKDA_LMA_Q2_Comments__c;
        Clist.TMKDA_LMA_Q3_Comments__c = ddAttestationScoping.TMKDA_LMA_Q3_Comments__c;
        Clist.TMKDA_LMA_Q4_Comments__c = ddAttestationScoping.TMKDA_LMA_Q4_Comments__c;
        Clist.TMKDA_LMA_Q5_Comments__c = ddAttestationScoping.TMKDA_LMA_Q5_Comments__c;
        Clist.TMKDA_LMA_Q6_Comments__c = ddAttestationScoping.TMKDA_LMA_Q6_Comments__c;
        Clist.TMKDA_LMA_Q7_Comments__c = ddAttestationScoping.TMKDA_LMA_Q7_Comments__c;
        Clist.TMKDA_LMA_Q8_Comments__c = ddAttestationScoping.TMKDA_LMA_Q8_Comments__c;
        Clist.TMKDA_LMA_Q9_Comments__c = ddAttestationScoping.TMKDA_LMA_Q9_Comments__c;
        Clist.TMKDA_LMA_Q10_Comments__c = ddAttestationScoping.TMKDA_LMA_Q10_Comments__c;
        Clist.TMKDA_LMA_Q11_Comments__c = ddAttestationScoping.TMKDA_LMA_Q11_Comments__c;
        Clist.TMKDA_LMA_Q12_Comments__c = ddAttestationScoping.TMKDA_LMA_Q12_Comments__c;
        Clist.TMKDA_LMA_Q13_Comments__c = ddAttestationScoping.TMKDA_LMA_Q13_Comments__c;
        Clist.TMKDA_LMA_Q14_Comments__c = ddAttestationScoping.TMKDA_LMA_Q14_Comments__c;
        Clist.TMKDA_LMA_Q15_Comments__c = ddAttestationScoping.TMKDA_LMA_Q15_Comments__c;
        Clist.TMKDA_LMA_Q16_Comments__c = ddAttestationScoping.TMKDA_LMA_Q16_Comments__c;
        Clist.TMKDA_LMA_Q17_Comments__c = ddAttestationScoping.TMKDA_LMA_Q17_Comments__c;
                
        Clist.TMKDA_ATT_0171__c = ddAttestationScoping.TMKDA_ATT_0171__c;
        Clist.TMKDA_ATT_0172__c = ddAttestationScoping.TMKDA_ATT_0172__c;
        Clist.TMKDA_ATT_0173__c = ddAttestationScoping.TMKDA_ATT_0173__c;
        Clist.TMKDA_ATT_0174__c = ddAttestationScoping.TMKDA_ATT_0174__c;
        
        Clist.TMKDA_Name__c = ddAttestationScoping.TMKDA_Name__c;
        Clist.TMKDA_Date__c = ddAttestationScoping.TMKDA_Date__c;
        Clist.TMKDA_Position__c = ddAttestationScoping.TMKDA_Position__c;
        Clist.TMKDA_Signoff_Comments__c = ddAttestationScoping.TMKDA_Signoff_Comments__c;

        //LMA cyber questions
        Clist.TMKDA_ATT_040__c = ddAttestationScoping.TMKDA_ATT_040__c;
        Clist.TMKDA_ATT_041__c = ddAttestationScoping.TMKDA_ATT_041__c;
        Clist.TMKDA_ATT_042__c = ddAttestationScoping.TMKDA_ATT_042__c;
        
        //Usercomments
        Clist.TMKDA_FormComments_ATT_001__c = ddAttestationScoping.TMKDA_UserComments_ATT_001__c;
        Clist.TMKDA_FormComments_ATT_002__c = ddAttestationScoping.TMKDA_UserComments_ATT_002__c;
        Clist.TMKDA_FormComments_ATT_003__c = ddAttestationScoping.TMKDA_UserComments_ATT_003__c;
        Clist.TMKDA_FormComments_ATT_004__c = ddAttestationScoping.TMKDA_UserComments_ATT_004__c;
        Clist.TMKDA_FormComments_ATT_005__c = ddAttestationScoping.TMKDA_UserComments_ATT_005__c;
        Clist.TMKDA_FormComments_ATT_006__c = ddAttestationScoping.TMKDA_UserComments_ATT_006__c;
        Clist.TMKDA_FormComments_ATT_007__c = ddAttestationScoping.TMKDA_UserComments_ATT_007__c;
        Clist.TMKDA_FormComments_ATT_008__c = ddAttestationScoping.TMKDA_UserComments_ATT_008__c;
        Clist.TMKDA_FormComments_ATT_009__c = ddAttestationScoping.TMKDA_UserComments_ATT_009__c;
        Clist.TMKDA_FormComments_ATT_010__c = ddAttestationScoping.TMKDA_UserComments_ATT_010__c;
        Clist.TMKDA_FormComments_ATT_011__c = ddAttestationScoping.TMKDA_UserComments_ATT_011__c;
        Clist.TMKDA_FormComments_ATT_012__c = ddAttestationScoping.TMKDA_UserComments_ATT_012__c;
        Clist.TMKDA_FormComments_ATT_013__c = ddAttestationScoping.TMKDA_UserComments_ATT_013__c;
        Clist.TMKDA_FormComments_ATT_014__c = ddAttestationScoping.TMKDA_UserComments_ATT_014__c;
        Clist.TMKDA_FormComments_ATT_015__c = ddAttestationScoping.TMKDA_UserComments_ATT_015__c;
        Clist.TMKDA_FormComments_ATT_016__c = ddAttestationScoping.TMKDA_UserComments_ATT_016__c;
        Clist.TMKDA_FormComments_ATT_0171__c = ddAttestationScoping.TMKDA_UserComments_ATT_0171__c;
        Clist.TMKDA_FormComments_ATT_0172__c = ddAttestationScoping.TMKDA_UserComments_ATT_0172__c;
        Clist.TMKDA_FormComments_ATT_0173__c = ddAttestationScoping.TMKDA_UserComments_ATT_0173__c;
        Clist.TMKDA_FormComments_ATT_0174__c = ddAttestationScoping.TMKDA_UserComments_ATT_0174__c;
        Clist.TMKDA_FormComments_ATT_018__c = ddAttestationScoping.TMKDA_UserComments_ATT_018__c;
        Clist.TMKDA_FormComments_ATT_019__c = ddAttestationScoping.TMKDA_UserComments_ATT_019__c;
        Clist.TMKDA_FormComments_ATT_020__c = ddAttestationScoping.TMKDA_UserComments_ATT_020__c;
        Clist.TMKDA_FormComments_ATT_021__c = ddAttestationScoping.TMKDA_UserComments_ATT_021__c;
        Clist.TMKDA_FormComments_ATT_022__c = ddAttestationScoping.TMKDA_UserComments_ATT_022__c;
        Clist.TMKDA_FormComments_ATT_023__c = ddAttestationScoping.TMKDA_UserComments_ATT_023__c;
        Clist.TMKDA_FormComments_ATT_024__c = ddAttestationScoping.TMKDA_UserComments_ATT_024__c;
        Clist.TMKDA_FormComments_ATT_025__c = ddAttestationScoping.TMKDA_UserComments_ATT_025__c;
        Clist.TMKDA_FormComments_ATT_026__c = ddAttestationScoping.TMKDA_UserComments_ATT_026__c;
        Clist.TMKDA_FormComments_ATT_028__c = ddAttestationScoping.TMKDA_UserComments_ATT_028__c;
        Clist.TMKDA_FormComments_ATT_029__c = ddAttestationScoping.TMKDA_UserComments_ATT_029__c;
        Clist.TMKDA_FormComments_ATT_030__c = ddAttestationScoping.TMKDA_UserComments_ATT_030__c;
        Clist.TMKDA_FormComments_ATT_031__c = ddAttestationScoping.TMKDA_UserComments_ATT_031__c;
        Clist.TMKDA_FormComments_ATT_032__c = ddAttestationScoping.TMKDA_UserComments_ATT_032__c;
        Clist.TMKDA_FormComments_ATT_033__c = ddAttestationScoping.TMKDA_UserComments_ATT_033__c;
        Clist.TMKDA_FormComments_ATT_034__c = ddAttestationScoping.TMKDA_UserComments_ATT_034__c;
        Clist.TMKDA_FormComments_ATT_035__c = ddAttestationScoping.TMKDA_UserComments_ATT_035__c;
        Clist.TMKDA_FormComments_ATT_036__c = ddAttestationScoping.TMKDA_UserComments_ATT_036__c;
        Clist.TMKDA_FormComments_ATT_037__c = ddAttestationScoping.TMKDA_UserComments_ATT_037__c;
        Clist.TMKDA_FormComments_ATT_038__c = ddAttestationScoping.TMKDA_UserComments_ATT_038__c;
        Clist.TMKDA_FormComments_ATT_039__c = ddAttestationScoping.TMKDA_UserComments_ATT_039__c;
        
            
        DD_Attestation_Scoping_Controller_WS.insertObject(clist);
        
     /*   Attachment attachment = new Attachment();
        attachment.Name = 'Attestation Form Attachment'; 
        attachment.Id = ddAttestationScopingExisting.Id;
        attachment.Body = Blob.valueOf(clist.Id); 
        insert attachment; */
        
        ddAttestationScoping.Id = NULL;
        ddAttestationScoping.TMKDA_CH_Attestation_Link__c= null;
        upload(); 
	//	uploadAttachment();
        
        System.debug('Clist.Name value before insert: ' + Clist.Name);
        System.debug('Clist.TMKDA_DD_Attestation_Scoping__c value before insert: ' + Clist.TMKDA_DD_Attestation_Scoping__c);
        System.debug('Before insert: ' + Clist);
        
      //  PageReference pageref = new PageReference('/apex/Thankyoupage');
      
        /*   if (isRequiredFieldsEmpty()) {
ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'All fields are mandatory.'));
return null;
} 

private Boolean isRequiredFieldsEmpty() {
if (String.isBlank(ddAttestationScoping.TMKDA_ATT_001__c) ||
String.isBlank(ddAttestationScoping.TMKDA_ATT_002__c)) {
return true;
}
return false;
}

*/
        
        
     //  redirect();
       
        System.debug('After insert: ' + Clist);
        System.debug('After insert: ' + Clist.Id);
        
    //    PageReference viewPage = new PageReference('/apex/ViewAttestationScoping');
     // viewPage.getParameters().put('redirect', 'true');
     //   viewPage.setRedirect(true);
       // return new PageReference('/apex/Thankyoupage');
        
       PageReference pageref = Page.Thankyoupage;
       // PageReference pageref = new PageReference('https://tmkis--tmkdev01.sandbox.my.salesforce-sites.com/Attestations?id='+ recordId);
        pageref.setRedirect(true);
        System.debug('After insert: ' + Clist);
        return pageref;
    }

    
 public List<SelectOption> getYesNoOptions() {
    List<SelectOption> options = new List<SelectOption>();
    options.add(new SelectOption('Yes', 'Yes'));
    options.add(new SelectOption('No', 'No'));
    return options;
    } 
}