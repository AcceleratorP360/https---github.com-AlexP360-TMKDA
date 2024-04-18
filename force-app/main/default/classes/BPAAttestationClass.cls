public without sharing class BPAAttestationClass
{
     public TMKDA_BPAAttestationResponseDetails__c Clist{ get; set; }
    public TMKDA_BPA_Attestation_Response_Form__c Customer{ get; set; }
    public Boolean showTcfPolicy { get; set; }
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
      
  
      TMKDA_BPA_Attestation_Response_Form__c Customer = [
            SELECT Id, Name
            FROM TMKDA_BPA_Attestation_Response_Form__c
            WHERE Id = :recordId LIMIT 1 
        ];  
    Clist = new TMKDA_BPAAttestationResponseDetails__c();     

	Clist.Name = Customer.Name;

   System.debug('Clist.Name value before insert: ' + Clist.Name);
     System.debug('Clist.TMKDA_DD_Attestation_Scoping__c value before insert: ' + Clist.TMKDA_BPA_Attestation_Response_Form__c);
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