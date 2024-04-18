public with sharing class BPA_AttestationController {
    
    public List<TMKDA_BPA_Summary_Detail__c> bpaDetails { get; set; }
    public List<TMKDA_BPA_Summary_Detail__c> bpaDetailsExisting;
    public TMKDA_BPA_Summary_Header__c bpaSummaryHeader { get; set; }
    public TMKDA_BPA_Summary_Header__c bpaHeader { get; set; }
    public TMKDA_BPA_Summary_Header__c bpaHeaderExisting; 
    public TMKDA_BPA_Attestation_Response_Form__c bpaForm {get; set;}
    public TMKDA_BPA_Attestation_Response_Form__c bpaFormExisting;
    public String selectedContact { get; set; }
    public TMKDA_BPAAttestationResponseDetails__c Clist;
    public String parentId;
    public String Type { get; set; }
    public String fileName { get; set; }
    public transient Blob file { get; set; }
    public String title { get; set; }
    public ContentVersion cv { get; set; }
    public String linkValue { get; set; }
    public String recordId;
    public String bpaHeaderName { get; private set; }
    
    // Wrapper class to hold BPA details and header
    public class BPAWrapper {
        public TMKDA_BPA_Summary_Detail__c detail { get; set; }
        public TMKDA_BPA_Summary_Header__c header { get; set; }
        public TMKDA_BPAAttestationResponseDetails__c Clist; 
        
        public BPAWrapper(TMKDA_BPA_Summary_Detail__c detail, TMKDA_BPA_Summary_Header__c header) {
            this.detail = detail;
            this.header = header;
        }
    }
    
    // Get BPA Details and Header as wrappers
    public List<BPAWrapper> bpaWrappers { get; set; }
    public String bpaName { get; set; } 
    
    public BPA_AttestationController() {
        String recordId = ApexPages.currentPage().getParameters().get('id');
        if (String.isNotBlank(recordId)) {
            getData(recordId);
        }
    }

    private void getData(String recordId) {
        // Query BPA header
        TMKDA_BPA_Summary_Header__c bpaHeader = [SELECT Id, Name, TMKDA_CH_Contact__c, TMKDA_CH_Contact__r.Name, TMKDA_CH_Contact__r.Email, 
                                                  TMKDA_BPA_Attestation_Link__c, TMKDA_Attestation_Link__c, TMKDA_Due_Diligence_Id__c,
                                                  TMKDA_BPA_Status__c, TMKDA_BPAAttestation_Link__c
                                                  FROM TMKDA_BPA_Summary_Header__c
                                                  WHERE Id = :recordId LIMIT 1];
        system.debug('BPA Header: ' + bpaHeader);
        String bpaHeaderId = bpaHeader.Id;
        String bpaHeaderName = bpaHeader.Name;
        
        // Query BPA details
        List<TMKDA_BPA_Summary_Detail__c> bpaDetails = [SELECT Id, Name, TMKDA_Information__c, TMKDA_Confirmation_Statement_Accurate__c,
                                                         TMKDA_BPA_Summary_Name__c, TMKDA_Coverholder_DCA__c, TMKDA_Due_Diligence__c, TMKDA_BPA_Summary_Name__r.Name,
                                                         TMKDA_Due_Diligence__r.Name, TMKDA_Coverholder_Comment__c
                                                         FROM TMKDA_BPA_Summary_Detail__c
                                                         WHERE TMKDA_BPA_Summary_Name__c = :bpaHeaderId];
        
        system.debug('BPA Details: ' + bpaDetails);
        
        
        if (!bpaDetails.isEmpty()) {
            bpaName = bpaDetails[0].TMKDA_BPA_Summary_Name__r.Name;
         //   system.debug('Details: ' + bpaDetails);
        }
      //  bpaSummaryHeader.Id = Null;
        
        bpaWrappers = new List<BPAWrapper>();
        for (TMKDA_BPA_Summary_Detail__c detail : bpaDetails) {
            bpaWrappers.add(new BPAWrapper(detail, bpaHeader));
            String HeaderId = bpaHeader.Id;
            system.debug('Test1');
        }
        
    }
    
    
    public PageReference submit() {
    system.debug('Test2');
    List<TMKDA_BPAAttestationResponseDetails__c> attestationResponseDetailsList = new List<TMKDA_BPAAttestationResponseDetails__c>();
    system.debug('bpaWrappers' + bpaWrappers);
    if (bpaWrappers != null && !bpaWrappers.isEmpty()) {
        for (BPAWrapper wrapper : bpaWrappers) {
            
           
          //  wrapper.Id = wrapper.header.Id;
          //  BPA_AttestationController_WS.updateObject(bpaHeader);
            
            // bpaSummaryHeader.Id =   recordId;
            TMKDA_BPA_Summary_Detail__c bpaRecord = wrapper.detail;
           // TMKDA_BPA_Summary_Header__c bpaSummaryHeader = wrapper.header;
          //  system.debug('bpaSummaryHeader' + bpaSummaryHeader);
            TMKDA_BPAAttestationResponseDetails__c attestationResponseDetail = new TMKDA_BPAAttestationResponseDetails__c();
            attestationResponseDetail.TMKDA_BPA_Detail__c = bpaRecord.Id;
            attestationResponseDetail.Name = bpaRecord.Name;
            attestationResponseDetail.TMKDA_BPA__c = bpaRecord.TMKDA_BPA_Summary_Name__c;
            attestationResponseDetail.TMKDA_Coverholder_Comment__c = bpaRecord.TMKDA_Coverholder_Comment__c;
            attestationResponseDetail.TMKDA_Information__c = bpaRecord.TMKDA_Information__c;
            attestationResponseDetail.TMKDA_Confirmation_Statement_Accurate__c = bpaRecord.TMKDA_Confirmation_Statement_Accurate__c;
            
            attestationResponseDetailsList.add(attestationResponseDetail);
        }
        
        try {
             BPA_AttestationController_WS.insertObject(attestationResponseDetailsList);
   			// BPA_AttestationController_WS.updateObject(attestationResponseDetailsList);
         //   insert attestationResponseDetailsList;
         //   update attestationResponseDetailsList;
        } catch (Exception e) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Error inserting records: ' + e.getMessage()));
            return null;
        }
    }
    
    // Redirect to the thank you page
    PageReference pageref = Page.Thankyoupage;
    pageref.setRedirect(true);
    return pageref;
}
    
    //upload file
     public PageReference upload() {
        ContentVersion cv = new ContentVersion();
        cv.versionData = file;
        cv.title = title;
        cv.pathOnClient = fileName;
        cv.FirstPublishLocationId = recordId;

        try {
            Insert cv;
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO, 'Document uploaded successfully to library'));
        } catch (DMLException e) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Error uploading Document in Library'));
            return null;
        }
        return null;
    }
}