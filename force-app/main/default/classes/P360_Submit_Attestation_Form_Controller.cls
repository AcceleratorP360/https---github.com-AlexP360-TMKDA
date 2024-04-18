public class P360_Submit_Attestation_Form_Controller {
    
    @AuraEnabled
    public static List<TMKDA_DD_Attestation_Scoping__c> fetchAttestaionScoping(string attRecId){
        List<TMKDA_DD_Attestation_Scoping__c> daAttestationScopingCon  = [SELECT Id, Name, Send_Attestation_Form_Contact__c, Send_Attestation_Form_Contact__r.Name, Send_Attestation_Form_Contact__r.Email,
                                                                          TMKDA_Attestation_Form_URL__c,TMKDA_Due_Diligence__c,TMKDA_Attestation_Stages__c,TMKDA_Due_diligence_status__c,TMKDA_Contact__c
                                                                          FROM TMKDA_DD_Attestation_Scoping__c
                                                                          WHERE Id =: attRecId AND Send_Attestation_Form_Contact__c != null order by createdDate DESC];
        return daAttestationScopingCon;
    }
    
    
    @AuraEnabled
    public static void sendEmailAndUpdate(string selecedConId, String attRecId){
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        String attlink = '';
        TMKDA_DD_Attestation_Scoping__c ddAtt = [SELECT Id, TMKDA_Issue_Attestation_Date__c, TMK_DA_Attestation_Sent_By__c,
                                                     TMK_DA_Attestation_Sent_to__c, TMK_DA_Attestation_link__c,TMKDA_Attestation_Form_URL__c,TMKDA_CH_Attestation_Link__c,TMKDA_Attestation_Link__c,
                                                     TMKDA_Attestation_Statuss__c,TMKDA_Due_Diligence__c,TMKDA_Attestation_Stages__c,TMKDA_Due_diligence_status__c,TMKDA_Contact__c 
                                                     FROM TMKDA_DD_Attestation_Scoping__c WHERE Id =: attRecId]; //DY 18/1/24 - Added TMKDA_Due_Diligence__c // DY on 11/2/24 >>>TMKDA_Attestation_Stages__c,TMKDA_Due_diligence_status__c,TMKDA_Contact__c
        List<Contact> selectedCon = [SELECT Id, Name, Email From Contact WHERE Id =: selecedConId];
        		
        
      //  attlink = ddAtt.TMKDA_Attestation_Form_URL__c;
   //     Boolean Att_004 = ddAtt.TMKDA_Review_Scope__c != 'Run-Off';
     //   attlink = attlink +'&Att_004='+ String.ValueOf(Att_004);
    //    System.debug(Att_004);
     //   System.debug(attlink);
         
        
        email.setToAddresses(new string[] {selectedCon[0].Email});
        email.setCcAddresses(new string[] {System.Label.P360_Send_Attestation_Form_Cc});                      
        email.setSubject('Please review and complete attestation');    //changed case - DY 12/1/24
        String emailBody = 'Dear ' + selectedCon[0].Name + ',<br/> <br/>';
        emailBody += 'Please review and complete the attestation form by clicking on the button / link below. <br/> <br/>';
        
        //changed by Deepika 25/01
      // attlink = ddAtt.TMKDA_Attestation_Form_URL__c;   //TMKDA_Attestation_Form_URL__c >>> TMKDA_Attestation_Link__c >>Formula fields
         attlink = ddAtt.TMKDA_Attestation_Link__c; //added by DY 9/2
        //changed by Deepika 25/01
      //   emailBody += '<a href="'+ddAtt.TMKDA_Attestation_Form_URL__c+'">'+' <strong>COMPLETE ATTESTATION</strong> </a> <br/><br/>';
         emailBody += '<a href="'+ddAtt.TMKDA_Attestation_Link__c+'">'+' <strong>COMPLETE ATTESTATION</strong> </a> <br/><br/>'; //added by DY 9/2
        
      //  emailBody += '<a href="'+attlink+'">'+' <strong>COMPLETE ATTESTATION</strong> </a> <br/><br/>';
        emailBody += 'Kindly submit your response within 5 days of receiving this email. <br/><br/>';
        emailBody += 'Regards, <br/><br/>';
        emailBody += UserInfo.getName();
        email.setHtmlBody(emailBody);  

        try{
            if(!test.isRunningTest()){
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { email });
            }
            
            ddAtt.TMKDA_Issue_Attestation_Date__c = system.today();
            ddAtt.TMK_DA_Attestation_Sent_By__c = UserInfo.getUserId(); 
            ddAtt.TMK_DA_Attestation_Sent_to__c = selecedConId;
          //  ddAtt.TMK_DA_Attestation_link__c = attlink;									//	TMK_DA_Attestation_link__c >>> TMKDA_CH_Attestation_Link__c >>URL Fields			
            ddAtt.TMKDA_CH_Attestation_Link__c = attlink;
            ddAtt.TMKDA_Attestation_Statuss__c = 'Attestation issued'; 						// Added by DY - 9/1/24
         //   ddAtt.TMKDA_Attestation_Scoping_Completed__c = true;       					// Added by DY - 18/1/24 //commented as per change request - DY 23/1/24
            ddAtt.TMKDA_Due_Diligence__c = ddAtt.TMKDA_Due_Diligence__c; 
            ddAtt.TMKDA_Attestation_Stages__c = 'TMKDA_Awaiting Attestation Response';
          //  ddAtt.TMKDA_Due_diligence_status__c = ddAtt.TMKDA_Due_diligence_status__c;	
         // ddAtt.TMKDA_Due_diligence_status__c = 'Attestation issued';	
         // 			 	    // Added by DY - 18/1/24
            update ddAtt;
           
        }Catch(exception ex){
            system.debug('---Ex ' +ex);
        }
        
    } 
}