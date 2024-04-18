@isTest(seeAllData=true)
public class SurveyController_Test {
    static testMethod void Handler1(){
    Account acc = new Account();
    acc.Name = 'TMK';
    acc.CurrencyIsoCode = 'GBP';
    insert acc;
    
    Contact con = new Contact();
    con.accountId = acc.Id;
    con.FirstName = 'John';
    con.LastName = 'Lobo';
    con.CurrencyIsoCode = 'GBP';
    con.Email = 'test@gmail.com';
        
    insert con;  
      SurveyVersion svi = new SurveyVersion();
        //svi.name = 'Test';
        //insert svi;
      Network nw = [SELECT Id,Name from Network];
      Survey sivs =  [SELECT Id, DeveloperName  FROM Survey LIMIT 1];
      SurveyInvitation SInv = new SurveyInvitation();
            SInv.Name = 'Test';
            SInv.P360_Party__c = acc.Id;
            SInv.OptionsCollectAnonymousResponse = true;
            SInv.OptionsAllowGuestUserResponse = true;
            SInv.SurveyId = sivs.Id;
            SInv.CommunityId = nw.Id;
            insert sinv;
        SurveyInvitation SInvname = [Select Id,InvitationLink from SurveyInvitation where Id =:SInv.Id LIMIT 1];
        SurveyController.getActiveSurveys();
        SurveyController.getSelectSurveyOptions();
        SurveyController.getRelatedContacts(acc.id);
        SurveyController.getSurveyVersion(sivs.Id);
        SurveyController.CreateSurveyInvitation(acc.Id, sivs.Id, con.email, con.id);
        SurveyController.SendEmailTemplateWithoutTemplate(con.Email, SInvname.InvitationLink, con.id);
    }
  
}