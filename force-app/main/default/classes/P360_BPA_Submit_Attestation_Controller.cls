public class P360_BPA_Submit_Attestation_Controller {
    
    @AuraEnabled
    public static List<TMKDA_BPA_Summary_Header__c> fetchAttestaionScoping(string attRecId){
        List<TMKDA_BPA_Summary_Header__c> daAttestationScopingCon  = [SELECT Id, Name,TMKDA_CH_Contact__c,TMKDA_CH_Contact__r.Name,TMKDA_CH_Contact__r.Email, TMKDA_BPA_Attestation_Link__c, 
																		TMKDA_Attestation_Link__c ,TMKDA_Due_Diligence_Id__c,TMKDA_BPA_Status__c,TMKDA_BPAAttestation_Link__c,
                                                                        TMKDA_BPA_Issued_Date__c,TMKDA_Sent_By__c,TMKDA_Sent_To__c
																		from TMKDA_BPA_Summary_Header__c
                                                                          WHERE Id =: attRecId AND TMKDA_CH_Contact__c  != null order by createdDate DESC];
        return daAttestationScopingCon;
    }
    
   
    
    @AuraEnabled
    public static void sendEmailAndUpdate(string selecedConId, String attRecId){
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        String attlink = '';
        TMKDA_BPA_Summary_Header__c ddAtt = [SELECT Id, Name,TMKDA_CH_Contact__c ,TMKDA_CH_Contact__r.Name,TMKDA_CH_Contact__r.Email, TMKDA_BPA_Attestation_Link__c, 
																		TMKDA_Attestation_Link__c ,	TMKDA_Due_Diligence_Id__c,TMKDA_BPA_Status__c,TMKDA_BPAAttestation_Link__c,
                                             							TMKDA_BPA_Issued_Date__c,TMKDA_Sent_By__c,TMKDA_Sent_To__c
																		from TMKDA_BPA_Summary_Header__c WHERE Id =: attRecId]; 
        System.debug('selecedConId: ' + selecedConId);
        List<Contact> selectedCon = [SELECT Id, Name, Email From Contact WHERE Id =: selecedConId];
        		
         System.debug('selectedCon size: ' + selectedCon.size());  
        
        email.setToAddresses(new string[] {selectedCon[0].Email});
        email.setCcAddresses(new string[] {System.Label.P360_Send_Attestation_Form_Cc});                      
        email.setSubject('Please review and complete attestation');    
        String emailBody = 'Dear ' + selectedCon[0].Name + ',<br/> <br/>';
        emailBody += 'Please review and complete the BPA attestation form by clicking on the button / link below. <br/> <br/>';
       
     
         attlink = ddAtt.TMKDA_BPAAttestation_Link__c; 
       
         emailBody += '<a href="'+ddAtt.TMKDA_BPAAttestation_Link__c+'">'+' <strong>COMPLETE ATTESTATION</strong> </a> <br/><br/>'; 
     
        emailBody += 'Kindly submit your response within 5 days of receiving this email. <br/><br/>';
        emailBody += 'Regards, <br/><br/>';
        emailBody += UserInfo.getName();
        email.setHtmlBody(emailBody);  

        try{
            if(!test.isRunningTest()){
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { email });
            }
            
             ddAtt.TMKDA_BPA_Issued_Date__c = system.today();
             ddAtt.TMKDA_Sent_By__c = UserInfo.getUserId(); 
             ddAtt.TMKDA_Sent_To__c = selecedConId;
             ddAtt.TMKDA_BPA_Attestation_Link__c = attlink;
                     update ddAtt;
           
        }Catch(exception ex){
            system.debug('---Ex ' +ex);
        }
        
    } 
}