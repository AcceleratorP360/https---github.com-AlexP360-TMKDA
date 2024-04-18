public with sharing class AccountDataController {        
@AuraEnabled(cacheable=true)
    public static List<P360_DD_Category__c> fetchAccounts(String recordId){
        try{
            return[SELECT Id,P360_DA_Category_ID__r.Name, P360_DA_Category_ID_URL__c , P360_Assessment__c,P360_Commentary__c,P360_CT_Inherent_risk__c,Name,Progress__c,P360_Category_Id__c,Sub_category_Completion_status__c,
                   P360_Completion_Marker__c,P360_Coverholder_TPA_Name__c,P360_Due_Diligence_Name__c,P360_Inherent_Risk__c,P360_Summary_Final_Assessment__c 
           FROM P360_DD_Category__c 
        where P360_Due_Diligence_Name__r.id =: recordId  WITH SECURITY_ENFORCED  ];
            
        }catch(exception e){
          throw new AuraHandledException(e.getMessage());   
        }
    }
   @AuraEnabled
       public static boolean updaterecord(List<P360_DD_Category__c> acclist){
        try {
            update acclist;
            return true;
        } catch(Exception e) {
            return false;
        }
    }
   
}