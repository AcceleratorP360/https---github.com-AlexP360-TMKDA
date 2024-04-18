public class previewAttestationScopingController {
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

     public previewAttestationScopingController(ApexPages.StandardController standardPageController) {
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
         
          if (!records.isEmpty()) {
            ddAttestationScoping = records[0];
        }
    }
    
      public PageReference submit() {
        PageReference pageref = Page.Thankyoupage;
        pageref.setRedirect(true);
//        System.debug('After insert: ' + Clist);
        return pageref;
      }
    
 public List<SelectOption> getYesNoOptions() {
    List<SelectOption> options = new List<SelectOption>();
    options.add(new SelectOption('Yes', 'Yes'));
    options.add(new SelectOption('No', 'No'));
    return options;
    } 
    
}