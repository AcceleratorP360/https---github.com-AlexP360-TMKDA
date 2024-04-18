public class DueDiligenceReportGenerator {
    
    public P360_Due_Diligence__c duediligence {get;set;}    
    public String generatedDate {get;set;}
    public List<getRelatedRecordsWrapper> wrapperList{get;set;}
   
    
    public DueDiligenceReportGenerator(ApexPages.StandardController standardPageController){
       
        
        DateTime d = Date.Today();
        String dateStr =  d.format('dd/MM/yyyy');
        this.generatedDate = dateStr;
        
        duediligence = [SELECT Id,Name,P360_DD_Coverholder_or_DCA__c,P360_Due_Diligence_Type__c,P360_CoverHolder_TPA_Name__c,TMKDA_Binder_Renewal_Date__c, TMKDA_Domicile__c,
                   P360_DD_Coverholder_Live_Date__c, P360_DD_Total_EPI__c, P360_DD_Line_of_Business__c, TMKDA_Previous_Committee_Date__c,
                   P360_DD_Number_of_Live_Binders__c, TMKDA_DD_Connection_Status__c, P360_DD_Number_of_Run_Off_Binders__c, P360_DD_Customer_Domicile__c,
                   P360_DD_Risk_Location__c, TMKDA_Overview__c, P360_DD_Last_Audit_Date__c,	P360_DD_Next_Audit_Date__c,P360_Recommendation__c,TMKDA_High_Actions_Report__c,
                   TMKDA_Medium_Actions_Report__c,TMKDA_Low_Actions_Report__c,TMKDA_High_Open_at_DD_Review_Date__c,TMKDA_Medium_Open_at_DD_Review_Date__c,TMKDA_Low_Open_at_DD_Review_Date__c,
                   TMKDA_High_Overview_at_DD_Review_Date__c,TMKDA_Medium_Overview_at_DD_Review_Date__c,TMKDA_Low_Overview_at_DD_Review_Date__c
                   FROM P360_Due_Diligence__c
               	   WHERE Id = :standardPageController.getRecord().Id];
   
    }  
    	
        public void getRelatedRecords(){
            
       
            
        List<P360_DD_Sub_Category__c> subCatList;
        List<P360_Review_Area__c> reviewAreaList;
    	List<getRelatedRecordsWrapper> wrapperList = new List<getRelatedRecordsWrapper>();
        
        Map<Id, List<P360_DD_Sub_Category__c>> catIdSubCatListMap = new Map<Id, List<P360_DD_Sub_Category__c>>();
        Map<Id, List<P360_Review_Area__c>> catIdReviewAreaListMap = new Map<Id, List<P360_Review_Area__c>>();
        Map<Id, P360_DD_Category__c> catIdCatMap = new Map<Id, P360_DD_Category__c>([SELECT P360_Category_Id__c,Name,TMKDA_Does_attestation_confirm_a_new_TCF__c,TMKDA_High_Risk_Customer_Type__c,TMKDA_Connected_to_a_Primary__c
                                                                                     FROM P360_DD_Category__c
                
                                                                                   WHERE P360_Due_Diligence_Name__c =: duediligence.Id]);

            for(P360_DD_Sub_Category__c subCat : [SELECT P360_Category_Name__c,P360_DA_Sub_Category_ID__c,Name
                                              FROM P360_DD_Sub_Category__c
                                              WHERE P360_Category_Name__c IN: catIdCatMap.keySet()
                                              AND  P360_Due_Diligence_Name__c =: duediligence.Id]){
                                                  if (!catIdSubCatListMap.containsKey(subCat.P360_Category_Name__c)) {
                                                      catIdSubCatListMap.put(subCat.P360_Category_Name__c, new List<P360_DD_Sub_Category__c>{subCat});
                                                  } else {
                                                      catIdSubCatListMap.get(subCat.P360_Category_Name__c).add(subCat);
                                                  }                       
                                                  
                                              }
        
        for(P360_Review_Area__c revArea : [SELECT P360_DD_Sub_Category__c,	P360_DA_Review_Area_ID__c, P360_DA_Review_Area_Name__c                                                                                                                        
                                           FROM P360_Review_Area__c WHERE P360_RA_Category__c IN: catIdCatMap.keySet() AND 
                                           Due_Diligence__c =: duediligence.Id]){
                                               if (!catIdReviewAreaListMap.containsKey(revArea.P360_RA_Category__c)) {
                                                   catIdReviewAreaListMap.put(revArea.P360_RA_Category__c, new List<P360_Review_Area__c>{revArea});
                                               } else {
                                                   catIdReviewAreaListMap.get(revArea.P360_RA_Category__c).add(revArea);
                                               } 
                                        }
        for(P360_DD_Category__c cat : [SELECT P360_Category_Id__c,Name,TMKDA_Does_attestation_confirm_a_new_TCF__c,TMKDA_High_Risk_Customer_Type__c,TMKDA_Connected_to_a_Primary__c
                                       FROM P360_DD_Category__c
                                       WHERE P360_Due_Diligence_Name__c =: duediligence.Id]){
                                           getRelatedRecordsWrapper wrp = new getRelatedRecordsWrapper();
                                           wrp.cat = catIdCatMap.get(cat.Id);
                                           wrp.subCatList =  catIdSubCatListMap.get(cat.Id); 
                                           wrp.reviewAreaList =  catIdReviewAreaListMap.get(cat.Id); 
                                       	   wrapperList.add(wrp);
                                       }
       /** return wrapperList; **/
    } 
      public class getRelatedRecordsWrapper{
        
        public P360_DD_Category__c cat{get;set;}
        
        public List<P360_DD_Sub_Category__c> subCatList{get;set;}
        
        public List<P360_Review_Area__c> reviewAreaList{get;set;}
    }
}