public class ReviewAreaController {
    
   @AuraEnabled(cacheable=true)
    public static List<P360_Review_Area__c> fetchAccounts(String recordId){
        
            return[SELECT Id,TMKDA_Severity__c,TMKDA_Source__c,P360_Review_Point__c,Name,Inherent_Risk__c,Due_Diligence__c,P360_Inherent_Risk__c
            FROM P360_Review_Area__c 
        where P360_DD_Sub_Category__r.id =: recordId WITH SECURITY_ENFORCED ];
            
    }                                                                                     
   
       @AuraEnabled
    public static string updateAccounts( Object data )
    {
        
        List < P360_Review_Area__c > accsForUpdate = ( List < P360_Review_Area__c > ) JSON.deserialize(
            JSON.serialize( data ),
            List < P360_Review_Area__c >.class
        );
        
            update accsForUpdate;
            return 'Success: Due Diligience Review Area updated successfully';
        }
    
     @AuraEnabled
    public static List<P360_Review_Area__c> getReviewAreas(String dueId){
         return[SELECT Id,P360_DA_Review_Area_Name__c,P360_Review_Point__c,P360_RA_Category__c,TMKDA_Primary_Linked__c,TMKDA_Severity__c
                       ,TMKDA_Answer__c,P360_Pass_Fail__c,TMKDA_Source__c,P360_Comment__c,P360_Completion_Marker__c
            FROM P360_Review_Area__c 
        where Due_Diligence__c =: dueId WITH SECURITY_ENFORCED ]; 
        
    }
    @AuraEnabled
    public static void updateAccount(List<P360_Review_Area__c> acc ){
        update acc;
    }
}