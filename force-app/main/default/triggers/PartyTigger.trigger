/* Trigger to Create New Due Diligence record in Party Path at Due Diligence Stage when there no available DD for that Party 
Created Date : 13-11-2023
Created by : Deepika Yenagula
Last Modified Date: 12-26-2023 
Last Modified By  : Md Sarwar Alam*/

trigger PartyTigger on Account (before update, after update) {
    if(CloneDueDiligenceOnParty.isFirstTime){
        CloneDueDiligenceOnParty.isFirstTime = false;
        if(Trigger.isBefore && Trigger.isUpdate){
            for(Account acc : Trigger.new){        
                if(acc.P360_DA_TPA_Stages__c == 'P360_DA_Duediligence'&& acc.P360_Connection_Type__c != 'Associated Group' ){
                    if(acc.RecordTypeName__c == 'Coverholder' || acc.RecordTypeName__c == 'DCA'){               //Added DCA recordtype - DY -01/03/24
                        
                        // Admin config should be Unique.
                        // It will be unique only and no duplicate records.
                        String Adminconfig = [Select P360_value__c from P360_AdminConfig__c where Name = 'Due Diligence' and P360_Parameter_Type__c = 'Template for CH'].P360_value__c;
                        String DDId = [Select Id from P360_Due_Diligence__c where Name =: Adminconfig].Id;
                        
                        CloneDueDiligenceOnParty.cloneRecords(DDId, acc.Id, acc.Name, acc.P360_Domicile__c, acc.P360_EPI__c, acc.P360_Connection_Type__c);
                        
                        // CloneDueDiligenceOnParty.cloneRecords('a083L000004DercQAC', acc.Id, acc.Name); 
                    }
                    /*  if(acc.RecordTypeName__c == 'DCA'){
CloneDueDiligenceOnParty.cloneRecords('a083L000004CuzdQAC', acc.Id, acc.Name);
}*/
                }
            }
        }
    }
    
    /*  if(Trigger.isAfter && Trigger.isUpdate){
Set<Id> accIdSet = new Set<Id>();
for(Account acc : Trigger.new){ 
if(  acc.Status__c == 'Approved' &&
acc.Status__c != trigger.oldMap.get(acc.Id).Status__c){
accIdSet.add(acc.Id);
}
}
if(!accIdSet.isEmpty()){
EmailTemplate et = [SELECT Id,Subject, Body FROM EmailTemplate WHERE DeveloperName ='Record_Llyods_Approval_mail'];
List<string> toAddress = new List<string>();
toAddress.add('powerstarpavankalyan3906@gmail.com');
Contact con = [Select Id, Email from Contact where Id != null LIMIT 1];
system.debug(et);
Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
mail.setTemplateId(et.Id);
mail.setToAddresses(toAddress);
mail.setSubject(et.subject);
mail.setHTMLBody(et.Body);
//mail.setTargetObjectId(con.Id);
mail.setWhatId(et.Id);
mail.setSaveAsActivity(false);
mail.setUseSignature(false);
List<Messaging.SingleEmailMessage> allmsg = new List<Messaging.SingleEmailMessage>();
allmsg.add(mail);

try {
Messaging.sendEmail(allmsg,false);
return;
} catch (Exception e) {
System.debug(e.getMessage());
}        
}
} */
    
}