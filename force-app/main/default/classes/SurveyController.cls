//NOT IN USE - DY - 21/1/24
public class SurveyController {

    @AuraEnabled(cacheable=true)
    public static List<String> getSelectSurveyOptions() {
        List<String> surveyOptions = new List<String>();
        List<Account> accWithSurveys = [SELECT Id, P360_Party_Attestation__c FROM Account WHERE P360_Party_Attestation__c != null];
        
        for (Account accRecord : accWithSurveys) {
            surveyOptions.add(accRecord.P360_Party_Attestation__c);
        }
        
        return surveyOptions;
    }
    
    /*Mohan changes for preview start here*/  
    @AuraEnabled(cacheable=true)
    public static SurveyVersion getSurveyVersion(String versionId){ 
        SurveyVersion suv = [SELECT Id,SurveyId FROM SurveyVersion where SurveyId =: versionId LIMIT 1];
        system.debug('Version==='+suv.id);
        return suv;
        
    }
    /*Mohan changes for preview end here*/
    
    /*Mohan changes for send start here*/
    @AuraEnabled(cacheable=true)
    public static List<Contact> getRelatedContacts(String accid) {
        List<Contact> conList = [Select id,Name,Email,Accountid,account.P360_DA_UnderWriter_Name__c from contact where Accountid =: accid];
        System.debug('Conlist----'+conList);
        return conList;
    }
    
    @AuraEnabled(cacheable=true)
    public static List<Survey> getActiveSurveys() {
        List<Survey> activeSurveys = new List<Survey>();
        
        try {
            activeSurveys = [SELECT Id, Name FROM Survey];
        } catch (Exception e) {
            System.debug('Exception in getActiveSurveys: ' + e.getMessage());
            throw new AuraHandledException('Error retrieving active surveys: ' + e.getMessage());
        }
        
        return activeSurveys;
    }
    
     @AuraEnabled(Cacheable=false)
    public static void CreateSurveyInvitation(String accId, String surveyId,String email,string contid) {
        String communityId;
        String surveyyId;
        String surveyName;
        String strSurveyURL;
        String Link;
        
       String AccName = [Select Id, Name from Account where Id=:accId].Name;
       String SurveysList = [Select Id,Name from Survey where Id=:surveyId ].Name;
       String Communitydetails = [select Id,Name from Network where Name= 'Feedback'].Id;
        
       System.debug('Account Name--------'+AccName);
       System.debug('SurveysList--------'+SurveysList);
       System.debug('Community Details--------'+Communitydetails);
        List<SurveyInvitation> siv = new List<SurveyInvitation>();
       SurveyInvitation SInv = new SurveyInvitation();
            SInv.CommunityId = Communitydetails;
            SInv.Name = system.now() + AccName + ' ' + SurveysList;
            SInv.P360_Party__c = accId;
            SInv.OptionsCollectAnonymousResponse = true;
            SInv.OptionsAllowGuestUserResponse = true;
            SInv.SurveyId = surveyId;
            //SInv.ParticipantId=conList.Id;
            siv.add(SINV);
        
            insert siv;
            SurveyInvitation SInvname = [Select Id,InvitationLink from SurveyInvitation where Id =:SInv.Id LIMIT 1];
            
        System.debug('Survey Invitation----'+SInv);
        System.debug('SInvname----------'+SInvname);
            
            //SInvname.TMKDA_Survey_Link__c =SInvname.InvitationLink;
            //update SInvname;
        
        SendEmailTemplateWithoutTemplate(email,SInvname.InvitationLink,contid);
        
        
        System.debug('After Update SInvname----------'+SInvname);
        System.debug('After Update SInvname----------'+SInvname.InvitationLink);
        
    }
    
    /* Email method to send an email to contact email */
    
    public static void SendEmailTemplateWithoutTemplate(string email,string link,string conid) { 
        
        String contactlist = [Select id,Name from contact where id =: conid].Name;
        System.debug('Contact Name----'+contactlist);
        List<Messaging.SingleEmailMessage> emailList = new List<Messaging.SingleEmailMessage>(); 
        List<String> address = new List<String>{email};
        System.debug('Email List----'+address);
       	Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setSubject('Preliminary Questions');
        String messageBody = '<html><body>Hi '+contactlist+', welcome to TMK,Please fill information with following link <a href="'+link+'">Click Here</a><br>Thanks,<br>TMK</body></html>';
        mail.setHtmlbody(messageBody);
        //mail.setHtmlbody('Welcome to TMK,Please fill information with following link:\n' +' <a href="'+link+'">Click Here</a>');
        mail.setToAddresses(address);
        emailList.add(mail);
        
        if(!emailList.isEmpty()){
            Messaging.sendEmail(emailList);
        }
    
    } 
  /*Mohan changes for send end here*/
}