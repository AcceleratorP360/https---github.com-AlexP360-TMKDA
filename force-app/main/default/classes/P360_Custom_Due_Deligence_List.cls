public class P360_Custom_Due_Deligence_List {

    @AuraEnabled
    public static List<getAllRecordsWrapper> getAllPartyRecords(String partyId){
        
        List<getAllRecordsWrapper> wrapperList = new List<getAllRecordsWrapper>();
        Map<Id, List<P360_DD_Category__c>> dueIdCatListMap = new Map<Id, List<P360_DD_Category__c>>();
        Map<Id, List<P360_DD_Sub_Category__c>> dueIdSubCatListMap = new Map<Id, List<P360_DD_Sub_Category__c>>();
        Map<Id, List<P360_Review_Area__c>> dueIdReviewAreaListMap = new Map<Id, List<P360_Review_Area__c>>();
        
        
        if(String.isNotBlank(partyId)){
            Map<Id, P360_Due_Diligence__c> dueIdDueDeligenceMap = new Map<Id, P360_Due_Diligence__c>([SELECT Id, Name, CreatedDate, P360_CoverHolder_TPA_Name__c,Expand_Due_Deligence__c,
                                                                                                      P360_CoverHolder_TPA_Name__r.P360_Primary_Connected__c
                                                                                                      FROM P360_Due_Diligence__c WHERE P360_CoverHolder_TPA_Name__c =: partyId ORDER BY CreatedDate]);        
            
            for(P360_DD_Category__c cat : [SELECT Id, Name, P360_Due_Diligence_Name__c, P360_Company_Type__c,
                                           Connect_Copy_Options__c,
                                           Expand_Category__c,
                                           P360_Summary_Final_Assessment__c,
                                           P360_Completion_Marker__c,
                                           Sub_category_Completion_status__c
                                           FROM P360_DD_Category__c
                                           WHERE P360_Due_Diligence_Name__c IN: dueIdDueDeligenceMap.keySet()]){
                                               if (!dueIdCatListMap.containsKey(cat.P360_Due_Diligence_Name__c)) {
                                                   dueIdCatListMap.put(cat.P360_Due_Diligence_Name__c, new List<P360_DD_Category__c>{cat});
                                               } else {
                                                   dueIdCatListMap.get(cat.P360_Due_Diligence_Name__c).add(cat);
                                               }  
                                               
                                           }
            
            for(P360_DD_Sub_Category__c subCat : [SELECT Id, Name, 
                                                  P360_Category_Name__c,
                                                  Expand_Sub_Catgeory__c,
                                                  P360_Category_Name__r.Name,
                                                  P360_Completion_Marker__c,
                                                  P360_DD_Child_COmpletion_Status__c,
                                                  P360_Due_Diligence_Name__c,
                                                  P360_Is_Connection_Enable__c,
                                                  P360_Connect_Copy_Options__c
                                                  FROM P360_DD_Sub_Category__c
                                                  WHERE P360_Due_Diligence_Name__c IN: dueIdDueDeligenceMap.keySet()]){
                                                      if (!dueIdSubCatListMap.containsKey(subCat.P360_Due_Diligence_Name__c)) {
                                                          dueIdSubCatListMap.put(subCat.P360_Due_Diligence_Name__c, new List<P360_DD_Sub_Category__c>{subCat});
                                                      } else {
                                                          dueIdSubCatListMap.get(subCat.P360_Due_Diligence_Name__c).add(subCat);
                                                      }                       
                                                      
                                                  }
            
            for(P360_Review_Area__c revArea : [SELECT Id, Name, P360_DD_Sub_Category__c, 
                                               P360_RA_Category__c,
                                               Due_Diligence__c,
                                               Connect_Copy_Options__c,
                                               TMKDA_Severity__c,
                                               P360_Scope_of_DD_Review__c,
                                               P360_Pass_Fail__c,
                                               P360_Comment__c,
                                               TMKDA_Answer__c,
                                               P360_Contained_in_Policy__c,
                                               P360_Is_Connection_Enable__c,
                                               P360_Review_Point__c,
                                               P360_Assessment__c,
                                               P360_Completion_Marker__c                                                                                                                        
                                               FROM P360_Review_Area__c WHERE Due_Diligence__c IN: dueIdDueDeligenceMap.keySet()]){
                                                   if (!dueIdReviewAreaListMap.containsKey(revArea.Due_Diligence__c)) {
                                                       dueIdReviewAreaListMap.put(revArea.Due_Diligence__c, new List<P360_Review_Area__c>{revArea});
                                                   } else {
                                                       dueIdReviewAreaListMap.get(revArea.Due_Diligence__c).add(revArea);
                                                   } 
                                               }
            for(P360_Due_Diligence__c due : [SELECT Id, P360_CoverHolder_TPA_Name__c,Expand_Due_Deligence__c,CreatedDate,
                                             P360_CoverHolder_TPA_Name__r.P360_Primary_Connected__c
                                             FROM P360_Due_Diligence__c WHERE Id IN:dueIdDueDeligenceMap.keySet()]){
                                                 getAllRecordsWrapper wrp = new getAllRecordsWrapper();
                                                 wrp.dueDeligence = dueIdDueDeligenceMap.get(due.Id);
                                                 wrp.createdYear = due.CreatedDate.Year();
                                                 wrp.catList = dueIdCatListMap.get(due.Id) != null ? dueIdCatListMap.get(due.Id) : new List<P360_DD_Category__c>();
                                                 wrp.subCatList =  dueIdSubCatListMap.get(due.Id) != null ? dueIdSubCatListMap.get(due.Id) : new List<P360_DD_Sub_Category__c>(); 
                                                 wrp.reviewAreaList =  dueIdReviewAreaListMap.get(due.Id) != null ? dueIdReviewAreaListMap.get(due.Id) : new List<P360_Review_Area__c>(); 
                                                 wrapperList.add(wrp);
                                             }
            return wrapperList;
        }
        return new List<getAllRecordsWrapper>();
    }  
    
    
    public class getAllRecordsWrapper{
        @AuraEnabled
        public P360_Due_Diligence__c dueDeligence{get;set;}
        @AuraEnabled
        public integer createdYear{get;set;}
        @AuraEnabled
        public List<P360_DD_Category__c> catList{get;set;}
        @AuraEnabled
        public List<P360_DD_Sub_Category__c> subCatList{get;set;}
        @AuraEnabled
        public List<P360_Review_Area__c> reviewAreaList{get;set;}
    }
}