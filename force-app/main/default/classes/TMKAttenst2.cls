public without sharing class TMKAttenst2 
{
    public string att2 { get; set; }
    public string att { get; set; }    
    public string att3 { get; set; }
    public string att4 { get; set; }
    public string att5 { get; set; }
    public string att6 { get; set; }
    public string att7 { get; set; }
    public string att8 { get; set; }
    public string att9 { get; set; }
    public string att10 { get; set; }
    public string att11 { get; set; }
    public string att12 { get; set; }
    public string att13 { get; set; }
    public string att14 { get; set; }
    public string att15 { get; set; }
    public string att16 { get; set; }
    public string att17 { get; set; }
    public string att18 { get; set; }
    public string att19 { get; set; }
    public string att20 { get; set; }
    public string att21 { get; set; }
    public string att22 { get; set; }
    public string att23 { get; set; }
    public string att24 { get; set; }
    public string att25 { get; set; }
    public string att26 { get; set; }
    public string att27 { get; set; }
    public string att28 { get; set; }
    public string att29 { get; set; }
    public string att30 { get; set; }
    public string att31 { get; set; }
    public string att32 { get; set; }
    public string att33 { get; set; }
    public string att34 { get; set; }
    public string att35 { get; set; }
    public string att36 { get; set; }
    public string att37 { get; set; }
    public string att38 { get; set; }
    public string att39 { get; set; }
    public TMKDA_DD_Attestation_Form__c Clist{ get; set; }
    public TMKDA_DD_Attestation_Scoping__c customer{ get; set; }
    public Boolean showTcfPolicy { get; set; }
  //  public Boolean var_Att_004 { get; set; }
 //   Public Boolean Att_004 {get; set;}
        
     public String Type { get; set; }
        public String fileName { get; set; }
        public transient  blob file { get; set; }
        public String title{ get;set; }
        public ContentVersion cv { get; set; }
        String contactId = System.currentPagereference().getParameters().get('Id');
       
   
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
   
    
 public PageReference insertCustomer() { 
 
   String recordId = ApexPages.currentPage().getParameters().get('id');   
     
    //var_Att_004 = ApexPages.currentPage().getParameters().get('Att_004') == 'true';  
  
        TMKDA_DD_Attestation_Scoping__c Customer = [
            SELECT Id,OwnerId, Name, CreatedById, LastModifiedById, TMKDA_DA_Analyst__c, TMKDA_Scoping_Date__c, TMKDA_Review_Scope__c,TMKDA_Contact__c,
            TMKDA_Company_Name__c, TMKDA_Claims_Handling__c, TMKDA_PDT_Outcome__c, TMKDA_Is_IDD_in_scope__c, TMKDA_Company_Type__c,TMKDA_Due_Diligence__c,
            TMKDA_Is_Whistleblowing_in_Scope__c, TMKDA_Is_Succession_Planning_in_Scope__c,TMKDA_ATT_001__c,TMKDA_ATT_002__c, TMKDA_ATT_003__c,TMKDA_ATT_004__c,TMKDA_ATT_005__c, TMKDA_ATT_006__c, TMKDA_ATT_007__c,
            TMKDA_ATT_008__c,TMKDA_ATT_009__c,TMKDA_ATT_010__c,TMKDA_ATT_011__c,TMKDA_ATT_012__c,TMKDA_ATT_013__c,
            TMKDA_ATT_014__c,TMKDA_ATT_015__c,TMKDA_ATT_016__c,TMKDA_ATT_017__c,TMKDA_ATT_018__c,TMKDA_ATT_019__c,
            TMKDA_ATT_020__c,TMKDA_ATT_021__c,TMKDA_ATT_022__c,TMKDA_ATT_023__c,TMKDA_ATT_024__c,TMKDA_ATT_025__c,
            TMKDA_ATT_026__c,TMKDA_ATT_027__c,TMKDA_ATT_028__c,TMKDA_ATT_029__c,TMKDA_ATT_030__c,TMDKA_ATT_031__c,
            TMKDA_ATT_032__c,TMKDA_ATT_033__c,TMKDA_ATT_034__c,TMKDA_ATT_035__c,TMKDA_ATT_036__c,TMKDA_ATT_037__c,
            TMKDA_ATT_038__c,TMKDA_ATT_039__c,TMKDA_Attestation_Start_Date__c,TMKDA_Attestation_End_Date__c
            FROM TMKDA_DD_Attestation_Scoping__c 
            WHERE Id = :recordId LIMIT 1 
        ];         
 
    /*DY 12/1/24 - added all fields to soql - TMKDA_ATT_001__c,TMKDA_ATT_002__c, TMKDA_ATT_003__c,TMKDA_ATT_004__c,TMKDA_ATT_005__c, TMKDA_ATT_006__c, TMKDA_ATT_007__c,
            TMKDA_ATT_008__c,TMKDA_ATT_009__c,TMKDA_ATT_010__c,TMKDA_ATT_011__c,TMKDA_ATT_012__c,TMKDA_ATT_013__c,
            TMKDA_ATT_014__c,TMKDA_ATT_015__c,TMKDA_ATT_016__c,TMKDA_ATT_017__c,TMKDA_ATT_018__c,TMKDA_ATT_019__c,
            TMKDA_ATT_020__c,TMKDA_ATT_021__c,TMKDA_ATT_022__c,TMKDA_ATT_023__c,TMKDA_ATT_024__c,TMKDA_ATT_025__c,
            TMKDA_ATT_026__c,TMKDA_ATT_027__c,TMKDA_ATT_028__c,TMKDA_ATT_029__c,TMKDA_ATT_030__c,TMDKA_ATT_031__c,
            TMKDA_ATT_032__c,TMKDA_ATT_033__c,TMKDA_ATT_034__c,TMKDA_ATT_035__c,TMKDA_ATT_036__c,TMKDA_ATT_037__c,
            TMKDA_ATT_038__c,TMKDA_ATT_039__c,TMKDA_Attestation_Start_Date__c,TMKDA_Attestation_End_Date__c */
                
Clist = new TMKDA_DD_Attestation_Form__c();     

Clist.Name = Customer.Name;
Clist.TMKDA_Due_Diligence__c = Customer.TMKDA_Due_Diligence__c;     //DY 18/1/24 Added
Clist.TMKDA_DD_Attestation_Scoping__c = recordId;     
Clist.TMKDA_Annual_Compliance__c = att29;
Clist.TMKDA_Any_changes_to_business_system_s__c = att18;
Clist.TMKADA_Any_changes_to_company_ownership__c = att19;
Clist.TMKDA_Any_changes_to_financial_promotion__c = att16;
Clist.TMKADA_Any_changes_to_oursourcing_arran__c = att26;
Clist.TMKDA_DRP_issues_improvements_identified__c = att25;
Clist.TMKADA_Any_issues_with_licensing__c = att20;
Clist.TMKDA_Any_issues_improvements_been_id__c = att23;
Clist.TMKDA_Binders_requiring_BPA__c = att15;
Clist.TMKDA_Changes_to_level_of_customer_data__c = att27;
Clist.TMKDA_Conflicts_of_interest_log_provided__c = att32;
Clist.TMKDA_Financials_YOA__c = att30;
Clist.TMKDA_Gifts_Entertainment_log__c = att33;
Clist.TMKDA_Has_a_complaints_log_been_provided__c = att31;
Clist.TMKDA_Has_a_new_Conflicts_of_Interest_po__c = att4;
Clist.TMKDA_Has_a_new_DRP_been_int__c = att7;
Clist.TMKDA_IDD_training_log__c = att36;
Clist.TMKDA_Information_Security__c = att11;
Clist.TMKDA_Is_the_BCP_tested_annually__c = att22;
Clist.TMKDA_Is_the_DRP_tested_annually__c = att24;
Clist.TMKDA_Latest_Financials_YOA__c = att35;
Clist.TMKDA_Live_E_O_policy__c = att34;
Clist.TMKDA_Loss_Funds__c = att13;
Clist.TMKDA_ew_Accounting_procedure_introduced__c = att14;
Clist.TMKDA_New_BCP_been_introduced__c = att6;
Clist.TMKDA_New_Claims_procedure_been_intro__c = att12;
Clist.TMKDA_Complaints__c = att2;
Clist.TMKDA_New_Data_Protection_policy__c = att10;
Clist.TMKDA_New_Fin_Crime_policy_been_intro__c = att3;
Clist.TMKDA_New_outsourcing_arrangement_intro__c = att8;
Clist.TMKDA_New_succession_plan_introduced__c = att5;
Clist.TMKDA_New_TCF_policy_has_been_introduced__c = att;
Clist.TMKDA_New_Whistleblowing_policy__c = att9;
Clist.TMKDA_Notify_TMK_FinCrime_incidents__c = att38;
Clist.TMKDA_Notify_TMK_of_all_data_breaches__c = att39;
Clist.TMKDA_Notify_TMK_all_FinCrime_suspicions__c = att37;
Clist.TMKDA_Reputation_standing_impact__c = att21;
Clist.TMKDA_Staff_Training_TCF_Financial_crime__c = att17;
Clist.TMKDA_PI_policy_due_to_expire__c = att28;

//changes by Deepika - 125/1/24
//String var_URL = 'https://tmkis--tmkdev01.sandbox.my.salesforce-sites.com/attestationForms?id=' +recordId;
     
  // Boolean Att_004 = Customer.TMKDA_Review_Scope__c != 'Run-Off';
     
    /*    var_URL = var_URL +'&Att_004='+ String.ValueOf(Att_004);
         System.debug(Att_004);
         System.debug(var_URL);*/
     

//changes by Deepika - 12/1/24

 /*    if (customer.TMKDA_PDT_Outcome__c != 'No BPA required. 3 year audit cycle'){
         Clist.TMKDA_New_TCF_policy_has_been_introduced__c = att;
     } */
    
     
     System.debug('Clist.Name value before insert: ' + Clist.Name);
     System.debug('Clist.TMKDA_DD_Attestation_Scoping__c value before insert: ' + Clist.TMKDA_DD_Attestation_Scoping__c);
     System.debug('Before insert: ' + Clist);
     insert Clist;
     
     
     PageReference pageref = new PageReference('/apex/Thankyoupage');
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