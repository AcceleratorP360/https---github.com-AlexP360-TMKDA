//NOT IN USE - DY - 21/1/24
public class DDAttestationController {
    
    @AuraEnabled(cacheable=true)
    public static List<String> getSelectSurveyOptions() {
        List<String> surveyOptions = new List<String>();
        List<P360_Due_Diligence__c> accWithSurveys = [SELECT Id, P360_Due_Diligence_Survey__c FROM P360_Due_Diligence__c WHERE P360_Due_Diligence_Survey__c != null];
        
        for (P360_Due_Diligence__c accRecord : accWithSurveys) {
            surveyOptions.add(accRecord.P360_Due_Diligence_Survey__c);
        }      
        return surveyOptions;
    }
    
    @AuraEnabled(cacheable=true)
    public static SurveyVersion getSurveyVersion(String versionId){ 
        SurveyVersion suv = [SELECT Id,SurveyId FROM SurveyVersion where SurveyId =: versionId LIMIT 1];
        system.debug('Version==='+suv.id);
        return suv;
    }
   
    @AuraEnabled(cacheable=true)
    public static List<Contact> getRelatedContacts(String accid) {
        List<Contact> conList = [Select id,Name,Email,Accountid,account.Name,Due_Diligence__c, Due_Diligence__r.Name from contact where Due_Diligence__c =: accid];
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
        
       String AccName = [Select Id, Name,P360_Due_Diligence_Survey__c, Contact__c from P360_Due_Diligence__c where Id=:accId].Name;
       String SurveysList = [Select Id,Name from Survey where Id=:surveyId ].Name;
       String Communitydetails = [select Id,Name from Network where Name= 'Feedback'].Id;
        
       System.debug('Account Name--------'+AccName);
       System.debug('SurveysList--------'+SurveysList);
       System.debug('Community Details--------'+Communitydetails);
        List<SurveyInvitation> siv = new List<SurveyInvitation>();
       SurveyInvitation SInv = new SurveyInvitation();
            SInv.CommunityId = Communitydetails;
            SInv.Name = AccName + ' ' + SurveysList + system.now();
            SInv.Due_Diligence__c = accId;
            SInv.OptionsCollectAnonymousResponse = true;
            SInv.OptionsAllowGuestUserResponse = true;
            SInv.SurveyId = surveyId;
            siv.add(SINV);
        
            insert siv;
            SurveyInvitation SInvname = [Select Id,InvitationLink from SurveyInvitation where Id =:SInv.Id LIMIT 1];
            
        System.debug('Survey Invitation----'+SInv);
        System.debug('SInvname----------'+SInvname);

        SendEmailTemplateWithoutTemplate(email,SInvname.InvitationLink,contid);
        
        
        System.debug('After Update SInvname----------'+SInvname);
        System.debug('After Update SInvname----------'+SInvname.InvitationLink);
        
    }
    
    
    public static void SendEmailTemplateWithoutTemplate(string email,string link,string conid) { 
        
        String contactlist = [Select id,Name from contact where id =: conid].Name;
        System.debug('Contact Name----'+contactlist);
        List<Messaging.SingleEmailMessage> emailList = new List<Messaging.SingleEmailMessage>(); 
        List<String> address = new List<String>{email};
        System.debug('Email List----'+address);
       	Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setSubject('Due Diligence Attestation');
        String messageBody = '<html><body>Hi '+contactlist+', welcome to TMK,Please fill information with following link <a href="'+link+'">Click Here</a><br>Thanks,<br>TMK</body></html>';
        mail.setHtmlbody(messageBody);
        //mail.setHtmlbody('Welcome to TMK,Please fill information with following link:\n' +' <a href="'+link+'">Click Here</a>');
        mail.setToAddresses(address);
        emailList.add(mail);
        
        if(!emailList.isEmpty()){
            Messaging.sendEmail(emailList);
        }
    
    } 

}