public class GenerateDD {
    
    public P360_Due_Diligence__c invoice {set;get;}
    public List<P360_DD_Category__c> invoiceLineItemList {set;get;}
    public List<P360_DD_Sub_Category__c> SubCategoryList  {set;get;}
    public List<P360_Review_Area__c> ReviewAreaList  {set;get;}
    public String totalAmount {set;get;}   
    public string generateddate {get;set;}
    
    public GenerateDD(ApexPages.StandardController standardPageController){
        DateTime d = Date.Today() ;
        String dateStr =  d.format('dd/MM/yyyy') ;

        this.generatedDate = dateStr;
        
        invoice = [SELECT id, Name, P360_CoverHolder_TPA_Name__r.Name, P360_DA_Analyst__r.Name, P360_Due_Diligence_Date__c, P360_Approval_Status__c,
                   			OwnerId, p360_Planned_Assessment_Start_Date__c, p360_Due_Diligence_Date_Valid_To__c, 
                   		 	p360_Planned_Assessment_End_Date__c, P360_DD_Assessment__c,
                   			P360_Due_Diligence_Type__c, P360_Actual_Assessment_End_Date__c, 
                            Category_Status__c, P360_Approved_By__r.Name, P360_Coverholder_TPA_summary__c, P360_Due_Diligence_Record_Id__c, P360_DD_Assessment_score__c,
                   			P360_wouldyouliketooverride_assessment__c,P360_DD_Override_assessment__c, P360_DD_Override_reason__c
               		FROM P360_Due_Diligence__c
               		WHERE Id =: standardPageController.getRecord().Id];
        
        invoiceLineItemList = [SELECT Id,P360_Assessment__c, Progress__c, P360_Commentary__c,Name,P360_Category_Id__c,P360_Completion_Marker__c,P360_Coverholder_TPA_Name__c,P360_Due_Diligence_Name__c,P360_Inherent_Risk__c,P360_Summary_Final_Assessment__c,P36_CT_Assessment_Score1__c 
           FROM P360_DD_Category__c  WHERE P360_Due_Diligence_Name__c =: invoice.Id];
        
        SubCategoryList = [SELECT Id,Name,P360_Category_Name__r.Name,P360_Assessment__c, P360_SC_Assessment_Score1__c,P360_SC_Assessment_status__c,P360_Completion_Marker__c,P360_Summary_Final_Assessment__c,P360_SC_Inherent_risk__c,P360_Commentary__c
           FROM P360_DD_Sub_Category__c  WHERE P360_Category_Name__c   =: invoiceLineItemList];

        ReviewAreaList = [SELECT Id,Name,P360_DD_Sub_Category__r.Name, P360_RA_Assessment_Score__c,Assessment_Status__c,P360_Completion_Marker__c, P360_RA_Overall_Score__c,Inherent_Risk__c,P360_Summary__c,P360_Commentary__c,P360_RA_Weighting__c
                          FROM P360_Review_Area__c WHERE P360_DD_Sub_Category__c  =: SubCategoryList];
        
       
    }


}