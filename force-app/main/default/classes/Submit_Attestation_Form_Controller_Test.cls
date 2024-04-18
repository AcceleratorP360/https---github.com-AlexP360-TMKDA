@isTest
public class Submit_Attestation_Form_Controller_Test {
    @isTest
    Static void setupMethod() {
     User thisUser = [select Id from User where Id = :UserInfo.getUserId()];
        Id coverHolderRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('P360_Broker').getRecordTypeId();
       Account acc = new Account(Name='Test Account',CurrencyIsoCode = 'GBP',   
                                    RecordTypeId =coverHolderRecordTypeId);
       insert acc;
        
        //Account accs = [select id,name from account where id =: acc.id];
        //accs.P360_Sponsoring_Broker__c = acc.Id;
        //update accs;
        Contact con = new Contact();
        con.LastName = 'Sat';
        con.CurrencyIsoCode = 'GBP';
        con.Email = 'test@gmail.com';
        insert con;
        
        TMKDA_Attestation__c att = new TMKDA_Attestation__c();
        att.name = 'Test attestation';
        att.Company_Name__c = acc.id;
        att.TMKDA_Issue_Attestation_Date__c = system.today();
        att.TMK_DA_Attestation_Sent_By__c = UserInfo.getUserId();
        att.TMK_DA_Attestation_Sent_to__c = con.id;
        att.TMK_DA_Attestation_link__c = '';
        insert att;
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        List<TMKDA_DD_Attestation_Scoping__c> attScopingList = new List<TMKDA_DD_Attestation_Scoping__c>();
        TMKDA_DD_Attestation_Scoping__c attscope = new TMKDA_DD_Attestation_Scoping__c();
        attscope.name = 'attscope test';
        attscope.TMKDA_Contact__c = con.id;
        insert attscope;
        attScopingList.add(attscope);
        Account acct = [select id,name,P360_Connection_Type__c from account where id=: acc.Id];
        
        Contact cont = [select id,lastname,email from contact where id=: con.Id];
        TMKDA_Attestation__c atts = [SELECT Id, TMKDA_Issue_Attestation_Date__c, TMK_DA_Attestation_Sent_By__c,
                                          TMK_DA_Attestation_Sent_to__c, 
                                          TMK_DA_Attestation_link__c FROM TMKDA_Attestation__c 
                                          WHERE Id =: att.Id];
            
        List<TMKDA_DD_Attestation_Scoping__c> attscopelist = [SELECT Id, Name, TMKDA_Contact__c, TMKDA_Contact__r.Name,
                                                        TMKDA_Contact__r.Email, TMKDA_Attestation_Form_URL__c
                                                                          FROM TMKDA_DD_Attestation_Scoping__c
                                                                          WHERE Id =:attscope.Id];
       P360_Submit_Attestation_Form_Controller.fetchAttestaionScoping(atts.id);
       P360_Submit_Attestation_Form_Controller.sendEmailAndUpdate(cont.id,attscopelist[0].Id);
    }
}