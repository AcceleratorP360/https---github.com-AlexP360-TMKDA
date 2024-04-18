public with sharing class P360_BPA_viewAttestationform {
    // Property to hold the list of BPA Details
    public List<TMKDA_BPA_Summary_Detail__c> bpa { get; set; }
    public TMKDA_BPA_Summary_Detail__c ddAttestationScoping { get; set; }
    public TMKDA_BPA_Summary_Detail__c ddAttestationScopingExisting;
    public TMKDA_BPAAttestationResponseDetails__c Clist { get; set; }
    public String parentId;
    public String Type { get; set; }
    public String fileName { get; set; }
    public transient blob file { get; set; }
    public String title { get;set; }
    public ContentVersion cv { get; set; }
    public String linkValue { get; set; }

    
    public PageReference upload() {
        ContentVersion cv = new ContentVersion();
        cv.versionData = file;
        cv.title = title;
        cv.pathOnClient = fileName;
        cv.FirstPublishLocationId = parentId; 

        try {
            Insert cv;
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO, 'Document uploaded successfully to library'));
        } catch (DMLException e) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Error uploading Document in Library'));
            return null;
        }
        
        return null;
    } 

    public P360_BPA_viewAttestationform(ApexPages.StandardController controller) {
        // Retrieve the parent record's ID from the URL parameter
        parentId = ApexPages.currentPage().getParameters().get('Id');
        system.debug('Parent ID: ' + parentId);

        // Query the BPA Details related to the parent record
     //   bpa = [SELECT Id, Name, TMKDA_Coverholder_Comment__c, TMKDA_Information__c, TMKDA_Confirmation_Statement_Accurate__c,
           //    TMKDA_BPA_Summary_Name__c,TMKDA_CO_Comments__c,TMKDA_Coverholder_DCA__c,TMKDA_Due_Diligence__c,TMKDA_Due_Diligence_Name__c
            //   FROM TMKDA_BPA_Summary_Detail__c
           //    WHERE TMKDA_BPA_Summary_Name__c = :parentId];
        system.debug('BPA Records: ' + bpa);
    }

    public PageReference submit() {
        for (TMKDA_BPA_Summary_Detail__c bpaRecord : bpa) {
            Clist = new TMKDA_BPAAttestationResponseDetails__c();     
            Clist.TMKDA_BPA_Detail__c = bpaRecord.Id;
            Clist.Name = bpaRecord.Name;
            Clist.TMKDA_BPA__c = bpaRecord.TMKDA_BPA_Summary_Name__c;
          //  Clist.TMKDA_Coverholder_Comment__c = bpaRecord.TMKDA_Coverholder_Comment__c;
          //  Clist.TMKDA_Information__c = bpaRecord.TMKDA_Information__c;
            Clist.TMKDA_Confirmation_Statement_Accurate__c = bpaRecord.TMKDA_Confirmation_Statement_Accurate__c;
            // Insert the record
            P360_BPA_AttestationformController_WS.insertObject(Clist);
        }
        
        // Clear the form fields
        ddAttestationScopingExisting = null;
        fileName = null;
        title = null;
        file = null;

        // Redirect to the thank you page
        PageReference pageref = Page.Thankyoupage;
        pageref.setRedirect(true);
        return pageref;
    }
}