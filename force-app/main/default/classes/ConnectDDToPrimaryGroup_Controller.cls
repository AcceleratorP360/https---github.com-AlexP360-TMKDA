public class ConnectDDToPrimaryGroup_Controller {
    
    @AuraEnabled
    public static List<P360_Due_Diligence__c> getPrimaryDueDeligence(String accId){
        List<P360_Due_Diligence__c> dueDeligenceList;
       List<P360_Due_Diligence__c> getprimaryAccount = [SELECT Id, P360_CoverHolder_TPA_Name__c,
                                                   P360_CoverHolder_TPA_Name__r.P360_Primary_Connected__c
                                                   FROM P360_Due_Diligence__c WHERE Id =: accId AND 
                                                   TMKDA_Primary_Due_Diligence_record__c  = null ];
        if(!getprimaryAccount.isEmpty()){
            if(String.isNotBlank(getprimaryAccount[0].P360_CoverHolder_TPA_Name__c)){
                dueDeligenceList = [SELECT Id, Name 
                                    FROM P360_Due_Diligence__c 
                                    WHERE P360_CoverHolder_TPA_Name__c =:getprimaryAccount[0].P360_CoverHolder_TPA_Name__r.P360_Primary_Connected__c  AND
                                    P360_Approval_Status__c  = 'Approved' ORDER BY LastModifiedDate DESC];
            }
        }
        return dueDeligenceList;
    }
    
    @AuraEnabled
    public static List<getRelatedRecordsWrapper> getRelatedRecords(String primaryDueDeligenceRec){
        
        List<P360_DD_Sub_Category__c> subCatList;
        List<P360_Review_Area__c> reviewAreaList;
        List<getRelatedRecordsWrapper> wrapperList = new List<getRelatedRecordsWrapper>();
        
        Map<Id, List<P360_DD_Sub_Category__c>> catIdSubCatListMap = new Map<Id, List<P360_DD_Sub_Category__c>>();
        Map<Id, List<P360_Review_Area__c>> catIdReviewAreaListMap = new Map<Id, List<P360_Review_Area__c>>();
        Map<Id, P360_DD_Category__c> catIdCatMap = new Map<Id, P360_DD_Category__c>([SELECT Id, Name, P360_Due_Diligence_Name__c, P360_Company_Type__c,
                                                                                     Connect_Copy_Options__c,
                                                                                     Expand_Category__c,
                                                                                     P360_Summary_Final_Assessment__c,
                                                                                     P360_Completion_Marker__c,
                                                                                     Sub_category_Completion_status__c
                                                                                     FROM P360_DD_Category__c
                                                                                     WHERE P360_Due_Diligence_Name__c =: primaryDueDeligenceRec]);
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
                                              WHERE P360_Category_Name__c IN: catIdCatMap.keySet()
                                              AND  P360_Due_Diligence_Name__c =: primaryDueDeligenceRec]){
                                                  if (!catIdSubCatListMap.containsKey(subCat.P360_Category_Name__c)) {
                                                      catIdSubCatListMap.put(subCat.P360_Category_Name__c, new List<P360_DD_Sub_Category__c>{subCat});
                                                  } else {
                                                      catIdSubCatListMap.get(subCat.P360_Category_Name__c).add(subCat);
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
                                           FROM P360_Review_Area__c WHERE P360_RA_Category__c IN: catIdCatMap.keySet() AND 
                                           Due_Diligence__c =: primaryDueDeligenceRec]){
                                               if (!catIdReviewAreaListMap.containsKey(revArea.P360_RA_Category__c)) {
                                                   catIdReviewAreaListMap.put(revArea.P360_RA_Category__c, new List<P360_Review_Area__c>{revArea});
                                               } else {
                                                   catIdReviewAreaListMap.get(revArea.P360_RA_Category__c).add(revArea);
                                               } 
                                           }
        for(P360_DD_Category__c cat : [SELECT Id, Name, P360_Due_Diligence_Name__c, P360_Company_Type__c,
                                       Connect_Copy_Options__c,
                                       Expand_Category__c,
                                       P360_Summary_Final_Assessment__c,
                                       P360_Completion_Marker__c,
                                       Sub_category_Completion_status__c
                                       FROM P360_DD_Category__c
                                       WHERE P360_Due_Diligence_Name__c =: primaryDueDeligenceRec]){
                                           getRelatedRecordsWrapper wrp = new getRelatedRecordsWrapper();
                                           wrp.cat = catIdCatMap.get(cat.Id);
                                           wrp.subCatList =  catIdSubCatListMap.get(cat.Id); 
                                           wrp.reviewAreaList =  catIdReviewAreaListMap.get(cat.Id); 
                                           wrapperList.add(wrp);
                                       }
        return wrapperList;
    }
    
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
    
    
    public class getRelatedRecordsWrapper{
        @AuraEnabled
        public P360_DD_Category__c cat{get;set;}
        @AuraEnabled
        public List<P360_DD_Sub_Category__c> subCatList{get;set;}
        @AuraEnabled
        public List<P360_Review_Area__c> reviewAreaList{get;set;}
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
    
    
    @AuraEnabled
    public static void updateParentRecords(List<getRelatedRecordsWrapper> wrapObject, String currentRecId, String selectedRcId){
        List<sObject> allObjects = new List<sObject>();
        P360_DD_Category__c wCat;
        P360_DD_Sub_Category__c wsubCat;
        Map<Id, String> catIdConnectionTypeMap = new Map<Id, String>();
        
        Map<Id, String> subCatIdConnectionTypeMap = new Map<Id, String>();
        Map<Id, String> reviewAereaIdConnectionTypeMap = new Map<Id, String>();
        
        for(getRelatedRecordsWrapper cWrp : wrapObject){
            wCat = cWrp.cat;
            if(String.isNotBlank(wCat.Connect_Copy_Options__c) && wCat.Connect_Copy_Options__c != 'NA'){
                allObjects.add(wCat);
                system.debug('--->>> wCat.Connect_Copy_Options__c '+wCat.Connect_Copy_Options__c);
                catIdConnectionTypeMap.put(wCat.Id, wCat.Connect_Copy_Options__c == 'Link' ? 'Linked' :
                                           wCat.Connect_Copy_Options__c == 'Copy' ? 'Copied' :   wCat.Connect_Copy_Options__c == 'Create'?'Create': '');
            }
            
            for(P360_DD_Sub_Category__c subCatWrp :  cWrp.subCatList){
                if(String.isNotBlank(subCatWrp.P360_Connect_Copy_Options__c) && subCatWrp.P360_Connect_Copy_Options__c != 'NA'){
                    allObjects.add(subCatWrp);
                    subCatIdConnectionTypeMap.put(subCatWrp.Id, subCatWrp.P360_Connect_Copy_Options__c == 'Link' ? 'Linked' :
                                                  subCatWrp.P360_Connect_Copy_Options__c == 'Copy' ? 'Copied' : subCatWrp.P360_Connect_Copy_Options__c == 'Create'?'Create':'');
                }
            }
            
            for(P360_Review_Area__c rAreaWrp :  cWrp.reviewAreaList){
                if(String.isNotBlank(rAreaWrp.Connect_Copy_Options__c) && rAreaWrp.Connect_Copy_Options__c != 'NA'){
                    allObjects.add(rAreaWrp);
                    
                    reviewAereaIdConnectionTypeMap.put(rAreaWrp.Id, rAreaWrp.Connect_Copy_Options__c == 'Link' ? 'Linked' :
                                                       rAreaWrp.Connect_Copy_Options__c == 'Copy' ? 'Copied' : rAreaWrp.Connect_Copy_Options__c == 'Create'?'Create':'');
                }
            }
        }
        
        if(!allObjects.isEmpty()){
            // upsert allObjects;
        }
        system.debug('----->>>> catIdConnectionTypeMap '+catIdConnectionTypeMap);
        if(!catIdConnectionTypeMap.isEmpty()){
            createCategotyLinkage(currentRecId, selectedRcId,catIdConnectionTypeMap);
        }
        
        if(!subCatIdConnectionTypeMap.isEmpty()){
            createSubCategotyLinkage(currentRecId,selectedRcId, subCatIdConnectionTypeMap);
        }
        if(!reviewAereaIdConnectionTypeMap.isEmpty()){
            createReviewAreaLinkage(currentRecId, selectedRcId,reviewAereaIdConnectionTypeMap);
        }
        
        if(String.isNotBlank(currentRecId) && String.isNotBlank(selectedRcId)){
            updateDueDeligenceConnect(currentRecId, selectedRcId);
        }
        
    }
    
    // Added by Srikanth
    // pass List category Ids
    public static void createCategotyLinkage(String currentRecrdId,String selectedRcId, Map<Id, String> primaryMap){
        ConnectDDToPrimaryGroup_ConnectHelper.getConnectedCatgory_records(currentRecrdId,selectedRcId, primaryMap);
    }
    
    // pass List subcategory Ids
    
    public static void createSubCategotyLinkage(String currentRecrdId,String selectedRcId, Map<Id, String> primaryMap){
        ConnectDDToPrimaryGroup_ConnectHelper.getConnectedSubCatgory_records(currentRecrdId,selectedRcId, primaryMap);
    }
    
    // pass List subReviewAredIds
    
    public static void createReviewAreaLinkage(String currentRecrdId,String selectedRcId, Map<Id, String> primaryMap){
        ConnectDDToPrimaryGroup_ConnectHelper.getConnectedReviewArea_records(currentRecrdId,selectedRcId, primaryMap);
    }
    
    public static void updateDueDeligenceConnect(String currentRecrdId, String primaryRecordId){
        ConnectDDToPrimaryGroup_ConnectHelper.updateDueDeligence(currentRecrdId, primaryRecordId);
    }
}