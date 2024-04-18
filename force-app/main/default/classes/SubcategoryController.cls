public class SubcategoryController { 
    @AuraEnabled(cacheable=true)
    
    public static List< P360_DD_Sub_Category__c> fetchAccounts(String recordId){
        
            return[SELECT Id,P360_Assessment__c,P360_SC_Assessment_status__c,P360_SC_Inherent_risk__c,P360_DD_Child_COmpletion_Status__c,P360_Commentary__c,Name,P360_Category_Name__c,P360_Summary_Final_Assessment__c,P360_Completion_Marker__c,P360_Inherent_Risk_Revised__c,P360_Coverholder_TPA_Name__c,P360_Due_Diligence_Name__c,P360_Inherent_Risk__c
                   FROM     P360_DD_Sub_Category__c 
                   where   P360_Category_Name__r.id =: recordId ];
        
    }
    
    @AuraEnabled
    public static boolean updaterecord(List<P360_DD_Category__c> acclist){
      
            update acclist;
            return true;
       
    }
}